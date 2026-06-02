import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Used To Lock The Session
/// 
/// This interface is used to request that the session be locked.
public final class ExtSessionLockManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "ext_session_lock_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "lock",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "ext_session_lock_v1",
                        ),
                    ],
                ),
            ],
        )
    /// Destroy The Session Lock Manager Object
    /// 
    /// This informs the compositor that the session lock manager object will
    /// no longer be used. Existing objects created through this interface
    /// remain valid.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Attempt To Lock The Session
    /// 
    /// This request creates a session lock and asks the compositor to lock the
    /// session. The compositor will send either the ext_session_lock_v1.locked
    /// or ext_session_lock_v1.finished event on the created object in
    /// response to this request.
    public func lock(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ExtSessionLockV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ExtSessionLockV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ExtSessionLockV1Protocol)
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

/// Manage Lock State And Create Lock Surfaces
/// 
/// In response to the creation of this object the compositor must send
/// either the locked or finished event.
/// The locked event indicates that the session is locked. This means
/// that the compositor must stop rendering and providing input to normal
/// clients. Instead the compositor must blank all outputs with an opaque
/// color such that their normal content is fully hidden.
/// The only surfaces that should be rendered while the session is locked
/// are the lock surfaces created through this interface and optionally,
/// at the compositor's discretion, special privileged surfaces such as
/// input methods or portions of desktop shell UIs.
/// The locked event must not be sent until a new "locked" frame (either
/// from a session lock surface or the compositor blanking the output) has
/// been presented on all outputs and no security sensitive normal/unlocked
/// content is possibly visible.
/// The finished event should be sent immediately on creation of this
/// object if the compositor decides that the locked event will not be sent.
/// The compositor may wait for the client to create and render session lock
/// surfaces before sending the locked event to avoid displaying intermediate
/// blank frames. However, it must impose a reasonable time limit if
/// waiting and send the locked event as soon as the hard requirements
/// described above can be met if the time limit expires. Clients should
/// immediately create lock surfaces for all outputs on creation of this
/// object to make this possible.
/// This behavior of the locked event is required in order to prevent
/// possible race conditions with clients that wish to suspend the system
/// or similar after locking the session. Without these semantics, clients
/// triggering a suspend after receiving the locked event would race with
/// the first "locked" frame being presented and normal/unlocked frames
/// might be briefly visible as the system is resumed if the suspend
/// operation wins the race.
/// If the client dies while the session is locked, the compositor must not
/// unlock the session in response. It is acceptable for the session to be
/// permanently locked if this happens. The compositor may choose to continue
/// to display the lock surfaces the client had mapped before it died or
/// alternatively fall back to a solid color, this is compositor policy.
/// Compositors may also allow a secure way to recover the session, the
/// details of this are compositor policy. Compositors may allow a new
/// client to create a ext_session_lock_v1 object and take responsibility
/// for unlocking the session, they may even start a new lock client
/// instance automatically.
public final class ExtSessionLockV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "ext_session_lock_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "get_lock_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "ext_session_lock_surface_v1",
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        ),
                    ],
                ),
                Message(
                    name: "unlock_and_destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "locked",
                    arguments: [],
                ),
                Message(
                    name: "finished",
                    arguments: [],
                ),
            ]
        )
    /// Destroy The Session Lock
    /// 
    /// This informs the compositor that the lock object will no longer be
    /// used. Existing objects created through this interface remain valid.
    /// After this request is made, lock surfaces created through this object
    /// should be destroyed by the client as they will no longer be used by
    /// the compositor.
    /// It is a protocol error to make this request if the locked event was
    /// sent, the unlock_and_destroy request must be used instead.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A Lock Surface For A Given Output
    /// 
    /// The client is expected to create lock surfaces for all outputs
    /// currently present and any new outputs as they are advertised. These
    /// won't be displayed by the compositor unless the lock is successful
    /// and the locked event is sent.
    /// Providing a wl_surface which already has a role or already has a buffer
    /// attached or committed is a protocol error, as is attaching/committing
    /// a buffer before the first ext_session_lock_surface_v1.configure event.
    /// Attempting to create more than one lock surface for a given output
    /// is a duplicate_output protocol error.
    /// 
    /// - Parameters:
    public func getLockSurface(surface: WlSurface, output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ExtSessionLockSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ExtSessionLockSurfaceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
            .object(output.id),
        ])
        return id
    }

    /// Unlock The Session, Destroying The Object
    /// 
    /// This request indicates that the session should be unlocked, for
    /// example because the user has entered their password and it has been
    /// verified by the client.
    /// This request also informs the compositor that the lock object will
    /// no longer be used and should be destroyed. Existing objects created
    /// through this interface remain valid.
    /// After this request is made, lock surfaces created through this object
    /// should be destroyed by the client as they will no longer be used by
    /// the compositor.
    /// It is a protocol error to make this request if the locked event has
    /// not been sent. In that case, the lock object must be destroyed using
    /// the destroy request.
    /// Note that a correct client that wishes to exit directly after unlocking
    /// the session must use the wl_display.sync request to ensure the server
    /// receives and processes the unlock_and_destroy request. Otherwise
    /// there is no guarantee that the server has unlocked the session due
    /// to the asynchronous nature of the Wayland protocol. For example,
    /// the server might terminate the client with a protocol error before
    /// it processes the unlock_and_destroy request.
    public func unlockAndDestroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ExtSessionLockV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// attempted to destroy session lock while locked
        case invalidDestroy = 0

        /// unlock requested but locked event was never sent
        case invalidUnlock = 1

        /// given wl_surface already has a role
        case role = 2

        /// given output already has a lock surface
        case duplicateOutput = 3

        /// given wl_surface has a buffer attached or committed
        case alreadyConstructed = 4
    }

    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
        case unlockAndDestroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case .unlockAndDestroy: try? self.unlockAndDestroy()
                case nil: break
            }
        }
    }

    public enum Event: Decodable {
        /// Session Successfully Locked
        /// 
        /// This client is now responsible for displaying graphics while the
        /// session is locked and deciding when to unlock the session.
        /// The locked event must not be sent until a new "locked" frame has been
        /// presented on all outputs and no security sensitive normal/unlocked
        /// content is possibly visible.
        /// If this event is sent, making the destroy request is a protocol error,
        /// the lock object must be destroyed using the unlock_and_destroy request.
        case locked

        /// The Session Lock Object Should Be Destroyed
        /// 
        /// The compositor has decided that the session lock should be destroyed
        /// as it will no longer be used by the compositor. Exactly when this
        /// event is sent is compositor policy, but it must never be sent more
        /// than once for a given session lock object.
        /// This might be sent because there is already another ext_session_lock_v1
        /// object held by a client, or the compositor has decided to deny the
        /// request to lock the session for some other reason. This might also
        /// be sent because the compositor implements some alternative, secure
        /// way to authenticate and unlock the session.
        /// The finished event should be sent immediately on creation of this
        /// object if the compositor decides that the locked event will not
        /// be sent.
        /// If the locked event is sent on creation of this object the finished
        /// event may still be sent at some later time in this object's
        /// lifetime. This is compositor policy.
        /// Upon receiving this event, the client should make either the destroy
        /// request or the unlock_and_destroy request, depending on whether or
        /// not the locked event was received on this object.
        case finished

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.locked
            case 1:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Surface Displayed While The Session Is Locked
/// 
/// The client may use lock surfaces to display a screensaver, render a
/// dialog to enter a password and unlock the session, or however else it
/// sees fit.
/// On binding this interface the compositor will immediately send the
/// first configure event. After making the ack_configure request in
/// response to this event the client should attach and commit the first
/// buffer. Committing the surface before acking the first configure is a
/// protocol error. Committing the surface with a null buffer at any time
/// is a protocol error.
/// The compositor is free to handle keyboard/pointer focus for lock
/// surfaces however it chooses. A reasonable way to do this would be to
/// give the first lock surface created keyboard focus and change keyboard
/// focus if the user clicks on other surfaces.
public final class ExtSessionLockSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "ext_session_lock_surface_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "ack_configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
                ),
            ],
            events: [
                Message(
                    name: "configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                        Argument(
                            name: "width",
                            type: .uint,
                        ),
                        Argument(
                            name: "height",
                            type: .uint,
                        ),
                    ],
                ),
            ]
        )
    /// Destroy The Lock Surface Object
    /// 
    /// This informs the compositor that the lock surface object will no
    /// longer be used.
    /// It is recommended for a lock client to destroy lock surfaces if
    /// their corresponding wl_output global is removed.
    /// If a lock surface on an active output is destroyed before the
    /// ext_session_lock_v1.unlock_and_destroy event is sent, the compositor
    /// must fall back to rendering a solid color.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Ack A Configure Event
    /// 
    /// When a configure event is received, if a client commits the surface
    /// in response to the configure event, then the client must make an
    /// ack_configure request sometime before the commit request, passing
    /// along the serial of the configure event.
    /// If the client receives multiple configure events before it can
    /// respond to one, it only has to ack the last configure event.
    /// A client is not required to commit immediately after sending an
    /// ack_configure request - it may even ack_configure several times
    /// before its next surface commit.
    /// A client may send multiple ack_configure requests before committing,
    /// but only the last request sent before a commit indicates which
    /// configure event the client really is responding to.
    /// Sending an ack_configure request consumes the configure event
    /// referenced by the given serial, as well as all older configure events
    /// sent on this object.
    /// It is a protocol error to issue multiple ack_configure requests
    /// referencing the same configure event or to issue an ack_configure
    /// request referencing a configure event older than the last configure
    /// event acked for a given lock surface.
    /// 
    /// - Parameters:
    ///   - serial: serial from the configure event
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(serial),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ExtSessionLockV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// surface committed before first ack_configure request
        case commitBeforeFirstAck = 0

        /// surface committed with a null buffer
        case nullBuffer = 1

        /// failed to match ack'd width/height
        case dimensionsMismatch = 2

        /// serial provided in ack_configure is invalid
        case invalidSerial = 3
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

    public enum Event: Decodable {
        /// The Client Should Resize Its Surface
        /// 
        /// This event is sent once on binding the interface and may be sent again
        /// at the compositor's discretion, for example if output geometry changes.
        /// The width and height are in surface-local coordinates and are exact
        /// requirements. Failing to match these surface dimensions in the next
        /// commit after acking a configure is a protocol error.
        case configure(serial: UInt32, width: UInt32, height: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(serial: r.uint(), width: r.uint(), height: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let ExtSessionLockV1Protocol = Protocol(
        name: "ext_session_lock_v1",
        interfaces: [
            ExtSessionLockManagerV1.interface,
ExtSessionLockV1.interface,
ExtSessionLockSurfaceV1.interface
        ]
    )

#endif