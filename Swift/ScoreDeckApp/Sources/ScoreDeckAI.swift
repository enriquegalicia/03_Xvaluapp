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

    /// Shared visual language for anything generated for this app — the
    /// same outline/palette/flatness rules as the Lab's app icons
    /// (`ICON_STYLE_GUIDE.md` §1/§3), so an AI-generated rider avatar or
    /// event banner reads as part of the same family as the Home Screen
    /// icon and the in-app amber accent, not a mismatched photo.
    static let styleSuffix = """
    Flat vector sticker illustration, no photorealism. Warm terracotta \
    orange (#D9722C) as the primary fill color, golden amber (#D4960A) as \
    the one secondary accent color, both outlined in a thick, uniform \
    espresso-brown ink stroke (#4A2F1C). One soft highlight per rounded \
    shape, flat colors otherwise — no gradients beyond that, no drop \
    shadows, no text or lettering. Hand-crafted, warm, a little naive.
    """
}
