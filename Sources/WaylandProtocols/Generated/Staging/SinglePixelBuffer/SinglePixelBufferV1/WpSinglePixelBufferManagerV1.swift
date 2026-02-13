import Foundation
import SwiftWayland

public final class WpSinglePixelBufferManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_single_pixel_buffer_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func createU32RgbaBuffer(r: UInt32, g: UInt32, b: UInt32, a: UInt32) throws(WaylandProxyError) -> WlBuffer {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlBuffer.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.uint(r),
            WaylandData.uint(g),
            WaylandData.uint(b),
            WaylandData.uint(a)
        ])
        connection.send(message: message)
        return id
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
