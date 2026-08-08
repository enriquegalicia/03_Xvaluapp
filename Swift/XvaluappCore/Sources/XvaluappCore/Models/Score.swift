import Foundation

/// One judge's mark for one participant on one category.
///
/// The legacy schema spread this across three parallel tables with identical
/// columns — `EVALUACIONLO` (judge's local/unsynced copy), `BUFFER` (staged
/// on the master, pending approval), and `EVALUACION` (approved/authoritative)
/// — and moved a score between them by literally re-INSERTing full row
/// copies as messages arrived (`actualizarcalifa:`, `Syncronizeall:` in
/// `JudgePanel.m`). That's three sources of truth for what is really one
/// piece of data with a lifecycle. Here it's one `Score` value with a
/// `status`, and `SyncMessage` (see Sync/) carries the *transition*, not a
/// full row copy, over the wire.
public struct Score: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var judgeID: Int
    public var participantID: Int
    public var categoryID: Int
    public var value: Double
    public var status: Status
    /// When this mark was recorded, for audit/undo — the legacy app had no
    /// timestamps anywhere, which made "who changed this and when" unanswerable.
    public var recordedAt: Date

    public enum Status: String, Codable, Sendable {
        /// Entered by a judge, not yet reviewed by the master device.
        /// (was: a row that only existed in `BUFFER` with `aprobado="0"`)
        case pending
        /// Reviewed and locked in by the master device.
        /// (was: `aprobado="1"` in `BUFFER`, mirrored into `EVALUACION`)
        case approved
    }

    public init(
        id: UUID = UUID(),
        judgeID: Int,
        participantID: Int,
        categoryID: Int,
        value: Double,
        status: Status = .pending,
        recordedAt: Date = Date()
    ) {
        self.id = id
        self.judgeID = judgeID
        self.participantID = participantID
        self.categoryID = categoryID
        self.value = value
        self.status = status
        self.recordedAt = recordedAt
    }
}
