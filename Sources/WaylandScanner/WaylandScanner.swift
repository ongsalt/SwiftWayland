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

    mutating func run() throws {
        if mode == .server {
            print("Server code is not yet support")
            return
        }

        let inputUrl = URL(filePath: inputFile)
        let decoder = XMLDecoder()

        let aProtocol = try decoder.decode(Protocol.self, from: Data(contentsOf: inputUrl))

        let wl_shell_surface = aProtocol.interfaces.first { $0.name == "wl_shell_surface" }

        
        let out = buildInterfaceClass(interface: wl_shell_surface!)
        // print(out)
        try out.write(to: URL(filePath: outputDirectory), atomically: true, encoding: .utf8)
    }
}
