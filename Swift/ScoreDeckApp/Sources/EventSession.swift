import Foundation
import Observation
import MultipeerConnectivity
import XvaluappCore

/// Holds one open event, the store to persist it to, and — once
/// `connect(displayName:)` is called — the Multipeer transport syncing it
/// with other devices at the same event.
///
/// This collapses what the legacy app spread across `JudgePanel.m`'s
/// `session:didReceiveData:fromPeer:` (a 90-line flat if-chain keyed on a
/// free-text `"Acceso"` string) into one exhaustive `switch` over
/// `SyncMessage`, and replaces the three-table `EVALUACION` /
/// `EVALUACIONLO` / `BUFFER` score lifecycle with a single `Score.Status`
/// that a `.scoreSubmitted` → `.scoresApproved` round trip advances.
///
/// Roles are a *set*, not one exclusive value — a device can be Judge and
/// Screen at once, or Master and Judge, and can add/drop roles at any time
/// without leaving the event. Exactly one connected device may hold
/// `.master`; see `canEnableMaster`.
@Observable
final class EventSession {
    private(set) var event: Event
    private let store: any EventStoring

    private(set) var roles: Set<PeerRole> = []
    /// Which judge on the roster this device scores as, when `.judge` is
    /// active. Independent of `roles` itself since a device can turn Judge
    /// on/off repeatedly without re-picking who it's scoring as.
    var activeJudgeID: UUID?

    private(set) var transport: MultipeerTransport?

    /// What every currently- or previously-connected peer has announced
    /// about itself via `.roleAnnounce` — the source both the Master-
    /// singleton guard and the Connections list read from.
    private(set) var knownPeerRoles: [MCPeerID: (deviceID: UUID, displayName: String, roles: Set<PeerRole>)] = [:]

    /// False only when some other *connected* peer already announced
    /// `.master`. The UI disables the Master toggle and explains why when
    /// this is false, instead of letting two devices both claim it — a
    /// lightweight, client-side guard rather than a real election: at this
    /// app's scale (a handful of staff devices on one LAN) that's enough,
    /// and it keeps the protocol simple. See the architecture write-up for
    /// the race this doesn't close.
    var canEnableMaster: Bool {
        if roles.contains(.master) { return true }
        guard let transport else { return true }
        return !transport.connectedPeers.contains { peer in
            knownPeerRoles[peer]?.roles.contains(.master) ?? false
        }
    }

    /// Set when a save fails mid-event; views alert on it and clear it via
    /// `clearPersistenceError()` instead of the app crashing on a full disk
    /// or a permissions hiccup, the way an unguarded `try!` here would.
    private(set) var persistenceError: String?

    func clearPersistenceError() {
        persistenceError = nil
    }

    init(event: Event, store: any EventStoring) {
        self.event = event
        self.store = store
    }

    /// Display names only — keeps `MCPeerID`/`MultipeerConnectivity` out of
    /// every view that just wants to show connection status (see
    /// `ConnectionStatusBadge`).
    var connectedPeerNames: [String] {
        transport?.connectedPeers.map(\.displayName) ?? []
    }

    /// `categoryID: nil` gives the overall average across every category —
    /// what the Screen carousel's first page and the Master console's
    /// "any scores yet" check both want; a specific id gives that one
    /// category's leaderboard, for the carousel's per-category pages.
    func standings(categoryID: UUID? = nil) -> [RankingRow] {
        RankingEngine.standings(participants: event.participants, scores: event.scores, categoryID: categoryID)
    }

    /// Participants who don't yet have an approved score in the given
    /// category — the modern equivalent of the legacy `Siguientes` /
    /// "cargasiguientes" queue, minus the bug where judges were forced
    /// through it in strict id order with no way to go back.
    func participantsAwaitingScore(in categoryID: UUID) -> [Participant] {
        let scored = Set(
            event.scores
                .filter { $0.categoryID == categoryID && $0.status == .approved }
                .map(\.participantID)
        )
        return event.activeParticipants.filter { !scored.contains($0.id) }
    }

    // MARK: - Networking

    /// Starts advertising *and* browsing unconditionally, independent of
    /// role — every device can discover and be discovered by every other
    /// device the moment an event is open, before anyone has picked a role.
    /// Call once, as soon as the event's detail screen appears.
    ///
    /// Replaces the old role-gated asymmetry (only a self-declared Master
    /// browsed/invited; everyone else just advertised and waited) — that
    /// no longer fits a world where role is chosen (and changed) after
    /// connecting, not before.
    func connect(displayName: String) {
        guard transport == nil else { return }
        let transport = MultipeerTransport(displayName: displayName)
        transport.onReceive = { [weak self] message, peer in self?.handle(message, from: peer) }
        transport.onPeerConnected = { [weak self] peer in
            guard let self else { return }
            transport.send(.fullEventSnapshot(self.event), to: [peer])
            transport.send(.roleAnnounce(deviceID: DeviceIdentity.current, displayName: displayName, roles: self.roles), to: [peer])
        }
        transport.onPeerDisconnected = { [weak self] peer in
            self?.knownPeerRoles.removeValue(forKey: peer)
        }
        transport.startAdvertising()
        transport.startBrowsing()
        self.transport = transport
    }

