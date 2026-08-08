import Foundation

/// State for the judge's numeric-keypad score entry (the `n1`...`n9`, `n00`
/// buttons + `LaEvParcial` label in `JudgePanel.m`).
///
/// The legacy `escribecalif:` (`JudgePanel.m`) rebuilt the display string by
/// manually slicing `LaEvParcial.text` by length, with branches for lengths
/// 4/3/1/0 and **no branch for length 2** — so a judge who typed exactly two
/// digits and pressed a third key got no response at all (a real, reported-
/// worthy bug, not a hypothetical one; found by direct code reading). This
/// type replaces that string-slicing state machine with an explicit digit
/// buffer that has no unhandled length.
///
/// Digits are entered most-significant-first and the last digit typed is
/// always the decimal place, matching the legacy "type digits, last one is
/// the tenths" UX (e.g. typing 7, 8, 5 produces "78.5").
public struct ScoreEntryPad: Equatable, Sendable {
    public private(set) var digits: [Int] = []
    public let maxDigits: Int

    /// - Parameter maxDigits: 3 reproduces the legacy behavior (2 whole-number
    ///   digits + 1 decimal digit, e.g. "99.9" as the max enterable score).
    public init(maxDigits: Int = 3) {
        self.maxDigits = maxDigits
    }

    @discardableResult
    public mutating func append(digit: Int) -> Bool {
        guard (0...9).contains(digit), digits.count < maxDigits else { return false }
        digits.append(digit)
        return true
    }

    public mutating func backspace() {
        if !digits.isEmpty { digits.removeLast() }
    }

    public mutating func clear() {
        digits.removeAll()
    }

    /// Formatted display text, e.g. `[7,8,5]` -> `"78.5"`, `[5]` -> `"0.5"`,
    /// `[]` -> `""`.
    public var displayText: String {
        guard !digits.isEmpty else { return "" }
        let whole = digits.dropLast()
        let tenths = digits.last!
        let wholeText = whole.isEmpty ? "0" : whole.map(String.init).joined()
        return "\(wholeText).\(tenths)"
    }

    /// The numeric value, or `nil` while fewer than 2 digits have been
    /// entered — mirrors the legacy `EnviarP:` guard requiring the raw digit
    /// string be `>= 10` (i.e. "must have at least a whole digit and a
    /// decimal digit") before a score can be submitted, but expressed as an
    /// explicit precondition instead of an unexplained numeric-string
    /// comparison.
    public var value: Double? {
        guard digits.count >= 2 else { return nil }
        return Double(displayText)
    }
}
