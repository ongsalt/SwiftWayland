import Foundation
import SwiftWayland

/// Object Representing A Toplevel Move During A Drag
/// 
/// 
public final class XdgToplevelDragV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel_drag_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy An Xdg_Toplevel_Drag_V1 Object
    /// 
    /// Destroy this xdg_toplevel_drag_v1 object. This request must only be
    /// called after the underlying wl_data_source drag has ended, as indicated
    /// by the dnd_drop_performed or cancelled events. In any other case an
    /// ongoing_drag error is raised.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Move A Toplevel With The Drag Operation
    /// 
    /// Request that the window will be moved with the cursor during the drag
    /// operation. The offset is a hint to the compositor how the toplevel
    /// should be positioned relative to the cursor hotspot in surface local
    /// coordinates and relative to the geometry of the toplevel being attached.
    /// See xdg_surface.set_window_geometry. For example it might only
    /// be used when an unmapped window is attached. The attached window
    /// does not participate in the selection of the drag target.
    /// If the toplevel is unmapped while it is attached, it is automatically
    /// detached from the drag. In this case this request has to be called again
    /// if the window should be attached after it is remapped.
    /// This request can be called multiple times but issuing it while a
    /// toplevel with an active role is attached raises a toplevel_attached
    /// error.
    /// 
    /// - Parameters:
    ///   - XOffset: dragged surface x offset
    ///   - YOffset: dragged surface y offset
    public func attach(toplevel: XdgToplevel, xOffset: Int32, yOffset: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(toplevel),
            WaylandData.int(xOffset),
            WaylandData.int(yOffset)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Valid Toplevel Already Attached
        case toplevelAttached = 0
        
        /// Drag Has Not Ended
        case ongoingDrag = 1
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
