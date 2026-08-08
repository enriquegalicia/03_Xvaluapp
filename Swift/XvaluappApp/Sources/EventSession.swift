import Foundation
import Observation
import XvaluappCore

/// Holds one open event plus the store to persist it back to. Every mutating
/// call here saves immediately — there is no separate "sync" step the way
/// the legacy app needed one (a judge's score went into `EVALUACIONLO` and
/// stayed invisible to the official leaderboard until a master device
/// explicitly pulled and approved it over Multipeer). Approval as a concept
/// is preserved (`Score.Status`), but persistence itself is no longer
/// coupled to the network.
@Observable
final class EventSession {
    private(set) var event: Event
    private let store: any EventStoring

    init(event: Event, store: any EventStoring) {
        self.event = event
        self.store = store
    }

    var standings: [RankingRow] {
        RankingEngine.standings(participants: event.participants, scores: event.scores)
    }

    /// Participants who don't yet have an approved score in the given
    /// category — the modern equivalent of the legacy `Siguientes` /
    /// "cargasiguientes" queue, minus the bug where judges were forced
    /// through it in strict id order with no way to go back.
    func participantsAwaitingScore(in categoryID: Int) -> [Participant] {
        let scored = Set(
            event.scores
                .filter { $0.categoryID == categoryID && $0.status == .approved }
                .map(\.participantID)
        )
        return event.participants.filter { !scored.contains($0.id) }
    }

    @discardableResult
    func submitScore(judgeID: Int, participantID: Int, categoryID: Int, value: Double) -> Score {
        let score = Score(
            judgeID: judgeID,
            participantID: participantID,
            categoryID: categoryID,
            value: value,
            status: .approved
        )
        event.scores.append(score)
        persist()
        return score
    }

    private func persist() {
        // Mirrors the legacy DataBase.m failure mode in one respect on
        // purpose: if this throws, better to know immediately in
        // development than to silently drop a judge's score the way
        // `sqlite3_exec` errors were swallowed there. A shipping build
        // should surface this as a retry/alert, not a fatalError.
        try! store.save(event)
    }
}
