import Foundation

/// Loads and saves `Event`s. Replaces `DataBase.m` (a hand-rolled raw-SQL
/// `sqlite3` wrapper with no parameter binding anywhere — every value,
/// including free-text participant/judge names, was interpolated straight
/// into SQL strings with `stringWithFormat:`, a real SQL-injection surface
/// documented in the migration report) and `GestorBD.m` (a thin schema
/// registry on top of it).
///
/// At this app's scale — a handful of events, dozens of participants, at
/// most a few thousand score rows per event — a SQL database buys nothing
/// that `Codable` + JSON doesn't already give more simply and more safely:
/// no query-building, no injection surface, no positional-column-index
/// mismatches (a documented bug in `DataBase.m`'s `getalltablesfromDB:`),
/// and free schema evolution via `Codable`'s normal `Decodable` defaulting
/// instead of `DataBase.m`'s "only creates tables if the file doesn't exist
/// yet, no migration path ever" limitation.
///
/// This protocol is the seam: the default implementation below is a plain
/// JSON-file store, but the same protocol could be backed by SwiftData
/// without changing any calling code, if a future version needs
/// cross-device iCloud sync of the event archive (the live Multipeer sync
/// during an event is unrelated to this — see `Sync/SyncMessage.swift`).
public protocol EventStoring: Sendable {
    func loadAll() throws -> [Event]
    func save(_ event: Event) throws
    func delete(eventID: UUID) throws
}

/// One JSON file per event, in the app's Application Support directory.
/// Human-readable, diffable, trivially backed-up/AirDropped between devices
/// (unlike the legacy per-event `.db` files), still fast enough at this
/// data scale to load an entire event into memory on open.
public final class JSONEventStore: EventStoring, @unchecked Sendable {
    private let directory: URL
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(directory: URL, fileManager: FileManager = .default) throws {
        self.directory = directory
        self.fileManager = fileManager
        self.encoder = JSONEncoder()
        self.encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder.dateEncodingStrategy = .iso8601
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    private func fileURL(for id: UUID) -> URL {
        directory.appendingPathComponent("\(id.uuidString).json")
    }

    public func loadAll() throws -> [Event] {
        let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            .filter { $0.pathExtension == "json" }
        return try files.map { url in
            let data = try Data(contentsOf: url)
            return try decoder.decode(Event.self, from: data)
        }
    }

    public func save(_ event: Event) throws {
        let data = try encoder.encode(event)
        try data.write(to: fileURL(for: event.id), options: .atomic)
    }

    public func delete(eventID: UUID) throws {
        let url = fileURL(for: eventID)
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }
}
