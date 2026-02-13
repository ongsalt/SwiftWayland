// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftWayland",
    products: [
        .executable(name: "WaylandScanner", targets: ["WaylandScanner"]),
        .library(name: "SwiftWayland", targets: ["SwiftWayland", "WaylandProtocols"]),
        // .library(name: "WaylandProtocols", targets: ["WaylandProtocols"]),
    ],
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.15.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        // .package(
        //     url: "https://github.com/swiftlang/swift-syntax.git",
        //     from: "602.0.0"
        // ),
        // .package(url: "https://github.com/PureSwift/Socket.git", from: "0.5.0"),
        // .package(url: "https://github.com/apple/swift-system", from: "1.6.1"),
    ],
    targets: [
        .target(
            name: "SwiftWayland",
            dependencies: [
                // .product(name: "SystemPackage", package: "swift-system")
            ]
        ),

        .target(
            name: "WaylandProtocols",
            dependencies: [
                "SwiftWayland"
            ],
        ),

        .executableTarget(
            name: "WaylandScanner",
            dependencies: [
                .product(name: "XMLCoder", package: "XMLCoder"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .testTarget(
            name: "SwiftWaylandTests",
            dependencies: ["SwiftWayland"]
        ),
        .executableTarget(
            name: "SwiftWaylandExample",
            dependencies: [
                "SwiftWayland"
            ]
        ),
    ]
)
