// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CounterStrikeTVService",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CounterStrikeTVService",
            targets: ["CounterStrikeTVService"]),
    ],
    dependencies: [
        .package(path: "CounterStrikeTVDomain")
    ],
    targets: [
        .target(
            name: "CounterStrikeTVService",
            dependencies: ["CounterStrikeTVDomain"]
        ),
        .testTarget(
            name: "CounterStrikeTVServiceTests",
            dependencies: ["CounterStrikeTVService", "CounterStrikeTVDomain"]
        ),
    ]
)
