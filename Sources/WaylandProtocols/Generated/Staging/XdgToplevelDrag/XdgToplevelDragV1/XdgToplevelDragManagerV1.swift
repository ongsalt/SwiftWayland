import Foundation
import SwiftWayland

public final class XdgToplevelDragManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel_drag_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getXdgToplevelDrag(dataSource: WlDataSource) -> XdgToplevelDragV1 {
        let id = connection.createProxy(type: XdgToplevelDragV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(dataSource)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidSource = 0
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
