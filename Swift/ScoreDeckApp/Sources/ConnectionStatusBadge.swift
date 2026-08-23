import SwiftUI

/// Surfaces Multipeer connection state on the Judge/Screen side. The legacy
/// app had nothing equivalent — `session:peer:didChangeState:` was an empty
/// stub (see the migration dossier), so a judge device had no on-screen way
/// to tell "connected to master" from "master hasn't invited me yet" from
/// "master just dropped." This alone doesn't fix the deeper leader-election
/// gap noted there, but it stops that state from being invisible.
///
/// Takes plain peer display names rather than `MCPeerID` so this view
/// doesn't need to import `MultipeerConnectivity` itself.
struct ConnectionStatusBadge: View {
    let connectedPeerNames: [String]

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(connectedPeerNames.isEmpty ? .orange : .green)
                .frame(width: 8, height: 8)
            Text(connectedPeerNames.isEmpty
                 ? "Waiting for master device…"
                 : "Connected to \(connectedPeerNames.joined(separator: ", "))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.thinMaterial, in: Capsule())
    }
}
