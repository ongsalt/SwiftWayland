// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Examples",
    dependencies: [
        .package(path: "../..", traits: ["UNSTABLE", "KDE", .defaults])
    ],
    targets: [
        .executableTarget(
            name: "Window",
            dependencies: [
                .product(name: "SwiftWayland", package: "SwiftWayland"),
            ],
        ),
    ],
    swiftLanguageModes: [.v6]
)
