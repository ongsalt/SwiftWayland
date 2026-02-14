import Foundation
import SwiftWayland

/// Protocol For Tearing Control
/// 
/// For some use cases like games or drawing tablets it can make sense to
/// reduce latency by accepting tearing with the use of asynchronous page
/// flips. This global is a factory interface, allowing clients to inform
/// which type of presentation the content of their surfaces is suitable for.
/// Graphics APIs like EGL or Vulkan, that manage the buffer queue and commits
/// of a wl_surface themselves, are likely to be using this extension
/// internally. If a client is using such an API for a wl_surface, it should
/// not directly use this extension on that surface, to avoid raising a
/// tearing_control_exists protocol error.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpTearingControlManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_tearing_control_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Tearing Control Factory Object
    /// 
    /// Destroy this tearing control factory object. Other objects, including
    /// wp_tearing_control_v1 objects created by this factory, are not affected
    /// by this request.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Extend Surface Interface For Tearing Control
    /// 
    /// Instantiate an interface extension for the given wl_surface to request
    /// asynchronous page flips for presentation.
    /// If the given wl_surface already has a wp_tearing_control_v1 object
    /// associated, the tearing_control_exists protocol error is raised.
    public func getTearingControl(surface: WlSurface) throws(WaylandProxyError) -> WpTearingControlV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpTearingControlV1.self, version: self.version)
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
        /// The Surface Already Has A Tearing Object Associated
        case tearingControlExists = 0
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
