import Foundation
import SwiftWayland

/// Move A Window During A Drag
/// 
/// This protocol enhances normal drag and drop with the ability to move a
/// window at the same time. This allows having detachable parts of a window
/// that when dragged out of it become a new window and can be dragged over
/// an existing window to be reattached.
/// A typical workflow would be when the user starts dragging on top of a
/// detachable part of a window, the client would create a wl_data_source and
/// a xdg_toplevel_drag_v1 object and start the drag as normal via
/// wl_data_device.start_drag. Once the client determines that the detachable
/// window contents should be detached from the originating window, it creates
/// a new xdg_toplevel with these contents and issues a
/// xdg_toplevel_drag_v1.attach request before mapping it. From now on the new
/// window is moved by the compositor during the drag as if the client called
/// xdg_toplevel.move.
/// Dragging an existing window is similar. The client creates a
/// xdg_toplevel_drag_v1 object and attaches the existing toplevel before
/// starting the drag.
/// Clients use the existing drag and drop mechanism to detect when a window
/// can be docked or undocked. If the client wants to snap a window into a
/// parent window it should delete or unmap the dragged top-level. If the
/// contents should be detached again it attaches a new toplevel as described
/// above. If a drag operation is cancelled without being dropped, clients
/// should revert to the previous state, deleting any newly created windows
/// as appropriate. When a drag operation ends as indicated by
/// wl_data_source.dnd_drop_performed the dragged toplevel window's final
/// position is determined as if a xdg_toplevel_move operation ended.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgToplevelDragManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel_drag_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Toplevel_Drag_Manager_V1 Object
    /// 
    /// Destroy this xdg_toplevel_drag_manager_v1 object. Other objects,
    /// including xdg_toplevel_drag_v1 objects created by this factory, are not
    /// affected by this request.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Get An Xdg_Toplevel_Drag For A Wl_Data_Source
    /// 
    /// Create an xdg_toplevel_drag for a drag and drop operation that is going
    /// to be started with data_source.
    /// This request can only be made on sources used in drag-and-drop, so it
    /// must be performed before wl_data_device.start_drag. Attempting to use
    /// the source other than for drag-and-drop such as in
    /// wl_data_device.set_selection will raise an invalid_source error.
    /// Destroying data_source while a toplevel is attached to the
    /// xdg_toplevel_drag is undefined.
    public func getXdgToplevelDrag(dataSource: WlDataSource) throws(WaylandProxyError) -> XdgToplevelDragV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgToplevelDragV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(dataSource)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Data_Source Already Used For Toplevel Drag
        case invalidSource = 0
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
