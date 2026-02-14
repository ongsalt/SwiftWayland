import Foundation
import SwiftWayland

/// Protocol For Fifo Constraints
/// 
/// When a Wayland compositor considers applying a content update,
/// it must ensure all the update's readiness constraints (fences, etc)
/// are met.
/// This protocol provides a way to use the completion of a display refresh
/// cycle as an additional readiness constraint.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpFifoManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_fifo_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Unbind From The Manager Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object. Existing objects created by this object
    /// are not affected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Request Fifo Interface For Surface
    /// 
    /// Establish a fifo object for a surface that may be used to add
    /// display refresh constraints to content updates.
    /// Only one such object may exist for a surface and attempting
    /// to create more than one will result in an already_exists
    /// protocol error. If a surface is acted on by multiple software
    /// components, general best practice is that only the component
    /// performing wl_surface.attach operations should use this protocol.
    public func getFifo(surface: WlSurface) throws(WaylandProxyError) -> WpFifoV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpFifoV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Fatal Presentation Error
    /// 
    /// These fatal protocol errors may be emitted in response to
    /// illegal requests.
    public enum Error: UInt32, WlEnum {
        /// Fifo Manager Already Exists For Surface
        case alreadyExists = 0
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
