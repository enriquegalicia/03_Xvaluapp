import SwiftUI
import UniformTypeIdentifiers
import AguaDesign
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
    @State private var showingNewEvent = false
    @State private var eventPendingDelete: Event?
    @State private var eventPendingRename: Event?
    @State private var renameText = ""
    @State private var showingSettings = false
    @State private var showingImporter = false

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
                        EventRow(event: event)
                            .tag(event.id)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    eventPendingDelete = event
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    eventPendingRename = event
                                    renameText = event.name
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                            .contextMenu {
                                Button {
                                    eventPendingRename = event
                                    renameText = event.name
                                } label: {
                                    Label("Rename…", systemImage: "pencil")
                                }
                                ShareLink(item: event, preview: SharePreview(event.name)) {
                                    Label("Export Event…", systemImage: "square.and.arrow.up")
                                }
                                Button(role: .destructive) {
                                    eventPendingDelete = event
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowBackground(AguaColor.bgCard)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(AguaColor.bgPrimary)
            .navigationTitle("ScoreDeck")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button {
                            showingNewEvent = true
                        } label: {
                            Label("New Event…", systemImage: "plus.circle")
                        }
                        Button {
                            addDemoEvent()
                        } label: {
                            Label("Add Demo Event", systemImage: "flag.checkered")
                        }
                        Button {
                            showingImporter = true
                        } label: {
                            Label("Import Event…", systemImage: "square.and.arrow.down")
                        }
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewEvent) {
                NewEventView(store: store) { event in
                    load()
                    selectedEventID = event.id
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .fileImporter(isPresented: $showingImporter, allowedContentTypes: [.json]) { result in
                importEvent(from: result)
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
        .confirmationDialog(
            "Delete \"\(eventPendingDelete?.name ?? "")\"?",
            isPresented: Binding(
                get: { eventPendingDelete != nil },
                set: { if !$0 { eventPendingDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let event = eventPendingDelete { deleteEvent(event) }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently deletes the event and every score recorded for it. This can't be undone.")
        }
        .alert(
            "Rename Event",
            isPresented: Binding(
                get: { eventPendingRename != nil },
                set: { if !$0 { eventPendingRename = nil } }
            )
        ) {
            TextField("Event name", text: $renameText)
            Button("Cancel", role: .cancel) { eventPendingRename = nil }
            Button("Save") { renameEvent() }
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

    private func deleteEvent(_ event: Event) {
        do {
            try store.delete(eventID: event.id)
            if selectedEventID == event.id { selectedEventID = nil }
            load()
        } catch {
            loadError = error.localizedDescription
        }
    }

    private func renameEvent() {
        guard let original = eventPendingRename else { return }
        let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
        defer { eventPendingRename = nil }
        guard !trimmed.isEmpty else { return }
        var renamed = original
        renamed.name = trimmed
        do {
            try store.save(renamed)
            load()
        } catch {
            loadError = error.localizedDescription
        }
    }

    /// Imports a `.json` file exported via `ShareLink` on another device
    /// (see `EventTransfer.swift`) — the actual fix for a brand-new device
    /// having no way to reach a running event at all, since `EventListView`
    /// only ever shows events already in *this* device's local store and
    /// picking a role/starting Multipeer discovery requires one already
    /// open. Saved under the imported `Event`'s own id, so if this device
    /// later joins the live session as Judge/Screen, the Master's current
    /// `.fullEventSnapshot` correctly overwrites this same local file
    /// instead of creating a duplicate.
    private func importEvent(from result: Result<URL, Error>) {
        do {
            let url = try result.get()
            let didAccess = url.startAccessingSecurityScopedResource()
            defer { if didAccess { url.stopAccessingSecurityScopedResource() } }
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let event = try decoder.decode(Event.self, from: data)
            try store.save(event)
            load()
            selectedEventID = event.id
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
        HStack(spacing: 12) {
            StoredImage(filename: event.logoImageFilename, size: 40, systemFallback: "flag.checkered")

            VStack(alignment: .leading, spacing: 4) {
                Text(event.name).font(.headline)
                Text("\(event.participants.count) participants · \(event.judges.count) judges · \(event.categories.count) categories")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
