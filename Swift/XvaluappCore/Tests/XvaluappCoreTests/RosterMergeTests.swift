import Testing
import Foundation
@testable import XvaluappCore

struct RosterMergeTests {

    let deviceA = UUID()
    let deviceB = UUID()

    @Test func unionKeepsEntriesUniqueToEachSide() {
        let local = [Participant(name: "Alice", countryCode: "MEX", originDeviceID: deviceA)]
        let remote = [Participant(name: "Bob", countryCode: "USA", originDeviceID: deviceB)]

        let merged = RosterMerge.merge(local: local, remote: remote)

        #expect(merged.count == 2, "an id present on only one side must pass through, not get dropped")
        #expect(Set(merged.map(\.name)) == ["Alice", "Bob"])
    }

    @Test func sameIDConflictKeepsLaterUpdatedAt() {
        let id = UUID()
        let older = Participant(id: id, name: "Alice", countryCode: "MEX", updatedAt: Date(timeIntervalSince1970: 0), originDeviceID: deviceA)
        let newer = Participant(id: id, name: "Alice R.", countryCode: "MEX", updatedAt: Date(timeIntervalSince1970: 100), originDeviceID: deviceB)

        let merged = RosterMerge.merge(local: [older], remote: [newer])

        #expect(merged.count == 1, "same id on both sides must not duplicate")
        #expect(merged.first?.name == "Alice R.", "the later updatedAt wins the conflict")

        // Order shouldn't matter — merging is meant to converge to the same
        // result regardless of which device merges into which.
        let mergedReversed = RosterMerge.merge(local: [newer], remote: [older])
        #expect(mergedReversed.first?.name == "Alice R.")
    }

    @Test func exactTimestampTieBreaksDeterministicallyByOriginDevice() {
        let id = UUID()
        let sameInstant = Date()
        let a = Participant(id: id, name: "From A", countryCode: "MEX", updatedAt: sameInstant, originDeviceID: deviceA)
        let b = Participant(id: id, name: "From B", countryCode: "MEX", updatedAt: sameInstant, originDeviceID: deviceB)

        let mergedAB = RosterMerge.merge(local: [a], remote: [b])
        let mergedBA = RosterMerge.merge(local: [b], remote: [a])

        // Whichever device wins the tiebreak, both merge directions must
        // agree on the same winner.
        #expect(mergedAB.first?.originDeviceID == mergedBA.first?.originDeviceID)
    }

    @Test func newerTombstoneWinsOverAnOlderStaleEdit() {
        // A device deletes a participant; another device, still holding an
        // older copy, later merges in the deletion. The tombstone must win
        // because it's newer — otherwise a plain union would let the
        // deleted row resurrect just by existing on the other side.
        let id = UUID()
        let original = Participant(id: id, name: "Alice", countryCode: "MEX", updatedAt: Date(timeIntervalSince1970: 0), originDeviceID: deviceA)
        let tombstoned = Participant(id: id, name: "Alice", countryCode: "MEX", updatedAt: Date(timeIntervalSince1970: 50), originDeviceID: deviceB, isDeleted: true)

        let merged = RosterMerge.merge(local: [original], remote: [tombstoned])

        #expect(merged.first?.isDeleted == true)
    }

    @Test func staleTombstoneLosesToANewerEdit() {
        // The reverse: a device deletes a row, but another device later
        // edits that same id without knowing about the delete (e.g. it
        // hadn't synced yet). The newer edit should win and un-delete it —
        // last-write-wins applies to deletion exactly like any other field.
        let id = UUID()
        let tombstoned = Participant(id: id, name: "Alice", countryCode: "MEX", updatedAt: Date(timeIntervalSince1970: 0), originDeviceID: deviceA, isDeleted: true)
        let revived = Participant(id: id, name: "Alice R.", countryCode: "MEX", updatedAt: Date(timeIntervalSince1970: 50), originDeviceID: deviceB)

        let merged = RosterMerge.merge(local: [tombstoned], remote: [revived])

        #expect(merged.first?.isDeleted == false)
        #expect(merged.first?.name == "Alice R.")
    }

    @Test func mergeScoresUnionsWithoutDuplicating() {
        let shared = Score(judgeID: UUID(), participantID: UUID(), categoryID: UUID(), value: 8.0)
        let localOnly = Score(judgeID: UUID(), participantID: UUID(), categoryID: UUID(), value: 7.0)
        let remoteOnly = Score(judgeID: UUID(), participantID: UUID(), categoryID: UUID(), value: 9.0)

        let merged = RosterMerge.mergeScores(local: [shared, localOnly], remote: [shared, remoteOnly])

        #expect(merged.count == 3)
        #expect(Set(merged.map(\.id)) == Set([shared.id, localOnly.id, remoteOnly.id]))
    }

    @Test func eventMergedCombinesRosterFromBothSides() {
        let id = UUID()
        var local = Event(id: id, name: "Dirt Conquers")
        local.participants = [Participant(name: "Alice", countryCode: "MEX", originDeviceID: deviceA)]

        var remote = Event(id: id, name: "Dirt Conquers")
        remote.participants = [Participant(name: "Bob", countryCode: "USA", originDeviceID: deviceB)]

        let merged = local.merged(with: remote)

        #expect(merged.participants.count == 2, "each device's own roster additions must survive a snapshot merge")
    }

    @Test func eventMergedTakesEventLevelFieldsFromNewerSide() {
        let id = UUID()
        let local = Event(id: id, name: "Old Name", updatedAt: Date(timeIntervalSince1970: 0))
        let remote = Event(id: id, name: "New Name", updatedAt: Date(timeIntervalSince1970: 100))

        let merged = local.merged(with: remote)

        #expect(merged.name == "New Name")
    }
}
