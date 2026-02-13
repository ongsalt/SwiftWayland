import Foundation

public final class WpViewport: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_viewport"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setSource(x: Double, y: Double, width: Double, height: Double) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.fixed(x),
            WaylandData.fixed(y),
            WaylandData.fixed(width),
            WaylandData.fixed(height)
        ])
        connection.send(message: message)
    }
    
    public func setDestination(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case badValue = 0
        case badSize = 1
        case outOfBuffer = 2
        case noSurface = 3
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
