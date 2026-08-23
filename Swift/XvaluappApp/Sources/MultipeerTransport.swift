import Foundation
import MultipeerConnectivity
import Observation
import XvaluappCore

/// The only file in this app that imports `MultipeerConnectivity` — every
/// other screen talks to `SyncMessage` values, never to `MCSession`
/// directly. That's the seam `XvaluappCore/Sync/SyncMessage.swift` was
/// designed around.
///
/// Compare this file's `session(_:didReceive:fromPeer:)` to the legacy
/// `JudgePanel.m`'s: there, payloads were `NSKeyedArchiver`-archived
/// dictionaries with no class allow-list, and a malformed payload could
/// throw an uncaught exception straight through the delegate callback. Here
/// a bad payload just fails `JSONDecoder.decode` and is dropped — `guard
/// let ... else { return }`, no crash.
@Observable
final class MultipeerTransport: NSObject {
    /// Service type identifiers must be 1–15 characters, lowercase
    /// letters/digits/hyphens only. Replaces the legacy hardcoded
    /// `"Xvaluapp1"` service type with the same idea, valid syntax.
    private static let serviceType = "xvaluapp-sync"

    let myPeerID: MCPeerID
    private let session: MCSession
    private let advertiser: MCNearbyServiceAdvertiser
    private let browser: MCNearbyServiceBrowser

    private(set) var connectedPeers: [MCPeerID] = []
    private(set) var discoveredPeers: [MCPeerID] = []

    struct PendingInvitation {
        let peerID: MCPeerID
        fileprivate let handler: (Bool, MCSession?) -> Void
    }

    /// An incoming invitation waiting on the user to accept or decline it —
    /// replaces the legacy `MCAdvertiserAssistant`'s silent auto-accept
    /// (see `advertiser(_:didReceiveInvitationFromPeer:...)` below) with a
    /// confirmation the device's own screen shows before joining any
    /// session.
    private(set) var pendingInvitation: PendingInvitation?

    func acceptPendingInvitation() {
        guard let pending = pendingInvitation else { return }
        pending.handler(true, session)
        pendingInvitation = nil
    }

    func declinePendingInvitation() {
        guard let pending = pendingInvitation else { return }
        pending.handler(false, nil)
        pendingInvitation = nil
    }

    var onReceive: ((SyncMessage, MCPeerID) -> Void)?
    /// Fired when a peer finishes connecting — the master uses this to push
    /// a full snapshot to just-joined devices, replacing the legacy app's
    /// "every screen requests a resync by typing a magic password command"
    /// flow.
    var onPeerConnected: ((MCPeerID) -> Void)?

    init(displayName: String) {
        // MCPeerID display names are capped at 63 UTF-8 bytes by the
        // framework; truncate defensively rather than let a long device
        // name silently fail session setup.
        myPeerID = MCPeerID(displayName: String(displayName.prefix(63)))
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: Self.serviceType)
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: Self.serviceType)
        super.init()
        session.delegate = self
        advertiser.delegate = self
        browser.delegate = self
    }

    func startAdvertising() { advertiser.startAdvertisingPeer() }
    func stopAdvertising() { advertiser.stopAdvertisingPeer() }
    func startBrowsing() { browser.startBrowsingForPeers() }
    func stopBrowsing() { browser.stopBrowsingForPeers() }

    func stopAll() {
        stopAdvertising()
        stopBrowsing()
        session.disconnect()
    }

    func invite(_ peer: MCPeerID) {
        browser.invitePeer(peer, to: session, withContext: nil, timeout: 15)
    }

    /// Send to every currently connected peer.
    func broadcast(_ message: SyncMessage) {
        send(message, to: session.connectedPeers)
    }

    /// Send to specific peers only — used to push a fresh snapshot to a
    /// single newly-joined device instead of re-broadcasting to everyone.
    func send(_ message: SyncMessage, to peers: [MCPeerID]) {
        guard !peers.isEmpty else { return }
        do {
            let data = try JSONEncoder().encode(message)
            try session.send(data, toPeers: peers, with: .reliable)
        } catch {
            // Surfaced, not swallowed — every legacy `sendData:...error:`
            // call site declared an NSError and never checked it.
            print("MultipeerTransport send failed: \(error)")
        }
    }
}

extension MultipeerTransport: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                if !self.connectedPeers.contains(peerID) {
                    self.connectedPeers.append(peerID)
                    self.onPeerConnected?(peerID)
                }
            case .notConnected:
                // Unlike the legacy app's empty didChangeState stub, a
                // disconnect actually updates visible state here instead
                // of leaving stale "connected" UI behind.
                self.connectedPeers.removeAll { $0 == peerID }
            case .connecting:
                break
            @unknown default:
                break
            }
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        guard let message = try? JSONDecoder().decode(SyncMessage.self, from: data) else { return }
        DispatchQueue.main.async { self.onReceive?(message, peerID) }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {}
}

extension MultipeerTransport: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Hold the invitation for the person at this device to accept or
        // decline, instead of the legacy `MCAdvertiserAssistant`'s silent
        // auto-accept — the framework requires the handler eventually be
        // called exactly once, so `pendingInvitation` owns it until then.
        DispatchQueue.main.async {
            self.pendingInvitation = PendingInvitation(peerID: peerID, handler: invitationHandler)
        }
    }
}

extension MultipeerTransport: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        DispatchQueue.main.async {
            if !self.discoveredPeers.contains(peerID) { self.discoveredPeers.append(peerID) }
        }
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            self.discoveredPeers.removeAll { $0 == peerID }
        }
    }
}
