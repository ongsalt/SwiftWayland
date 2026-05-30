import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if UNSTABLE
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
public final class ZwpLinuxExplicitSynchronizationV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_linux_explicit_synchronization_v1",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_synchronization",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_linux_surface_synchronization_v1"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy Explicit Synchronization Factory Object
    /// 
    /// Destroy this explicit synchronization factory object. Other objects,
    /// including zwp_linux_surface_synchronization_v1 objects created by this
    /// factory, shall not be affected by this request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
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
    ///   - surface: the surface
    /// 
    /// - Returns: the new synchronization interface id
    public func getSynchronization(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpLinuxSurfaceSynchronizationV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpLinuxSurfaceSynchronizationV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ZwpLinuxExplicitSynchronizationUnstableV1)
    }
    
    public enum Error: UInt32 {
        /// the surface already has a synchronization object associated
        case synchronizationExists = 0
    }

    public typealias Event = NoEvent
}
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
public final class ZwpLinuxSurfaceSynchronizationV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_linux_surface_synchronization_v1",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_acquire_fence",
                    arguments: [
                    Argument(
                        name: "fd",
                        type: .fd,
                    ),
                    ],
                ),
                Message(
                    name: "get_release",
                    arguments: [
                    Argument(
                        name: "release",
                        type: .newId,
                        interface: "zwp_linux_buffer_release_v1"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy Synchronization Object
    /// 
    /// Destroy this explicit synchronization object.
    /// Any fence set by this object with set_acquire_fence since the last
    /// commit will be discarded by the server. Any fences set by this object
    /// before the last commit are not affected.
    /// zwp_linux_buffer_release_v1 objects created by this object are not
    /// affected by this request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
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
    ///   - fd: acquire fence fd
    public func setAcquireFence(fd: FileHandle) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .fd(fd),
        ])
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
    /// 
    /// - Returns: new zwp_linux_buffer_release_v1 object
    public func getRelease(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpLinuxBufferReleaseV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let release = connection.createProxy(type: ZwpLinuxBufferReleaseV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(release.id),
        ])
        return release
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ZwpLinuxExplicitSynchronizationUnstableV1)
    }
    
    public enum Error: UInt32 {
        /// the fence specified by the client could not be imported
        case invalidFence = 0

        /// multiple fences added for a single surface commit
        case duplicateFence = 1

        /// multiple releases added for a single surface commit
        case duplicateRelease = 2

        /// the associated wl_surface was destroyed
        case noSurface = 3

        /// the buffer does not support explicit synchronization
        case unsupportedBuffer = 4

        /// no buffer was attached
        case noBuffer = 5
    }

    public typealias Event = NoEvent
}
/// Buffer Release Explicit Synchronization
/// 
/// This object is instantiated in response to a
/// zwp_linux_surface_synchronization_v1.get_release request.
/// It provides an alternative to wl_buffer.release events, providing a
/// unique release from a single wl_surface.commit request. The release event
/// also supports explicit synchronization, providing a fence FD for the
/// client to synchronize against.
/// Exactly one event, either a fenced_release or an immediate_release, will
/// be emitted for the wl_surface.commit request. The compositor can choose
/// release by release which event it uses.
/// This event does not replace wl_buffer.release events; servers are still
/// required to send those events.
/// Once a buffer release object has delivered a 'fenced_release' or an
/// 'immediate_release' event it is automatically destroyed.
public final class ZwpLinuxBufferReleaseV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_linux_buffer_release_v1",
            version: 1,
            enums: [],
            requests: [
                ],
            events: [
                Message(
                    name: "fenced_release",
                    type: .destructor,
                    arguments: [
                    Argument(
                        name: "fence",
                        type: .fd,
                    ),
                    ],
                ),
                Message(
                    name: "immediate_release",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
        )
    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ZwpLinuxExplicitSynchronizationUnstableV1)
    }
    
    public enum Event: Decodable {
        /// Release Buffer With Fence
        /// 
        /// Sent when the compositor has finalised its usage of the associated
        /// buffer for the relevant commit, providing a dma_fence which will be
        /// signaled when all operations by the compositor on that buffer for that
        /// commit have finished.
        /// Once the fence has signaled, and assuming the associated buffer is not
        /// pending release from other wl_surface.commit requests, no additional
        /// explicit or implicit synchronization is required to safely reuse or
        /// destroy the buffer.
        /// This event destroys the zwp_linux_buffer_release_v1 object.
        case fencedRelease(fence: FileHandle)

        /// Release Buffer Immediately
        /// 
        /// Sent when the compositor has finalised its usage of the associated
        /// buffer for the relevant commit, and either performed no operations
        /// using it, or has a guarantee that all its operations on that buffer for
        /// that commit have finished.
        /// Once this event is received, and assuming the associated buffer is not
        /// pending release from other wl_surface.commit requests, no additional
        /// explicit or implicit synchronization is required to safely reuse or
        /// destroy the buffer.
        /// This event destroys the zwp_linux_buffer_release_v1 object.
        case immediateRelease

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.fencedRelease(fence: r.fd())
            case 1:
                self = Self.immediateRelease
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let ZwpLinuxExplicitSynchronizationUnstableV1 = Protocol(
        name: "zwp_linux_explicit_synchronization_unstable_v1",
        interfaces: [
            ZwpLinuxExplicitSynchronizationV1.interface,
ZwpLinuxSurfaceSynchronizationV1.interface,
ZwpLinuxBufferReleaseV1.interface
        ]
    )

#endif