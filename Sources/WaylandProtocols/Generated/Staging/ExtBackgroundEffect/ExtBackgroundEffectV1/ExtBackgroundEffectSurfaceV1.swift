import Foundation
import SwiftWayland

public final class ExtBackgroundEffectSurfaceV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setBlurRegion(region: WlRegion) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(region)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case surfaceDestroyed = 0
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
