import Foundation
import SwiftWayland

public final class XwaylandSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xwayland_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func setSerial(serialLo: UInt32, serialHi: UInt32) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(serialLo),
            .uint(serialHi)
        ])
        connection.queueSend(message: message)
    }
    
    public func destroy() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyAssociated = 0
        case invalidSerial = 1
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
