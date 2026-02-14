import Foundation
import SwiftWayland

/// Create Dialogs Related To Other Toplevels
/// 
/// The xdg_wm_dialog_v1 interface is exposed as a global object allowing
/// to register surfaces with a xdg_toplevel role as "dialogs" relative to
/// another toplevel.
/// The compositor may let this relation influence how the surface is
/// placed, displayed or interacted with.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgWmDialogV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_wm_dialog_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Dialog Manager Object
    /// 
    /// Destroys the xdg_wm_dialog_v1 object. This does not affect
    /// the xdg_dialog_v1 objects generated through it.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A Dialog Object
    /// 
    /// Creates a xdg_dialog_v1 object for the given toplevel. See the interface
    /// description for more details.
    /// Compositors must raise an already_used error if clients attempt to
    /// create multiple xdg_dialog_v1 objects for the same xdg_toplevel.
    public func getXdgDialog(toplevel: XdgToplevel) throws(WaylandProxyError) -> XdgDialogV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgDialogV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(toplevel)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Xdg_Toplevel Object Has Already Been Used To Create A Xdg_Dialog_V1
        case alreadyUsed = 0
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
