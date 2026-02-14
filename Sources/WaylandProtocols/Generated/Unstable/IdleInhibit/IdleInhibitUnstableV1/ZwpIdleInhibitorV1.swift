import Foundation
import SwiftWayland

/// Context Object For Inhibiting Idle Behavior
/// 
/// An idle inhibitor prevents the output that the associated surface is
/// visible on from being set to a state where it is not visually usable due
/// to lack of user interaction (e.g. blanked, dimmed, locked, set to power
/// save, etc.)  Any screensaver processes are also blocked from displaying.
/// If the surface is destroyed, unmapped, becomes occluded, loses
/// visibility, or otherwise becomes not visually relevant for the user, the
/// idle inhibitor will not be honored by the compositor; if the surface
/// subsequently regains visibility the inhibitor takes effect once again.
/// Likewise, the inhibitor isn't honored if the system was already idled at
/// the time the inhibitor was established, although if the system later
/// de-idles and re-idles the inhibitor will take effect.
public final class ZwpIdleInhibitorV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_idle_inhibitor_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Idle Inhibitor Object
    /// 
    /// Remove the inhibitor effect from the associated wl_surface.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
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
