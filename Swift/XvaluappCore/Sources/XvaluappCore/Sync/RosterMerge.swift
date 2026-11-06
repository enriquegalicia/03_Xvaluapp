import Foundation

/// Anything that can be merged with another copy of itself by id, picking a
/// winner on conflict instead of one side unconditionally clobbering the
/// other. `Participant`, `Judge`, and `ScoringCategory` all conform — see
/// their `updatedAt`/`originDeviceID` fields.
public protocol MergeableEntity: Identifiable {
    var updatedAt: Date { get }
    var originDeviceID: UUID { get }
}

extension Participant: MergeableEntity {}
extension Judge: MergeableEntity {}
extension ScoringCategory: MergeableEntity {}

/// Merges the roster/scores two devices each independently built up —
/// replacing the old "master pushes a full snapshot, everyone else
/// overwrites their copy with it" model, which silently dropped whatever a
/// non-master device had added locally. Both sides of a merge end up with
/// the same result, so it doesn't matter which device merges into which.
public enum RosterMerge {

    /// Unions `local` and `remote` by id. An id present on only one side
    /// passes through unchanged — this is what lets any device add
    /// participants/judges/categories without a peer's own additions
    /// getting lost when the two lists are reconciled. An id present on
    /// both sides keeps whichever copy has the later `updatedAt`; an exact
    /// tie (e.g. two clocks that happen to match) falls back to comparing
    /// `originDeviceID` so every device resolves the tie the same way.
    public static func merge<T: MergeableEntity>(local: [T], remote: [T]) -> [T] {
        var byID: [T.ID: T] = [:]
        for item in local { byID[item.id] = item }
        for item in remote {
            guard let existing = byID[item.id] else {
                byID[item.id] = item
                continue
            }
            byID[item.id] = winner(existing, item)
        }
        // Stable-ish ordering: local order first, then any remote-only
        // additions appended in their remote order, rather than whatever
        // order the dictionary happens to iterate in.
        var seen = Set<T.ID>()
        var ordered: [T] = []
        for item in local {
            guard let resolved = byID[item.id], !seen.contains(item.id) else { continue }
            ordered.append(resolved)
            seen.insert(item.id)
        }
        for item in remote where !seen.contains(item.id) {
            guard let resolved = byID[item.id] else { continue }
            ordered.append(resolved)
            seen.insert(item.id)
        }
        return ordered
    }

    private static func winner<T: MergeableEntity>(_ a: T, _ b: T) -> T {
        if a.updatedAt != b.updatedAt { return a.updatedAt > b.updatedAt ? a : b }
        return a.originDeviceID.uuidString > b.originDeviceID.uuidString ? a : b
    }

    /// Scores are append-only and individually id-stamped, so merging them
    /// is just a union by id — no conflict resolution needed, since two
    /// devices never edit the *same* `Score` value, they only ever add new
    /// ones. Formalizes the id-union pattern `EventSession` already used
    /// for `.scoresApproved`, so the connect-time merge and the live
    /// broadcast handler share one implementation.
    public static func mergeScores(local: [Score], remote: [Score]) -> [Score] {
        var byID: [Score.ID: Score] = [:]
        for score in local { byID[score.id] = score }
        for score in remote where byID[score.id] == nil { byID[score.id] = score }
        var seen = Set<Score.ID>()
        var ordered: [Score] = []
        for score in local where !seen.contains(score.id) {
            ordered.append(score)
            seen.insert(score.id)
        }
        for score in remote where !seen.contains(score.id) {
            ordered.append(score)
            seen.insert(score.id)
        }
        return ordered
    }
}

extension Event {
    /// Merges another copy of this same event (same `id`) into this one.
    /// Used both when a `.fullEventSnapshot` arrives from a peer and when
    /// reconciling a locally-edited roster with what's already synced —
    /// see `EventSession`. Event-level fields (name, branding, `heatSize`,
    /// `finalistCount`) come from whichever side has the newer `updatedAt`;
    /// the roster and scores merge entity-by-entity via `RosterMerge`.
    public func merged(with other: Event) -> Event {
        let base = updatedAt >= other.updatedAt ? self : other
        var result = base
        result.participants = RosterMerge.merge(local: participants, remote: other.participants)
        result.judges = RosterMerge.merge(local: judges, remote: other.judges)
        result.categories = RosterMerge.merge(local: categories, remote: other.categories)
        result.scores = RosterMerge.mergeScores(local: scores, remote: other.scores)
        return result
    }
}
