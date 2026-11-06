import SwiftUI

/// Surfaces Multipeer connection state on a non-Master device. The legacy
/// app had nothing equivalent — `session:peer:didChangeState:` was an empty
/// stub (see the migration dossier), so a judge device had no on-screen way
/// to tell "connected" from "nobody's invited me yet" from "just dropped."
/// Copy is deliberately not Master-specific — connecting now happens the
/// moment an event opens, before any role (including Master) is picked, so
/// "waiting" can mean waiting for any peer, not specifically a Master.
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
                 ? "Waiting for other devices…"
                 : "Connected to \(connectedPeerNames.joined(separator: ", "))")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.thinMaterial, in: Capsule())
    }
}
