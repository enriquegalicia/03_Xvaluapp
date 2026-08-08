// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "XvaluappCore",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        // Pure-Swift domain layer: models, ranking/scoring math, the typed
        // Multipeer sync protocol, and a Codable-JSON persistence layer.
        // No UIKit/SwiftUI/MultipeerConnectivity imports here on purpose —
        // this target has to compile and unit-test on plain Foundation so it
        // stays testable outside Xcode/iOS (see Tests/).  The iOS app target
        // (created in Xcode, not included in this package) links this and
        // adds the SwiftUI views + a thin MultipeerConnectivity transport
        // that just sends/receives the `Data` this package already encodes.
        .library(name: "XvaluappCore", targets: ["XvaluappCore"]),
    ],
    targets: [
        .target(name: "XvaluappCore"),
        .testTarget(name: "XvaluappCoreTests", dependencies: ["XvaluappCore"]),
    ]
)
