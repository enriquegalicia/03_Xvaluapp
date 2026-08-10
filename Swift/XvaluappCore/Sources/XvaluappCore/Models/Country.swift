import Foundation

/// A selectable country/flag for a participant. Replaces `Subtitulados.m`'s
/// hardcoded `Banderas` array (27 bare flag-image filenames, positionally
/// tied to a separate hardcoded `Riders` name array by index — reordering
/// one without the other silently mismatched flags to names) with a proper
/// `Identifiable` value carrying both a code and a display name.
public struct Country: Identifiable, Hashable, Sendable {
    /// Matches a `Flag-<code>` asset in the app target's asset catalog.
    public var code: String
    public var name: String

    public var id: String { code }

    public init(code: String, name: String) {
        self.code = code
        self.name = name
    }
}

public enum Countries {
    /// The flags carried over from the legacy app's bundled artwork
    /// (`RedBullApp/*.png`). Extending this list to a country without
    /// matching flag artwork in the app target's `Assets.xcassets` will
    /// still work — `FlagImage` in the app target falls back to a plain
    /// text badge for any code it can't find an asset for — but won't show
    /// a real flag until artwork is added.
    public static let all: [Country] = [
        Country(code: "AUS", name: "Australia"),
        Country(code: "BRA", name: "Brazil"),
        Country(code: "CAN", name: "Canada"),
        Country(code: "COL", name: "Colombia"),
        Country(code: "CR", name: "Costa Rica"),
        Country(code: "ESP", name: "Spain"),
        Country(code: "FRA", name: "France"),
        Country(code: "MEX", name: "Mexico"),
        Country(code: "NL", name: "Netherlands"),
        Country(code: "UK", name: "United Kingdom"),
        Country(code: "USA", name: "United States"),
        Country(code: "VEN", name: "Venezuela"),
    ]

    public static func named(_ code: String) -> String {
        all.first { $0.code == code }?.name ?? code
    }
}
