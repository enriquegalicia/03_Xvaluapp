import SwiftUI
import XvaluappCore

/// Replaces `CreacionEventos`'s launcher screen: pick a saved event, or
/// start a new one. Unlike the legacy screen, "new event" actually works —
/// `NuevoEvento:` was fully commented out there (see the migration dossier).
///
/// `NavigationSplitView` — not a plain push stack — is doing real work here:
/// on iPhone (compact width) it collapses to a single column that pushes,
/// same as the old app's flow. On iPad (regular width) it shows the event
/// list as a permanent sidebar next to whatever's selected, so a judge or
/// scorekeeper never loses the event list the way the legacy app's
/// fixed-frame, iPad-only screens forced a full-screen swap for every step.
/// This is the direct fix for the legacy app's device-family = iPad-only,
/// fixed-1024×768-frame layout documented in the migration dossier.
struct EventListView: View {
    let store: JSONEventStore

    @State private var events: [Event] = []
    @State private var selectedEventID: Event.ID?
    @State private var loadError: String?

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedEventID) {
                if events.isEmpty {
                    ContentUnavailableView(
                        "No Events Yet",
                        systemImage: "flag.checkered",
                        description: Text("Add the demo event to try scoring end to end.")
                    )
                } else {
                    ForEach(events) { event in
                        EventRow(event: event).tag(event.id)
                    }
                }
            }
            .navigationTitle("Xvaluapp")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        addDemoEvent()
                    } label: {
                        Label("Add Demo Event", systemImage: "plus")
                    }
                }
            }
        } detail: {
            NavigationStack {
                if let event = events.first(where: { $0.id == selectedEventID }) {
                    EventDetailView(session: EventSession(event: event, store: store))
                } else {
                    ContentUnavailableView(
                        "Select an Event",
                        systemImage: "sidebar.left",
                        description: Text("Choose an event from the list to start judging or view standings.")
                    )
                }
            }
        }
        .task { load() }
        .alert("Couldn't load events", isPresented: .constant(loadError != nil), presenting: loadError) { _ in
            Button("OK") { loadError = nil }
        } message: { message in
            Text(message)
        }
    }

    private func load() {
        do {
            events = try store.loadAll().sorted { $0.name < $1.name }
            if selectedEventID == nil { selectedEventID = events.first?.id }
        } catch {
            loadError = error.localizedDescription
        }
    }

    private func addDemoEvent() {
        let event = DemoData.dirtConquers()
        do {
            try store.save(event)
            load()
            selectedEventID = event.id
        } catch {
            loadError = error.localizedDescription
        }
    }
}

private struct EventRow: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(event.name).font(.headline)
            Text("\(event.participants.count) participants · \(event.judges.count) judges · \(event.categories.count) categories")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
