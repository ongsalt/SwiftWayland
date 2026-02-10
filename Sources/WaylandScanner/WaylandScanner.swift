// The Swift Programming Language
// https://docs.swift.org/swift-book

import ArgumentParser
import Foundation
import FoundationXML

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
struct SwiftWayland: ParsableCommand {
    @Argument(help: "server | client", completion: .list(["server", "client"]))
    var mode: Mode

    @Argument()
    var inputFile: String
    @Argument()
    var outputFile: String

    mutating func run() throws {
        print("Run")
    }
}
