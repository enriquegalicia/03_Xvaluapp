import SwiftUI
import XvaluappCore

@main
struct XvaluappApp: App {
    @State private var store: JSONEventStore

    init() {
        let directory = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Events", isDirectory: true)
        // If this ever fails (e.g. disk full), better to crash loudly at launch
        // than silently swallow it the way the legacy DataBase.m did.
        _store = State(initialValue: try! JSONEventStore(directory: directory))
    }

    var body: some Scene {
        WindowGroup {
            EventListView(store: store)
        }
    }
}
