import Foundation
import SwiftWayland

/// Fifo Interface
/// 
/// A fifo object for a surface that may be used to add
/// display refresh constraints to content updates.
public final class WpFifoV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_fifo_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Sets The Start Point For A Fifo Constraint
    /// 
    /// When the content update containing the "set_barrier" is applied,
    /// it sets a "fifo_barrier" condition on the surface associated with
    /// the fifo object. The condition is cleared immediately after the
    /// following latching deadline for non-tearing presentation.
    /// The compositor may clear the condition early if it must do so to
    /// ensure client forward progress assumptions.
    /// To wait for this condition to clear, use the "wait_barrier" request.
    /// "set_barrier" is double-buffered state, see wl_surface.commit.
    /// Requesting set_barrier after the fifo object's surface is
    /// destroyed will generate a "surface_destroyed" error.
    public func setBarrier() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    /// Adds A Fifo Constraint To A Content Update
    /// 
    /// Indicate that this content update is not ready while a
    /// "fifo_barrier" condition is present on the surface.
    /// This means that when the content update containing "set_barrier"
    /// was made active at a latching deadline, it will be active for
    /// at least one refresh cycle. A content update which is allowed to
    /// tear might become active after a latching deadline if no content
    /// update became active at the deadline.
    /// The constraint must be ignored if the surface is a subsurface in
    /// synchronized mode. If the surface is not being updated by the
    /// compositor (off-screen, occluded) the compositor may ignore the
    /// constraint. Clients must use an additional mechanism such as
    /// frame callbacks or timestamps to ensure throttling occurs under
    /// all conditions.
    /// "wait_barrier" is double-buffered state, see wl_surface.commit.
    /// Requesting "wait_barrier" after the fifo object's surface is
    /// destroyed will generate a "surface_destroyed" error.
    public func waitBarrier() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    /// Destroy The Fifo Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object.
    /// Surface state changes previously made by this protocol are
    /// unaffected by this object's destruction.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Fatal Error
    /// 
    /// These fatal protocol errors may be emitted in response to
    /// illegal requests.
    public enum Error: UInt32, WlEnum {
        /// The Associated Surface No Longer Exists
        case surfaceDestroyed = 0
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
