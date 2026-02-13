import Foundation
import SwiftWayland

public final class ZwpLockedPointerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_locked_pointer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setCursorPositionHint(surfaceX: Double, surfaceY: Double) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .fixed(surfaceX),
            .fixed(surfaceY)
        ])
        connection.queueSend(message: message)
    }
    
    public func setRegion(region: WlRegion) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(region)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case locked
        case unlocked
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.locked
            case 1:
                return Self.unlocked
            default:
                fatalError("Unknown message")
            }
        }
    }
}
