import Foundation
import SwiftWayland

/// Create Desktop-Style Surfaces
/// 
/// xdg_shell allows clients to turn a wl_surface into a "real window"
/// which can be dragged, resized, stacked, and moved around by the
/// user. Everything about this interface is suited towards traditional
/// desktop environments.
public final class XdgShell: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_shell"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Xdg_Shell
    /// 
    /// Destroy this xdg_shell object.
    /// Destroying a bound xdg_shell object while there are surfaces
    /// still alive created by this xdg_shell object instance is illegal
    /// and will result in a protocol error.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Enable Use Of This Unstable Version
    /// 
    /// Negotiate the unstable version of the interface.  This
    /// mechanism is in place to ensure client and server agree on the
    /// unstable versions of the protocol that they speak or exit
    /// cleanly if they don't agree.  This request will go away once
    /// the xdg-shell protocol is stable.
    public func useUnstableVersion(version: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.int(version)
        ])
        connection.send(message: message)
    }
    
    /// Create A Shell Surface From A Surface
    /// 
    /// This creates an xdg_surface for the given surface and gives it the
    /// xdg_surface role. A wl_surface can only be given an xdg_surface role
    /// once. If get_xdg_surface is called with a wl_surface that already has
    /// an active xdg_surface associated with it, or if it had any other role,
    /// an error is raised.
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
    
    /// Create A Popup For A Surface
    /// 
    /// This creates an xdg_popup for the given surface and gives it the
    /// xdg_popup role. A wl_surface can only be given an xdg_popup role
    /// once. If get_xdg_popup is called with a wl_surface that already has
    /// an active xdg_popup associated with it, or if it had any other role,
    /// an error is raised.
    /// This request must be used in response to some sort of user action
    /// like a button press, key press, or touch down event.
    /// See the documentation of xdg_popup for more details about what an
    /// xdg_popup is and how it is used.
    /// 
    /// - Parameters:
    ///   - Seat: the wl_seat of the user event
    ///   - Serial: the serial of the user event
    public func getXdgPopup(surface: WlSurface, parent: WlSurface, seat: WlSeat, serial: UInt32, x: Int32, y: Int32) throws(WaylandProxyError) -> XdgPopup {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgPopup.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface),
            WaylandData.object(parent),
            WaylandData.object(seat),
            WaylandData.uint(serial),
            WaylandData.int(x),
            WaylandData.int(y)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Respond To A Ping Event
    /// 
    /// A client must respond to a ping event with a pong request or
    /// the client may be deemed unresponsive.
    /// 
    /// - Parameters:
    ///   - Serial: serial of the ping event
    public func pong(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Latest Protocol Version
    /// 
    /// The 'current' member of this enum gives the version of the
    /// protocol.  Implementations can compare this to the version
    /// they implement using static_assert to ensure the protocol and
    /// implementation versions match.
    public enum Version: UInt32, WlEnum {
        /// Always The Latest Version
        case current = 5
    }
    
    public enum Error: UInt32, WlEnum {
        /// Given Wl_Surface Has Another Role
        case role = 0
        
        /// Xdg_Shell Was Destroyed Before Children
        case defunctSurfaces = 1
        
        /// The Client Tried To Map Or Destroy A Non-Topmost Popup
        case notTheTopmostPopup = 2
        
        /// The Client Specified An Invalid Popup Parent Surface
        case invalidPopupParent = 3
    }
    
    public enum Event: WlEventEnum {
        /// Check If The Client Is Alive
        /// 
        /// The ping event asks the client if it's still alive. Pass the
        /// serial specified in the event back to the compositor by sending
        /// a "pong" request back with the specified serial.
        /// Compositors can use this to determine if the client is still
        /// alive. It's unspecified what will happen if the client doesn't
        /// respond to the ping request, or in what timeframe. Clients should
        /// try to respond in a reasonable amount of time.
        /// A compositor is free to ping in any way it wants, but a client must
        /// always respond to any xdg_shell object it created.
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
