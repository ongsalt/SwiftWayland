import Foundation

public final class WlSubcompositor: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getSubsurface(surface: WlSurface, parent: WlSurface) -> WlSubsurface {
        let id = connection.createProxy(type: WlSubsurface.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface),
            .object(parent)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case badSurface = 0
        case badParent = 1
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
