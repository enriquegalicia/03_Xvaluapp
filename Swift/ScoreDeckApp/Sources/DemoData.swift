import Foundation
import XvaluappCore

/// A seed event for trying the app end to end, in the same spirit as the
/// legacy app's hardcoded "DirtConquers" seed event (`CreacionEventos.m`) —
/// except here it's one function you can delete, not baked into the launch
/// screen's default state.
enum DemoData {
    static func dirtConquers() -> Event {
        Event(
            name: "Dirt Conquers",
            participants: [
                Participant(id: 1, name: "Mika Aguilar", countryCode: "MEX"),
                Participant(id: 2, name: "Sam Whitfield", countryCode: "USA"),
                Participant(id: 3, name: "Léo Bertrand", countryCode: "FRA"),
                Participant(id: 4, name: "Jonas Reyes", countryCode: "ESP"),
                Participant(id: 5, name: "Priya Osei", countryCode: "CAN"),
            ],
            judges: [
                Judge(id: 1, name: "R. Dominguez"),
                Judge(id: 2, name: "K. Marsh"),
                Judge(id: 3, name: "A. Fontaine"),
                Judge(id: 4, name: "T. Iwasaki"),
                Judge(id: 5, name: "L. Okafor"),
            ],
            categories: [
                // Localized at creation time, not display time — these become
                // real ScoringCategory.name data a judge picks from, not UI
                // chrome, so they only get one chance to match the device's
                // language: right now, when the demo event is added.
                ScoringCategory(id: 1, name: String(localized: "Difficulty")),
                ScoringCategory(id: 2, name: String(localized: "Execution")),
                ScoringCategory(id: 3, name: String(localized: "Style")),
            ],
            heatSize: 4,
            finalistCount: 3
        )
    }
}
