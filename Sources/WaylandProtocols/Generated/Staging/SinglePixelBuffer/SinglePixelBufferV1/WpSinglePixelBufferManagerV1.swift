import Foundation
import SwiftWayland

/// Global Factory For Single-Pixel Buffers
/// 
/// The wp_single_pixel_buffer_manager_v1 interface is a factory for
/// single-pixel buffers.
public final class WpSinglePixelBufferManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_single_pixel_buffer_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Manager
    /// 
    /// Destroy the wp_single_pixel_buffer_manager_v1 object.
    /// The child objects created via this interface are unaffected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A 1×1 Buffer From 32-Bit Rgba Values
    /// 
    /// Create a single-pixel buffer from four 32-bit RGBA values.
    /// Unless specified in another protocol extension, the RGBA values use
    /// pre-multiplied alpha.
    /// The width and height of the buffer are 1.
    /// The r, g, b and a arguments valid range is from UINT32_MIN (0)
    /// to UINT32_MAX (0xffffffff).
    /// 
    /// These arguments should be interpreted as a percentage, i.e.
    /// - UINT32_MIN = 0% of the given color component
    /// - UINT32_MAX = 100% of the given color component
    /// 
    /// - Parameters:
    ///   - R: value of the buffer's red channel
    ///   - G: value of the buffer's green channel
    ///   - B: value of the buffer's blue channel
    ///   - A: value of the buffer's alpha channel
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
