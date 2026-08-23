import SwiftUI
import UIKit
import AguaDesign
import XvaluappCore

/// The Screen role's unattended, crowd-facing display — replaces `Play:`'s
/// `NSTimer`-driven fade sequence in `JudgePanel.m`, which only ever
/// alternated between the same two hardcoded views. This rotates the
/// overall leaderboard plus one page per scoring category, so a multi-
/// category event (Difficulty/Execution/Style, say) actually gets shown
/// instead of only ever displaying the blended average.
struct ScoreboardCarouselView: View {
    let session: EventSession

    @State private var pageIndex = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var pages: [Page] {
        [Page(title: "Overall", categoryID: nil)]
            + session.event.categories.map { Page(title: $0.name, categoryID: $0.id) }
    }

    var body: some View {
        VStack(spacing: 0) {
            banner

            TabView(selection: $pageIndex) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    StandingsView(
                        session: session,
                        categoryID: page.categoryID,
                        title: page.title,
                        showsInlineTitle: true
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: pages.count > 1 ? .always : .never))
        }
        .aguaBackground()
        .task(id: pages.count) {
            pageIndex = min(pageIndex, max(pages.count - 1, 0))
            await rotate()
        }
    }

    /// The event's background (or logo, if no background was set) as a
    /// banner strip up top — the first real use of `Event.backgroundImageFilename`/
    /// `logoImageFilename` anywhere in the app; both were declared but never
    /// rendered before this pass.
    @ViewBuilder
    private var banner: some View {
        if let filename = session.event.backgroundImageFilename ?? session.event.logoImageFilename,
           let uiImage = try? XvaluappAI.imageStore.loadImage(from: filename) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 140)
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(alignment: .bottomLeading) {
                    Text(session.event.name)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(.black.opacity(0.35), in: Capsule())
                        .padding(14)
                }
        }
    }

    /// One page every 8 seconds. Reduce Motion skips the crossfade, not the
    /// rotation itself — the changing standings are the point of a
    /// scoreboard, unlike a purely decorative animation.
    private func rotate() async {
        while !Task.isCancelled {
            try? await Task.sleep(for: .seconds(8))
            guard Task.isCancelled == false, pages.count > 1 else { continue }
            let next = (pageIndex + 1) % pages.count
            if reduceMotion {
                pageIndex = next
            } else {
                withAnimation(.easeInOut(duration: 0.4)) { pageIndex = next }
            }
        }
    }

    private struct Page {
        let title: String
        let categoryID: Int?
    }
}
