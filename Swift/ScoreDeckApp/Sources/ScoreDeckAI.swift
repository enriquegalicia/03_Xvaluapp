import Foundation
import AguaAI

/// Shared BYOK AI service + local image cache — the same
/// `OpenAIVisionService`/`LocalImageStore` pattern every other
/// Aguach1leLabs app uses (see `SettingsView`, `ImagePickerField`), so a
/// tournament banner or rider portrait is stored and generated exactly the
/// way a plate photo is in PlateSnap.
enum ScoreDeckAI {
    static var visionService: OpenAIVisionService {
        OpenAIVisionService(appIdentifier: Bundle.main.bundleIdentifier ?? "ScoreDeck")
    }

    static var imageStore: LocalImageStore {
        LocalImageStore(subdirectory: "ScoreDeck")
    }

    /// Shared visual language for anything generated for this app, matching
    /// ScoreDeck's own look (graphite panels, the icon's LED amber). It used
    /// to ask for the portfolio's old cream-and-terracotta sticker style,
    /// which App Review had seen across the account's other apps (4.3).
    static let styleSuffix = """
    Bold flat vector badge illustration, like a sports scoreboard graphic. \
    Warm graphite background (#141312), LED amber (#F2B33D) as the one \
    accent color, clean off-white linework (#F7F2E8). Crisp shapes, flat \
    colors, at most a soft glow on the amber parts. No photorealism, no \
    text or lettering.
    """
}
