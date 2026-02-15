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

        let importName = self.import

        let dir = URL(filePath: outputDirectory)
        try! FileManager.default.createDirectory(
            at: dir, withIntermediateDirectories: true)

        // bruhhh
        // Task {
        //     await withTaskGroup { group in
        for interface in aProtocol.interfaces {
            // group.addTask {
            //     await withUnsafeContinuation { contination in
            //         DispatchQueue.global().async {
            var url = dir
            url.append(path: "\(interface.name.camel).swift")

            print(" - Writing \(url.lastPathComponent)")
            let generator = Generator()
            if let importName {
                generator.imports.append(importName)
            }
            let decl = transform(interface: interface)
            generator.walk(node: decl)
            // dump(decl)
            let out = generator.text

            try! out.write(to: url, atomically: true, encoding: .utf8)
            //         contination.resume()
            //     }
            // }
        }
        //         }
        //     }

        //     Foundation.exit(0)
        // }

        // RunLoop.main.run()
    }
}
