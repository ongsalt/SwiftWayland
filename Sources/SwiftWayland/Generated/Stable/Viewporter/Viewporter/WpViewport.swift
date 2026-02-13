import Foundation

public final class WpViewport: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_viewport"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func setSource(x: Double, y: Double, width: Double, height: Double) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .fixed(x),
            .fixed(y),
            .fixed(width),
            .fixed(height)
        ])
        connection.send(message: message)
    }
    
    public func setDestination(width: Int32, height: Int32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case badValue = 0
        case badSize = 1
        case outOfBuffer = 2
        case noSurface = 3
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
