import Foundation
import SwiftWayland

/// Context Object For Xwayland Shell
/// 
/// xwayland_shell_v1 is a singleton global object that
/// provides the ability to create a xwayland_surface_v1 object
/// for a given wl_surface.
/// This interface is intended to be bound by the Xwayland server.
/// A compositor must not allow clients other than Xwayland to
/// bind to this interface. A compositor should hide this global
/// from other clients' wl_registry.
/// A client the compositor does not consider to be an Xwayland
/// server attempting to bind this interface will result in
/// an implementation-defined error.
/// An Xwayland server that has bound this interface must not
/// set the `WL_SURFACE_ID` atom on a window.
public final class XwaylandShellV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xwayland_shell_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xwayland Shell Object
    /// 
    /// Destroy the xwayland_shell_v1 object.
    /// The child objects created via this interface are unaffected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Assign The Xwayland_Surface Surface Role
    /// 
    /// Create an xwayland_surface_v1 interface for a given wl_surface
    /// object and gives it the xwayland_surface role.
    /// 
    /// It is illegal to create an xwayland_surface_v1 for a wl_surface
    /// which already has an assigned role and this will result in the
    /// `role` protocol error.
    /// See the documentation of xwayland_surface_v1 for more details
    /// about what an xwayland_surface_v1 is and how it is used.
    public func getXwaylandSurface(surface: WlSurface) throws(WaylandProxyError) -> XwaylandSurfaceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XwaylandSurfaceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Given Wl_Surface Has Another Role
        case role = 0
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
