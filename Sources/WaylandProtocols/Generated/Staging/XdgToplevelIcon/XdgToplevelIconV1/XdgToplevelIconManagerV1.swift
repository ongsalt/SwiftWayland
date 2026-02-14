import Foundation
import SwiftWayland

/// Interface To Manage Toplevel Icons
/// 
/// This interface allows clients to create toplevel window icons and set
/// them on toplevel windows to be displayed to the user.
public final class XdgToplevelIconManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel_icon_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Toplevel Icon Manager
    /// 
    /// Destroy the toplevel icon manager.
    /// This does not destroy objects created with the manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A New Icon Instance
    /// 
    /// Creates a new icon object. This icon can then be attached to a
    /// xdg_toplevel via the 'set_icon' request.
    public func createIcon() throws(WaylandProxyError) -> XdgToplevelIconV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgToplevelIconV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Set An Icon On A Toplevel Window
    /// 
    /// This request assigns the icon 'icon' to 'toplevel', or clears the
    /// toplevel icon if 'icon' was null.
    /// This state is double-buffered and is applied on the next
    /// wl_surface.commit of the toplevel.
    /// After making this call, the xdg_toplevel_icon_v1 provided as 'icon'
    /// can be destroyed by the client without 'toplevel' losing its icon.
    /// The xdg_toplevel_icon_v1 is immutable from this point, and any
    /// future attempts to change it must raise the
    /// 'xdg_toplevel_icon_v1.immutable' protocol error.
    /// The compositor must set the toplevel icon from either the pixel data
    /// the icon provides, or by loading a stock icon using the icon name.
    /// See the description of 'xdg_toplevel_icon_v1' for details.
    /// If 'icon' is set to null, the icon of the respective toplevel is reset
    /// to its default icon (usually the icon of the application, derived from
    /// its desktop-entry file, or a placeholder icon).
    /// If this request is passed an icon with no pixel buffers or icon name
    /// assigned, the icon must be reset just like if 'icon' was null.
    /// 
    /// - Parameters:
    ///   - Toplevel: the toplevel to act on
    public func setIcon(toplevel: XdgToplevel, icon: XdgToplevelIconV1) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.object(toplevel),
            WaylandData.object(icon)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Describes A Supported & Preferred Icon Size
        /// 
        /// This event indicates an icon size the compositor prefers to be
        /// available if the client has scalable icons and can render to any size.
        /// When the 'xdg_toplevel_icon_manager_v1' object is created, the
        /// compositor may send one or more 'icon_size' events to describe the list
        /// of preferred icon sizes. If the compositor has no size preference, it
        /// may not send any 'icon_size' event, and it is up to the client to
        /// decide a suitable icon size.
        /// A sequence of 'icon_size' events must be finished with a 'done' event.
        /// If the compositor has no size preferences, it must still send the
        /// 'done' event, without any preceding 'icon_size' events.
        /// 
        /// - Parameters:
        ///   - Size: the edge size of the square icon in surface-local coordinates, e.g. 64
        case iconSize(size: Int32)
        
        /// All Information Has Been Sent
        /// 
        /// This event is sent after all 'icon_size' events have been sent.
        case done
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.iconSize(size: r.readInt())
            case 1:
                return Self.done
            default:
                fatalError("Unknown message")
            }
        }
    }
}
