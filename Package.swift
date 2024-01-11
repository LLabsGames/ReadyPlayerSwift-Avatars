// swift-tools-version: 5.8.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReadyPlayerSwift",
    products: [
        .library(name: "ReadyPlayerSwift", targets: ["ReadyPlayerSwift"]),
        .executable(name: "UsageExample", targets: ["UsageExample"])
    ],
    targets: [
        .target(name: "ReadyPlayerSwift", path: "Sources"),
        .executableTarget(name: "UsageExample", dependencies: ["ReadyPlayerSwift"], path: "Example")
    ]
)
