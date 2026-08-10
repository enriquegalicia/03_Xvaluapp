import SwiftUI
import XvaluappCore

/// Replaces the legacy `CreacionEventos`/`JudgePanel` role flow, where the
/// device's role ("Accesado" = "1"/"2"/"3") was picked once on the launcher
/// screen and then baked into `MCPeerID.accessibilityLabel` — a value other
/// peers could never actually read. Here it's just local state that decides
/// which screen this device shows; the role is carried explicitly inside
/// each `SyncMessage` case instead.
struct RoleSelectionView: View {
    let judges: [Judge]
    let onContinue: (PeerRole, Int?) -> Void

    @State private var role: PeerRole = .judge
    @State private var selectedJudgeID: Int?

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "flag.checkered.circle")
                .font(.system(size: 56))
                .foregroundStyle(.tint)

            Text("What is this device?")
                .font(.title2.bold())

            Picker("Role", selection: $role) {
                Text("Judge").tag(PeerRole.judge)
                Text("Master").tag(PeerRole.master)
                Text("Screen").tag(PeerRole.scoreboard)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 40)

            Group {
                switch role {
                case .judge:
                    Text("Pick which judge is scoring on this device.")
                        .foregroundStyle(.secondary)
                case .master:
                    Text("This device reviews and approves scores, and controls heats and finals.")
                        .foregroundStyle(.secondary)
                case .scoreboard:
                    Text("This device shows a read-only, auto-updating leaderboard for the crowd.")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.subheadline)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)

            if role == .judge {
                Picker("Judge", selection: $selectedJudgeID) {
                    Text("Select a judge").tag(Int?.none)
                    ForEach(judges) { judge in
                        Text(judge.name).tag(Int?.some(judge.id))
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxHeight: 150)
                .padding(.horizontal, 40)
            }

            Spacer()

            Button {
                onContinue(role, role == .judge ? selectedJudgeID : nil)
            } label: {
                Text("Continue")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .disabled(role == .judge && selectedJudgeID == nil)
            .padding(.horizontal, 40)
            .padding(.bottom, 24)
        }
    }
}
