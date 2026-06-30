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
struct WaylandScannerCLI: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Calculate descriptive statistics.",
        subcommands: [GenerateClientCode.self])
}

struct GenerateClientCode: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "client",
        abstract: "Calculate descriptive statistics.", )

    @Option(
        name: .shortAndLong, parsing: .upToNextOption, help: "Protocol XML",
        completion: .file(extensions: ["xml"]))
    var inputFiles: [String]

    @Option(name: .shortAndLong, help: "Output directory", completion: .file(extensions: ["swift"]))
    var outputFile: String

    @Flag(name: .long, help: "Do not generate `import WaylandClient`")
    var `noImport`: Bool = false

    @Option(
        name: .long,
        help: "generate class under an empty enum `extension Namespace.V1.Whatever { ... }` ")
    var namespace: String? = nil

    @Option(
        name: .long,
        help: "Traits")
    var traits: String? = nil

    @Option(
        name: .long,
        help: "Prefix remapping in 'old_prefix:NewPrefix' format (repeatable)")
    var prefixMap: [String] = []

    mutating func run() async throws {
        let outputFile = URL(filePath: outputFile)
        let parsedPrefixMap: [(from: String, to: String)] = prefixMap.compactMap { entry in
            let parts = entry.split(separator: ":", maxSplits: 1)
            guard parts.count == 2 else { return nil }
            return (from: String(parts[0]), to: String(parts[1]))
        }

        let options = Options(
            namespace: namespace,
            noImport: self.noImport,
            traits: traits,
            prefixMap: parsedPrefixMap
        )

        var protocols: [ProtocolDeclaration] = []
        for inputFile in inputFiles {
            let url = URL(filePath: inputFile)
            let p = try WaylandScanner.parse(String(contentsOf: url, encoding: .utf8))
            protocols.append(p)
        }

        try FileManager.default.createDirectory(
            at: outputFile.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )

        guard let writer = FileWriter(url: outputFile) else {
            throw ScannerError.cannotCreateOutputStream
        }

        let generator = Generator(outputStream: writer)

        try write(into: generator, protocols: protocols, options: options)

    }
}

public func write<Output: TextOutputStream>(
    into gen: Generator<Output>, protocols: [ProtocolDeclaration], options: Options
) throws {
    gen << "import Foundation"
    if !options.noImport {
        gen << "import WaylandClient"
    }
    gen.add()

    if let traits = options.traits {
        gen.add("#if \(traits)")
    }

    if let namespace = options.namespace {
        gen.add("extension \(namespace) {")
        gen.indentLevel += 4
    }

    for p in protocols {
        p.generate(gen)
        gen.add()
    }

    if options.namespace != nil {
        gen.indentLevel -= 4
        gen.add("}")
    }

    if options.traits != nil {
        gen.add("#endif")
    }
}

// struct GenerateNamespaces: ParsableCommand {
//     static let configuration = CommandConfiguration(
//         commandName: "namespace",
//         abstract: "Generated namespace enum from provided list")

//     @ArgumentParser.Argument(help: "Output file", completion: .file())
//     var outputFile: String

//     @ArgumentParser.Argument(help: "Namespace list like Wayland.Display,Xdg.Decoration.ZV1")
//     var namespaces: [String]

//     mutating func run() throws {
//         let outputFile = URL(filePath: outputFile)
//         try! FileManager.default.createDirectory(
//             at: outputFile.deletingLastPathComponent(), withIntermediateDirectories: true)

//         let text = createNamespaces(namespaces: Set(namespaces))
//         try text.write(to: outputFile, atomically: true, encoding: .utf8)
//     }
// }

enum ScannerError: Error {
    case cannotCreateOutputStream
}

struct FileWriter: TextOutputStream {
    let fileHandle: FileHandle

    init?(url: URL) {
        if !FileManager.default.fileExists(atPath: url.path) {
            _ = FileManager.default.createFile(atPath: url.path, contents: nil)
        }

        guard let handle = try? FileHandle(forWritingTo: url) else { return nil }
        self.fileHandle = handle

        self.fileHandle.truncateFile(atOffset: 0)
    }

    mutating func write(_ string: String) {
        if let data = string.data(using: .utf8) {
            fileHandle.write(data)
        }
    }

    func close() {
        try? fileHandle.close()
    }
}
