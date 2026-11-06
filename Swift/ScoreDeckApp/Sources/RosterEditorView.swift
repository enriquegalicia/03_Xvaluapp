import SwiftUI
import AguaDesign
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

    /// The non-deleted ids this screen opened with — used at save time to
    /// tell "swiped away in this session" apart from "was never here", so a
    /// deletion can be turned into a tombstone (see `save()`) instead of
    /// silently doing nothing once `updateRoster` merges instead of
    /// replacing.
    private let originalParticipantIDs: Set<UUID>
    private let originalJudgeIDs: Set<UUID>
    private let originalCategoryIDs: Set<UUID>

    init(session: EventSession) {
        self.session = session
        let liveParticipants = session.event.participants.filter { !$0.isDeleted }
        let liveJudges = session.event.judges.filter { !$0.isDeleted }
        let liveCategories = session.event.categories.filter { !$0.isDeleted }
        _participants = State(initialValue: liveParticipants.map {
            RosterDraft(existingID: $0.id, name: $0.name, countryCode: $0.countryCode, imageFilename: $0.imageFilename)
        })
        _judges = State(initialValue: liveJudges.map {
            NameDraft(existingID: $0.id, name: $0.name)
        })
        _categories = State(initialValue: liveCategories.map {
            NameDraft(existingID: $0.id, name: $0.name)
        })
        _logoImageFilename = State(initialValue: session.event.logoImageFilename)
        _backgroundImageFilename = State(initialValue: session.event.backgroundImageFilename)
        originalParticipantIDs = Set(liveParticipants.map(\.id))
        originalJudgeIDs = Set(liveJudges.map(\.id))
        originalCategoryIDs = Set(liveCategories.map(\.id))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Branding") {
                    ImagePickerField(label: "Logo", imageFilename: $logoImageFilename)
                    ImagePickerField(label: "Background", imageFilename: $backgroundImageFilename)
                }
                .listRowBackground(AguaColor.bgCard)

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
            .scrollContentBackground(.hidden)
            .background(AguaColor.bgPrimary)
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
        // New/actually-edited entries get a fresh `updatedAt`/`originDeviceID`
        // stamp; an existing row nobody touched in this pass keeps its
        // original stamp. That distinction matters once `RosterMerge` is
        // involved: if every save blanket-restamped every row, one device
        // opening this screen and saving without touching a field another
        // device just edited would still "win" the merge purely by having
        // the newer save time, silently reverting the real edit. New
        // entries get a fresh `UUID`, not a `max + 1` counter — that's what
        // lets two devices add participants independently, online or off,
        // without minting the same id.
        let now = Date()
        let existingParticipantsByID = Dictionary(uniqueKeysWithValues: session.event.participants.map { ($0.id, $0) })
        let existingJudgesByID = Dictionary(uniqueKeysWithValues: session.event.judges.map { ($0.id, $0) })
        let existingCategoriesByID = Dictionary(uniqueKeysWithValues: session.event.categories.map { ($0.id, $0) })

        let resolvedParticipants = participants
            .filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { draft -> Participant in
                if let id = draft.existingID, let original = existingParticipantsByID[id],
                   original.name == draft.name, original.countryCode == draft.countryCode, original.imageFilename == draft.imageFilename {
                    return original
                }
                return Participant(
                    id: draft.existingID ?? UUID(),
                    name: draft.name,
                    countryCode: draft.countryCode,
                    imageFilename: draft.imageFilename,
                    updatedAt: now,
                    originDeviceID: DeviceIdentity.current
                )
            }
        let resolvedJudges = judges
            .filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { draft -> Judge in
                if let id = draft.existingID, let original = existingJudgesByID[id], original.name == draft.name {
                    return original
                }
                return Judge(id: draft.existingID ?? UUID(), name: draft.name, updatedAt: now, originDeviceID: DeviceIdentity.current)
            }
        let resolvedCategories = categories
            .filter { !$0.name.trimmingCharacters(in: .whitespaces).isEmpty }
            .map { draft -> ScoringCategory in
                if let id = draft.existingID, let original = existingCategoriesByID[id], original.name == draft.name {
                    return original
                }
                return ScoringCategory(id: draft.existingID ?? UUID(), name: draft.name, updatedAt: now, originDeviceID: DeviceIdentity.current)
            }

        // Rows swiped away in this session (present when the screen opened,
        // absent from the draft now) become tombstones rather than just
        // vanishing from what's sent — `updateRoster` merges instead of
        // replacing, so an omitted id wouldn't otherwise be distinguishable
        // from an id this device simply doesn't know about yet.
        let remainingParticipantIDs = Set(participants.compactMap(\.existingID))
        let deletedParticipants = originalParticipantIDs.subtracting(remainingParticipantIDs).compactMap { id -> Participant? in
            guard var tombstone = existingParticipantsByID[id] else { return nil }
            tombstone.updatedAt = now
            tombstone.originDeviceID = DeviceIdentity.current
            tombstone.isDeleted = true
            return tombstone
        }
        let remainingJudgeIDs = Set(judges.compactMap(\.existingID))
        let deletedJudges = originalJudgeIDs.subtracting(remainingJudgeIDs).compactMap { id -> Judge? in
            guard var tombstone = existingJudgesByID[id] else { return nil }
            tombstone.updatedAt = now
            tombstone.originDeviceID = DeviceIdentity.current
            tombstone.isDeleted = true
            return tombstone
        }
        let remainingCategoryIDs = Set(categories.compactMap(\.existingID))
        let deletedCategories = originalCategoryIDs.subtracting(remainingCategoryIDs).compactMap { id -> ScoringCategory? in
            guard var tombstone = existingCategoriesByID[id] else { return nil }
            tombstone.updatedAt = now
            tombstone.originDeviceID = DeviceIdentity.current
            tombstone.isDeleted = true
            return tombstone
        }

        session.updateRoster(
            participants: resolvedParticipants + deletedParticipants,
            judges: resolvedJudges + deletedJudges,
            categories: resolvedCategories + deletedCategories
        )
        session.updateBranding(logoImageFilename: logoImageFilename, backgroundImageFilename: backgroundImageFilename)
        dismiss()
    }
}
