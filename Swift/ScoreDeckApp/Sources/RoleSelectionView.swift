import SwiftUI
import XvaluappCore

/// Replaces the legacy `CreacionEventos`/`JudgePanel` role flow, where the
/// device's role ("Accesado" = "1"/"2"/"3") was picked once on the launcher
/// screen and baked into `MCPeerID.accessibilityLabel`, and this app's own
/// first pass, where a single `PeerRole` was chosen once and never
/// revisited. A device now holds a *set* of roles — Judge and Screen at
/// once, Master and Judge at once — toggled here, and this view can be
/// reopened at any time (not just before any role is picked) to add, drop,
/// or swap roles without leaving the event. Turning Master back off here is
/// the "way back" from running the console to just judging or watching the
/// leaderboard.
struct RoleSelectionView: View {
    let session: EventSession
    let onDone: () -> Void

    @State private var roles: Set<PeerRole>
    @State private var selectedJudgeID: UUID?

    init(session: EventSession, onDone: @escaping () -> Void) {
        self.session = session
        self.onDone = onDone
        _roles = State(initialValue: session.roles)
        _selectedJudgeID = State(initialValue: session.activeJudgeID)
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "flag.checkered.circle")
                .font(.system(size: 56))
                .foregroundStyle(.tint)

            Text("What is this device?")
                .font(.title2.bold())

            Text("Pick as many as apply — a device can judge and also run the leaderboard, or run the console and still enter scores.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            VStack(spacing: 12) {
                RoleToggleRow(
                    title: "Judge",
                    subtitle: "Pick which judge is scoring on this device.",
                    systemImage: "pencil.and.list.clipboard",
                    isOn: roles.contains(.judge)
                ) { toggle(.judge) }

                RoleToggleRow(
                    title: "Master",
                    subtitle: masterSubtitle,
                    systemImage: "checkmark.seal",
                    isOn: roles.contains(.master),
                    isDisabled: !roles.contains(.master) && !session.canEnableMaster
                ) { toggle(.master) }

                RoleToggleRow(
                    title: "Screen",
                    subtitle: "Show a read-only, auto-updating leaderboard for the crowd.",
                    systemImage: "tv",
                    isOn: roles.contains(.scoreboard)
                ) { toggle(.scoreboard) }
            }
            .padding(.horizontal, 24)

            if roles.contains(.judge) {
                Picker("Judge", selection: $selectedJudgeID) {
                    Text("Select a judge").tag(UUID?.none)
                    ForEach(session.event.activeJudges) { judge in
                        Text(judge.name).tag(UUID?.some(judge.id))
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxHeight: 150)
                .padding(.horizontal, 40)
            }

            Spacer()

            Button {
                session.activeJudgeID = roles.contains(.judge) ? selectedJudgeID : nil
                session.setRoles(roles)
                onDone()
            } label: {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
            .disabled(roles.isEmpty || (roles.contains(.judge) && selectedJudgeID == nil))
            .padding(.horizontal, 40)
            .padding(.bottom, 24)
        }
    }

    // `LocalizedStringKey`, not `String` — a `String`-typed parameter skips
    // catalog lookup even when every call site happens to pass a literal,
    // since lookup is resolved by the parameter's static type (see
    // `ImagePickerField.label`/`RosterSection`/`NameSection` for the same
    // fix elsewhere in this app). Both branches here are fixed copy, no
    // untranslatable dynamic data, so this is safe to type as a key.
    private var masterSubtitle: LocalizedStringKey {
        if !roles.contains(.master) && !session.canEnableMaster {
            return "Another connected device is already the Master for this event."
        }
        return "Reviews and approves scores, and controls heats and finals."
    }

    private func toggle(_ role: PeerRole) {
        if roles.contains(role) {
            roles.remove(role)
        } else {
            roles.insert(role)
        }
    }
}

private struct RoleToggleRow: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey
    let systemImage: String
    let isOn: Bool
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title3)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    // `.tint`/`.secondary` as a ternary's two branches doesn't
                    // typecheck — Swift infers the whole expression's type
                    // from the first branch (the concrete `TintShapeStyle`),
                    // then can't resolve `.secondary` as a member of that
                    // specific type. `Color.accentColor`/`Color.secondary`
                    // share one concrete type, so the ternary resolves cleanly.
                    .foregroundStyle(isOn ? Color.accentColor : Color.secondary)
            }
            .padding(12)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.5 : 1)
    }
}
