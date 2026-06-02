import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Touchpad Gestures
/// 
/// A global interface to provide semantic touchpad gestures for a given
/// pointer.
/// Three gestures are currently supported: swipe, pinch, and hold.
/// Pinch and swipe gestures follow a three-stage cycle: begin, update,
/// end. Hold gestures follow a two-stage cycle: begin and end. All
/// gestures are identified by a unique id.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpPointerGesturesV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_gestures_v1",
            version: 3,
            requests: [
                Message(
                    name: "get_swipe_gesture",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_pointer_gesture_swipe_v1",
                        ),
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        ),
                    ],
                ),
                Message(
                    name: "get_pinch_gesture",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_pointer_gesture_pinch_v1",
                        ),
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        ),
                    ],
                ),
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [],
                    since: 2
                ),
                Message(
                    name: "get_hold_gesture",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_pointer_gesture_hold_v1",
                        ),
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        ),
                    ],
                    since: 3
                ),
            ],
        )
    /// Get Swipe Gesture
    /// 
    /// Create a swipe gesture object. See the
    /// wl_pointer_gesture_swipe interface for details.
    /// 
    /// - Parameters:
    public func getSwipeGesture(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPointerGestureSwipeV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPointerGestureSwipeV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(pointer.id),
        ])
        return id
    }

    /// Get Pinch Gesture
    /// 
    /// Create a pinch gesture object. See the
    /// wl_pointer_gesture_pinch interface for details.
    /// 
    /// - Parameters:
    public func getPinchGesture(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPointerGesturePinchV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPointerGesturePinchV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(pointer.id),
        ])
        return id
    }

    /// Destroy The Pointer Gesture Object
    /// 
    /// Destroy the pointer gesture object. Swipe, pinch and hold objects
    /// created via this gesture object remain valid.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    /// Get Hold Gesture
    /// 
    /// Create a hold gesture object. See the
    /// wl_pointer_gesture_hold interface for details.
    /// 
    /// - Parameters:
    public func getHoldGesture(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPointerGestureHoldV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let id = connection.createProxy(type: ZwpPointerGestureHoldV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 3, [
            .object(id.id),
            .object(pointer.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PointerGesturesUnstableV1Protocol)
    }
    
    var destructor: Destructor? = .release

    enum Destructor {
        case release
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .release: try? self.release()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}

/// A Swipe Gesture Object
/// 
/// A swipe gesture object notifies a client about a multi-finger swipe
/// gesture detected on an indirect input device such as a touchpad.
/// The gesture is usually initiated by multiple fingers moving in the
/// same direction but once initiated the direction may change.
/// The precise conditions of when such a gesture is detected are
/// implementation-dependent.
/// A gesture consists of three stages: begin, update (optional) and end.
/// There cannot be multiple simultaneous hold, pinch or swipe gestures on a
/// same pointer/seat, how compositors prevent these situations is
/// implementation-dependent.
/// A gesture may be cancelled by the compositor or the hardware.
/// Clients should not consider performing permanent or irreversible
/// actions until the end of a gesture has been received.
public final class ZwpPointerGestureSwipeV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_gesture_swipe_v1",
            version: 3,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "begin",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                        Argument(
                            name: "time",
                            type: .uint,
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "fingers",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "update",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        ),
                        Argument(
                            name: "dx",
                            type: .fixed,
                        ),
                        Argument(
                            name: "dy",
                            type: .fixed,
                        ),
                    ],
                ),
                Message(
                    name: "end",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                        Argument(
                            name: "time",
                            type: .uint,
                        ),
                        Argument(
                            name: "cancelled",
                            type: .int,
                        ),
                    ],
                ),
            ]
        )
    /// Destroy The Pointer Swipe Gesture Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PointerGesturesUnstableV1Protocol)
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
        /// Multi-Finger Swipe Begin
        /// 
        /// This event is sent when a multi-finger swipe gesture is detected
        /// on the device.
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)

        /// Multi-Finger Swipe Motion
        /// 
        /// This event is sent when a multi-finger swipe gesture changes the
        /// position of the logical center.
        /// The dx and dy coordinates are relative coordinates of the logical
        /// center of the gesture compared to the previous event.
        case update(time: UInt32, dx: Double, dy: Double)

        /// Multi-Finger Swipe End
        /// 
        /// This event is sent when a multi-finger swipe gesture ceases to
        /// be valid. This may happen when one or more fingers are lifted or
        /// the gesture is cancelled.
        /// When a gesture is cancelled, the client should undo state changes
        /// caused by this gesture. What causes a gesture to be cancelled is
        /// implementation-dependent.
        case end(serial: UInt32, time: UInt32, cancelled: Int32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.begin(serial: r.uint(), time: r.uint(), surface: r.object(type: WlSurface.self), fingers: r.uint())
            case 1:
                self = Self.update(time: r.uint(), dx: r.fixed(), dy: r.fixed())
            case 2:
                self = Self.end(serial: r.uint(), time: r.uint(), cancelled: r.int())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Pinch Gesture Object
/// 
/// A pinch gesture object notifies a client about a multi-finger pinch
/// gesture detected on an indirect input device such as a touchpad.
/// The gesture is usually initiated by multiple fingers moving towards
/// each other or away from each other, or by two or more fingers rotating
/// around a logical center of gravity. The precise conditions of when
/// such a gesture is detected are implementation-dependent.
/// A gesture consists of three stages: begin, update (optional) and end.
/// There cannot be multiple simultaneous hold, pinch or swipe gestures on a
/// same pointer/seat, how compositors prevent these situations is
/// implementation-dependent.
/// A gesture may be cancelled by the compositor or the hardware.
/// Clients should not consider performing permanent or irreversible
/// actions until the end of a gesture has been received.
public final class ZwpPointerGesturePinchV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_gesture_pinch_v1",
            version: 3,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "begin",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                        Argument(
                            name: "time",
                            type: .uint,
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "fingers",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "update",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        ),
                        Argument(
                            name: "dx",
                            type: .fixed,
                        ),
                        Argument(
                            name: "dy",
                            type: .fixed,
                        ),
                        Argument(
                            name: "scale",
                            type: .fixed,
                        ),
                        Argument(
                            name: "rotation",
                            type: .fixed,
                        ),
                    ],
                ),
                Message(
                    name: "end",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                        Argument(
                            name: "time",
                            type: .uint,
                        ),
                        Argument(
                            name: "cancelled",
                            type: .int,
                        ),
                    ],
                ),
            ]
        )
    /// Destroy The Pinch Gesture Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PointerGesturesUnstableV1Protocol)
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
        /// Multi-Finger Pinch Begin
        /// 
        /// This event is sent when a multi-finger pinch gesture is detected
        /// on the device.
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)

        /// Multi-Finger Pinch Motion
        /// 
        /// This event is sent when a multi-finger pinch gesture changes the
        /// position of the logical center, the rotation or the relative scale.
        /// The dx and dy coordinates are relative coordinates in the
        /// surface coordinate space of the logical center of the gesture.
        /// The scale factor is an absolute scale compared to the
        /// pointer_gesture_pinch.begin event, e.g. a scale of 2 means the fingers
        /// are now twice as far apart as on pointer_gesture_pinch.begin.
        /// The rotation is the relative angle in degrees clockwise compared to the previous
        /// pointer_gesture_pinch.begin or pointer_gesture_pinch.update event.
        case update(time: UInt32, dx: Double, dy: Double, scale: Double, rotation: Double)

        /// Multi-Finger Pinch End
        /// 
        /// This event is sent when a multi-finger pinch gesture ceases to
        /// be valid. This may happen when one or more fingers are lifted or
        /// the gesture is cancelled.
        /// When a gesture is cancelled, the client should undo state changes
        /// caused by this gesture. What causes a gesture to be cancelled is
        /// implementation-dependent.
        case end(serial: UInt32, time: UInt32, cancelled: Int32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.begin(serial: r.uint(), time: r.uint(), surface: r.object(type: WlSurface.self), fingers: r.uint())
            case 1:
                self = Self.update(time: r.uint(), dx: r.fixed(), dy: r.fixed(), scale: r.fixed(), rotation: r.fixed())
            case 2:
                self = Self.end(serial: r.uint(), time: r.uint(), cancelled: r.int())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Hold Gesture Object
/// 
/// A hold gesture object notifies a client about a single- or
/// multi-finger hold gesture detected on an indirect input device such as
/// a touchpad. The gesture is usually initiated by one or more fingers
/// being held down without significant movement. The precise conditions
/// of when such a gesture is detected are implementation-dependent.
/// In particular, this gesture may be used to cancel kinetic scrolling.
/// A hold gesture consists of two stages: begin and end. Unlike pinch and
/// swipe there is no update stage.
/// There cannot be multiple simultaneous hold, pinch or swipe gestures on a
/// same pointer/seat, how compositors prevent these situations is
/// implementation-dependent.
/// A gesture may be cancelled by the compositor or the hardware.
/// Clients should not consider performing permanent or irreversible
/// actions until the end of a gesture has been received.
public final class ZwpPointerGestureHoldV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_gesture_hold_v1",
            version: 3,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                    since: 3
                ),
            ],
            events: [
                Message(
                    name: "begin",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                        Argument(
                            name: "time",
                            type: .uint,
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "fingers",
                            type: .uint,
                        ),
                    ],
                    since: 3
                ),
                Message(
                    name: "end",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                        Argument(
                            name: "time",
                            type: .uint,
                        ),
                        Argument(
                            name: "cancelled",
                            type: .int,
                        ),
                    ],
                    since: 3
                ),
            ]
        )
    /// Destroy The Hold Gesture Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: PointerGesturesUnstableV1Protocol)
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
        /// Multi-Finger Hold Begin
        /// 
        /// This event is sent when a hold gesture is detected on the device.
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)

        /// Multi-Finger Hold End
        /// 
        /// This event is sent when a hold gesture ceases to
        /// be valid. This may happen when the holding fingers are lifted or
        /// the gesture is cancelled, for example if the fingers move past an
        /// implementation-defined threshold, the finger count changes or the hold
        /// gesture changes into a different type of gesture.
        /// When a gesture is cancelled, the client may need to undo state changes
        /// caused by this gesture. What causes a gesture to be cancelled is
        /// implementation-dependent.
        case end(serial: UInt32, time: UInt32, cancelled: Int32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.begin(serial: r.uint(), time: r.uint(), surface: r.object(type: WlSurface.self), fingers: r.uint())
            case 1:
                self = Self.end(serial: r.uint(), time: r.uint(), cancelled: r.int())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let PointerGesturesUnstableV1Protocol = Protocol(
        name: "pointer_gestures_unstable_v1",
        interfaces: [
            ZwpPointerGesturesV1.interface,
ZwpPointerGestureSwipeV1.interface,
ZwpPointerGesturePinchV1.interface,
ZwpPointerGestureHoldV1.interface
        ]
    )

#endif