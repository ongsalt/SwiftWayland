import Foundation
import SwiftWayland

/// Confined Pointer Object
/// 
/// The wp_confined_pointer interface represents a confined pointer state.
/// This object will send the event 'confined' when the confinement is
/// activated. Whenever the confinement is activated, it is guaranteed that
/// the surface the pointer is confined to will already have received pointer
/// focus and that the pointer will be within the region passed to the request
/// creating this object. It is up to the compositor to decide whether this
/// requires some user interaction and if the pointer will warp to within the
/// passed region if outside.
/// To unconfine the pointer, send the destroy request. This will also destroy
/// the wp_confined_pointer object.
/// If the compositor decides to unconfine the pointer the unconfined event is
/// sent. The wp_confined_pointer object is at this point defunct and should
/// be destroyed.
public final class ZwpConfinedPointerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_confined_pointer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Confined Pointer Object
    /// 
    /// Destroy the confined pointer object. If applicable, the compositor will
    /// unconfine the pointer.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set A New Confine Region
    /// 
    /// Set a new region used to confine the pointer.
    /// The new confine region is double-buffered, see wl_surface.commit.
    /// If the confinement is active when the new confinement region is applied
    /// and the pointer ends up outside of newly applied region, the pointer may
    /// warped to a position within the new confinement region. If warped, a
    /// wl_pointer.motion event will be emitted, but no
    /// wp_relative_pointer.relative_motion event.
    /// The compositor may also, instead of using the new region, unconfine the
    /// pointer.
    /// For details about the confine region, see wp_confined_pointer.
    /// 
    /// - Parameters:
    ///   - Region: region of surface
    public func setRegion(region: WlRegion) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(region)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Pointer Confined
        /// 
        /// Notification that the pointer confinement of the seat's pointer is
        /// activated.
        case confined
        
        /// Pointer Unconfined
        /// 
        /// Notification that the pointer confinement of the seat's pointer is no
        /// longer active. If this is a oneshot pointer confinement (see
        /// wp_pointer_constraints.lifetime) this object is now defunct and should
        /// be destroyed. If this is a persistent pointer confinement (see
        /// wp_pointer_constraints.lifetime) this pointer confinement may again
        /// reactivate in the future.
        case unconfined
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.confined
            case 1:
                return Self.unconfined
            default:
                fatalError("Unknown message")
            }
        }
    }
}
