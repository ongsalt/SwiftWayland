import Foundation
import SwiftWayland

/// Receive Relative Pointer Motion Events
/// 
/// The wp_locked_pointer interface represents a locked pointer state.
/// While the lock of this object is active, the wl_pointer objects of the
/// associated seat will not emit any wl_pointer.motion events.
/// This object will send the event 'locked' when the lock is activated.
/// Whenever the lock is activated, it is guaranteed that the locked surface
/// will already have received pointer focus and that the pointer will be
/// within the region passed to the request creating this object.
/// To unlock the pointer, send the destroy request. This will also destroy
/// the wp_locked_pointer object.
/// If the compositor decides to unlock the pointer the unlocked event is
/// sent. See wp_locked_pointer.unlock for details.
/// When unlocking, the compositor may warp the cursor position to the set
/// cursor position hint. If it does, it will not result in any relative
/// motion events emitted via wp_relative_pointer.
/// If the surface the lock was requested on is destroyed and the lock is not
/// yet activated, the wp_locked_pointer object is now defunct and must be
/// destroyed.
public final class ZwpLockedPointerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_locked_pointer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Locked Pointer Object
    /// 
    /// Destroy the locked pointer object. If applicable, the compositor will
    /// unlock the pointer.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set The Pointer Cursor Position Hint
    /// 
    /// Set the cursor position hint relative to the top left corner of the
    /// surface.
    /// If the client is drawing its own cursor, it should update the position
    /// hint to the position of its own cursor. A compositor may use this
    /// information to warp the pointer upon unlock in order to avoid pointer
    /// jumps.
    /// The cursor position hint is double-buffered state, see
    /// wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - SurfaceX: surface-local x coordinate
    ///   - SurfaceY: surface-local y coordinate
    public func setCursorPositionHint(surfaceX: Double, surfaceY: Double) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.fixed(surfaceX),
            WaylandData.fixed(surfaceY)
        ])
        connection.send(message: message)
    }
    
    /// Set A New Lock Region
    /// 
    /// Set a new region used to lock the pointer.
    /// The new lock region is double-buffered, see wl_surface.commit.
    /// For details about the lock region, see wp_locked_pointer.
    /// 
    /// - Parameters:
    ///   - Region: region of surface
    public func setRegion(region: WlRegion) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.object(region)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Lock Activation Event
        /// 
        /// Notification that the pointer lock of the seat's pointer is activated.
        case locked
        
        /// Lock Deactivation Event
        /// 
        /// Notification that the pointer lock of the seat's pointer is no longer
        /// active. If this is a oneshot pointer lock (see
        /// wp_pointer_constraints.lifetime) this object is now defunct and should
        /// be destroyed. If this is a persistent pointer lock (see
        /// wp_pointer_constraints.lifetime) this pointer lock may again
        /// reactivate in the future.
        case unlocked
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.locked
            case 1:
                return Self.unlocked
            default:
                fatalError("Unknown message")
            }
        }
    }
}
