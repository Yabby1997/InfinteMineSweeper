// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InfiniteMineSweeper",
    products: [
        .library(
            name: "InfiniteMineSweeper",
            targets: ["InfiniteMineSweeper"]
        ),
    ],
    targets: [
        .target(
            name: "InfiniteMineSweeper"
        ),
        .executableTarget(
            name: "InfiniteMineSweeperExecutable",
            dependencies: ["InfiniteMineSweeper"]
        ),
        .testTarget(
            name: "InfiniteMineSweeperTests",
            dependencies: ["InfiniteMineSweeper"]
        ),
    ]
)
