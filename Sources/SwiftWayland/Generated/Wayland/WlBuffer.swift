import Foundation

public final class WlBuffer: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_buffer"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case release
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.release
            default:
                fatalError("Unknown message")
            }
        }
    }
}
