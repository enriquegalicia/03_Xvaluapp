import SwiftUI
import AguaAI
import AguaDesign

/// BYOK (bring your own key) — same pattern as every other Aguach1leLabs
/// app with cloud AI (see PlateSnap's `SettingsView`). The key never ships
/// in this binary; it's typed in here once and stored only in this
/// device's Keychain.
struct SettingsView: View {
    @State private var keyInput = ""
    @State private var hasStoredKey = false
    @State private var feedback: String?

    private var keyStore: KeychainKeyStore {
        KeychainKeyStore(appIdentifier: Bundle.main.bundleIdentifier ?? "ScoreDeck")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    if hasStoredKey {
                        HStack {
                            Label("Key saved", systemImage: "checkmark.seal.fill")
                                .foregroundStyle(.green)
                            Spacer()
                            Button("Remove", role: .destructive) {
                                keyStore.delete(.openAI)
                                hasStoredKey = false
                                feedback = nil
                            }
                        }
                    } else {
                        SecureField("Paste your OpenAI API key (sk-...)", text: $keyInput)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        Button("Save Key") { saveKey() }
                            .disabled(keyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    if let feedback {
                        Text(feedback).font(.footnote).foregroundStyle(.secondary)
                    }
                } header: {
                    Text("OpenAI API Key")
                } footer: {
                    Text("Generating tournament banners and rider avatars uses OpenAI's image API with your own key, stored only in this device's Keychain. Without a key, you can still add photos from your library. Get a key at platform.openai.com/api-keys.")
                }
                .listRowBackground(AguaColor.bgCard)
            }
            .scrollContentBackground(.hidden)
            .background(AguaColor.bgPrimary)
            .navigationTitle("Settings")
            .onAppear { hasStoredKey = keyStore.read(.openAI) != nil }
        }
    }

    private func saveKey() {
        let trimmed = keyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("sk-") else {
            feedback = String(localized: "That doesn't look like an OpenAI key — it should start with sk-.")
            return
        }
        do {
            try keyStore.save(trimmed, for: .openAI)
            keyInput = ""
            hasStoredKey = true
            feedback = nil
        } catch {
            feedback = error.localizedDescription
        }
    }
}
