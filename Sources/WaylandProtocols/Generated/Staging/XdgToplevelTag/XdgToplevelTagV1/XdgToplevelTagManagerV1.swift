import Foundation
import SwiftWayland

public final class XdgToplevelTagManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel_tag_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func setToplevelTag(toplevel: XdgToplevel, tag: String) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(toplevel),
            .string(tag)
        ])
        connection.send(message: message)
    }
    
    public func setToplevelDescription(toplevel: XdgToplevel, description: String) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(toplevel),
            .string(description)
        ])
        connection.send(message: message)
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
