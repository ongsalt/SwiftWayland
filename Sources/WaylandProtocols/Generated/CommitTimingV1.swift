import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if STAGING
/// Commit Timing
/// 
/// When a compositor latches on to new content updates it will check for
/// any number of requirements of the available content updates (such as
/// fences of all buffers being signalled) to consider the update ready.
/// This protocol provides a method for adding a time constraint to surface
/// content. This constraint indicates to the compositor that a content
/// update should be presented as closely as possible to, but not before,
/// a specified time.
/// This protocol does not change the Wayland property that content
/// updates are applied in the order they are received, even when some
/// content updates contain timestamps and others do not.
/// To provide timestamps, this global factory interface must be used to
/// acquire a wp_commit_timing_v1 object for a surface, which may then be
/// used to provide timestamp information for commits.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpCommitTimingManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_commit_timing_manager_v1",
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
                    name: "get_timer",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_commit_timer_v1"
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
    /// Unbind From The Commit Timing Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object. Existing objects created by this object
    /// are not affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Request Commit Timer Interface For Surface
    /// 
    /// Establish a timing controller for a surface.
    /// Only one commit timer can be created for a surface, or a
    /// commit_timer_exists protocol error will be generated.
    /// 
    /// - Parameters:
    public func getTimer(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpCommitTimerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpCommitTimerV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: CommitTimingV1)
    }
    
    public enum Error: UInt32 {
        /// commit timer already exists for surface
        case commitTimerExists = 0
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
/// Surface Commit Timer
/// 
/// An object to set a time constraint for a content update on a surface.
public final class WpCommitTimerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_commit_timer_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "set_timestamp",
                    arguments: [
                    Argument(
                        name: "tv_sec_hi",
                        type: .uint,
                    ),
                    Argument(
                        name: "tv_sec_lo",
                        type: .uint,
                    ),
                    Argument(
                        name: "tv_nsec",
                        type: .uint,
                    ),
                    ],
                ),
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
    /// Specify Time The Following Commit Takes Effect
    /// 
    /// Provide a timing constraint for a surface content update.
    /// A set_timestamp request may be made before a wl_surface.commit to
    /// tell the compositor that the content is intended to be presented
    /// as closely as possible to, but not before, the specified time.
    /// The time is in the domain of the compositor's presentation clock.
    /// An invalid_timestamp error will be generated for invalid tv_nsec.
    /// If a timestamp already exists on the surface, a timestamp_exists
    /// error is generated.
    /// Requesting set_timestamp after the commit_timer object's surface is
    /// destroyed will generate a "surface_destroyed" error.
    /// 
    /// - Parameters:
    ///   - tvSecHi: high 32 bits of the seconds part of target time
    ///   - tvSecLo: low 32 bits of the seconds part of target time
    ///   - tvNsec: nanoseconds part of target time
    public func setTimestamp(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(tvSecHi),
            .uint(tvSecLo),
            .uint(tvNsec),
        ])
    }

    /// Destroy The Timer
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object.
    /// Existing timing constraints are not affected by the destruction.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: CommitTimingV1)
    }
    
    public enum Error: UInt32 {
        /// timestamp contains an invalid value
        case invalidTimestamp = 0

        /// timestamp exists
        case timestampExists = 1

        /// the associated surface no longer exists
        case surfaceDestroyed = 2
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

public let CommitTimingV1 = Protocol(
        name: "commit_timing_v1",
        interfaces: [
            WpCommitTimingManagerV1.interface,
WpCommitTimerV1.interface
        ]
    )

#endif