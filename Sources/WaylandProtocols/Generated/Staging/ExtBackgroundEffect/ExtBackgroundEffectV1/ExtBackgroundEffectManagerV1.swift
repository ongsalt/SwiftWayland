import Foundation
import SwiftWayland

public final class ExtBackgroundEffectManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_background_effect_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getBackgroundEffect(surface: WlSurface) -> ExtBackgroundEffectSurfaceV1 {
        let id = connection.createProxy(type: ExtBackgroundEffectSurfaceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case backgroundEffectExists = 0
    }
    
    public enum Capability: UInt32, WlEnum {
        case blur = 1
    }
    
    public enum Event: WlEventEnum {
        case capabilities(flags: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.capabilities(flags: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
