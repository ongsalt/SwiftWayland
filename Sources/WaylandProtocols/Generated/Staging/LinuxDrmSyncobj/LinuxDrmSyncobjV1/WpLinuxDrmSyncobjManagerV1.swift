import Foundation
import SwiftWayland

/// Global For Providing Explicit Synchronization
/// 
/// This global is a factory interface, allowing clients to request
/// explicit synchronization for buffers on a per-surface basis.
/// See wp_linux_drm_syncobj_surface_v1 for more information.
public final class WpLinuxDrmSyncobjManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_linux_drm_syncobj_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Explicit Synchronization Factory Object
    /// 
    /// Destroy this explicit synchronization factory object. Other objects
    /// shall not be affected by this request.
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
    /// associated, the surface_exists protocol error is raised.
    /// Graphics APIs, like EGL or Vulkan, that manage the buffer queue and
    /// commits of a wl_surface themselves, are likely to be using this
    /// extension internally. If a client is using such an API for a
    /// wl_surface, it should not directly use this extension on that surface,
    /// to avoid raising a surface_exists protocol error.
    /// 
    /// - Parameters:
    ///   - Surface: the surface
    public func getSurface(surface: WlSurface) throws(WaylandProxyError) -> WpLinuxDrmSyncobjSurfaceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpLinuxDrmSyncobjSurfaceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Import A Drm Syncobj Timeline
    /// 
    /// Import a DRM synchronization object timeline.
    /// If the FD cannot be imported, the invalid_timeline error is raised.
    /// 
    /// - Parameters:
    ///   - Fd: drm_syncobj file descriptor
    public func importTimeline(fd: FileHandle) throws(WaylandProxyError) -> WpLinuxDrmSyncobjTimelineV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpLinuxDrmSyncobjTimelineV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(id.id),
            WaylandData.fd(fd)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Surface Already Has A Synchronization Object Associated
        case surfaceExists = 0
        
        /// The Timeline Object Could Not Be Imported
        case invalidTimeline = 1
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
