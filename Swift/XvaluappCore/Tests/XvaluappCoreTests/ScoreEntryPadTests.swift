import Testing
@testable import XvaluappCore

struct ScoreEntryPadTests {

    @Test func typingThreeDigitsFormatsAsScore() {
        var pad = ScoreEntryPad()
        pad.append(digit: 7)
        pad.append(digit: 8)
        pad.append(digit: 5)
        #expect(pad.displayText == "78.5")
        #expect(pad.value == 78.5)
    }

    @Test func exactlyTwoDigitsStillAcceptsAThirdDigit() {
        // Regression test for the legacy `escribecalif:` bug (JudgePanel.m):
        // its length-based if/else chain handled string lengths 4, 3, 1, 0
        // but had NO branch for length 2, so a judge who had typed exactly
        // two digits and pressed a third key got no visible response at all.
        var pad = ScoreEntryPad()
        pad.append(digit: 7)
        pad.append(digit: 8)
        #expect(pad.displayText == "7.8")

        let accepted = pad.append(digit: 5)
        #expect(accepted, "a third digit after two must be accepted")
        #expect(pad.displayText == "78.5")
    }

    @Test func singleDigitPadsWholeNumberWithZero() {
        var pad = ScoreEntryPad()
        pad.append(digit: 5)
        #expect(pad.displayText == "0.5")
        #expect(pad.value == nil, "fewer than 2 digits must not be submittable, matching the legacy >=10 guard in EnviarP:")
    }

    @Test func backspaceAndClear() {
        var pad = ScoreEntryPad()
        pad.append(digit: 9); pad.append(digit: 9); pad.append(digit: 9)
        pad.backspace()
        #expect(pad.displayText == "9.9")
        pad.clear()
        #expect(pad.displayText == "")
    }

    @Test func cannotExceedMaxDigits() {
        var pad = ScoreEntryPad(maxDigits: 3)
        pad.append(digit: 1); pad.append(digit: 2); pad.append(digit: 3)
        let accepted = pad.append(digit: 4)
        #expect(!accepted)
        #expect(pad.displayText == "12.3")
    }
}
