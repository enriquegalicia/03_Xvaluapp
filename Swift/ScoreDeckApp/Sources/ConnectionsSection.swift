import SwiftUI
import AguaDesign
import XvaluappCore

/// The connected/discovered-peers list, each with the role(s) it last
/// announced. Shared between `MasterConsoleView` (embedded as a section
/// alongside roster/event-control) and `EventDetailView`'s toolbar
/// "Connections" sheet — connecting to peers is no longer something only
/// the Master console can do, since networking now starts the moment an
/// event opens, before any role is picked (see `EventSession.connect`).
struct ConnectionsSection: View {
    let session: EventSession

    var body: some View {
        if let transport = session.transport {
            Section("Connections") {
                if transport.connectedPeers.isEmpty {
                    Text("No devices connected yet").foregroundStyle(.secondary)
                } else {
                    ForEach(transport.connectedPeers, id: \.self) { peer in
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(peer.displayName)
                                if let roles = session.knownPeerRoles[peer]?.roles, !roles.isEmpty {
                                    Text(roleSummary(roles))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        .foregroundStyle(.primary)
                    }
                }
                ForEach(transport.discoveredPeers.filter { !transport.connectedPeers.contains($0) }, id: \.self) { peer in
                    Button {
                        transport.invite(peer)
                    } label: {
                        Label(peer.displayName, systemImage: "plus.circle")
                    }
                }
            }
            .listRowBackground(AguaColor.bgCard)
        }
    }

    private func roleSummary(_ roles: Set<PeerRole>) -> String {
        roles.map(\.displayName).sorted().joined(separator: ", ")
    }
}

extension PeerRole {
    var displayName: String {
        switch self {
        case .master: return String(localized: "Master")
        case .judge: return String(localized: "Judge")
        case .scoreboard: return String(localized: "Screen")
        }
    }
}
