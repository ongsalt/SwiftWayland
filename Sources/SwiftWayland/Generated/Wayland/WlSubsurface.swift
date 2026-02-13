import Foundation

public final class WlSubsurface: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_subsurface"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func setPosition(x: Int32, y: Int32) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .int(x),
            .int(y)
        ])
        connection.send(message: message)
    }
    
    public func placeAbove(sibling: WlSurface) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(sibling)
        ])
        connection.send(message: message)
    }
    
    public func placeBelow(sibling: WlSurface) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .object(sibling)
        ])
        connection.send(message: message)
    }
    
    public func setSync() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.send(message: message)
    }
    
    public func setDesync() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 5, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case badSurface = 0
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
