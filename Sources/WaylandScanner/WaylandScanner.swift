import Foundation
import XMLCoder

public struct Options: Sendable {
    public var trimPrefix: String?
    public var trimPostfix: String?
    public var namespace: String?
    public var importName: String?
    public var traits: String?

    public init(
        trimPrefix: String? = nil, trimPostfix: String? = nil, namespace: String? = nil,
        importName: String? = nil, traits: String? = nil
    ) {
        self.trimPrefix = trimPrefix
        self.trimPostfix = trimPostfix
        self.namespace = namespace
        self.importName = importName
        self.traits = traits
    }

    public static func external(
        trimPrefix: String? = nil, trimPostfix: String? = nil, namespace: String? = nil,
        traits: String?
    ) -> Self {
        Self.init(
            trimPrefix: trimPrefix,
            trimPostfix: trimPostfix,
            namespace: namespace,
            importName: "SwiftWayland",
            traits: traits
        )
    }

    public init(
        _ prefix: String, _ version: String, _ traits: String? = nil
    ) {
        self.init(
            trimPrefix: prefix,
            trimPostfix: version,
            namespace: prefix,
            importName: "SwiftWayland",
            traits: traits
        )
    }

    public static func unstable(
        _ namespace: String, _ prefix: String, _ version: String,
    ) -> Self {
        Self.init(
            trimPrefix: prefix,
            trimPostfix: version,
            namespace: namespace,
            importName: "SwiftWayland",
            traits: "UNSTABLE"
        )
    }

    public init(path: String, autoTrimPrefix: Bool = true) {
        self.importName = "SwiftWayland"
        let url = URL(filePath: path)

        let filename = url.lastPathComponent.split(separator: ".")[0]
        let namespace = url.pathComponents[2].split(separator: "-").map { $0.capitalized }
        self.namespace = namespace.joined(separator: ".")

        if autoTrimPrefix {
            self.trimPrefix = namespace[0]
        } else {
            self.trimPrefix = nil
        }

        let stability = url.pathComponents[1]
        self.traits = stability.uppercased()
        if self.traits == "STABLE" {
            self.trimPostfix = nil
            return
        }

        let version = filename.split(separator: "-").last!.uppercased()
        if self.traits == "UNSTABLE" {
            self.trimPostfix = "Z" + version
        } else {
            self.trimPostfix = version
        }

    }
}

func auto(_ path: String, trimPrefix: Bool = true) -> (String, Options) {
    (path, Options(path: path, autoTrimPrefix: trimPrefix))
}

let mappings: [(String, Options)] = [
    auto("./protocols/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml"),
    auto("./protocols/unstable/xdg-foreign/xdg-foreign-unstable-v1.xml"),
    auto("./protocols/unstable/xdg-foreign/xdg-foreign-unstable-v2.xml"),
    auto("./protocols/unstable/xdg-output/xdg-output-unstable-v1.xml"),
    auto("./protocols/stable/xdg-shell/xdg-shell.xml"),
    auto("./protocols/staging/xdg-toplevel-drag/xdg-toplevel-drag-v1.xml"),  // TODO: dependencies, this depend on Xdg.Shell
    auto("./protocols/staging/xdg-dialog/xdg-dialog-v1.xml"),
    auto("./protocols/staging/xdg-toplevel-icon/xdg-toplevel-icon-v1.xml"),
    auto("./protocols/staging/xdg-toplevel-tag/xdg-toplevel-tag-v1.xml"),  // also depend on Xdg.Shell
    auto("./protocols/staging/xdg-system-bell/xdg-system-bell-v1.xml", ),
]

public func generateClasses(_ xml: String, options: Options) throws -> String {
    return try generateFile(xml, options: options, doImport: false)
}

public func generateFile(_ xml: String, options: Options, doImport: Bool = true) throws -> String {
    let decoder = XMLDecoder()
    let aProtocol = try decoder.decode(Protocol.self, from: xml.data(using: .utf8)!)

    let generator = Generator()

    if doImport {
        generator.add("import Foundation")
        if let name = options.importName {
            generator.add("@_spi(SwiftWaylandPrivate) import \(name)")
        }

        generator.add()
    }

    if let namespace = options.namespace {
        generator.add("extension \(namespace) {")
        generator.indentLevel += 4
    }

    for interface in aProtocol.interfaces {
        let decl = transform(
            interface: interface,
            trimPrefix: options.trimPrefix,
            trimSubfix: options.trimPostfix
        )
        generator.walk(node: decl)
        generator.add()
    }

    if options.namespace != nil {
        generator.indentLevel -= 4
        generator.add("}")
    }

    return generator.text
}
