import SwiftUI
import UIKit
import XvaluappCore

/// Every device that opens an event connects to nearby peers immediately —
/// before any role is chosen — and shows one tab per role it currently
/// holds (Judge/Master/Screen), any combination of which can be active at
/// once and changed later without leaving the event. Replaces both the
/// legacy app's one-shot "Accesado" role gate and this app's own first
/// pass, where picking a role started networking and locked the screen to
/// that one role for the rest of the session.
struct EventDetailView: View {
    let session: EventSession

    @State private var showingRolePicker = false
    @State private var showingConnections = false

    var body: some View {
        content
            .navigationTitle(session.event.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingConnections = true
                    } label: {
                        Label("Connections", systemImage: "personalhotspot")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingRolePicker = true
                    } label: {
                        Label("Change Roles", systemImage: "person.2.badge.gearshape")
                    }
                }
            }
            .sheet(isPresented: $showingRolePicker) {
                RoleSelectionView(session: session) { showingRolePicker = false }
            }
            .sheet(isPresented: $showingConnections) {
                ConnectionsSheetView(session: session)
            }
            .task {
                #if DEBUG
                if StoreShot.requested != nil { return }
                #endif
                session.connect(displayName: UIDevice.current.name)
            }
            .onDisappear {
                session.stopNetworking()
            }
            .alert(
                "Couldn't Save",
                isPresented: Binding(
                    get: { session.persistenceError != nil },
                    set: { if !$0 { session.clearPersistenceError() } }
                )
            ) {
                Button("OK") { session.clearPersistenceError() }
            } message: {
                Text(session.persistenceError ?? "")
            }
            .alert(
                "Connection Request",
                isPresented: Binding(
                    get: { session.transport?.pendingInvitation != nil },
                    set: { if !$0 { session.transport?.declinePendingInvitation() } }
                )
            ) {
                Button("Accept") { session.transport?.acceptPendingInvitation() }
                Button("Decline", role: .cancel) { session.transport?.declinePendingInvitation() }
            } message: {
                let peerName = session.transport?.pendingInvitation?.peerID.displayName
                    ?? String(localized: "A device")
                Text("\"\(peerName)\" wants to connect to this event.")
            }
    }

    @ViewBuilder
    private var content: some View {
        if session.roles.isEmpty {
            RoleSelectionView(session: session) {}
        } else {
            TabView {
                if session.roles.contains(.judge) {
                    NavigationStack {
                        if let judgeID = session.activeJudgeID,
                           let judge = session.event.activeJudges.first(where: { $0.id == judgeID }) {
                            ScoringView(session: session, judge: judge)
                        } else {
                            ContentUnavailableView(
                                "Pick a Judge",
                                systemImage: "pencil.and.list.clipboard",
                                description: Text("Choose which judge this device is scoring as.")
                            )
                        }
                    }
                    .tabItem { Label("Score", systemImage: "pencil.and.list.clipboard") }
                }

                if session.roles.contains(.master) {
                    NavigationStack {
                        MasterConsoleView(session: session)
                    }
                    .tabItem { Label("Console", systemImage: "checkmark.seal") }
                }

                if session.roles.contains(.scoreboard) {
                    NavigationStack {
                        ScoreboardCarouselView(session: session)
                    }
                    .tabItem { Label("Leaderboard", systemImage: "tv") }
                }
            }
        }
    }
}
