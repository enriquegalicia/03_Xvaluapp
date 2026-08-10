import Foundation
import Observation
import MultipeerConnectivity
import XvaluappCore

/// Holds one open event, the store to persist it to, and — once
/// `startNetworking(as:displayName:)` is called — the Multipeer transport
/// syncing it with other devices at the same event.
///
/// This collapses what the legacy app spread across `JudgePanel.m`'s
/// `session:didReceiveData:fromPeer:` (a 90-line flat if-chain keyed on a
/// free-text `"Acceso"` string) into one exhaustive `switch` over
/// `SyncMessage`, and replaces the three-table `EVALUACION` /
/// `EVALUACIONLO` / `BUFFER` score lifecycle with a single `Score.Status`
/// that a `.scoreSubmitted` → `.scoresApproved` round trip advances.
@Observable
final class EventSession {
    private(set) var event: Event
    private let store: any EventStoring

    private(set) var role: PeerRole?
    private(set) var transport: MultipeerTransport?

    init(event: Event, store: any EventStoring) {
        self.event = event
        self.store = store
    }

    var standings: [RankingRow] {
        RankingEngine.standings(participants: event.participants, scores: event.scores)
    }

    /// Participants who don't yet have an approved score in the given
    /// category — the modern equivalent of the legacy `Siguientes` /
    /// "cargasiguientes" queue, minus the bug where judges were forced
    /// through it in strict id order with no way to go back.
    func participantsAwaitingScore(in categoryID: Int) -> [Participant] {
        let scored = Set(
            event.scores
                .filter { $0.categoryID == categoryID && $0.status == .approved }
                .map(\.participantID)
        )
        return event.participants.filter { !scored.contains($0.id) }
    }

    // MARK: - Networking

    /// The master both advertises (so judge/screen devices can find it) and
    /// browses (so its "Connections" screen can show and invite nearby
    /// devices too) — same "every peer can do both" shape the legacy app
    /// used, but now the *role* each connected peer plays is an explicit,
    /// typed choice made on this screen, not a string stashed in
    /// `MCPeerID.accessibilityLabel` that peers never actually exchanged.
    func startNetworking(as role: PeerRole, displayName: String) {
        self.role = role
        let transport = MultipeerTransport(displayName: displayName)
        transport.onReceive = { [weak self] message, _ in self?.handle(message) }
        if role == .master {
            transport.onPeerConnected = { [weak self] peer in
                guard let self else { return }
                transport.send(.fullEventSnapshot(self.event), to: [peer])
            }
        }
        transport.startAdvertising()
        transport.startBrowsing()
        self.transport = transport
    }

    func stopNetworking() {
        transport?.stopAll()
        transport = nil
        role = nil
    }

    private func handle(_ message: SyncMessage) {
        switch message {
        case .fullEventSnapshot(let incoming):
            // The master is always authoritative for its own event; it
            // ignores snapshots (there should be only one master, but see
            // the leader-election note in the migration dossier — this
            // guard is the cheap half of that fix, not the whole thing).
            guard role != .master else { return }
            event = incoming

        case .scoreSubmitted(let score):
            guard role == .master else { return }
            var approved = score
            approved.status = .approved
            event.scores.append(approved)
            persist()
            transport?.broadcast(.scoresApproved([approved]))

        case .scoresApproved(let scores):
            guard role != .master else { return }
            let existingIDs = Set(event.scores.map(\.id))
            event.scores.append(contentsOf: scores.filter { !existingIDs.contains($0.id) })
            persist()

        case .rosterUpdated(let participants, let categories, let judges):
            guard role != .master else { return }
            event.participants = participants
            event.categories = categories
            event.judges = judges
            persist()

        case .resetEvent:
            event.scores.removeAll()
            persist()

        case .advanceToFinals(let finalsEvent):
            guard role != .master else { return }
            event = finalsEvent
            persist()

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
    func submitScore(judgeID: Int, participantID: Int, categoryID: Int, value: Double) -> Score {
        let isMaster = role == .master || role == nil
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

    // MARK: - Master-only actions (see MasterConsoleView)

    func resetScores() {
        event.scores.removeAll()
        persist()
        transport?.broadcast(.resetEvent)
    }

    func advanceToFinals() {
        let finalists = RankingEngine.finalists(from: standings, count: event.finalistCount)
        var finalsEvent = event
        finalsEvent.participants = finalists.map(\.participant)
        finalsEvent.scores = []
        event = finalsEvent
        persist()
        transport?.broadcast(.advanceToFinals(finalsEvent))
    }

    private func persist() {
        // A shipping build should surface a save failure as a retry/alert;
        // `try!` here matches the rest of this prototype pass (see
        // XvaluappApp.swift) rather than silently swallowing it the way
        // `DataBase.m`'s sqlite3 error paths did.
        try! store.save(event)
    }
}
