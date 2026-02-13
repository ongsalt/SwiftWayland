import Foundation
import SwiftWayland

public final class WpColorManagementSurfaceFeedbackV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_management_surface_feedback_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getPreferred() -> WpImageDescriptionV1 {
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(imageDescription.id)
        ])
        connection.queueSend(message: message)
        return imageDescription
    }
    
    public func getPreferredParametric() -> WpImageDescriptionV1 {
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(imageDescription.id)
        ])
        connection.queueSend(message: message)
        return imageDescription
    }
    
    public enum Error: UInt32, WlEnum {
        case inert = 0
        case unsupportedFeature = 1
    }
    
    public enum Event: WlEventEnum {
        case preferredChanged(identity: UInt32)
        case preferredChanged2(identityHi: UInt32, identityLo: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.preferredChanged(identity: r.readUInt())
            case 1:
                return Self.preferredChanged2(identityHi: r.readUInt(), identityLo: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
