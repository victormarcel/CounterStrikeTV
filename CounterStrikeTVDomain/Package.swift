// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CounterStrikeTVDomain",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CounterStrikeTVDomain",
            targets: ["CounterStrikeTVDomain"]
        ),
    ],
    targets: [
        .target(
            name: "CounterStrikeTVDomain"
        ),
        .testTarget(
            name: "CounterStrikeTVDomainTests",
            dependencies: ["CounterStrikeTVDomain"],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
