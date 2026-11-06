import SwiftUI
import AguaDesign

/// `ConnectionsSection` wrapped for standalone sheet presentation — reached
/// from `EventDetailView`'s toolbar regardless of role, since discovery now
/// starts the moment an event opens, before any role (Master included) is
/// picked.
struct ConnectionsSheetView: View {
    let session: EventSession
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ConnectionsSection(session: session)
            }
            .scrollContentBackground(.hidden)
            .background(AguaColor.bgPrimary)
            .navigationTitle("Connections")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
