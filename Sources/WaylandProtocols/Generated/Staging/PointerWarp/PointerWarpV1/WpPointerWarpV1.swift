import Foundation
import SwiftWayland

public final class WpPointerWarpV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_pointer_warp_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func warpPointer(surface: WlSurface, pointer: WlPointer, x: Double, y: Double, serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(surface),
            .object(pointer),
            .fixed(x),
            .fixed(y),
            .uint(serial)
        ])
        connection.send(message: message)
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
