import SwiftUI
import AguaDesign
import XvaluappCore

/// Replaces `JudgePanel.m`'s "Segundo Screen" (judge/rubro combo boxes +
/// numeric keypad + `Anteriores`/`Siguientes` tables) as one focused screen
/// per judge, driven by `ScoreEntryPad` instead of the legacy
/// string-slicing keypad state machine.
struct ScoringView: View {
    let session: EventSession
    let judge: Judge

    // A never-matching sentinel when the roster has no categories yet,
    // mirroring the old `?? 0` fallback (id `0` never matched a real
    // category either) — keeps the segmented Picker's binding type
    // non-optional, which a plain `UUID?` selection can't drive cleanly.
    @State private var categoryID: UUID
    @State private var selectedParticipantID: UUID?
    @State private var pad = ScoreEntryPad()

    init(session: EventSession, judge: Judge) {
        self.session = session
        self.judge = judge
        _categoryID = State(initialValue: session.event.activeCategories.first?.id ?? UUID())
    }

    private var pendingParticipants: [Participant] {
        session.participantsAwaitingScore(in: categoryID)
    }

    var body: some View {
        VStack(spacing: 0) {
            if !session.roles.contains(.master) {
                ConnectionStatusBadge(connectedPeerNames: session.connectedPeerNames)
                    .padding(.top, 8)
            }

            Picker("Category", selection: $categoryID) {
                ForEach(session.event.activeCategories) { category in
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
                Label {
                    Text(participant.name)
                } icon: {
                    ParticipantAvatar(participant: participant, size: 22)
                }
                .tag(participant.id)
                .listRowBackground(AguaColor.bgCard)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .frame(maxHeight: 220)
            .overlay {
                if pendingParticipants.isEmpty {
                    ContentUnavailableView("All Scored", systemImage: "checkmark.circle", description: Text("Every participant has a \(categoryName) score."))
                }
            }

            Divider()

            keypad
        }
        .aguaBackground()
        .navigationTitle(judge.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var categoryName: String {
        session.event.activeCategories.first { $0.id == categoryID }?.name ?? ""
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
        // On iPad's much wider detail column, a keypad stretched edge to
        // edge is harder to reach and to read than one sized for a hand —
        // cap and center it instead of letting it fill the available
        // width, the same "fit the screen" fix as the split-view change.
        .frame(maxWidth: 480)
        .frame(maxWidth: .infinity)
        .background(AguaColor.bgElevated)
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