    /// Tears down the live transport only — deliberately leaves `roles`/
    /// `activeJudgeID` alone. Those are this device's standing preference
    /// for *this event*, not connection state: briefly navigating back to
    /// the event list and returning shouldn't force re-picking Judge/
    /// Master/Screen every time, it should just reconnect and re-announce
    /// whatever was already chosen (see `onPeerConnected` in `connect`).
    func stopNetworking() {
        transport?.stopAll()
        transport = nil
        knownPeerRoles.removeAll()
    }

    /// Updates this device's active roles and tells every connected peer.
    /// Turning `.master` back off (e.g. to hand it to another device) is
    /// just calling this without it in the set — there's no separate
    /// "step down" message, since removing a role and adding one use the
    /// same announcement.
    func setRoles(_ newRoles: Set<PeerRole>) {
        roles = newRoles
        transport?.broadcast(.roleAnnounce(deviceID: DeviceIdentity.current, displayName: transport?.myPeerID.displayName ?? "", roles: roles))
    }

    private func handle(_ message: SyncMessage, from peer: MCPeerID) {
        switch message {
        case .fullEventSnapshot(let incoming):
            event = event.merged(with: incoming)
            persist()

        case .scoreSubmitted(let score):
            guard roles.contains(.master) else { return }
            var approved = score
            approved.status = .approved
            event.scores.append(approved)
            persist()
            transport?.broadcast(.scoresApproved([approved]))

        case .scoresApproved(let scores):
            event.scores = RosterMerge.mergeScores(local: event.scores, remote: scores)
            persist()

        case .rosterUpdated(let participants, let categories, let judges):
            event.participants = RosterMerge.merge(local: event.participants, remote: participants)
            event.categories = RosterMerge.merge(local: event.categories, remote: categories)
            event.judges = RosterMerge.merge(local: event.judges, remote: judges)
            persist()

        case .resetEvent:
            event.scores.removeAll()
            persist()

        case .advanceToFinals(let finalsEvent):
            event = finalsEvent
            persist()

        case .roleAnnounce(let deviceID, let displayName, let announcedRoles):
            knownPeerRoles[peer] = (deviceID, displayName, announcedRoles)

        case .requestUnsyncedScores, .unsyncedScores:
            // Not needed under this always-broadcast model — every approved
            // score is pushed the moment the master approves it, so there's
            // no "pull my unsynced scores" step the way the legacy
            // "JuezRev2"/"Sincronia" pair required.
            break
        }
    }

    // MARK: - Scoring

    @discardableResult
    func submitScore(judgeID: UUID, participantID: UUID, categoryID: UUID, value: Double) -> Score {
        let isMaster = roles.contains(.master)
        let score = Score(
            judgeID: judgeID,
            participantID: participantID,
            categoryID: categoryID,
            value: value,
            status: isMaster ? .approved : .pending
        )
        event.scores.append(score)
        persist()

        if isMaster {
            transport?.broadcast(.scoresApproved([score]))
        } else {
            transport?.broadcast(.scoreSubmitted(score))
        }
        return score
    }

    // MARK: - Roster & event control (any device may call these now — see
    // the sync architecture write-up for why roster editing is no longer
    // Master-gated)

    func resetScores() {
        event.scores.removeAll()
        persist()
        transport?.broadcast(.resetEvent)
    }

    /// Merges the given roster draft into this device's own event instead
    /// of replacing it outright, so a local edit composes with whatever
    /// was already merged in from peers rather than discarding it. Existing
    /// scores are untouched — this only ever changes the participant/judge/
    /// category *lists*, never renumbers ids `Score`s already reference.
    func updateRoster(participants: [Participant], judges: [Judge], categories: [ScoringCategory]) {
        event.participants = RosterMerge.merge(local: event.participants, remote: participants)
        event.judges = RosterMerge.merge(local: event.judges, remote: judges)
        event.categories = RosterMerge.merge(local: event.categories, remote: categories)
        event.updatedAt = Date()
        persist()
        transport?.broadcast(.rosterUpdated(participants: event.participants, categories: event.categories, judges: event.judges))
    }

    /// Kept separate from `updateRoster` so that method's other call sites
    /// don't have to pass branding values. Image *bytes* aren't synced to
    /// other devices yet — only this local Documents path is stored, so a
    /// Judge/Screen device that hasn't set its own logo just shows the
    /// placeholder instead of another device's art until image transfer is
    /// added (see the migration roadmap).
    func updateBranding(logoImageFilename: String?, backgroundImageFilename: String?) {
        event.logoImageFilename = logoImageFilename
        event.backgroundImageFilename = backgroundImageFilename
        event.updatedAt = Date()
        persist()
    }

    func advanceToFinals() {
        let finalists = RankingEngine.finalists(from: standings(), count: event.finalistCount)
        var finalsEvent = event
        finalsEvent.participants = finalists.map(\.participant)
        finalsEvent.scores = []
        finalsEvent.updatedAt = Date()
        event = finalsEvent
        persist()
        transport?.broadcast(.advanceToFinals(finalsEvent))
    }

    private func persist() {
        do {
            try store.save(event)
        } catch {
            persistenceError = error.localizedDescription
        }
    }
}
