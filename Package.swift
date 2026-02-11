// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftWayland",
    products: [
        // .executable(name: "WaylandScanner", targets: ["WaylandScanner"])
    ],
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.15.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "602.0.0"
        ),
        // .package(url: "https://github.com/PureSwift/Socket.git", from: "0.5.0"),
        // .package(url: "https://github.com/apple/swift-system", from: "1.6.1"),
    ],
    targets: [
        .executableTarget(
            name: "SwiftWayland",
            dependencies: [
                // "Socket",
                // .product(name: "SystemPackage", package: "swift-system"),
            ],
        ),
        // .target(name: "WaylandScanner"),
        .executableTarget(
            name: "WaylandScanner",
            dependencies: [
                .product(name: "XMLCoder", package: "XMLCoder"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
            ]
        ),
        .testTarget(
            name: "SwiftWaylandTests",
            dependencies: ["SwiftWayland"]
        ),
    ]
)
