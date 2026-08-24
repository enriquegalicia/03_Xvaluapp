import CoreTransferable
import UniformTypeIdentifiers
import XvaluappCore

/// Lets an `Event` be shared/exported as a `.json` file via `ShareLink`.
///
/// This is the fix for the actual gap a brand-new device has: `EventListView`
/// only ever shows events already sitting in *this* device's local
/// `JSONEventStore` — there was no way to get one onto a device that has
/// none yet. Live Multipeer sync (`EventSession.startNetworking`'s
/// `.fullEventSnapshot` push on connect) only ever catches a device *up* on
/// an event it can already open; it can't hand one to a device with zero
/// events, since reaching the role-selection/discovery screen at all
/// requires an `Event` to already be open. Export on one device + import on
/// the other (see `EventListView`'s `.fileImporter`) closes that gap —
/// once imported, the new device shows up in `EventListView` like any other
/// event, can be opened, and — if it then picks Judge/Screen and the real
/// Master is running nearby — gets immediately superseded by the Master's
/// live, authoritative snapshot the moment it connects (same `Event.id`, so
/// it overwrites the same local file rather than duplicating it).
///
/// Deliberately kept in the app target, not `XvaluappCore` — `Transferable`
/// lives in `CoreTransferable`, a platform framework that package stays
/// clear of on purpose (see its own doc comment).
extension Event: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .json) { event in
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(event)

            let safeName = event.name
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "/", with: "-")
            let fileName = safeName.isEmpty ? "Event" : "ScoreDeck - \(safeName)"
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent(fileName)
                .appendingPathExtension("json")
            try data.write(to: url, options: .atomic)
            return SentTransferredFile(url)
        }
    }
}
