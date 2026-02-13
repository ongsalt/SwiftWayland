import Foundation

public final class WlCompositor: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_compositor"
    public var onEvent: (Event) -> Void = { _ in }

    public func createSurface() -> WlSurface {
        let id = connection.createProxy(type: WlSurface.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func createRegion() -> WlRegion {
        let id = connection.createProxy(type: WlRegion.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
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
