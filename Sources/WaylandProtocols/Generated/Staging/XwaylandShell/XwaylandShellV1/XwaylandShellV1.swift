import Foundation
import SwiftWayland

public final class XwaylandShellV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getXwaylandSurface(surface: WlSurface) -> XwaylandSurfaceV1 {
        let id = connection.createProxy(type: XwaylandSurfaceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case role = 0
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
