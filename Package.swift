// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftWayland",
    products: [
        .library(name: "WaylandClient", targets: ["WaylandClient", "WaylandClientProtocols"]),
        // .library(name: "WaylandServer", targets: ["WaylandServer"]),
        .executable(name: "WaylandScannerCLI", targets: ["WaylandScannerCLI"]),
    ],
    traits: [
        .trait(name: "CLIENT"),
        .trait(name: "SERVER"),
        .trait(name: "STAGING"),
        .trait(name: "UNSTABLE"),
        .trait(name: "XDG"),
        .trait(name: "WP"),
        .trait(name: "XWAYLAND"),
        .trait(name: "KDE"),
        .trait(name: "WLR"),

        .default(enabledTraits: ["CLIENT", "XDG"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.18.2"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.8.0"),
    ],
    targets: [
        .target(
            name: "SwiftWaylandCommon",
        ),

        .systemLibrary(
            name: "CWayland",
            pkgConfig: "wayland-client",
        ),

        .plugin(
            name: "WaylandScannerPlugin",
            capability: .buildTool(),
            dependencies: ["WaylandScannerCLI"]
        ),

        .target(
            name: "WaylandClient",
            dependencies: [
                "SwiftWaylandCommon",
                "CWayland",
            ],
            plugins: ["WaylandScannerPlugin"]
        ),

        .target(
            name: "WaylandClientProtocols",
            dependencies: [
                "WaylandClient",
            ],
            plugins: ["WaylandScannerPlugin"]
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

        .testTarget(
            name: "SwiftWaylandTests",
            dependencies: ["WaylandClient"]
        ),
    ],
    swiftLanguageModes: [.v6],
)
