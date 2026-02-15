import Foundation
import XMLCoder

public struct Options {
    public var trimPrefix: String?
    public var xml: String

    public init(trimPrefix: String? = nil, xml: String) {
        self.trimPrefix = trimPrefix
        self.xml = xml
    }
}

public func generateClasses(options: Options) throws -> String {
    let decoder = XMLDecoder()
    let aProtocol = try decoder.decode(Protocol.self, from: options.xml.data(using: .utf8)!)

    let generator = Generator()
    for interface in aProtocol.interfaces {
        let decl = transform(interface: interface, trimPrefix: options.trimPrefix)
        generator.walk(node: decl)
        generator.add()
    }

    return generator.text
}
