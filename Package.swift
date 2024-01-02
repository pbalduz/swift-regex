// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swift-regex",
    platforms: [
        .iOS(.v14),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftRegex",
            targets: ["SwiftRegex"]
        ),
    ],
    targets: [
        .target(name: "SwiftRegex"),
        .testTarget(
            name: "SwiftRegexTests",
            dependencies: ["SwiftRegex"]
        ),
    ]
)
