// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftWayland",
    products: [
        // .executable(name: "WaylandScanner", targets: ["WaylandScanner"]),
        .library(name: "SwiftWayland", targets: ["SwiftWayland", "WaylandProtocols"]),
        .plugin(
            name: "WaylandScannerPlugin",
            targets: [
                "WaylandScannerPlugin"
            ]
        ),
    ],
    traits: [
        .trait(name: "Client"),
        .trait(name: "Server"),
        .trait(name: "Staging"),
        .trait(name: "Unstable"),
        .default(enabledTraits: ["Client"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.15.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "602.0.0"
        ),
    ],
    targets: [
        .target(
            name: "SwiftWayland",
            dependencies: [
                // "WaylandScannerMacro"
            ],
            plugins: [
                "WaylandScannerPlugin"
            ]
        ),

        .target(
            name: "WaylandProtocols",
            dependencies: [
                "SwiftWayland"
            ],
            plugins: [
                "WaylandScannerPlugin"
            ]
        ),

        .target(
            name: "WaylandScanner",
            dependencies: [
                .product(name: "XMLCoder", package: "XMLCoder"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // .macro(
        //     name: "WaylandScannerMacro",
        //     dependencies: [
        //         "WaylandScanner"
        //     ]
        // ),

        .executableTarget(
            name: "WaylandScannerCLI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "WaylandScanner",
            ]
        ),

        .plugin(
            name: "WaylandScannerPlugin",
            capability: .buildTool(),
            dependencies: [
                "WaylandScannerCLI"
            ]
        ),

        // .testTarget(
        //     name: "SwiftWaylandTests",
        //     dependencies: ["SwiftWayland"]
        // ),
        .executableTarget(
            name: "SwiftWaylandExample",
            dependencies: [
                // "SwiftWayland",
                "SwiftWayland",
                "WaylandProtocols"
            ],
        ),
    ]
)
