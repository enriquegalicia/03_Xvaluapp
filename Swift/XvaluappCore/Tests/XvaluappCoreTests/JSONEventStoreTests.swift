import Testing
import Foundation
@testable import XvaluappCore

struct JSONEventStoreTests {

    private func makeStore() throws -> (JSONEventStore, URL) {
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        return (try JSONEventStore(directory: dir), dir)
    }

    @Test func savedEventRoundTrips() throws {
        let (store, _) = try makeStore()
        let event = Event(name: "Dirt Conquers")
        try store.save(event)

        let loaded = try store.loadAll()
        #expect(loaded.map(\.id) == [event.id])
    }

    /// Regression test: a single file that fails to decode (e.g. left over
    /// from a schema this package no longer matches — `Int` participant ids
    /// before the migration to `UUID`, say) must not take the rest of the
    /// store down with it. `loadAll()` used to `try`-`map` every file, so
    /// one bad file made the whole call throw and return nothing — from the
    /// app, that looked like a freshly-saved event had silently failed to
    /// save, when really the *load* right after it was failing on some
    /// unrelated old file.
    @Test func oneUndecodableFileDoesNotBreakTheRestOfTheList() throws {
        let (store, dir) = try makeStore()
        let good = Event(name: "Readable Event")
        try store.save(good)

        // A file shaped nothing like a current `Event` — stands in for an
        // old-schema save or a truncated/corrupt write.
        let garbageURL = dir.appendingPathComponent("\(UUID().uuidString).json")
        try Data("{\"notAnEvent\":true}".utf8).write(to: garbageURL)

        let loaded = try store.loadAll()
        #expect(loaded.map(\.id) == [good.id], "the unreadable file must be skipped, not abort the whole load")
    }

    @Test func deleteRemovesOnlyThatEvent() throws {
        let (store, _) = try makeStore()
        let keep = Event(name: "Keep")
        let remove = Event(name: "Remove")
        try store.save(keep)
        try store.save(remove)

        try store.delete(eventID: remove.id)

        let loaded = try store.loadAll()
        #expect(loaded.map(\.id) == [keep.id])
    }
}
