import Foundation

/// Create Desktop-Style Surfaces
/// 
/// The xdg_wm_base interface is exposed as a global object enabling clients
/// to turn their wl_surfaces into windows in a desktop environment. It
/// defines the basic functionality needed for clients and the compositor to
/// create windows that can be dragged, resized, maximized, etc, as well as
/// creating transient windows such as popup menus.
public final class XdgWmBase: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_wm_base"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Xdg_Wm_Base
    /// 
    /// Destroy this xdg_wm_base object.
    /// Destroying a bound xdg_wm_base object while there are surfaces
    /// still alive created by this xdg_wm_base object instance is illegal
    /// and will result in a defunct_surfaces error.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A Positioner Object
    /// 
    /// Create a positioner object. A positioner object is used to position
    /// surfaces relative to some parent surface. See the interface description
    /// and xdg_surface.get_popup for details.
    public func createPositioner() throws(WaylandProxyError) -> XdgPositioner {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgPositioner.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Create A Shell Surface From A Surface
    /// 
    /// This creates an xdg_surface for the given surface. While xdg_surface
    /// itself is not a role, the corresponding surface may only be assigned
    /// a role extending xdg_surface, such as xdg_toplevel or xdg_popup. It is
    /// illegal to create an xdg_surface for a wl_surface which already has an
    /// assigned role and this will result in a role error.
    /// This creates an xdg_surface for the given surface. An xdg_surface is
    /// used as basis to define a role to a given surface, such as xdg_toplevel
    /// or xdg_popup. It also manages functionality shared between xdg_surface
    /// based surface roles.
    /// See the documentation of xdg_surface for more details about what an
    /// xdg_surface is and how it is used.
    public func getXdgSurface(surface: WlSurface) throws(WaylandProxyError) -> XdgSurface {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgSurface.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Respond To A Ping Event
    /// 
    /// A client must respond to a ping event with a pong request or
    /// the client may be deemed unresponsive. See xdg_wm_base.ping
    /// and xdg_wm_base.error.unresponsive.
    /// 
    /// - Parameters:
    ///   - Serial: serial of the ping event
    public func pong(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Given Wl_Surface Has Another Role
        case role = 0
        
        /// Xdg_Wm_Base Was Destroyed Before Children
        case defunctSurfaces = 1
        
        /// The Client Tried To Map Or Destroy A Non-Topmost Popup
        case notTheTopmostPopup = 2
        
        /// The Client Specified An Invalid Popup Parent Surface
        case invalidPopupParent = 3
        
        /// The Client Provided An Invalid Surface State
        case invalidSurfaceState = 4
        
        /// The Client Provided An Invalid Positioner
        case invalidPositioner = 5
        
        /// The Client Didn’t Respond To A Ping Event In Time
        case unresponsive = 6
    }
    
    public enum Event: WlEventEnum {
        /// Check If The Client Is Alive
        /// 
        /// The ping event asks the client if it's still alive. Pass the
        /// serial specified in the event back to the compositor by sending
        /// a "pong" request back with the specified serial. See xdg_wm_base.pong.
        /// Compositors can use this to determine if the client is still
        /// alive. It's unspecified what will happen if the client doesn't
        /// respond to the ping request, or in what timeframe. Clients should
        /// try to respond in a reasonable amount of time. The “unresponsive”
        /// error is provided for compositors that wish to disconnect unresponsive
        /// clients.
        /// A compositor is free to ping in any way it wants, but a client must
        /// always respond to any xdg_wm_base object it created.
        /// 
        /// - Parameters:
        ///   - Serial: pass this to the pong request
        case ping(serial: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.ping(serial: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
