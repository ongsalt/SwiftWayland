import Foundation
import SwiftWayland

public final class ZwpIdleInhibitManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_idle_inhibit_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func createInhibitor(surface: WlSurface) -> ZwpIdleInhibitorV1 {
        let id = connection.createProxy(type: ZwpIdleInhibitorV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
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
