import SwiftUI
import AguaDesign
import XvaluappCore

/// Replaces `ResultadosGlobales`/`Resultados1` — one live-updating leaderboard
/// off `RankingEngine.standings(...)` instead of a hand-run `AVG() GROUP BY`
/// query plus the `Subtitulados` tie-color post-processing step.
struct StandingsView: View {
    let session: EventSession
    /// `nil` shows the overall average across every category; a specific id
    /// shows just that category's leaderboard — what the Screen carousel
    /// rotates through one page at a time.
    var categoryID: Int? = nil
    var title: String = "Standings"
    /// The carousel embeds this view without a `NavigationStack`, so
    /// `.navigationTitle` alone wouldn't render anywhere — it shows an
    /// in-list header instead when used that way.
    var showsInlineTitle: Bool = false

    private var rows: [RankingRow] {
        session.standings(categoryID: categoryID)
    }

    var body: some View {
        List {
            if showsInlineTitle {
                Text(title)
                    .font(.largeTitle.bold())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }

            if session.role != .master {
                ConnectionStatusBadge(connectedPeerNames: session.connectedPeerNames)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
            }

            if rows.isEmpty {
                ContentUnavailableView(
                    "No Scores Yet",
                    systemImage: "list.number",
                    description: Text("Standings appear once at least one judge submits a score.")
                )
            } else {
                ForEach(rows) { row in
                    HStack {
                        Text("\(row.rank)")
                            .font(.title3.monospacedDigit().bold())
                            .foregroundStyle(.secondary)
                            .frame(width: 32, alignment: .leading)

                        ParticipantAvatar(participant: row.participant)

                        VStack(alignment: .leading) {
                            Text(row.participant.name).font(.headline)
                            Text(Countries.named(row.participant.countryCode))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.leading, 6)

                        Spacer()

                        Text(row.averageScore, format: .number.precision(.fractionLength(2)))
                            .font(.title3.monospacedDigit())
                            .foregroundStyle(row.isTiedWithNeighbor ? .orange : .primary)
                    }
                    .padding(.vertical, 2)
                    .listRowBackground(AguaColor.bgCard)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(AguaColor.bgPrimary)
        .navigationTitle(title)
    }
}
