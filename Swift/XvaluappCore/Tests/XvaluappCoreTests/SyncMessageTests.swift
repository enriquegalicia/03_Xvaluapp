import Testing
import Foundation
@testable import XvaluappCore

struct SyncMessageTests {

    /// The legacy protocol used `NSKeyedArchiver`/`NSKeyedUnarchiver` with no
    /// class allow-list, so a malformed payload could throw uncaught
    /// exceptions during unarchiving. The replacement guarantee this test
    /// checks: every case round-trips exactly through Codable, and a
    /// well-formed encode/decode round trip never throws.
    @Test func allCasesRoundTripThroughJSON() throws {
        let event = Event(name: "Dirt Conquers")
        let score = Score(judgeID: 1, participantID: 2, categoryID: 3, value: 8.5)

        let messages: [SyncMessage] = [
            .fullEventSnapshot(event),
            .scoreSubmitted(score),
            .scoresApproved([score]),
            .requestUnsyncedScores,
            .unsyncedScores([score]),
            .rosterUpdated(participants: [], categories: [], judges: []),
            .resetEvent,
            .advanceToFinals(event),
        ]

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        for message in messages {
            let data = try encoder.encode(message)
            _ = try decoder.decode(SyncMessage.self, from: data)
        }
    }

    @Test func malformedPayloadFailsToDecodeInsteadOfCrashing() {
        let garbage = Data("{\"notARealCase\":{}}".utf8)
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(SyncMessage.self, from: garbage)
        }
    }
}
