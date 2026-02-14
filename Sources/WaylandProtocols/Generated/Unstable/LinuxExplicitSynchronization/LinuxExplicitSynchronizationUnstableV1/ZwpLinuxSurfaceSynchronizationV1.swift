import Foundation
import SwiftWayland

/// Per-Surface Explicit Synchronization Support
/// 
/// This object implements per-surface explicit synchronization.
/// Synchronization refers to co-ordination of pipelined operations performed
/// on buffers. Most GPU clients will schedule an asynchronous operation to
/// render to the buffer, then immediately send the buffer to the compositor
/// to be attached to a surface.
/// In implicit synchronization, ensuring that the rendering operation is
/// complete before the compositor displays the buffer is an implementation
/// detail handled by either the kernel or userspace graphics driver.
/// By contrast, in explicit synchronization, dma_fence objects mark when the
/// asynchronous operations are complete. When submitting a buffer, the
/// client provides an acquire fence which will be waited on before the
/// compositor accesses the buffer. The Wayland server, through a
/// zwp_linux_buffer_release_v1 object, will inform the client with an event
/// which may be accompanied by a release fence, when the compositor will no
/// longer access the buffer contents due to the specific commit that
/// requested the release event.
/// Each surface can be associated with only one object of this interface at
/// any time.
/// In version 1 of this interface, explicit synchronization is only
/// guaranteed to be supported for buffers created with any version of the
/// wp_linux_dmabuf buffer factory. Version 2 additionally guarantees
/// explicit synchronization support for opaque EGL buffers, which is a type
/// of platform specific buffers described in the EGL_WL_bind_wayland_display
/// extension. Compositors are free to support explicit synchronization for
/// additional buffer types.
public final class ZwpLinuxSurfaceSynchronizationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_surface_synchronization_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Synchronization Object
    /// 
    /// Destroy this explicit synchronization object.
    /// Any fence set by this object with set_acquire_fence since the last
    /// commit will be discarded by the server. Any fences set by this object
    /// before the last commit are not affected.
    /// zwp_linux_buffer_release_v1 objects created by this object are not
    /// affected by this request.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set The Acquire Fence
    /// 
    /// Set the acquire fence that must be signaled before the compositor
    /// may sample from the buffer attached with wl_surface.attach. The fence
    /// is a dma_fence kernel object.
    /// The acquire fence is double-buffered state, and will be applied on the
    /// next wl_surface.commit request for the associated surface. Thus, it
    /// applies only to the buffer that is attached to the surface at commit
    /// time.
    /// If the provided fd is not a valid dma_fence fd, then an INVALID_FENCE
    /// error is raised.
    /// If a fence has already been attached during the same commit cycle, a
    /// DUPLICATE_FENCE error is raised.
    /// If the associated wl_surface was destroyed, a NO_SURFACE error is
    /// raised.
    /// If at surface commit time the attached buffer does not support explicit
    /// synchronization, an UNSUPPORTED_BUFFER error is raised.
    /// If at surface commit time there is no buffer attached, a NO_BUFFER
    /// error is raised.
    /// 
    /// - Parameters:
    ///   - Fd: acquire fence fd
    public func setAcquireFence(fd: FileHandle) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.fd(fd)
        ])
        connection.send(message: message)
    }
    
    /// Release Fence For Last-Attached Buffer
    /// 
    /// Create a listener for the release of the buffer attached by the
    /// client with wl_surface.attach. See zwp_linux_buffer_release_v1
    /// documentation for more information.
    /// The release object is double-buffered state, and will be associated
    /// with the buffer that is attached to the surface at wl_surface.commit
    /// time.
    /// If a zwp_linux_buffer_release_v1 object has already been requested for
    /// the surface in the same commit cycle, a DUPLICATE_RELEASE error is
    /// raised.
    /// If the associated wl_surface was destroyed, a NO_SURFACE error
    /// is raised.
    /// If at surface commit time there is no buffer attached, a NO_BUFFER
    /// error is raised.
    public func getRelease() throws(WaylandProxyError) -> ZwpLinuxBufferReleaseV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let release = connection.createProxy(type: ZwpLinuxBufferReleaseV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(release.id)
        ])
        connection.send(message: message)
        return release
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Fence Specified By The Client Could Not Be Imported
        case invalidFence = 0
        
        /// Multiple Fences Added For A Single Surface Commit
        case duplicateFence = 1
        
        /// Multiple Releases Added For A Single Surface Commit
        case duplicateRelease = 2
        
        /// The Associated Wl_Surface Was Destroyed
        case noSurface = 3
        
        /// The Buffer Does Not Support Explicit Synchronization
        case unsupportedBuffer = 4
        
        /// No Buffer Was Attached
        case noBuffer = 5
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
