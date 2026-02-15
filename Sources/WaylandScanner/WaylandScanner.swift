import Foundation
import XMLCoder

public struct Options {
    public var trimPrefix: String? = nil
    public var trimPostfix: String? = nil
    public var namespace: String? = nil
    public var importName: String? = nil

    public init(
        trimPrefix: String? = nil, trimPostfix: String? = nil, namespace: String? = nil,
        importName: String? = nil
    ) {
        self.trimPrefix = trimPrefix
        self.trimPostfix = trimPostfix
        self.namespace = namespace
    }
}

public func generateClasses(_ xml: String, options: Options) throws -> String {
    let decoder = XMLDecoder()
    let aProtocol = try decoder.decode(Protocol.self, from: xml.data(using: .utf8)!)

    let generator = Generator()

    generator.add("import Foundation")
    if let name = options.importName {
        generator.add("@_spi(SwiftWaylandPrivate) import \(name)")
    }

    generator.add()

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
