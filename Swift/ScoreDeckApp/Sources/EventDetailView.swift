import SwiftUI
import UIKit
import XvaluappCore

/// Every device that opens an event picks its role here — Judge, Master, or
/// Screen — same three roles the legacy app had ("Accesado" 1/2/3), except
/// choosing one now actually starts a typed Multipeer session instead of
/// just remembering a number in `NSUserDefaults`.
struct EventDetailView: View {
    let session: EventSession

    @State private var role: PeerRole?
    @State private var judgeID: Int?

    var body: some View {
        content
            .navigationTitle(session.event.name)
            .navigationBarTitleDisplayMode(.inline)
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
                Text("\"\(session.transport?.pendingInvitation?.peerID.displayName ?? "A device")\" wants to connect to this event.")
            }
    }

    @ViewBuilder
    private var content: some View {
        switch role {
        case .none:
            RoleSelectionView(judges: session.event.judges) { chosenRole, chosenJudgeID in
                judgeID = chosenJudgeID
                role = chosenRole
                session.startNetworking(as: chosenRole, displayName: UIDevice.current.name)
            }
        case .judge:
            if let judgeID, let judge = session.event.judges.first(where: { $0.id == judgeID }) {
                ScoringView(session: session, judge: judge)
            }
        case .scoreboard:
            ScoreboardCarouselView(session: session)
        case .master:
            MasterConsoleView(session: session)
        }
    }
}
