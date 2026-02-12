import Foundation
import SwiftWayland

public final class XdgActivationV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getActivationToken() -> XdgActivationTokenV1 {
        let id = connection.createProxy(type: XdgActivationTokenV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func activate(token: String, surface: WlSurface) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .string(token),
            .object(surface)
        ])
        connection.queueSend(message: message)
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
