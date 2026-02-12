import Foundation

public final class WlSubsurface: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setPosition(x: Int32, y: Int32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .int(x),
            .int(y)
        ])
        connection.queueSend(message: message)
    }
    
    public func placeAbove(sibling: WlSurface) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(sibling)
        ])
        connection.queueSend(message: message)
    }
    
    public func placeBelow(sibling: WlSurface) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .object(sibling)
        ])
        connection.queueSend(message: message)
    }
    
    public func setSync() {
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setDesync() {
        let message = Message(objectId: self.id, opcode: 5, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case badSurface = 0
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
