import SwiftUI
import XvaluappCore

struct EventDetailView: View {
    let session: EventSession

    var body: some View {
        List {
            Section("Judge") {
                ForEach(session.event.judges) { judge in
                    NavigationLink(judge.name) {
                        ScoringView(session: session, judge: judge)
                    }
                }
            }
            Section {
                NavigationLink("Standings") {
                    StandingsView(session: session)
                }
            }
        }
        .navigationTitle(session.event.name)
    }
}
