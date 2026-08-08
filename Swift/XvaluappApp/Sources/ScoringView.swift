import SwiftUI
import XvaluappCore

/// Replaces `JudgePanel.m`'s "Segundo Screen" (judge/rubro combo boxes +
/// numeric keypad + `Anteriores`/`Siguientes` tables) as one focused screen
/// per judge, driven by `ScoreEntryPad` instead of the legacy
/// string-slicing keypad state machine.
struct ScoringView: View {
    let session: EventSession
    let judge: Judge

    @State private var categoryID: Int
    @State private var selectedParticipantID: Int?
    @State private var pad = ScoreEntryPad()

    init(session: EventSession, judge: Judge) {
        self.session = session
        self.judge = judge
        _categoryID = State(initialValue: session.event.categories.first?.id ?? 0)
    }

    private var pendingParticipants: [Participant] {
        session.participantsAwaitingScore(in: categoryID)
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("Category", selection: $categoryID) {
                ForEach(session.event.categories) { category in
                    Text(category.name).tag(category.id)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: categoryID) {
                selectedParticipantID = nil
                pad.clear()
            }

            List(pendingParticipants, selection: $selectedParticipantID) { participant in
                Text(participant.name).tag(participant.id)
            }
            .listStyle(.plain)
            .frame(maxHeight: 220)
            .overlay {
                if pendingParticipants.isEmpty {
                    ContentUnavailableView("All Scored", systemImage: "checkmark.circle", description: Text("Every participant has a \(categoryName) score."))
                }
            }

            Divider()

            keypad
        }
        .navigationTitle(judge.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var categoryName: String {
        session.event.categories.first { $0.id == categoryID }?.name ?? ""
    }

    private var keypad: some View {
        VStack(spacing: 12) {
            Text(pad.displayText.isEmpty ? "—" : pad.displayText)
                .font(.system(size: 48, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .frame(maxWidth: .infinity)
                .padding(.top, 12)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(1...9, id: \.self) { digit in
                    KeypadButton(label: "\(digit)") { pad.append(digit: digit) }
                }
                KeypadButton(label: "⌫", role: .secondary) { pad.backspace() }
                KeypadButton(label: "0") { pad.append(digit: 0) }
                KeypadButton(label: "C", role: .secondary) { pad.clear() }
            }
            .padding(.horizontal)

            Button {
                submit()
            } label: {
                Text("Submit Score")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .disabled(pad.value == nil || selectedParticipantID == nil)
            .padding()
        }
        .background(.thinMaterial)
    }

    private func submit() {
        guard let value = pad.value, let participantID = selectedParticipantID else { return }
        session.submitScore(judgeID: judge.id, participantID: participantID, categoryID: categoryID, value: value)
        pad.clear()
        selectedParticipantID = nil
    }
}

private struct KeypadButton: View {
    enum Role { case primary, secondary }

    let label: String
    var role: Role = .primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title2.weight(.medium))
                .frame(maxWidth: .infinity, minHeight: 48)
        }
        .buttonStyle(.bordered)
        .tint(role == .primary ? .accentColor : .secondary)
    }
}
