import Foundation

/// Who a connected peer is, in this session. Replaces stashing the role
/// string ("Maestra"/"Juez"/"Pantalla") in `MCPeerID.accessibilityLabel` —
/// an accessibility API repurposed as a role tag in `JudgePanel.m`, readable
/// only locally (a peer could never tell *another* peer's role from it).
///
/// A device holds a *set* of these, not one exclusive value — the legacy
/// app (and this app's first pass) forced Judge/Master/Screen to be
/// mutually exclusive, which doesn't fit an event run by fewer staff than
/// roles: the Master device reviewing scores should also be able to judge
/// or watch the leaderboard without giving up Master, and one device can
/// cover both Judge and Screen duty. Exactly one connected device may hold
/// `.master` at a time (enforced client-side — see `EventSession.canEnableMaster`);
/// the other two roles are unrestricted.
public enum PeerRole: String, Codable, Sendable, CaseIterable {
    case master   // was "Maestra"
    case judge    // was "Juez"
    case scoreboard // was "Pantalla"
}

/// The Multipeer wire protocol, as a typed, `Codable` enum.
///
/// Replaces the legacy protocol of `NSMutableDictionary` payloads keyed by a
/// free-text `"Acceso"` discriminator string (`"Inicial"`, `"Dato"`,
/// `"Pantalla"`, `"JuezRev"`, `"JuezRev2"`, `"Sincronia"`, `"UpdateLocal"`,
/// `"UpdateOrder"`, `"CleanThemAll"`, `"Eliminatorias"` — 10 ad hoc shapes,
/// see `JudgePanel.m: session:didReceiveData:fromPeer:`), archived with the
/// deprecated, non-`NSSecureCoding` `NSKeyedArchiver`/`NSKeyedUnarchiver`
/// APIs, and dispatched with unguarded `objectAtIndex:` calls that crash on
/// any malformed payload.
///
/// With `Codable` + `JSONEncoder`/`JSONDecoder` (or `PropertyListEncoder` for
/// a smaller wire size), a switch over this enum is exhaustive at compile
/// time, and a malformed/foreign payload simply fails `decode(...)` instead
/// of crashing the app.
///
/// This intentionally does **not** reproduce two legacy quirks 1:1:
///  - "Dato"/"Aprobar" were two message types with an identical payload
///    shape (the analysis couldn't find any sender for "Aprobar" — it reads
///    as dead code); they collapse to one `.scoreSubmitted` case here.
///  - "Pantalla" and "JuezRev" broadcast the *same* payload to two different
///    role filters; here that's one `.scoresApproved` message plus an
///    explicit `recipients: Set<PeerRole>` the transport layer checks,
///    rather than two separate message types.
public enum SyncMessage: Codable, Sendable {
    /// Sent to a newly-connected peer (both directions — every device does
    /// this now, not just Master) and merged into the receiver's own event
    /// via `Event.merged(with:)` rather than overwriting it outright. Was
    /// "Inicial", and was one-directional/overwrite-on-receive before this
    /// pass — Master is no longer the sole owner of roster truth, so it has
    /// to merge incoming snapshots too instead of ignoring them.
    case fullEventSnapshot(Event)

    /// Judge -> master: one newly-entered score. Was "Dato" (and the
    /// apparently-dead "Aprobar").
    case scoreSubmitted(Score)

    /// Master -> judges + scoreboard: these scores are now approved and
    /// authoritative. Was "Pantalla" + "JuezRev" (two messages, same shape).
    case scoresApproved([Score])

    /// Master -> judge devices: request any scores the judge holds locally
    /// that the master hasn't seen yet. Was "JuezRev2" (misleadingly named
    /// "Extract" at the call site — it triggers a *pull*, it doesn't export
    /// a file; nothing in the legacy app writes a results file anywhere).
    case requestUnsyncedScores

    /// Judge -> master: reply to `.requestUnsyncedScores`. Was "Sincronia".
    case unsyncedScores([Score])

    /// Any device -> all: roster/category edits propagated live, merged
    /// into the receiver's roster via `RosterMerge` rather than replacing
    /// it. Was "UpdateOrder", and was Master-only in both directions before
    /// this pass — roster population is no longer gated to the Master
    /// device, so any device can send this.
    case rosterUpdated(participants: [Participant], categories: [ScoringCategory], judges: [Judge])

    /// Any device -> all, whenever its active roles change (including once
    /// to every peer right after connecting). Lets every device keep a live
    /// map of which connected peer holds which role(s) — what the
    /// client-side Master-singleton guard and the Connections list both
    /// read from. Has no legacy equivalent; the old app never exchanged
    /// role information between peers at all.
    case roleAnnounce(deviceID: UUID, displayName: String, roles: Set<PeerRole>)

    /// Master -> all: wipe all local competition data. Was "CleanThemAll",
    /// reachable in the legacy app only via typing "Reset" into a plaintext
    /// password field with no confirmation dialog on any receiving device.
    /// Keep the message; the new client MUST require a confirmation step
    /// before acting on it (see migration report, "Admin console" item).
    case resetEvent

    /// Master -> all: cut over to the next elimination round with a new
    /// finalist roster. Was "Eliminatorias". The legacy version hardcoded
    /// `LIMIT 12` finalists and two literal filenames
    /// (`"DirtConquersFinals1.db"`); here the finalist `Event` is just a
    /// normal `Event` value, no magic filenames involved.
    case advanceToFinals(Event)
}
