import SwiftUI
import XvaluappCore

/// Replaces `ResultadosGlobales`/`Resultados1` — one live-updating leaderboard
/// off `RankingEngine.standings(...)` instead of a hand-run `AVG() GROUP BY`
/// query plus the `Subtitulados` tie-color post-processing step.
struct StandingsView: View {
    let session: EventSession

    var body: some View {
        List {
            if session.standings.isEmpty {
                ContentUnavailableView(
                    "No Scores Yet",
                    systemImage: "list.number",
                    description: Text("Standings appear once at least one judge submits a score.")
                )
            } else {
                ForEach(session.standings) { row in
                    HStack {
                        Text("\(row.rank)")
                            .font(.title3.monospacedDigit().bold())
                            .foregroundStyle(.secondary)
                            .frame(width: 32, alignment: .leading)

                        VStack(alignment: .leading) {
                            Text(row.participant.name).font(.headline)
                            Text(row.participant.countryCode)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(row.averageScore, format: .number.precision(.fractionLength(2)))
                            .font(.title3.monospacedDigit())
                            .foregroundStyle(row.isTiedWithNeighbor ? .orange : .primary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .navigationTitle("Standings")
    }
}
