import Foundation
import SwiftWayland

/// List Toplevels
/// 
/// A toplevel is defined as a surface with a role similar to xdg_toplevel.
/// XWayland surfaces may be treated like toplevels in this protocol.
/// After a client binds the ext_foreign_toplevel_list_v1, each mapped
/// toplevel window will be sent using the ext_foreign_toplevel_list_v1.toplevel
/// event.
/// Clients which only care about the current state can perform a roundtrip after
/// binding this global.
/// For each instance of ext_foreign_toplevel_list_v1, the compositor must
/// create a new ext_foreign_toplevel_handle_v1 object for each mapped toplevel.
/// If a compositor implementation sends the ext_foreign_toplevel_list_v1.finished
/// event after the global is bound, the compositor must not send any
/// ext_foreign_toplevel_list_v1.toplevel events.
public final class ExtForeignToplevelListV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_foreign_toplevel_list_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Stop Sending Events
    /// 
    /// This request indicates that the client no longer wishes to receive
    /// events for new toplevels.
    /// The Wayland protocol is asynchronous, meaning the compositor may send
    /// further toplevel events until the stop request is processed.
    /// The client should wait for a ext_foreign_toplevel_list_v1.finished
    /// event before destroying this object.
    public func stop() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    /// Destroy The Ext_Foreign_Toplevel_List_V1 Object
    /// 
    /// This request should be called either when the client will no longer
    /// use the ext_foreign_toplevel_list_v1 or after the finished event
    /// has been received to allow destruction of the object.
    /// If a client wishes to destroy this object it should send a
    /// ext_foreign_toplevel_list_v1.stop request and wait for a ext_foreign_toplevel_list_v1.finished
    /// event, then destroy the handles and then this object.
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
    
    public enum Event: WlEventEnum {
        /// A Toplevel Has Been Created
        /// 
        /// This event is emitted whenever a new toplevel window is created. It is
        /// emitted for all toplevels, regardless of the app that has created them.
        /// All initial properties of the toplevel (identifier, title, app_id) will be sent
        /// immediately after this event using the corresponding events for
        /// ext_foreign_toplevel_handle_v1. The compositor will use the
        /// ext_foreign_toplevel_handle_v1.done event to indicate when all data has
        /// been sent.
        case toplevel(toplevel: ExtForeignToplevelHandleV1)
        
        /// The Compositor Has Finished With The Toplevel Manager
        /// 
        /// This event indicates that the compositor is done sending events
        /// to this object. The client should destroy the object.
        /// See ext_foreign_toplevel_list_v1.destroy for more information.
        /// The compositor must not send any more toplevel events after this event.
        case finished
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.toplevel(toplevel: connection.createProxy(type: ExtForeignToplevelHandleV1.self, version: version, id: r.readNewId()))
            case 1:
                return Self.finished
            default:
                fatalError("Unknown message")
            }
        }
    }
}
