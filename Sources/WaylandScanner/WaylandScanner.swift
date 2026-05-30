import Foundation
import SwiftWaylandCommon
import XMLCoder

public struct Options: Sendable {
    public var trim: Bool = false
    public var namespace: String?
    public var importName: String?
    public var traits: String?
    public var prefixMap: [(from: String, to: String)] = []

    public init(
        trim: Bool = false, namespace: String? = nil, importName: String? = nil,
        traits: String? = nil, prefixMap: [(from: String, to: String)] = []
    ) {
        self.trim = trim
        self.namespace = namespace
        self.importName = importName
        self.traits = traits
        self.prefixMap = prefixMap
    }
}

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

    if let traits = options.traits {
        generator.add("#if \(traits)")
    }

    if let namespace = options.namespace {
        generator.add("extension \(namespace) {")
        generator.indentLevel += 4
    }

    let decl = transform(
        protocol: aProtocol,
        trim: options.trim,
        prefixMap: options.prefixMap
    )
    generator.walk(node: decl)
    generator.add()

    if options.namespace != nil {
        generator.indentLevel -= 4
        generator.add("}")
    }

    if options.traits != nil {
        generator.add("#endif")
    }

    return generator.text
}
