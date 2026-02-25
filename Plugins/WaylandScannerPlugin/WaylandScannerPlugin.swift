import Foundation
import PackagePlugin

@main
struct WaylandScannerPlugin: BuildToolPlugin {
    func createBuildCommands(
        context: PluginContext,
        target: Target
    ) throws -> [Command] {
        var mappings: [(String, Options)] = []
        switch target.name {
        case "SwiftWayland":
            mappings = waylandMappings
        case "WaylandProtocols":
            mappings = defaultMappings
        default:
            return []
        }

        let versionFile = URL(filePath: "./.codegenversion")

        let outputDirectory: URL = context.pluginWorkDirectoryURL
        let outputFile = outputDirectory.appendingPathComponent("WaylandNamespace.swift")
        let cli = try context.tool(named: "WaylandScannerCLI")

        // let namespaceCommand: Command = Command.buildCommand(
        //     displayName: "Generating namespace for wayland protocols",
        //     executable: cli.url,
        //     arguments: ["namespace", outputFile.path()] + mappings.lazy
        //         .map { $0.1.namespace }
        //         .filter { $0 != nil }
        //         .map { $0! } ,
        //     inputFiles: mappings.map { URL(filePath: $0.0) } + [versionFile],
        //     outputFiles: [outputFile]
        // )
        // [namespaceCommand] +
        return mappings.map { (path, options) in
            let inputPath = URL(filePath: path)
            let name = String(inputPath.lastPathComponent.split(separator: ".")[0]).camel
            let outputPath = outputDirectory.appendingPathComponent("\(name).swift")

            var arguments: [String] = [
                "client",
                "\(inputPath.path())", "\(outputPath.path())",
            ]

            // if let t = options.namespace {
            //     arguments.append(contentsOf: ["--namespace", t])
            // }
            // if let t = options.importName {
            //     arguments.append(contentsOf: ["--import", t])
            // }
            if target.name == "SwiftWayland" {
                arguments.append(contentsOf: ["--import", "SwiftWaylandCommon"])
            } else {
                arguments.append(contentsOf: ["--import", "SwiftWayland"])
            }
            if let t = options.traits {
                arguments.append(contentsOf: ["--traits", t])
            }

            return .buildCommand(
                displayName: "Generating protocol \(name)",
                executable: cli.url,
                arguments: arguments,
                inputFiles: [inputPath, versionFile],
                outputFiles: [outputPath]
            )
        }
    }
}

extension String {
    var camel: String {
        self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: "-", omittingEmptySubsequences: true)
            .map { $0.lowercased().capitalized }
            .joined()
    }
}
