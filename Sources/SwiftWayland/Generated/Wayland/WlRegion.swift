import Foundation

public final class WlRegion: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_region"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func add(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func subtract(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
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
