// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CounterStrikeTVUI",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CounterStrikeTVUI",
            targets: ["CounterStrikeTVUI"]),
    ],
    dependencies: [
        .package(path: "CounterStrikeTVDomain")
    ],
    targets: [
        .target(
            name: "CounterStrikeTVUI",
            dependencies: ["CounterStrikeTVDomain"]
        ),
//        .testTarget(
//            name: "CounterStrikeTVUITests",
//            dependencies: ["CounterStrikeTVUI"]
//        ),
    ]
)
