import SwiftUI
import UIKit
import AguaAI
import XvaluappCore

/// Renders an image previously saved via `ScoreDeckAI.imageStore` (a photo or
/// AI-generated art, see `ImagePickerField`), falling back to a plain SF
/// Symbol badge when there's no filename or the file isn't on this device —
/// which happens for any device that hasn't set its own branding yet, since
/// image bytes aren't synced over Multipeer (only the JSON event is; see
/// `EventSession.updateBranding`).
struct StoredImage: View {
    let filename: String?
    var size: CGFloat = 44
    var systemFallback: String = "photo"

    var body: some View {
        if let filename, let uiImage = try? ScoreDeckAI.imageStore.loadImage(from: filename) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(RoundedRectangle(cornerRadius: size * 0.2))
        } else {
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(Color.secondary.opacity(0.15))
                .frame(width: size, height: size)
                .overlay(
                    Image(systemName: systemFallback)
                        .font(.system(size: size * 0.45))
                        .foregroundStyle(.secondary)
                )
        }
    }
}

/// A participant's photo where one's been set, falling back to their flag
/// (`FlagImage`) rather than a generic photo icon — every participant has
/// a country code, so there's always a meaningful fallback here even
/// before anyone's added a photo.
struct ParticipantAvatar: View {
    let participant: Participant
    var size: CGFloat = 28

    var body: some View {
        if let filename = participant.imageFilename,
           let uiImage = try? ScoreDeckAI.imageStore.loadImage(from: filename) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(.separator, lineWidth: 0.5))
        } else {
            FlagImage(countryCode: participant.countryCode, size: size * 0.85)
        }
    }
}
