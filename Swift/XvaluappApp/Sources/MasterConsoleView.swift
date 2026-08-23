import SwiftUI
import XvaluappCore

/// Replaces `JudgePanel.m`'s `Desactivado:` admin console — a `UITextField`
/// where typing an exact command string ("Clean", "Purgar", "Reset", ...)
/// triggered destructive, unconfirmed operations broadcast to every
/// connected device. Every destructive action here goes through
/// `.confirmationDialog`, and there is no plaintext command line at all.
struct MasterConsoleView: View {
    let session: EventSession

    @State private var showResetConfirm = false
    @State private var showFinalsConfirm = false

    var body: some View {
        List {
            Section("Roster") {
                NavigationLink {
                    RosterEditorView(session: session)
                } label: {
                    Label("Edit Participants, Judges & Categories", systemImage: "person.crop.circle.badge.plus")
                }
                Text("\(session.event.participants.count) participants · \(session.event.judges.count) judges · \(session.event.categories.count) categories")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section("Score as Judge") {
                ForEach(session.event.judges) { judge in
                    NavigationLink(judge.name) {
                        ScoringView(session: session, judge: judge)
                    }
                }
            }

            Section("Standings") {
                NavigationLink("View Standings") {
                    StandingsView(session: session)
                }
            }

            if let transport = session.transport {
                Section("Connections") {
                    if transport.connectedPeers.isEmpty {
                        Text("No devices connected yet").foregroundStyle(.secondary)
                    } else {
                        ForEach(transport.connectedPeers, id: \.self) { peer in
                            Label(peer.displayName, systemImage: "checkmark.circle.fill")
                                .foregroundStyle(.primary)
                        }
                    }
                    ForEach(transport.discoveredPeers.filter { !transport.connectedPeers.contains($0) }, id: \.self) { peer in
                        Button {
                            transport.invite(peer)
                        } label: {
                            Label(peer.displayName, systemImage: "plus.circle")
                        }
                    }
                }
            }

            Section("Event Control") {
                Button(role: .destructive) {
                    showFinalsConfirm = true
                } label: {
                    Label("Advance to Finals (Top \(session.event.finalistCount))", systemImage: "trophy")
                }
                .disabled(session.standings().isEmpty)

                Button(role: .destructive) {
                    showResetConfirm = true
                } label: {
                    Label("Reset All Scores", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Master Console")
        .confirmationDialog(
            "Reset all scores?",
            isPresented: $showResetConfirm,
            titleVisibility: .visible
        ) {
            Button("Reset Scores", role: .destructive) { session.resetScores() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This clears every score on this device and every connected device. This can't be undone.")
        }
        .confirmationDialog(
            "Advance to finals?",
            isPresented: $showFinalsConfirm,
            titleVisibility: .visible
        ) {
            Button("Advance to Finals", role: .destructive) { session.advanceToFinals() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Replaces the roster with the top \(session.event.finalistCount) by current average and clears scores for the new round, on every connected device.")
        }
    }
}
