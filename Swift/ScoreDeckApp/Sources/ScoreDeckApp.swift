import SwiftUI
import AguaDesign
import XvaluappCore

@main
struct ScoreDeckApp: App {
    @State private var store: JSONEventStore

    init() {
        // ScoreDeck's own look, not the shared portfolio slate (App Review
        // rejected look-alike apps from this account under 4.3).
        AguaTheme.current = .scoreDeck
        let directory = FileManager.default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("Events", isDirectory: true)
        // If this ever fails (e.g. disk full), better to crash loudly at launch
        // than silently swallow it the way the legacy DataBase.m did.
        _store = State(initialValue: try! JSONEventStore(directory: directory))
    }

    var body: some Scene {
        WindowGroup {
            // LED amber, ScoreDeck's own accent (no longer a shared house
            // swatch). Set once here, so every default-tinted control across
            // the app (buttons, pickers, the role-selection icon) picks it up.
            EventListView(store: store)
                .tint(Color.scoreboardAmber)
                .aguaBackground()
        }
    }
}

// MARK: - ScoreDeck's look

extension AguaTheme {
    /// A scoreboard at night: warm graphite panels and LED amber. Neutral
    /// warm greys, where the old shared portfolio look was a cool blue slate.
    static let scoreDeck = AguaTheme(
        colorScheme: .dark,
        bgPrimary: Color(hex: 0x141312),
        bgSecondary: Color(hex: 0x1C1A18),
        bgCard: Color(hex: 0x252220),
        bgElevated: Color(hex: 0x312D29),
        textPrimary: Color(hex: 0xF7F2E8),
        textSecondary: Color(hex: 0xCDC5B6),
        textMuted: Color(hex: 0x908878),
        success: Color(hex: 0x6BD08A),
        warning: Color(hex: 0xF2B33D),
        error: Color(hex: 0xFF6A5C),
        info: Color(hex: 0x8CC4FF)
    )
}

extension Color {
    /// LED amber, ScoreDeck's accent: the exact amber of the icon's clipboard and star.
    static let scoreboardAmber = Color(hex: 0xF2B33D)
}

