import Testing
import Foundation
@testable import XvaluappCore

struct RankingEngineTests {

    let deviceID = UUID()
    let aliceID = UUID()
    let bobID = UUID()
    let cyID = UUID()
    let judgeID = UUID()
    let judge2ID = UUID()
    let categoryID = UUID()
    let category2ID = UUID()

    var participants: [Participant] {
        [
            Participant(id: aliceID, name: "Alice", countryCode: "MEX", originDeviceID: deviceID),
            Participant(id: bobID, name: "Bob", countryCode: "USA", originDeviceID: deviceID),
            Participant(id: cyID, name: "Cy", countryCode: "ESP", originDeviceID: deviceID),
        ]
    }

    @Test func ranksByAverageDescending() {
        let scores = [
            Score(judgeID: judgeID, participantID: aliceID, categoryID: categoryID, value: 8.0, status: .approved),
            Score(judgeID: judge2ID, participantID: aliceID, categoryID: categoryID, value: 9.0, status: .approved),
            Score(judgeID: judgeID, participantID: bobID, categoryID: categoryID, value: 7.0, status: .approved),
            Score(judgeID: judge2ID, participantID: bobID, categoryID: categoryID, value: 7.5, status: .approved),
        ]
        let standings = RankingEngine.standings(participants: participants, scores: scores)

        #expect(standings.map(\.participant.id) == [aliceID, bobID])
        #expect(abs(standings[0].averageScore - 8.5) < 0.0001)
        #expect(standings[0].rank == 1)
        #expect(abs(standings[1].averageScore - 7.25) < 0.0001)
    }

    @Test func participantsWithNoApprovedScoresAreExcluded() {
        let scores = [
            Score(judgeID: judgeID, participantID: aliceID, categoryID: categoryID, value: 8.0, status: .pending),
        ]
        let standings = RankingEngine.standings(participants: participants, scores: scores)
        #expect(standings.isEmpty, "a pending-only score must not count toward the official leaderboard")
    }

    @Test func onlyApprovedFalseIncludesPending() {
        let scores = [
            Score(judgeID: judgeID, participantID: aliceID, categoryID: categoryID, value: 8.0, status: .pending),
        ]
        let standings = RankingEngine.standings(participants: participants, scores: scores, onlyApproved: false)
        #expect(standings.count == 1)
    }

    @Test func nearTiesAreFlagged() {
        let scores = [
            Score(judgeID: judgeID, participantID: aliceID, categoryID: categoryID, value: 8.0, status: .approved),
            Score(judgeID: judgeID, participantID: bobID, categoryID: categoryID, value: 8.05, status: .approved),
            Score(judgeID: judgeID, participantID: cyID, categoryID: categoryID, value: 5.0, status: .approved),
        ]
        let standings = RankingEngine.standings(participants: participants, scores: scores, tieThreshold: 0.2)
        let byID = Dictionary(uniqueKeysWithValues: standings.map { ($0.participant.id, $0) })

        #expect(byID[aliceID]!.isTiedWithNeighbor)
        #expect(byID[bobID]!.isTiedWithNeighbor)
        #expect(!byID[cyID]!.isTiedWithNeighbor, "5.0 is not within the tie threshold of 8.05")
    }

    @Test func finalistsTakesTopNInRankOrder() {
        let ids = [aliceID, bobID, cyID]
        let scores = ids.enumerated().map { index, pid in
            Score(judgeID: judgeID, participantID: pid, categoryID: categoryID, value: Double(10 - index), status: .approved)
        }
        let standings = RankingEngine.standings(participants: participants, scores: scores)
        let finalists = RankingEngine.finalists(from: standings, count: 2)

        #expect(finalists.map(\.participant.id) == [aliceID, bobID])
        #expect(finalists.first?.rank == 1, "unlike the legacy ProximaEliminatoria:, rank order is preserved, not reversed")
    }

    @Test func categoryFilterRestrictsAverage() {
        let scores = [
            Score(judgeID: judgeID, participantID: aliceID, categoryID: categoryID, value: 10.0, status: .approved),
            Score(judgeID: judgeID, participantID: aliceID, categoryID: category2ID, value: 0.0, status: .approved),
        ]
        let overall = RankingEngine.standings(participants: participants, scores: scores)
        let categoryOnly = RankingEngine.standings(participants: participants, scores: scores, categoryID: categoryID)

        #expect(abs((overall.first?.averageScore ?? -1) - 5.0) < 0.0001)
        #expect(abs((categoryOnly.first?.averageScore ?? -1) - 10.0) < 0.0001)
    }
}
