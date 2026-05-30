import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Global For Providing Explicit Synchronization
/// 
/// This global is a factory interface, allowing clients to request
/// explicit synchronization for buffers on a per-surface basis.
/// See wp_linux_drm_syncobj_surface_v1 for more information.
public final class WpLinuxDrmSyncobjManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_linux_drm_syncobj_manager_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_surface",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_linux_drm_syncobj_surface_v1"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "import_timeline",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_linux_drm_syncobj_timeline_v1"
                    ),
                    Argument(
                        name: "fd",
                        type: .fd,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy Explicit Synchronization Factory Object
    /// 
    /// Destroy this explicit synchronization factory object. Other objects
    /// shall not be affected by this request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
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
    ///   - surface: the surface
    /// 
    /// - Returns: the new synchronization surface object id
    public func getSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpLinuxDrmSyncobjSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpLinuxDrmSyncobjSurfaceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// Import A Drm Syncobj Timeline
    /// 
    /// Import a DRM synchronization object timeline.
    /// If the FD cannot be imported, the invalid_timeline error is raised.
    /// 
    /// - Parameters:
    ///   - fd: drm_syncobj file descriptor
    public func importTimeline(fd: FileHandle, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpLinuxDrmSyncobjTimelineV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpLinuxDrmSyncobjTimelineV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(id.id),
            .fd(fd),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: LinuxDrmSyncobjV1)
    }
    
    public enum Error: UInt32 {
        /// the surface already has a synchronization object associated
        case surfaceExists = 0

        /// the timeline object could not be imported
        case invalidTimeline = 1
    }

    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}
/// Synchronization Object Timeline
/// 
/// This object represents an explicit synchronization object timeline
/// imported by the client to the compositor.
public final class WpLinuxDrmSyncobjTimelineV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_linux_drm_syncobj_timeline_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Timeline
    /// 
    /// Destroy the synchronization object timeline. Other objects are not
    /// affected by this request, in particular timeline points set by
    /// set_acquire_point and set_release_point are not unset.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: LinuxDrmSyncobjV1)
    }
    
    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}
