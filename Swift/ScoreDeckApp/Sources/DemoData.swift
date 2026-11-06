import Foundation
import XvaluappCore

/// A seed event for trying the app end to end, in the same spirit as the
/// legacy app's hardcoded "DirtConquers" seed event (`CreacionEventos.m`) —
/// except here it's one function you can delete, not baked into the launch
/// screen's default state.
enum DemoData {
    static func dirtConquers() -> Event {
        let deviceID = DeviceIdentity.current
        return Event(
            // Fictional on purpose. The legacy app's real event name used to be the demo, and a
            // real event's name has no place inside a general-purpose product.
            name: "Ridgeline Jam",
            participants: [
                Participant(name: "Mika Aguilar", countryCode: "MEX", originDeviceID: deviceID),
                Participant(name: "Sam Whitfield", countryCode: "USA", originDeviceID: deviceID),
                Participant(name: "Léo Bertrand", countryCode: "FRA", originDeviceID: deviceID),
                Participant(name: "Jonas Reyes", countryCode: "ESP", originDeviceID: deviceID),
                Participant(name: "Priya Osei", countryCode: "CAN", originDeviceID: deviceID),
            ],
            judges: [
                Judge(name: "R. Dominguez", originDeviceID: deviceID),
                Judge(name: "K. Marsh", originDeviceID: deviceID),
                Judge(name: "A. Fontaine", originDeviceID: deviceID),
                Judge(name: "T. Iwasaki", originDeviceID: deviceID),
                Judge(name: "L. Okafor", originDeviceID: deviceID),
            ],
            categories: [
                // Localized at creation time, not display time — these become
                // real ScoringCategory.name data a judge picks from, not UI
                // chrome, so they only get one chance to match the device's
                // language: right now, when the demo event is added.
                ScoringCategory(name: String(localized: "Difficulty"), originDeviceID: deviceID),
                ScoringCategory(name: String(localized: "Execution"), originDeviceID: deviceID),
                ScoringCategory(name: String(localized: "Style"), originDeviceID: deviceID),
            ],
            heatSize: 4,
            finalistCount: 3
        )
    }
}

#if DEBUG
/// App Store screenshot staging (Debug builds only). `-StoreShot <id>` seeds the demo event with
/// approved scores, except the last two riders' first category (they haven't ridden it yet, so
/// the judge's keypad has work on screen), and opens the screen the shot needs, without starting the
/// local-network session, whose permission alert a script can't dismiss.
enum StoreShot: String {
    case judge, leaderboard, console, roles, events

    static let requested: StoreShot? = {
        let args = ProcessInfo.processInfo.arguments
        guard let i = args.firstIndex(of: "-StoreShot"), i + 1 < args.count else { return nil }
        return StoreShot(rawValue: args[i + 1])
    }()

    var roles: Set<PeerRole> {
        switch self {
        case .judge: [.judge]
        case .leaderboard: [.scoreboard]
        case .console: [.master]
        case .roles, .events: []
        }
    }

    static func scoredDemoEvent() -> Event {
        var event = DemoData.dirtConquers()
        // A fixed spread, so retakes show the same standings: one clear leader, a tie-break
        // fight for second, and a rider at the back.
        let riderBase: [Double] = [88.5, 84.0, 83.6, 79.2, 71.4]
        let judgeLean: [Double] = [0, 1.2, -0.8, 0.6, -1.4]
        let categoryLean: [Double] = [-1.5, 0.9, 1.8]
        for (c, category) in event.categories.enumerated() {
            for (p, participant) in event.participants.enumerated() {
                for (j, judge) in event.judges.enumerated() {
                    if c == 0 && p >= 3 { continue }
                    let value = ((riderBase[p] + judgeLean[j] + categoryLean[c]) * 10).rounded() / 10
                    event.scores.append(Score(judgeID: judge.id, participantID: participant.id,
                                              categoryID: category.id, value: value, status: .approved))
                }
            }
        }
        return event
    }
}
#endif

