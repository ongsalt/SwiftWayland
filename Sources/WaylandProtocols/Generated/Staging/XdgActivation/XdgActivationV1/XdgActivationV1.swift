import Foundation
import SwiftWayland

public final class XdgActivationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_activation_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func getActivationToken() throws(WaylandProxyError)  -> XdgActivationTokenV1 {
        let id = connection.createProxy(type: XdgActivationTokenV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func activate(token: String, surface: WlSurface) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .string(token),
            .object(surface)
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
