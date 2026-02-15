// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.
import CompilerPluginSupport
import PackageDescription

let package = Package(
    name: "SwiftWayland",
    products: [
        // .executable(name: "WaylandScanner", targets: ["WaylandScanner"]),
        .library(name: "SwiftWayland", targets: ["SwiftWayland", "WaylandProtocols"])
    ],
    dependencies: [
        // other dependencies
        .package(url: "https://github.com/CoreOffice/XMLCoder.git", from: "0.15.0"),
        // .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            from: "602.0.0"
        ),
        // .package(url: "https://github.com/PureSwift/Socket.git", from: "0.5.0"),
    ],
    targets: [
        .target(
            name: "SwiftWayland",
            dependencies: [
                "WaylandScanner"
            ]
        ),
        .target(
            name: "WaylandProtocols",
            dependencies: [
                "SwiftWayland"
            ],
        ),

        .macro(
            name: "WaylandScanner",
            dependencies: [
                .product(name: "XMLCoder", package: "XMLCoder"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
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
                .target(name: "SwiftWayland")
            ],
        ),
    ]
)
