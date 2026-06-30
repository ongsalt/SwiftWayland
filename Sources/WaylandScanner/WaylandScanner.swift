import Foundation
import SwiftWaylandCommon
import XMLCoder


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
