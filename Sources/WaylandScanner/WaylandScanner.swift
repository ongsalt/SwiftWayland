import Foundation
import SwiftWaylandCommon
import XMLCoder

public struct Options: Sendable {
    public var trim: Bool = false
    public var namespace: String?
    public var noImport: Bool
    public var traits: String?
    public var prefixMap: [(from: String, to: String)] = []

    public init(
        trim: Bool = false, namespace: String? = nil, noImport: Bool = false,
        traits: String? = nil, prefixMap: [(from: String, to: String)] = []
    ) {
        self.trim = trim
        self.namespace = namespace
        self.noImport = noImport
        self.traits = traits
        self.prefixMap = prefixMap
    }
}

public func parse(
    _ xml: String,
    trimmed trim: Bool = false,
    prefixMap: [(from: String, to: String)] = []
) throws -> ProtocolDeclaration {
    let decoder = XMLDecoder()
    let aProtocol = try decoder.decode(Protocol.self, from: xml.data(using: .utf8)!)
    let decl = transform(
        protocol: aProtocol,
        trim: trim,
        prefixMap: prefixMap
    )

    return decl
}
