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

    @ArgumentParser.Argument()
    var inputFile: String
    @ArgumentParser.Argument()
    var outputPackage: String

    mutating func run() throws {
        if mode == .server {
            print("Server code is not yet support")
            return
        }
        let inputUrl = URL(filePath: inputFile)
        let decoder = XMLDecoder()

        let aProtocol = try decoder.decode(Protocol.self, from: Data(contentsOf: inputUrl))

        dump(aProtocol)
    }
}
