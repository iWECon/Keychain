// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Keychain",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "Keychain", targets: ["Keychain"]),
        .library(name: "KeychainHelper", targets: ["KeychainHelper"])
    ],
    targets: [
        .target(
            name: "Keychain",
            dependencies: []
        ),
        .target(
            name: "KeychainHelper",
            dependencies: [
                "Keychain"
            ],
            path: "Sources/KeychainHelper"
        ),
        .testTarget(name: "KeychainTests", dependencies: ["Keychain"]),
    ],
    swiftLanguageVersions: [.v5]
)
