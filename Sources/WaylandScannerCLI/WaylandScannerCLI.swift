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
struct WaylandScanner: ParsableCommand {
    @ArgumentParser.Argument(help: "server | client", completion: .list(["server", "client"]))
    var mode: Mode

    @ArgumentParser.Argument(help: "Protocol XML", completion: .file())
    var inputFile: String

    @ArgumentParser.Argument(help: "Output directory", completion: .directory)
    var outputFile: String

    @Option(name: .long, help: "import name")
    var `import`: String? = nil

    @Option(name: .long, help: "trim class prefix e.g. WlDisplay -> Display")
    var trimPrefix: String? = nil

    @Option(name: .long, help: "same, e.g. WpAlphaModifierV1 -> WpAlphaModifier")
    var trimPostfix: String? = nil

    @Option(
        name: .long,
        help: "generate class under an empty enum `extension Namespace.V1.Whatever { ... }` ")
    var namespace: String? = nil
    

    mutating func run() throws {
        if mode == .server {
            print("Server code is not yet support")
            return
        }

        let inputUrl = URL(filePath: inputFile)

        let importName = self.import

        let outputFile = URL(filePath: outputFile)
        try! FileManager.default.createDirectory(
            at: outputFile.deletingLastPathComponent(), withIntermediateDirectories: true)

        let text: String = try generateClasses(
            String(contentsOf: inputUrl, encoding: .utf8),
            options: Options(
                trimPrefix: trimPrefix,
                trimPostfix: trimPostfix,
                namespace: namespace,
                importName: importName
            ))
        try text.write(to: outputFile, atomically: true, encoding: .utf8)
    }
}
