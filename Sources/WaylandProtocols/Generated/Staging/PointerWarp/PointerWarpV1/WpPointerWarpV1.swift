import Foundation
import SwiftWayland

/// Reposition The Pointer To A Location On A Surface
/// 
/// This global interface allows applications to request the pointer to be
/// moved to a position relative to a wl_surface.
/// Note that if the desired behavior is to constrain the pointer to an area
/// or lock it to a position, this protocol does not provide a reliable way
/// to do that. The pointer constraint and pointer lock protocols should be
/// used for those use cases instead.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpPointerWarpV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_pointer_warp_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Warp Manager
    /// 
    /// Destroy the pointer warp manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Reposition The Pointer
    /// 
    /// Request the compositor to move the pointer to a surface-local position.
    /// Whether or not the compositor honors the request is implementation defined,
    /// but it should
    /// - honor it if the surface has pointer focus, including
    /// when it has an implicit pointer grab
    /// - reject it if the enter serial is incorrect
    /// - reject it if the requested position is outside of the surface
    /// Note that the enter serial is valid for any surface of the client,
    /// and does not have to be from the surface the pointer is warped to.
    /// 
    /// - Parameters:
    ///   - Surface: surface to position the pointer on
    ///   - Pointer: the pointer that should be repositioned
    ///   - Serial: serial number of the enter event
    public func warpPointer(surface: WlSurface, pointer: WlPointer, x: Double, y: Double, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(surface),
            WaylandData.object(pointer),
            WaylandData.fixed(x),
            WaylandData.fixed(y),
            WaylandData.uint(serial)
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
