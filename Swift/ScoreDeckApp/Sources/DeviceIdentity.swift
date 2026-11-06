import Foundation

/// A stable id for *this install*, generated once and kept in
/// `UserDefaults` — the `originDeviceID` stamped on every roster entity
/// this device creates/edits (see `RosterEditorView`) and the `deviceID`
/// this device announces in `.roleAnnounce`.
///
/// Deliberately app-layer, not `XvaluappCore`: it's a device/install
/// concept tied to this app's own persistence choice, the same reasoning
/// that keeps `UIDevice.current.name` out of that package.
enum DeviceIdentity {
    private static let defaultsKey = "com.aguach1leLabs.ScoreDeck.deviceID"

    static let current: UUID = {
        let defaults = UserDefaults.standard
        if let stored = defaults.string(forKey: defaultsKey), let id = UUID(uuidString: stored) {
            return id
        }
        let fresh = UUID()
        defaults.set(fresh.uuidString, forKey: defaultsKey)
        return fresh
    }()
}
