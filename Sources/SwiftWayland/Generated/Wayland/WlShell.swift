import Foundation

public final class WlShell: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func getShellSurface(surface: WlSurface) -> WlShellSurface {
        let id = connection.createProxy(type: WlShellSurface.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
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
