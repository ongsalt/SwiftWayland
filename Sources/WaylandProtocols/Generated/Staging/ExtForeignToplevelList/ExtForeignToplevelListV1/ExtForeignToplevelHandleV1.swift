import Foundation
import SwiftWayland

/// A Mapped Toplevel
/// 
/// A ext_foreign_toplevel_handle_v1 object represents a mapped toplevel
/// window. A single app may have multiple mapped toplevels.
public final class ExtForeignToplevelHandleV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_foreign_toplevel_handle_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Ext_Foreign_Toplevel_Handle_V1 Object
    /// 
    /// This request should be used when the client will no longer use the handle
    /// or after the closed event has been received to allow destruction of the
    /// object.
    /// When a handle is destroyed, a new handle may not be created by the server
    /// until the toplevel is unmapped and then remapped. Destroying a toplevel handle
    /// is not recommended unless the client is cleaning up child objects
    /// before destroying the ext_foreign_toplevel_list_v1 object, the toplevel
    /// was closed or the toplevel handle will not be used in the future.
    /// Other protocols which extend the ext_foreign_toplevel_handle_v1
    /// interface should require destructors for extension interfaces be
    /// called before allowing the toplevel handle to be destroyed.
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
        /// The Toplevel Has Been Closed
        /// 
        /// The server will emit no further events on the ext_foreign_toplevel_handle_v1
        /// after this event. Any requests received aside from the destroy request must
        /// be ignored. Upon receiving this event, the client should destroy the handle.
        /// Other protocols which extend the ext_foreign_toplevel_handle_v1
        /// interface must also ignore requests other than destructors.
        case closed
        
        /// All Information About The Toplevel Has Been Sent
        /// 
        /// This event is sent after all changes in the toplevel state have
        /// been sent.
        /// This allows changes to the ext_foreign_toplevel_handle_v1 properties
        /// to be atomically applied. Other protocols which extend the
        /// ext_foreign_toplevel_handle_v1 interface may use this event to also
        /// atomically apply any pending state.
        /// This event must not be sent after the ext_foreign_toplevel_handle_v1.closed
        /// event.
        case done
        
        /// Title Change
        /// 
        /// The title of the toplevel has changed.
        /// The configured state must not be applied immediately. See
        /// ext_foreign_toplevel_handle_v1.done for details.
        case title(title: String)
        
        /// App_Id Change
        /// 
        /// The app id of the toplevel has changed.
        /// The configured state must not be applied immediately. See
        /// ext_foreign_toplevel_handle_v1.done for details.
        case appId(appId: String)
        
        /// A Stable Identifier For A Toplevel
        /// 
        /// This identifier is used to check if two or more toplevel handles belong
        /// to the same toplevel.
        /// The identifier is useful for command line tools or privileged clients
        /// which may need to reference an exact toplevel across processes or
        /// instances of the ext_foreign_toplevel_list_v1 global.
        /// The compositor must only send this event when the handle is created.
        /// The identifier must be unique per toplevel and it's handles. Two different
        /// toplevels must not have the same identifier. The identifier is only valid
        /// as long as the toplevel is mapped. If the toplevel is unmapped the identifier
        /// must not be reused. An identifier must not be reused by the compositor to
        /// ensure there are no races when sharing identifiers between processes.
        /// An identifier is a string that contains up to 32 printable ASCII bytes.
        /// An identifier must not be an empty string. It is recommended that a
        /// compositor includes an opaque generation value in identifiers. How the
        /// generation value is used when generating the identifier is implementation
        /// dependent.
        case identifier(identifier: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.closed
            case 1:
                return Self.done
            case 2:
                return Self.title(title: r.readString())
            case 3:
                return Self.appId(appId: r.readString())
            case 4:
                return Self.identifier(identifier: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
