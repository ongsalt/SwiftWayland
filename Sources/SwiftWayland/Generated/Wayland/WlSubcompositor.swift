import Foundation

public final class WlSubcompositor: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_subcompositor"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func getSubsurface(surface: WlSurface, parent: WlSurface) throws(WaylandProxyError)  -> WlSubsurface {
        let id = connection.createProxy(type: WlSubsurface.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface),
            .object(parent)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case badSurface = 0
        case badParent = 1
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
