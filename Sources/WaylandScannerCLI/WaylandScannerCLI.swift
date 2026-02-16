// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation
import WaylandScanner

enum Mode: String {
    case server
    case client
}

extension Mode: ExpressibleByArgument {
    init?(argument: String) {
        self.init(rawValue: argument)
    }
}

@main
struct WaylandScannerCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Calculate descriptive statistics.",
        subcommands: [GenerateClientCode.self, GenerateNamespaces.self])
}

struct GenerateClientCode: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "client",
        abstract: "Calculate descriptive statistics.", )

    @ArgumentParser.Argument(help: "Protocol XML", completion: .file())
    var inputFile: String

    @ArgumentParser.Argument(help: "Output directory", completion: .file())
    var outputFile: String

    @Option(name: .long, help: "import name")
    var `import`: String? = nil

    @Option(
        name: .long,
        help: "generate class under an empty enum `extension Namespace.V1.Whatever { ... }` ")
    var namespace: String? = nil

    @Option(
        name: .long,
        help: "Traits")
    var traits: String? = nil

    mutating func run() throws {
        let inputUrl = URL(filePath: inputFile)

        let importName = self.import
        let outputFile = URL(filePath: outputFile)

        try! FileManager.default.createDirectory(
            at: outputFile.deletingLastPathComponent(), withIntermediateDirectories: true)

        let text: String = try generateFile(
            String(contentsOf: inputUrl, encoding: .utf8),
            options: Options(
                namespace: namespace,
                importName: importName,
                traits: traits
            ))
        try text.write(to: outputFile, atomically: true, encoding: .utf8)
    }
}

struct GenerateNamespaces: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "namespace",
        abstract: "Generated namespace enum from provided list")

    @ArgumentParser.Argument(help: "Output file", completion: .file())
    var outputFile: String

    @ArgumentParser.Argument(help: "Namespace list like Wayland.Display,Xdg.Decoration.ZV1")
    var namespaces: [String]

    mutating func run() throws {
        let outputFile = URL(filePath: outputFile)
        try! FileManager.default.createDirectory(
            at: outputFile.deletingLastPathComponent(), withIntermediateDirectories: true)

        let text = createNamespaces(namespaces: Set(namespaces))
        try text.write(to: outputFile, atomically: true, encoding: .utf8)
    }
}
