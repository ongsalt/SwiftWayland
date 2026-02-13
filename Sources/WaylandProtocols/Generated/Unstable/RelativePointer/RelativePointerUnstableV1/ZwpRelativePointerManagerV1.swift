import Foundation
import SwiftWayland

public final class ZwpRelativePointerManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_relative_pointer_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func getRelativePointer(pointer: WlPointer) throws(WaylandProxyError)  -> ZwpRelativePointerV1 {
        let id = connection.createProxy(type: ZwpRelativePointerV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
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
