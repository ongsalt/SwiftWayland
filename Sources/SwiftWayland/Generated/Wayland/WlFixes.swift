import Foundation

public final class WlFixes: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_fixes"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func destroyRegistry(registry: WlRegistry) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(registry)
        ])
        connection.send(message: message)
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
