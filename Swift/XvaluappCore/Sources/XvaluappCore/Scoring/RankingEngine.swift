import Foundation

/// One row of a leaderboard: a participant's average score and rank.
///
/// Replaces the ad hoc `idaiNoCa*` / `idNoCa*` family in `Subtitulados.m`
/// (~6 near-duplicate methods) and the `AVG(calificacion) GROUP BY nombre
/// ORDER BY AVG DESC` query duplicated three times across
/// `cargarresultadosglobales/rondas/m` in `JudgePanel.m`.
public struct RankingRow: Identifiable, Hashable, Sendable {
    public var rank: Int
    public var participant: Participant
    public var averageScore: Double
    /// Number of category marks this average is built from — surfaced so the
    /// UI can flag "only 1 of 5 judges scored" instead of silently averaging
    /// whatever exists yet, which the legacy `AVG()` query did unconditionally.
    public var scoreCount: Int
    /// True when this row's score is a near-tie with a neighboring row and
    /// should be visually highlighted, replacing the exact/near-tie
    /// `Colores` logic duplicated (and in two places, dead/commented-out) in
    /// `Subtitulados.m`.
    public var isTiedWithNeighbor: Bool

    public var id: Int { participant.id }
}

public enum RankingEngine {

    /// Ranks participants by mean score, highest first.
    ///
    /// - Parameters:
    ///   - scores: all scores for the event (any status).
    ///   - onlyApproved: when `true` (the default, matching what the legacy
    ///     "official" leaderboard should have done) only `.approved` scores
    ///     count toward the average. The legacy `EVALUACION`-table query had
    ///     no equivalent filter available at the SQL layer for this — pending
    ///     `BUFFER` rows and approved `EVALUACION` rows lived in different
    ///     tables, so this distinction existed only by *which table* you
    ///     queried, not as an explicit, testable rule.
    ///   - categoryID: restrict to one scoring category, or `nil` for the
    ///     overall average across all categories.
    ///   - tieThreshold: score delta below which two adjacent rows are
    ///     flagged as tied. The legacy code used two different inconsistent
    ///     thresholds (`== 0` in one method, `< 0.2` in another) depending on
    ///     which `Subtitulados` method happened to be called — this makes it
    ///     one explicit parameter instead.
    public static func standings(
        participants: [Participant],
        scores: [Score],
        onlyApproved: Bool = true,
        categoryID: Int? = nil,
        tieThreshold: Double = 0.2
    ) -> [RankingRow] {
        let relevant = scores
            .filter { !onlyApproved || $0.status == .approved }
            .filter { categoryID == nil || $0.categoryID == categoryID }

        var byParticipant: [Int: [Double]] = [:]
        for score in relevant {
            byParticipant[score.participantID, default: []].append(score.value)
        }

        let ranked = participants.compactMap { participant -> (Participant, Double, Int)? in
            guard let values = byParticipant[participant.id], !values.isEmpty else { return nil }
            let average = values.reduce(0, +) / Double(values.count)
            return (participant, average, values.count)
        }
        .sorted { $0.1 > $1.1 }

        return ranked.enumerated().map { index, entry in
            let (participant, average, count) = entry
            let previousAverage = index > 0 ? ranked[index - 1].1 : nil
            let nextAverage = index + 1 < ranked.count ? ranked[index + 1].1 : nil
            let tied = [previousAverage, nextAverage]
                .compactMap { $0 }
                .contains { abs($0 - average) < tieThreshold }
            return RankingRow(
                rank: index + 1,
                participant: participant,
                averageScore: average,
                scoreCount: count,
                isTiedWithNeighbor: tied
            )
        }
    }

    /// Selects the finalists for the next elimination round.
    ///
    /// Replaces `ProximaEliminatoria:` in `JudgePanel.m`, which hardcoded
    /// `LIMIT 12`, then rebuilt the finalist list in *reverse* order so the
    /// lowest-ranked finalist got id `1` — an artifact of how the old
    /// SQL-result array happened to be indexed, not an intentional ordering.
    /// This returns finalists already in proper rank order (best first).
    public static func finalists(
        from standings: [RankingRow],
        count: Int
    ) -> [RankingRow] {
        Array(standings.prefix(count))
    }
}
