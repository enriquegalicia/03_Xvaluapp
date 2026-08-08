import Testing
@testable import XvaluappCore

struct RankingEngineTests {

    let participants = [
        Participant(id: 1, name: "Alice", countryCode: "MEX"),
        Participant(id: 2, name: "Bob", countryCode: "USA"),
        Participant(id: 3, name: "Cy", countryCode: "ESP"),
    ]

    @Test func ranksByAverageDescending() {
        let scores = [
            Score(judgeID: 1, participantID: 1, categoryID: 1, value: 8.0, status: .approved),
            Score(judgeID: 2, participantID: 1, categoryID: 1, value: 9.0, status: .approved),
            Score(judgeID: 1, participantID: 2, categoryID: 1, value: 7.0, status: .approved),
            Score(judgeID: 2, participantID: 2, categoryID: 1, value: 7.5, status: .approved),
        ]
        let standings = RankingEngine.standings(participants: participants, scores: scores)

        #expect(standings.map(\.participant.id) == [1, 2])
        #expect(abs(standings[0].averageScore - 8.5) < 0.0001)
        #expect(standings[0].rank == 1)
        #expect(abs(standings[1].averageScore - 7.25) < 0.0001)
    }

    @Test func participantsWithNoApprovedScoresAreExcluded() {
        let scores = [
            Score(judgeID: 1, participantID: 1, categoryID: 1, value: 8.0, status: .pending),
        ]
        let standings = RankingEngine.standings(participants: participants, scores: scores)
        #expect(standings.isEmpty, "a pending-only score must not count toward the official leaderboard")
    }

    @Test func onlyApprovedFalseIncludesPending() {
        let scores = [
            Score(judgeID: 1, participantID: 1, categoryID: 1, value: 8.0, status: .pending),
        ]
        let standings = RankingEngine.standings(participants: participants, scores: scores, onlyApproved: false)
        #expect(standings.count == 1)
    }

    @Test func nearTiesAreFlagged() {
        let scores = [
            Score(judgeID: 1, participantID: 1, categoryID: 1, value: 8.0, status: .approved),
            Score(judgeID: 1, participantID: 2, categoryID: 1, value: 8.05, status: .approved),
            Score(judgeID: 1, participantID: 3, categoryID: 1, value: 5.0, status: .approved),
        ]
        let standings = RankingEngine.standings(participants: participants, scores: scores, tieThreshold: 0.2)
        let byID = Dictionary(uniqueKeysWithValues: standings.map { ($0.participant.id, $0) })

        #expect(byID[1]!.isTiedWithNeighbor)
        #expect(byID[2]!.isTiedWithNeighbor)
        #expect(!byID[3]!.isTiedWithNeighbor, "5.0 is not within the tie threshold of 8.05")
    }

    @Test func finalistsTakesTopNInRankOrder() {
        let scores = (1...3).map { pid in
            Score(judgeID: 1, participantID: pid, categoryID: 1, value: Double(10 - pid), status: .approved)
        }
        let standings = RankingEngine.standings(participants: participants, scores: scores)
        let finalists = RankingEngine.finalists(from: standings, count: 2)

        #expect(finalists.map(\.participant.id) == [1, 2])
        #expect(finalists.first?.rank == 1, "unlike the legacy ProximaEliminatoria:, rank order is preserved, not reversed")
    }

    @Test func categoryFilterRestrictsAverage() {
        let scores = [
            Score(judgeID: 1, participantID: 1, categoryID: 1, value: 10.0, status: .approved),
            Score(judgeID: 1, participantID: 1, categoryID: 2, value: 0.0, status: .approved),
        ]
        let overall = RankingEngine.standings(participants: participants, scores: scores)
        let categoryOnly = RankingEngine.standings(participants: participants, scores: scores, categoryID: 1)

        #expect(abs((overall.first?.averageScore ?? -1) - 5.0) < 0.0001)
        #expect(abs((categoryOnly.first?.averageScore ?? -1) - 10.0) < 0.0001)
    }
}
