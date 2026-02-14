import Foundation
import SwiftWayland

/// Protocol For Providing Explicit Synchronization
/// 
/// This global is a factory interface, allowing clients to request
/// explicit synchronization for buffers on a per-surface basis.
/// See zwp_linux_surface_synchronization_v1 for more information.
/// This interface is derived from Chromium's
/// zcr_linux_explicit_synchronization_v1.
/// Note: this protocol is superseded by linux-drm-syncobj.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpLinuxExplicitSynchronizationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_explicit_synchronization_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Explicit Synchronization Factory Object
    /// 
    /// Destroy this explicit synchronization factory object. Other objects,
    /// including zwp_linux_surface_synchronization_v1 objects created by this
    /// factory, shall not be affected by this request.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Extend Surface Interface For Explicit Synchronization
    /// 
    /// Instantiate an interface extension for the given wl_surface to provide
    /// explicit synchronization.
    /// If the given wl_surface already has an explicit synchronization object
    /// associated, the synchronization_exists protocol error is raised.
    /// Graphics APIs, like EGL or Vulkan, that manage the buffer queue and
    /// commits of a wl_surface themselves, are likely to be using this
    /// extension internally. If a client is using such an API for a
    /// wl_surface, it should not directly use this extension on that surface,
    /// to avoid raising a synchronization_exists protocol error.
    /// 
    /// - Parameters:
    ///   - Surface: the surface
    public func getSynchronization(surface: WlSurface) throws(WaylandProxyError) -> ZwpLinuxSurfaceSynchronizationV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpLinuxSurfaceSynchronizationV1.self, version: self.version)
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
        /// The Surface Already Has A Synchronization Object Associated
        case synchronizationExists = 0
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
