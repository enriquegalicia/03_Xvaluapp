import SwiftUI
import XvaluappCore

/// Replaces `CreacionEventos.m`'s `NuevoEvento:` — fully commented out in
/// the legacy app, so creating a real new event (as opposed to the two
/// hardcoded seed events) never actually worked there. This one does.
struct NewEventView: View {
    let store: JSONEventStore
    let onCreated: (Event) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var participants: [RosterDraft] = []
    @State private var judges: [NameDraft] = []
    @State private var categories: [NameDraft] = []
    @State private var heatSize = 4
    @State private var finalistCount = 12
    @State private var logoImageFilename: String?
    @State private var backgroundImageFilename: String?
    @State private var saveError: String?

    var body: some View {
        NavigationStack {
            Form {
                Section("Event") {
                    TextField("Name", text: $name)
                    Stepper("Heat size: \(heatSize)", value: $heatSize, in: 1...20)
                    Stepper("Finalists: \(finalistCount)", value: $finalistCount, in: 1...50)
                }

                Section("Branding") {
                    ImagePickerField(label: "Logo", imageFilename: $logoImageFilename)
                    ImagePickerField(label: "Background", imageFilename: $backgroundImageFilename)
                }

                RosterSection(title: "Participants", addLabel: "Add Participant", items: $participants) {
                    RosterDraft(name: "", countryCode: Countries.all.first?.code ?? "USA")
                } row: { $item in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            TextField("Name", text: $item.name)
                            CountryPicker(selection: $item.countryCode)
                                .fixedSize()
                        }
                        ImagePickerField(label: "Photo", imageFilename: $item.imageFilename)
                    }
                }

                NameSection(title: "Judges", addLabel: "Add Judge", items: $judges)
                NameSection(title: "Categories", addLabel: "Add Category", items: $categories)
            }
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .alert("Couldn't create event", isPresented: .constant(saveError != nil), presenting: saveError) { _ in
                Button("OK") { saveError = nil }
            } message: { Text($0) }
        }
    }

    private func create() {
        let event = Event(
            name: name.trimmingCharacters(in: .whitespaces),
            logoImageFilename: logoImageFilename,
            backgroundImageFilename: backgroundImageFilename,
            participants: participants.enumerated().map { index, draft in
                Participant(
                    id: index + 1,
                    name: draft.name.isEmpty ? String(localized: "Participant \(index + 1)") : draft.name,
                    countryCode: draft.countryCode,
                    imageFilename: draft.imageFilename
                )
            },
            judges: judges.enumerated().map { index, draft in
                Judge(id: index + 1, name: draft.name.isEmpty ? String(localized: "Judge \(index + 1)") : draft.name)
            },
            categories: categories.enumerated().map { index, draft in
                ScoringCategory(id: index + 1, name: draft.name.isEmpty ? String(localized: "Category \(index + 1)") : draft.name)
            },
            heatSize: heatSize,
            finalistCount: finalistCount
        )
        do {
            try store.save(event)
            onCreated(event)
            dismiss()
        } catch {
            saveError = error.localizedDescription
        }
    }
}

// MARK: - Draft rows shared with RosterEditorView

struct RosterDraft: Identifiable {
    let id = UUID()
    /// The real `Participant.id` this draft came from, or `nil` if it's a
    /// brand-new row. Preserving this on edit (see `RosterEditorView`)
    /// matters because existing `Score`s reference participant/judge ids —
    /// renumbering everyone on every save the way `NewEventView` safely can
    /// (no scores exist yet) would silently misattribute past scores.
    var existingID: Int? = nil
    var name: String
    var countryCode: String
    var imageFilename: String? = nil
}

struct NameDraft: Identifiable {
    let id = UUID()
    var existingID: Int? = nil
    var name: String
}

struct RosterSection<Row: View>: View {
    let title: LocalizedStringKey
    /// A singular label ("Add Participant") for the add button — kept as
    /// its own parameter rather than derived from `title` (the old
    /// `title.dropLast()` trick only coincidentally worked for regular
    /// English plurals, silently produced "Categorie" for "Categories",
    /// and has no equivalent rule in Spanish at all).
    let addLabel: LocalizedStringKey
    @Binding var items: [RosterDraft]
    let makeNew: () -> RosterDraft
    @ViewBuilder let row: (Binding<RosterDraft>) -> Row

    var body: some View {
        Section {
            ForEach($items) { $item in row($item) }
                .onDelete { items.remove(atOffsets: $0) }
            Button {
                items.append(makeNew())
            } label: {
                Label(addLabel, systemImage: "plus")
            }
        } header: {
            Text(title)
        }
    }
}

struct NameSection: View {
    let title: LocalizedStringKey
    let addLabel: LocalizedStringKey
    @Binding var items: [NameDraft]

    var body: some View {
        Section {
            ForEach($items) { $item in
                TextField("Name", text: $item.name)
            }
            .onDelete { items.remove(atOffsets: $0) }
            Button {
                items.append(NameDraft(name: ""))
            } label: {
                Label(addLabel, systemImage: "plus")
            }
        } header: {
            Text(title)
        }
    }
}
