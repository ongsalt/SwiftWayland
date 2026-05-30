// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftWayland",
    products: [
        // .executable(name: "WaylandScanner", targets: ["WaylandScanner"]),
        .library(name: "SwiftWayland", targets: ["SwiftWayland", "WaylandProtocols"]),
    ],
    traits: [
        .trait(name: "CLIENT"),
        .trait(name: "SERVER"),
        .trait(name: "STAGING"),
        .trait(name: "UNSTABLE"),
        .default(enabledTraits: ["CLIENT"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.15.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "SwiftWaylandCommon",
        ),

        .systemLibrary(
            name: "CWayland",
            pkgConfig: "wayland-client",
        ),

        .target(
            name: "SwiftWayland",
            dependencies: [
                "SwiftWaylandCommon",
                "CWayland",
            ],
        ),

        .target(
            name: "WaylandProtocols",
            dependencies: [
                "SwiftWayland"
            ],
        ),

        .target(
            name: "WaylandScanner",
            dependencies: [
                "SwiftWaylandCommon",
                .product(name: "XMLCoder", package: "XMLCoder"),
            ]
        ),

        .executableTarget(
            name: "WaylandScannerCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "WaylandScanner",
            ]
        ),

        // .testTarget(
        //     name: "SwiftWaylandTests",
        //     dependencies: ["SwiftWayland"]
        // ),
    ]
)
