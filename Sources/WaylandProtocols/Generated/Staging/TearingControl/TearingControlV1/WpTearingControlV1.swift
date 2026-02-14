import Foundation
import SwiftWayland

/// Per-Surface Tearing Control Interface
/// 
/// An additional interface to a wl_surface object, which allows the client
/// to hint to the compositor if the content on the surface is suitable for
/// presentation with tearing.
/// The default presentation hint is vsync. See presentation_hint for more
/// details.
/// If the associated wl_surface is destroyed, this object becomes inert and
/// should be destroyed.
public final class WpTearingControlV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_tearing_control_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Set Presentation Hint
    /// 
    /// Set the presentation hint for the associated wl_surface. This state is
    /// double-buffered, see wl_surface.commit.
    /// The compositor is free to dynamically respect or ignore this hint based
    /// on various conditions like hardware capabilities, surface state and
    /// user preferences.
    public func setPresentationHint(hint: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.uint(hint)
        ])
        connection.send(message: message)
    }
    
    /// Destroy Tearing Control Object
    /// 
    /// Destroy this surface tearing object and revert the presentation hint to
    /// vsync. The change will be applied on the next wl_surface.commit.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Presentation Hint Values
    /// 
    /// This enum provides information for if submitted frames from the client
    /// may be presented with tearing.
    public enum PresentationHint: UInt32, WlEnum {
        case vsync = 0
        
        case `async` = 1
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
