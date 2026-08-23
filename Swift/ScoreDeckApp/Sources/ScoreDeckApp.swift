import SwiftUI
import AguaDesign
import XvaluappCore

@main
struct ScoreDeckApp: App {
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
            // Amber is this app's one AguaColor.Accent — dirt/trophy-gold,
            // and distinct from the accents already saturated elsewhere in
            // the Lab (see ICON_STYLE_GUIDE.md's accent bridge). Setting it
            // here, once, makes every default-tinted control across the app
            // (buttons, pickers, the role-selection icon) pick it up.
            EventListView(store: store)
                .tint(AguaColor.Accent.amber)
                .aguaBackground()
        }
    }
}