/// Per-Surface Explicit Synchronization
/// 
/// This object is an add-on interface for wl_surface to enable explicit
/// synchronization.
/// Each surface can be associated with only one object of this interface at
/// any time.
/// Explicit synchronization is guaranteed to be supported for buffers
/// created with any version of the linux-dmabuf protocol. Compositors are
/// free to support explicit synchronization for additional buffer types.
/// If at surface commit time the attached buffer does not support explicit
/// synchronization, an unsupported_buffer error is raised.
/// As long as the wp_linux_drm_syncobj_surface_v1 object is alive, the
/// compositor may ignore implicit synchronization for buffers attached and
/// committed to the wl_surface. The delivery of wl_buffer.release events
/// for buffers attached to the surface becomes undefined.
/// Clients must set both acquire and release points if and only if a
/// non-null buffer is attached in the same surface commit. See the
/// no_buffer, no_acquire_point and no_release_point protocol errors.
/// If at surface commit time the acquire and release DRM syncobj timelines
/// are identical, the acquire point value must be strictly less than the
/// release point value, or else the conflicting_points protocol error is
/// raised.
public final class WpLinuxDrmSyncobjSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_linux_drm_syncobj_surface_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_acquire_point",
                    arguments: [
                    Argument(
                        name: "timeline",
                        type: .object,
                        interface: "wp_linux_drm_syncobj_timeline_v1"
                    ),
                    Argument(
                        name: "point_hi",
                        type: .uint,
                    ),
                    Argument(
                        name: "point_lo",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_release_point",
                    arguments: [
                    Argument(
                        name: "timeline",
                        type: .object,
                        interface: "wp_linux_drm_syncobj_timeline_v1"
                    ),
                    Argument(
                        name: "point_hi",
                        type: .uint,
                    ),
                    Argument(
                        name: "point_lo",
                        type: .uint,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Surface Synchronization Object
    /// 
    /// Destroy this surface synchronization object.
    /// Any timeline point set by this object with set_acquire_point or
    /// set_release_point since the last commit may be discarded by the
    /// compositor. Any timeline point set by this object before the last
    /// commit will not be affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Acquire Timeline Point
    /// 
    /// Set the timeline point that must be signalled before the compositor may
    /// sample from the buffer attached with wl_surface.attach.
    /// The 64-bit unsigned value combined from point_hi and point_lo is the
    /// point value.
    /// The acquire point is double-buffered state, and will be applied on the
    /// next wl_surface.commit request for the associated surface. Thus, it
    /// applies only to the buffer that is attached to the surface at commit
    /// time.
    /// If an acquire point has already been attached during the same commit
    /// cycle, the new point replaces the old one.
    /// If the associated wl_surface was destroyed, a no_surface error is
    /// raised.
    /// If at surface commit time there is a pending acquire timeline point set
    /// but no pending buffer attached, a no_buffer error is raised. If at
    /// surface commit time there is a pending buffer attached but no pending
    /// acquire timeline point set, the no_acquire_point protocol error is
    /// raised.
    /// 
    /// - Parameters:
    ///   - pointHi: high 32 bits of the point value
    ///   - pointLo: low 32 bits of the point value
    public func setAcquirePoint(timeline: WpLinuxDrmSyncobjTimelineV1, pointHi: UInt32, pointLo: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(timeline.id),
            .uint(pointHi),
            .uint(pointLo),
        ])
    }

    /// Set The Release Timeline Point
    /// 
    /// Set the timeline point that must be signalled by the compositor when it
    /// has finished its usage of the buffer attached with wl_surface.attach
    /// for the relevant commit.
    /// Once the timeline point is signaled, and assuming the associated buffer
    /// is not pending release from other wl_surface.commit requests, no
    /// additional explicit or implicit synchronization with the compositor is
    /// required to safely re-use the buffer.
    /// Note that clients cannot rely on the release point being always
    /// signaled after the acquire point: compositors may release buffers
    /// without ever reading from them. In addition, the compositor may use
    /// different presentation paths for different commits, which may have
    /// different release behavior. As a result, the compositor may signal the
    /// release points in a different order than the client committed them.
    /// Because signaling a timeline point also signals every previous point,
    /// it is generally not safe to use the same timeline object for the
    /// release points of multiple buffers. The out-of-order signaling
    /// described above may lead to a release point being signaled before the
    /// compositor has finished reading. To avoid this, it is strongly
    /// recommended that each buffer should use a separate timeline for its
    /// release points.
    /// The 64-bit unsigned value combined from point_hi and point_lo is the
    /// point value.
    /// The release point is double-buffered state, and will be applied on the
    /// next wl_surface.commit request for the associated surface. Thus, it
    /// applies only to the buffer that is attached to the surface at commit
    /// time.
    /// If a release point has already been attached during the same commit
    /// cycle, the new point replaces the old one.
    /// If the associated wl_surface was destroyed, a no_surface error is
    /// raised.
    /// If at surface commit time there is a pending release timeline point set
    /// but no pending buffer attached, a no_buffer error is raised. If at
    /// surface commit time there is a pending buffer attached but no pending
    /// release timeline point set, the no_release_point protocol error is
    /// raised.
    /// 
    /// - Parameters:
    ///   - pointHi: high 32 bits of the point value
    ///   - pointLo: low 32 bits of the point value
    public func setReleasePoint(timeline: WpLinuxDrmSyncobjTimelineV1, pointHi: UInt32, pointLo: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(timeline.id),
            .uint(pointHi),
            .uint(pointLo),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: LinuxDrmSyncobjV1)
    }
    
    public enum Error: UInt32 {
        /// the associated wl_surface was destroyed
        case noSurface = 1

        /// the buffer does not support explicit synchronization
        case unsupportedBuffer = 2

        /// no buffer was attached
        case noBuffer = 3

        /// no acquire timeline point was set
        case noAcquirePoint = 4

        /// no release timeline point was set
        case noReleasePoint = 5

        /// acquire and release timeline points are in conflict
        case conflictingPoints = 6
    }

    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}

public let LinuxDrmSyncobjV1 = Protocol(
        name: "linux_drm_syncobj_v1",
        interfaces: [
            WpLinuxDrmSyncobjManagerV1.interface,
WpLinuxDrmSyncobjTimelineV1.interface,
WpLinuxDrmSyncobjSurfaceV1.interface
        ]
    )

#endif