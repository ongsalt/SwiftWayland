// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation
import XMLCoder

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
    var outputDirectory: String

    @Option(name: .long, help: "import name")
    var `import`: String? = nil

    mutating func run() throws {
        if mode == .server {
            print("Server code is not yet support")
            return
        }

        let inputUrl = URL(filePath: inputFile)
        let decoder = XMLDecoder()

        let aProtocol = try decoder.decode(Protocol.self, from: Data(contentsOf: inputUrl))
        print("Protocol: \(aProtocol.name)")

        // let interface = aProtocol.interfaces.first { $0.name == "wl_display" }
        for interface in aProtocol.interfaces {
            // if interface.name != "wl_data_device" {
            //     continue
            // }

            var url = URL(filePath: outputDirectory)
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)

            url.append(path: "\(interface.name.camel).swift")

            print(" - Writing \(url.lastPathComponent)")
            let out = buildInterfaceClass(interface: interface, importName: self.`import`)
            try out.write(to: url, atomically: true, encoding: .utf8)

            // break
        }
    }
}
