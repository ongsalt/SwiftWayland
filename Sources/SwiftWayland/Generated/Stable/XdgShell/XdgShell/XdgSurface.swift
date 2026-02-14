import Foundation

/// Desktop User Interface Surface Base Interface
/// 
/// An interface that may be implemented by a wl_surface, for
/// implementations that provide a desktop-style user interface.
/// It provides a base set of functionality required to construct user
/// interface elements requiring management by the compositor, such as
/// toplevel windows, menus, etc. The types of functionality are split into
/// xdg_surface roles.
/// Creating an xdg_surface does not set the role for a wl_surface. In order
/// to map an xdg_surface, the client must create a role-specific object
/// using, e.g., get_toplevel, get_popup. The wl_surface for any given
/// xdg_surface can have at most one role, and may not be assigned any role
/// not based on xdg_surface.
/// A role must be assigned before any other requests are made to the
/// xdg_surface object.
/// The client must call wl_surface.commit on the corresponding wl_surface
/// for the xdg_surface state to take effect.
/// Creating an xdg_surface from a wl_surface which has a buffer attached or
/// committed is a client error, and any attempts by a client to attach or
/// manipulate a buffer prior to the first xdg_surface.configure call must
/// also be treated as errors.
/// After creating a role-specific object and setting it up (e.g. by sending
/// the title, app ID, size constraints, parent, etc), the client must
/// perform an initial commit without any buffer attached. The compositor
/// will reply with initial wl_surface state such as
/// wl_surface.preferred_buffer_scale followed by an xdg_surface.configure
/// event. The client must acknowledge it and is then allowed to attach a
/// buffer to map the surface.
/// Mapping an xdg_surface-based role surface is defined as making it
/// possible for the surface to be shown by the compositor. Note that
/// a mapped surface is not guaranteed to be visible once it is mapped.
/// For an xdg_surface to be mapped by the compositor, the following
/// conditions must be met:
/// (1) the client has assigned an xdg_surface-based role to the surface
/// (2) the client has set and committed the xdg_surface state and the
/// role-dependent state to the surface
/// (3) the client has committed a buffer to the surface
/// A newly-unmapped surface is considered to have met condition (1) out
/// of the 3 required conditions for mapping a surface if its role surface
/// has not been destroyed, i.e. the client must perform the initial commit
/// again before attaching a buffer.
public final class XdgSurface: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_surface"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Surface
    /// 
    /// Destroy the xdg_surface object. An xdg_surface must only be destroyed
    /// after its role object has been destroyed, otherwise
    /// a defunct_role_object error is raised.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Assign The Xdg_Toplevel Surface Role
    /// 
    /// This creates an xdg_toplevel object for the given xdg_surface and gives
    /// the associated wl_surface the xdg_toplevel role.
    /// See the documentation of xdg_toplevel for more details about what an
    /// xdg_toplevel is and how it is used.
    public func getToplevel() throws(WaylandProxyError) -> XdgToplevel {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgToplevel.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Assign The Xdg_Popup Surface Role
    /// 
    /// This creates an xdg_popup object for the given xdg_surface and gives
    /// the associated wl_surface the xdg_popup role.
    /// If null is passed as a parent, a parent surface must be specified using
    /// some other protocol, before committing the initial state.
    /// See the documentation of xdg_popup for more details about what an
    /// xdg_popup is and how it is used.
    public func getPopup(parent: XdgSurface, positioner: XdgPositioner) throws(WaylandProxyError) -> XdgPopup {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgPopup.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(parent),
            WaylandData.object(positioner)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Set The New Window Geometry
    /// 
    /// The window geometry of a surface is its "visible bounds" from the
    /// user's perspective. Client-side decorations often have invisible
    /// portions like drop-shadows which should be ignored for the
    /// purposes of aligning, placing and constraining windows. Note that
    /// in some situations, compositors may clip rendering to the window
    /// geometry, so the client should avoid putting functional elements
    /// outside of it.
    /// The window geometry is double-buffered state, see wl_surface.commit.
    /// When maintaining a position, the compositor should treat the (x, y)
    /// coordinate of the window geometry as the top left corner of the window.
    /// A client changing the (x, y) window geometry coordinate should in
    /// general not alter the position of the window.
    /// Once the window geometry of the surface is set, it is not possible to
    /// unset it, and it will remain the same until set_window_geometry is
    /// called again, even if a new subsurface or buffer is attached.
    /// If never set, the value is the full bounds of the surface,
    /// including any subsurfaces. This updates dynamically on every
    /// commit. This unset is meant for extremely simple clients.
    /// The arguments are given in the surface-local coordinate space of
    /// the wl_surface associated with this xdg_surface, and may extend outside
    /// of the wl_surface itself to mark parts of the subsurface tree as part of
    /// the window geometry.
    /// When applied, the effective window geometry will be the set window
    /// geometry clamped to the bounding rectangle of the combined
    /// geometry of the surface of the xdg_surface and the associated
    /// subsurfaces.
    /// The effective geometry will not be recalculated unless a new call to
    /// set_window_geometry is done and the new pending surface state is
    /// subsequently applied.
    /// The width and height of the effective window geometry must be
    /// greater than zero. Setting an invalid size will raise an
    /// invalid_size error.
    public func setWindowGeometry(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    /// Ack A Configure Event
    /// 
    /// When a configure event is received, if a client commits the
    /// surface in response to the configure event, then the client
    /// must make an ack_configure request sometime before the commit
    /// request, passing along the serial of the configure event.
    /// For instance, for toplevel surfaces the compositor might use this
    /// information to move a surface to the top left only when the client has
    /// drawn itself for the maximized or fullscreen state.
    /// If the client receives multiple configure events before it
    /// can respond to one, it only has to ack the last configure event.
    /// Acking a configure event that was never sent raises an invalid_serial
    /// error.
    /// A client is not required to commit immediately after sending
    /// an ack_configure request - it may even ack_configure several times
    /// before its next surface commit.
    /// A client may send multiple ack_configure requests before committing, but
    /// only the last request sent before a commit indicates which configure
    /// event the client really is responding to.
    /// Sending an ack_configure request consumes the serial number sent with
    /// the request, as well as serial numbers sent by all configure events
    /// sent on this xdg_surface prior to the configure event referenced by
    /// the committed serial.
    /// It is an error to issue multiple ack_configure requests referencing a
    /// serial from the same configure event, or to issue an ack_configure
    /// request referencing a serial from a configure event issued before the
    /// event identified by the last ack_configure request for the same
    /// xdg_surface. Doing so will raise an invalid_serial error.
    /// 
    /// - Parameters:
    ///   - Serial: the serial from the configure event
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Surface Was Not Fully Constructed
        case notConstructed = 1
        
        /// Surface Was Already Constructed
        case alreadyConstructed = 2
        
        /// Attaching A Buffer To An Unconfigured Surface
        case unconfiguredBuffer = 3
        
        /// Invalid Serial Number When Acking A Configure Event
        case invalidSerial = 4
        
        /// Width Or Height Was Zero Or Negative
        case invalidSize = 5
        
        /// Surface Was Destroyed Before Its Role Object
        case defunctRoleObject = 6
    }
    
    public enum Event: WlEventEnum {
        /// Suggest A Surface Change
        /// 
        /// The configure event marks the end of a configure sequence. A configure
        /// sequence is a set of one or more events configuring the state of the
        /// xdg_surface, including the final xdg_surface.configure event.
        /// Where applicable, xdg_surface surface roles will during a configure
        /// sequence extend this event as a latched state sent as events before the
        /// xdg_surface.configure event. Such events should be considered to make up
        /// a set of atomically applied configuration states, where the
        /// xdg_surface.configure commits the accumulated state.
        /// Clients should arrange their surface for the new states, and then send
        /// an ack_configure request with the serial sent in this configure event at
        /// some point before committing the new surface.
        /// If the client receives multiple configure events before it can respond
        /// to one, it is free to discard all but the last event it received.
        /// 
        /// - Parameters:
        ///   - Serial: serial of the configure event
        case configure(serial: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(serial: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
