import Foundation
import SwiftWayland

/// Dialog Object
/// 
/// A xdg_dialog_v1 object is an ancillary object tied to a xdg_toplevel. Its
/// purpose is hinting the compositor that the toplevel is a "dialog" (e.g. a
/// temporary window) relative to another toplevel (see
/// xdg_toplevel.set_parent). If the xdg_toplevel is destroyed, the xdg_dialog_v1
/// becomes inert.
/// Through this object, the client may provide additional hints about
/// the purpose of the secondary toplevel. This interface has no effect
/// on toplevels that are not attached to a parent toplevel.
public final class XdgDialogV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_dialog_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Dialog Object
    /// 
    /// Destroys the xdg_dialog_v1 object. If this object is destroyed
    /// before the related xdg_toplevel, the compositor should unapply its
    /// effects.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Mark Dialog As Modal
    /// 
    /// Hints that the dialog has "modal" behavior. Modal dialogs typically
    /// require to be fully addressed by the user (i.e. closed) before resuming
    /// interaction with the parent toplevel, and may require a distinct
    /// presentation.
    /// Clients must implement the logic to filter events in the parent
    /// toplevel on their own.
    /// Compositors may choose any policy in event delivery to the parent
    /// toplevel, from delivering all events unfiltered to using them for
    /// internal consumption.
    public func setModal() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    /// Mark Dialog As Not Modal
    /// 
    /// Drops the hint that this dialog has "modal" behavior. See
    /// xdg_dialog_v1.set_modal for more details.
    public func unsetModal() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
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
