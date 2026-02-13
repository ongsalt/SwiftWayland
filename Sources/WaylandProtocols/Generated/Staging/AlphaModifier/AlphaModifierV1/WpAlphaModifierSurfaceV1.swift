import Foundation
import SwiftWayland

public final class WpAlphaModifierSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_alpha_modifier_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setMultiplier(factor: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .uint(factor)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case noSurface = 0
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
