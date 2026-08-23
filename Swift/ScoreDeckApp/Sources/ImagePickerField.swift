import SwiftUI
import PhotosUI
import UIKit
import AguaAI

/// Attaches a photo to an event or participant — pick one from the library,
/// or generate one with AI in the shared Aguach1leLabs illustrated style
/// (`ScoreDeckAI.styleSuffix`) via OpenAI, BYOK (see `SettingsView`). Neither
/// the event nor the participant model had any imagery at all before this —
/// see the migration roadmap's "Imagery & brand" phase.
///
/// Uses `PhotosPicker`, not `UIImagePickerController` — it runs out of
/// process and only ever hands back what the user explicitly selects, so no
/// `NSPhotoLibraryUsageDescription` is needed at all.
struct ImagePickerField: View {
    /// `LocalizedStringKey`, not `String` — a `String`-typed property loses
    /// automatic catalog lookup even when every call site passes a literal,
    /// since the lookup is resolved by the parameter's static type, not by
    /// how the caller wrote it.
    let label: LocalizedStringKey
    @Binding var imageFilename: String?

    @State private var photosItem: PhotosPickerItem?
    @State private var isGenerating = false
    @State private var showingPromptSheet = false
    @State private var aiPrompt = ""
    @State private var errorText: String?

    private let imageStore = ScoreDeckAI.imageStore

    var body: some View {
        HStack(spacing: 12) {
            thumbnail

            VStack(alignment: .leading, spacing: 4) {
                Text(label).font(.subheadline.weight(.medium))

                Menu {
                    PhotosPicker(selection: $photosItem, matching: .images) {
                        Label("Choose Photo", systemImage: "photo")
                    }
                    Button {
                        showingPromptSheet = true
                    } label: {
                        Label("Generate with AI…", systemImage: "sparkles")
                    }
                    if imageFilename != nil {
                        Button(role: .destructive) {
                            imageFilename = nil
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
                } label: {
                    Text(imageFilename == nil ? "Add Image" : "Change Image")
                        .font(.footnote)
                }

                if isGenerating {
                    ProgressView().controlSize(.small)
                }
                if let errorText {
                    Text(errorText).font(.caption2).foregroundStyle(.red)
                }
            }

            Spacer()
        }
        .onChange(of: photosItem) { _, newItem in
            Task { await loadPickedPhoto(newItem) }
        }
        .sheet(isPresented: $showingPromptSheet) {
            AIPromptSheet(prompt: $aiPrompt) { finalPrompt in
                Task { await generate(prompt: finalPrompt) }
            }
        }
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let imageFilename, let uiImage = try? imageStore.loadImage(from: imageFilename) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 44, height: 44)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        } else {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.secondary.opacity(0.15))
                .frame(width: 44, height: 44)
                .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
        }
    }

    private func loadPickedPhoto(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data) else {
                errorText = String(localized: "Couldn't read that photo.")
                return
            }
            imageFilename = try imageStore.save(uiImage)
            errorText = nil
        } catch {
            errorText = error.localizedDescription
        }
    }

    private func generate(prompt: String) async {
        isGenerating = true
        errorText = nil
        defer { isGenerating = false }
        do {
            let data = try await ScoreDeckAI.visionService.generateImage(
                prompt: "\(prompt). \(ScoreDeckAI.styleSuffix)"
            )
            guard let uiImage = UIImage(data: data) else {
                errorText = String(localized: "The AI didn't return a usable image.")
                return
            }
            imageFilename = try imageStore.save(uiImage)
        } catch let error as AIServiceError {
            // AguaAI's own error copy is English-only static text (it's a
            // shared package with no localization infrastructure of its
            // own) — remapped here rather than touched there, since fixing
            // that for every app that depends on it is a bigger, separate
            // change nobody's asked for.
            errorText = Self.localizedMessage(for: error)
        } catch {
            errorText = error.localizedDescription
        }
    }

    private static func localizedMessage(for error: AIServiceError) -> String {
        switch error {
        case .missingAPIKey:
            String(localized: "No OpenAI API key yet — add one in Settings → AI.")
        case .modelNotDownloaded:
            String(localized: "The on-device model is still downloading.")
        case .backendUnavailable:
            String(localized: "AI generation is unavailable right now.")
        case .requestFailed:
            String(localized: "That request failed. Check your connection and try again.")
        case .invalidResponse:
            String(localized: "The AI response wasn't in the expected format.")
        }
    }
}

private struct AIPromptSheet: View {
    @Binding var prompt: String
    let onGenerate: (String) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Describe what to generate…", text: $prompt, axis: .vertical)
                        .lineLimit(3...6)
                } footer: {
                    Text("Uses your OpenAI key from Settings → AI. The Aguachilelabs illustrated style is applied automatically.")
                }
            }
            .navigationTitle("Generate with AI")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Generate") {
                        onGenerate(prompt)
                        dismiss()
                    }
                    .disabled(prompt.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
