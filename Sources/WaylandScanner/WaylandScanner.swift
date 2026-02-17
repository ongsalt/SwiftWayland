import Foundation
import XMLCoder
import SwiftWaylandCommon

public struct Options: Sendable {
    public var trim: Bool = false
    public var namespace: String?
    public var importName: String?
    public var traits: String?

    public init(
        trim: Bool = false, namespace: String? = nil, importName: String? = nil,
        traits: String? = nil
    ) {
        self.trim = trim
        self.namespace = namespace
        self.importName = importName
        self.traits = traits
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

    for interface in aProtocol.interfaces {
        let decl = transform(
            interface: interface,
            trim: options.trim
        )
        generator.walk(node: decl)
        generator.add()
    }

    if options.namespace != nil {
        generator.indentLevel -= 4
        generator.add("}")
    }

    if let _ = options.traits {
        generator.add("#endif")
    }

    return generator.text
}
