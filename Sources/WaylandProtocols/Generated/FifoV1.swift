import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if STAGING
/// Protocol For Fifo Constraints
/// 
/// When a Wayland compositor considers applying a content update,
/// it must ensure all the update's readiness constraints (fences, etc)
/// are met.
/// This protocol provides a way to use the completion of a display refresh
/// cycle as an additional readiness constraint.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpFifoManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_fifo_manager_v1",
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
                    name: "get_fifo",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_fifo_v1"
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
    /// Unbind From The Manager Interface
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

    /// Request Fifo Interface For Surface
    /// 
    /// Establish a fifo object for a surface that may be used to add
    /// display refresh constraints to content updates.
    /// Only one such object may exist for a surface and attempting
    /// to create more than one will result in an already_exists
    /// protocol error. If a surface is acted on by multiple software
    /// components, general best practice is that only the component
    /// performing wl_surface.attach operations should use this protocol.
    /// 
    /// - Parameters:
    public func getFifo(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpFifoV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpFifoV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: FifoV1)
    }
    
    public enum Error: UInt32 {
        /// fifo manager already exists for surface
        case alreadyExists = 0
    }

    public typealias Event = NoEvent
}
/// Fifo Interface
/// 
/// A fifo object for a surface that may be used to add
/// display refresh constraints to content updates.
public final class WpFifoV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_fifo_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "set_barrier",
                    arguments: [
                    ],
                ),
                Message(
                    name: "wait_barrier",
                    arguments: [
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
    /// Sets The Start Point For A Fifo Constraint
    /// 
    /// When the content update containing the "set_barrier" is applied,
    /// it sets a "fifo_barrier" condition on the surface associated with
    /// the fifo object. The condition is cleared immediately after the
    /// following latching deadline for non-tearing presentation.
    /// The compositor may clear the condition early if it must do so to
    /// ensure client forward progress assumptions.
    /// To wait for this condition to clear, use the "wait_barrier" request.
    /// "set_barrier" is double-buffered state, see wl_surface.commit.
    /// Requesting set_barrier after the fifo object's surface is
    /// destroyed will generate a "surface_destroyed" error.
    public func setBarrier() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Adds A Fifo Constraint To A Content Update
    /// 
    /// Indicate that this content update is not ready while a
    /// "fifo_barrier" condition is present on the surface.
    /// This means that when the content update containing "set_barrier"
    /// was made active at a latching deadline, it will be active for
    /// at least one refresh cycle. A content update which is allowed to
    /// tear might become active after a latching deadline if no content
    /// update became active at the deadline.
    /// The constraint must be ignored if the surface is a subsurface in
    /// synchronized mode. If the surface is not being updated by the
    /// compositor (off-screen, occluded) the compositor may ignore the
    /// constraint. Clients must use an additional mechanism such as
    /// frame callbacks or timestamps to ensure throttling occurs under
    /// all conditions.
    /// "wait_barrier" is double-buffered state, see wl_surface.commit.
    /// Requesting "wait_barrier" after the fifo object's surface is
    /// destroyed will generate a "surface_destroyed" error.
    public func waitBarrier() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Destroy The Fifo Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object.
    /// Surface state changes previously made by this protocol are
    /// unaffected by this object's destruction.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: FifoV1)
    }
    
    public enum Error: UInt32 {
        /// the associated surface no longer exists
        case surfaceDestroyed = 0
    }

    public typealias Event = NoEvent
}

public let FifoV1 = Protocol(
        name: "fifo_v1",
        interfaces: [
            WpFifoManagerV1.interface,
WpFifoV1.interface
        ]
    )

#endif