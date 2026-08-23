import SwiftUI
import XvaluappCore

/// Add/remove participants (with a country flag), judges, and scoring
/// categories on an event that's already running — the legacy app's
/// closest equivalent, `JudgePanel.m`'s config-list screen, could only
/// operate on one entity at a time via `Nuevo:`/`Modificar:`/`Borrar:`
/// IBActions against whichever SQL table `Lista` happened to point at, with
/// changes taking effect locally on the master only until (if) a judge
/// device separately triggered a resync. Saving here calls
/// `EventSession.updateRoster`, which persists locally *and* broadcasts the
/// change to every connected device in one step.
struct RosterEditorView: View {
    let session: EventSession
    @Environment(\.dismiss) private var dismiss

    @State private var participants: [RosterDraft]
    @State private var judges: [NameDraft]
    @State private var categories: [NameDraft]
    @State private var logoImageFilename: String?
    @State private var backgroundImageFilename: String?

    init(session: EventSession) {
        self.session = session
        _participants = State(initialValue: session.event.participants.map {
            RosterDraft(existingID: $0.id, name: $0.name, countryCode: $0.countryCode, imageFilename: $0.imageFilename)
        })
        _judges = State(initialValue: session.event.judges.map {
            NameDraft(existingID: $0.id, name: $0.name)
        })
        _categories = State(initialValue: session.event.categories.map {
            NameDraft(existingID: $0.id, name: $0.name)
        })
        _logoImageFilename = State(initialValue: session.event.logoImageFilename)
        _backgroundImageFilename = State(initialValue: session.event.backgroundImageFilename)
    }

    var body: some View {
        NavigationStack {
            Form {
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
            .navigationTitle("Edit Roster")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }

    private func save() {
        var nextParticipantID = (session.event.participants.map(\.id).max() ?? 0) + 1
        var nextJudgeID = (session.event.judges.map(\.id).max() ?? 0) + 1
        var nextCategoryID = (session.event.categories.map(\.id).max() ?? 0) + 1

        let resolvedParticipants = participants
            .filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { draft -> Participant in
                let id = draft.existingID ?? nextParticipantID
                if draft.existingID == nil { nextParticipantID += 1 }
                return Participant(id: id, name: draft.name, countryCode: draft.countryCode, imageFilename: draft.imageFilename)
            }
        let resolvedJudges = judges
            .filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { draft -> Judge in
                let id = draft.existingID ?? nextJudgeID
                if draft.existingID == nil { nextJudgeID += 1 }
                return Judge(id: id, name: draft.name)
            }
        let resolvedCategories = categories
            .filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { draft -> ScoringCategory in
                let id = draft.existingID ?? nextCategoryID
                if draft.existingID == nil { nextCategoryID += 1 }
                return ScoringCategory(id: id, name: draft.name)
            }

        session.updateRoster(participants: resolvedParticipants, judges: resolvedJudges, categories: resolvedCategories)
        session.updateBranding(logoImageFilename: logoImageFilename, backgroundImageFilename: backgroundImageFilename)
        dismiss()
    }
}
