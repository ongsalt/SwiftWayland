import Foundation
import SwiftWayland

/// Surface Alpha Modifier Manager
/// 
/// This interface allows a client to set a factor for the alpha values on a
/// surface, which can be used to offload such operations to the compositor,
/// which can in turn for example offload them to KMS.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpAlphaModifierV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_alpha_modifier_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Alpha Modifier Manager Object
    /// 
    /// Destroy the alpha modifier manager. This doesn't destroy objects
    /// created with the manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A New Alpha Modifier Surface Object
    /// 
    /// Create a new alpha modifier surface object associated with the
    /// given wl_surface. If there is already such an object associated with
    /// the wl_surface, the already_constructed error will be raised.
    public func getSurface(surface: WlSurface) throws(WaylandProxyError) -> WpAlphaModifierSurfaceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpAlphaModifierSurfaceV1.self, version: self.version)
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
        /// Wl_Surface Already Has A Alpha Modifier Object
        case alreadyConstructed = 0
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
