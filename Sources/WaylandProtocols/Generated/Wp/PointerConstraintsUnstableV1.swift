import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Constrain The Movement Of A Pointer
/// 
/// The global interface exposing pointer constraining functionality. It
/// exposes two requests: lock_pointer for locking the pointer to its
/// position, and confine_pointer for locking the pointer to a region.
/// The lock_pointer and confine_pointer requests create the objects
/// wp_locked_pointer and wp_confined_pointer respectively, and the client can
/// use these objects to interact with the lock.
/// For any surface, only one lock or confinement may be active across all
/// wl_pointer objects of the same seat. If a lock or confinement is requested
/// when another lock or confinement is active or requested on the same surface
/// and with any of the wl_pointer objects of the same seat, an
/// 'already_constrained' error will be raised.
public final class ZwpPointerConstraintsV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_constraints_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "lock_pointer",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_locked_pointer_v1",
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        ),
                        Argument(
                            name: "region",
                            type: .object,
                            interface: "wl_region",
                            nullable: true,
                        ),
                        Argument(
                            name: "lifetime",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "confine_pointer",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_confined_pointer_v1",
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        ),
                        Argument(
                            name: "region",
                            type: .object,
                            interface: "wl_region",
                            nullable: true,
                        ),
                        Argument(
                            name: "lifetime",
                            type: .uint,
                        ),
                    ],
                ),
            ],
        )
    /// Destroy The Pointer Constraints Manager Object
    /// 
    /// Used by the client to notify the server that it will no longer use this
    /// pointer constraints object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Lock Pointer To A Position
    /// 
    /// The lock_pointer request lets the client request to disable movements of
    /// the virtual pointer (i.e. the cursor), effectively locking the pointer
    /// to a position. This request may not take effect immediately; in the
    /// future, when the compositor deems implementation-specific constraints
    /// are satisfied, the pointer lock will be activated and the compositor
    /// sends a locked event.
    /// The protocol provides no guarantee that the constraints are ever
    /// satisfied, and does not require the compositor to send an error if the
    /// constraints cannot ever be satisfied. It is thus possible to request a
    /// lock that will never activate.
    /// There may not be another pointer constraint of any kind requested or
    /// active on the surface for any of the wl_pointer objects of the seat of
    /// the passed pointer when requesting a lock. If there is, an error will be
    /// raised. See general pointer lock documentation for more details.
    /// The intersection of the region passed with this request and the input
    /// region of the surface is used to determine where the pointer must be
    /// in order for the lock to activate. It is up to the compositor whether to
    /// warp the pointer or require some kind of user interaction for the lock
    /// to activate. If the region is null the surface input region is used.
    /// A surface may receive pointer focus without the lock being activated.
    /// The request creates a new object wp_locked_pointer which is used to
    /// interact with the lock as well as receive updates about its state. See
    /// the the description of wp_locked_pointer for further information.
    /// Note that while a pointer is locked, the wl_pointer objects of the
    /// corresponding seat will not emit any wl_pointer.motion events, but
    /// relative motion events will still be emitted via wp_relative_pointer
    /// objects of the same seat. wl_pointer.axis and wl_pointer.button events
    /// are unaffected.
    /// 
    /// - Parameters:
    ///   - surface: surface to lock pointer to
    ///   - pointer: the pointer that should be locked
    ///   - region: region of surface
    ///   - lifetime: lock lifetime
    public func lockPointer(surface: WlSurface, pointer: WlPointer, region: WlRegion? = nil, lifetime: Lifetime, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpLockedPointerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpLockedPointerV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
            .object(pointer.id),
            .object(region?.id ?? 0),
            .uint(lifetime.rawValue),
        ])
        return id
    }

    /// Confine Pointer To A Region
    /// 
    /// The confine_pointer request lets the client request to confine the
    /// pointer cursor to a given region. This request may not take effect
    /// immediately; in the future, when the compositor deems implementation-
    /// specific constraints are satisfied, the pointer confinement will be
    /// activated and the compositor sends a confined event.
    /// The intersection of the region passed with this request and the input
    /// region of the surface is used to determine where the pointer must be
    /// in order for the confinement to activate. It is up to the compositor
    /// whether to warp the pointer or require some kind of user interaction for
    /// the confinement to activate. If the region is null the surface input
    /// region is used.
    /// The request will create a new object wp_confined_pointer which is used
    /// to interact with the confinement as well as receive updates about its
    /// state. See the the description of wp_confined_pointer for further
    /// information.
    /// 
    /// - Parameters:
    ///   - surface: surface to lock pointer to
    ///   - pointer: the pointer that should be confined
    ///   - region: region of surface
    ///   - lifetime: confinement lifetime
    public func confinePointer(surface: WlSurface, pointer: WlPointer, region: WlRegion? = nil, lifetime: Lifetime, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpConfinedPointerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpConfinedPointerV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(id.id),
            .object(surface.id),
            .object(pointer.id),
            .object(region?.id ?? 0),
            .uint(lifetime.rawValue),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = PointerConstraintsUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// pointer constraint already requested on that surface
        case alreadyConstrained = 1
    }

    public enum Lifetime: UInt32 {
        case oneshot = 1

        case persistent = 2
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

/// Receive Relative Pointer Motion Events
/// 
/// The wp_locked_pointer interface represents a locked pointer state.
/// While the lock of this object is active, the wl_pointer objects of the
/// associated seat will not emit any wl_pointer.motion events.
/// This object will send the event 'locked' when the lock is activated.
/// Whenever the lock is activated, it is guaranteed that the locked surface
/// will already have received pointer focus and that the pointer will be
/// within the region passed to the request creating this object.
/// To unlock the pointer, send the destroy request. This will also destroy
/// the wp_locked_pointer object.
/// If the compositor decides to unlock the pointer the unlocked event is
/// sent. See wp_locked_pointer.unlock for details.
/// When unlocking, the compositor may warp the cursor position to the set
/// cursor position hint. If it does, it will not result in any relative
/// motion events emitted via wp_relative_pointer.
/// If the surface the lock was requested on is destroyed and the lock is not
/// yet activated, the wp_locked_pointer object is now defunct and must be
/// destroyed.
public final class ZwpLockedPointerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_locked_pointer_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "set_cursor_position_hint",
                    arguments: [
                        Argument(
                            name: "surface_x",
                            type: .fixed,
                        ),
                        Argument(
                            name: "surface_y",
                            type: .fixed,
                        ),
                    ],
                ),
                Message(
                    name: "set_region",
                    arguments: [
                        Argument(
                            name: "region",
                            type: .object,
                            interface: "wl_region",
                            nullable: true,
                        ),
                    ],
                ),
            ],
            events: [
                Message(
                    name: "locked",
                    arguments: [],
                ),
                Message(
                    name: "unlocked",
                    arguments: [],
                ),
            ]
        )
    /// Destroy The Locked Pointer Object
    /// 
    /// Destroy the locked pointer object. If applicable, the compositor will
    /// unlock the pointer.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Pointer Cursor Position Hint
    /// 
    /// Set the cursor position hint relative to the top left corner of the
    /// surface.
    /// If the client is drawing its own cursor, it should update the position
    /// hint to the position of its own cursor. A compositor may use this
    /// information to warp the pointer upon unlock in order to avoid pointer
    /// jumps.
    /// The cursor position hint is double-buffered state, see
    /// wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - surfaceX: surface-local x coordinate
    ///   - surfaceY: surface-local y coordinate
    public func setCursorPositionHint(surfaceX: Double, surfaceY: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .fixed(surfaceX),
            .fixed(surfaceY),
        ])
    }

    /// Set A New Lock Region
    /// 
    /// Set a new region used to lock the pointer.
    /// The new lock region is double-buffered, see wl_surface.commit.
    /// For details about the lock region, see wp_locked_pointer.
    /// 
    /// - Parameters:
    ///   - _: region of surface
    public func setRegion(_ region: WlRegion? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(region?.id ?? 0),
        ])
    }

    
    public static let `protocol`: Protocol = PointerConstraintsUnstableV1Protocol
    
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

    public enum Event: Decodable {
        /// Lock Activation Event
        /// 
        /// Notification that the pointer lock of the seat's pointer is activated.
        case locked

        /// Lock Deactivation Event
        /// 
        /// Notification that the pointer lock of the seat's pointer is no longer
        /// active. If this is a oneshot pointer lock (see
        /// wp_pointer_constraints.lifetime) this object is now defunct and should
        /// be destroyed. If this is a persistent pointer lock (see
        /// wp_pointer_constraints.lifetime) this pointer lock may again
        /// reactivate in the future.
        case unlocked

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.locked
            case 1:
                self = Self.unlocked
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Confined Pointer Object
/// 
/// The wp_confined_pointer interface represents a confined pointer state.
/// This object will send the event 'confined' when the confinement is
/// activated. Whenever the confinement is activated, it is guaranteed that
/// the surface the pointer is confined to will already have received pointer
/// focus and that the pointer will be within the region passed to the request
/// creating this object. It is up to the compositor to decide whether this
/// requires some user interaction and if the pointer will warp to within the
/// passed region if outside.
/// To unconfine the pointer, send the destroy request. This will also destroy
/// the wp_confined_pointer object.
/// If the compositor decides to unconfine the pointer the unconfined event is
/// sent. The wp_confined_pointer object is at this point defunct and should
/// be destroyed.
public final class ZwpConfinedPointerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_confined_pointer_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "set_region",
                    arguments: [
                        Argument(
                            name: "region",
                            type: .object,
                            interface: "wl_region",
                            nullable: true,
                        ),
                    ],
                ),
            ],
            events: [
                Message(
                    name: "confined",
                    arguments: [],
                ),
                Message(
                    name: "unconfined",
                    arguments: [],
                ),
            ]
        )
    /// Destroy The Confined Pointer Object
    /// 
    /// Destroy the confined pointer object. If applicable, the compositor will
    /// unconfine the pointer.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set A New Confine Region
    /// 
    /// Set a new region used to confine the pointer.
    /// The new confine region is double-buffered, see wl_surface.commit.
    /// If the confinement is active when the new confinement region is applied
    /// and the pointer ends up outside of newly applied region, the pointer may
    /// warped to a position within the new confinement region. If warped, a
    /// wl_pointer.motion event will be emitted, but no
    /// wp_relative_pointer.relative_motion event.
    /// The compositor may also, instead of using the new region, unconfine the
    /// pointer.
    /// For details about the confine region, see wp_confined_pointer.
    /// 
    /// - Parameters:
    ///   - _: region of surface
    public func setRegion(_ region: WlRegion? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(region?.id ?? 0),
        ])
    }

    
    public static let `protocol`: Protocol = PointerConstraintsUnstableV1Protocol
    
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

    public enum Event: Decodable {
        /// Pointer Confined
        /// 
        /// Notification that the pointer confinement of the seat's pointer is
        /// activated.
        case confined

        /// Pointer Unconfined
        /// 
        /// Notification that the pointer confinement of the seat's pointer is no
        /// longer active. If this is a oneshot pointer confinement (see
        /// wp_pointer_constraints.lifetime) this object is now defunct and should
        /// be destroyed. If this is a persistent pointer confinement (see
        /// wp_pointer_constraints.lifetime) this pointer confinement may again
        /// reactivate in the future.
        case unconfined

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.confined
            case 1:
                self = Self.unconfined
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let PointerConstraintsUnstableV1Protocol = Protocol(
        name: "pointer_constraints_unstable_v1",
        interfaces: [
            ZwpPointerConstraintsV1.interface,
ZwpLockedPointerV1.interface,
ZwpConfinedPointerV1.interface
        ]
    )

#endif