import Foundation

/// One judged competition, e.g. a single stop of a BMX/skate/wakeboard tour.
///
/// This replaces the old two-tier "Main.db `archivos` table -> one .db file
/// per event" design in `CreacionEventos.m` / `DataBase.m`. There the active
/// event was tracked only as a filename string in `NSUserDefaults`; here it's
/// a real, `Codable`, Identifiable value that can be persisted (see
/// `Persistence/EventStore.swift`), synced, exported, or archived.
public struct Event: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var name: String
    public var logoImageFilename: String?
    public var backgroundImageFilename: String?

    public var participants: [Participant]
    public var judges: [Judge]
    public var categories: [ScoringCategory]
    public var scores: [Score]

    /// Participants per heat/round grouping. Was `NSUserDefaults["Divisiones"]`
    /// (default 4) in `JudgePanel.m`.
    public var heatSize: Int

    /// How many top participants advance to the finals round. The legacy app
    /// hardcoded this to `12` inside `ProximaEliminatoria:` — here it's a
    /// per-event setting instead of a magic number baked into the app.
    public var finalistCount: Int

    /// When any event-level field below (name, branding, `heatSize`,
    /// `finalistCount`) last changed on *some* device. Two devices can edit
    /// these independently while disconnected; `merged(with:)` uses this to
    /// pick a winner instead of one side unconditionally overwriting the
    /// other the way `.fullEventSnapshot` used to.
    public var updatedAt: Date

    public init(
        id: UUID = UUID(),
        name: String,
        logoImageFilename: String? = nil,
        backgroundImageFilename: String? = nil,
        participants: [Participant] = [],
        judges: [Judge] = [],
        categories: [ScoringCategory] = [],
        scores: [Score] = [],
        heatSize: Int = 4,
        finalistCount: Int = 12,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.logoImageFilename = logoImageFilename
        self.backgroundImageFilename = backgroundImageFilename
        self.participants = participants
        self.judges = judges
        self.categories = categories
        self.scores = scores
        self.heatSize = heatSize
        self.finalistCount = finalistCount
        self.updatedAt = updatedAt
    }

    /// The roster minus tombstones (see `Participant.isDeleted`) — what
    /// every display site should iterate instead of the raw arrays above,
    /// which keep deleted rows around so a deletion can still merge/win a
    /// conflict correctly (see `RosterMerge`).
    public var activeParticipants: [Participant] { participants.filter { !$0.isDeleted } }
    public var activeJudges: [Judge] { judges.filter { !$0.isDeleted } }
    public var activeCategories: [ScoringCategory] { categories.filter { !$0.isDeleted } }
}

/// A competitor. Legacy table: `PARTICIPANTES(IDD, NOMBRE, PAIS)`.
public struct Participant: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var name: String
    /// Country code used to look up a flag asset (legacy `Bandera`), e.g. "MEX".
    public var countryCode: String
    /// Reference to a locally-stored photo or AI-generated portrait — see
    /// `Event.logoImageFilename` for the same idea at the event level. Falls
    /// back to the country flag anywhere it's shown when `nil`.
    public var imageFilename: String?
    public var updatedAt: Date
    public var originDeviceID: UUID
    /// A tombstone, not a removal — see `RosterMerge`. Deleting a row on one
    /// device while another device still has an older, non-deleted copy of
    /// the same id needs *some* record that a delete happened and when, or
    /// the union merge that keeps everyone's *additions* in sync would just
    /// as happily resurrect everyone's deletions too. Filtered out of every
    /// display list; kept in the data so the deletion itself can propagate
    /// and win or lose a conflict by `updatedAt` exactly like any other edit.
    public var isDeleted: Bool

    public init(
        id: UUID = UUID(),
        name: String,
        countryCode: String,
        imageFilename: String? = nil,
        updatedAt: Date = Date(),
        originDeviceID: UUID,
        isDeleted: Bool = false
    ) {
        self.id = id
        self.name = name
        self.countryCode = countryCode
        self.imageFilename = imageFilename
        self.updatedAt = updatedAt
        self.originDeviceID = originDeviceID
        self.isDeleted = isDeleted
    }
}

/// A judge. Legacy table: `JUECES(IDD, NOMBRE)`.
public struct Judge: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var name: String
    public var updatedAt: Date
    public var originDeviceID: UUID
    /// See `Participant.isDeleted`.
    public var isDeleted: Bool

    public init(id: UUID = UUID(), name: String, updatedAt: Date = Date(), originDeviceID: UUID, isDeleted: Bool = false) {
        self.id = id
        self.name = name
        self.updatedAt = updatedAt
        self.originDeviceID = originDeviceID
        self.isDeleted = isDeleted
    }
}

/// A scoring criterion / category ("Rubro"). Legacy table: `RUBROS(IDD, NOMBRE)`.
public struct ScoringCategory: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var name: String
    public var updatedAt: Date
    public var originDeviceID: UUID
    /// See `Participant.isDeleted`.
    public var isDeleted: Bool

    public init(id: UUID = UUID(), name: String, updatedAt: Date = Date(), originDeviceID: UUID, isDeleted: Bool = false) {
        self.id = id
        self.name = name
        self.updatedAt = updatedAt
        self.originDeviceID = originDeviceID
        self.isDeleted = isDeleted
    }
}
