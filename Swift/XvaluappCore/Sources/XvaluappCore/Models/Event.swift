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
        finalistCount: Int = 12
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
    }
}

/// A competitor. Legacy table: `PARTICIPANTES(IDD, NOMBRE, PAIS)`.
public struct Participant: Identifiable, Codable, Hashable, Sendable {
    public var id: Int
    public var name: String
    /// Country code used to look up a flag asset (legacy `Bandera`), e.g. "MEX".
    public var countryCode: String

    public init(id: Int, name: String, countryCode: String) {
        self.id = id
        self.name = name
        self.countryCode = countryCode
    }
}

/// A judge. Legacy table: `JUECES(IDD, NOMBRE)`.
public struct Judge: Identifiable, Codable, Hashable, Sendable {
    public var id: Int
    public var name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

/// A scoring criterion / category ("Rubro"). Legacy table: `RUBROS(IDD, NOMBRE)`.
public struct ScoringCategory: Identifiable, Codable, Hashable, Sendable {
    public var id: Int
    public var name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
