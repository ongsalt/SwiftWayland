import Foundation
import SwiftWayland

public final class WpSinglePixelBufferManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_single_pixel_buffer_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func createU32RgbaBuffer(r: UInt32, g: UInt32, b: UInt32, a: UInt32) throws(WaylandProxyError)  -> WlBuffer {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlBuffer.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .uint(r),
            .uint(g),
            .uint(b),
            .uint(a)
        ])
        connection.send(message: message)
        return id
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
