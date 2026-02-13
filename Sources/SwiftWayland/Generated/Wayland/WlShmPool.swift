import Foundation

public final class WlShmPool: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_shm_pool"
    public var onEvent: (Event) -> Void = { _ in }

    public func createBuffer(offset: Int32, width: Int32, height: Int32, stride: Int32, format: UInt32) throws(WaylandProxyError) -> WlBuffer {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlBuffer.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id),
            WaylandData.int(offset),
            WaylandData.int(width),
            WaylandData.int(height),
            WaylandData.int(stride),
            WaylandData.uint(format)
        ])
        connection.send(message: message)
        return id
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func resize(size: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.int(size)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
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
