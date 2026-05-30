import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WLR
/// Virtual Pointer
/// 
/// This protocol allows clients to emulate a physical pointer device. The
/// requests are mostly mirror opposites of those specified in wl_pointer.
public final class ZwlrVirtualPointerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_virtual_pointer_v1",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "motion",
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
                    name: "motion_absolute",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    Argument(
                        name: "x",
                        type: .uint,
                    ),
                    Argument(
                        name: "y",
                        type: .uint,
                    ),
                    Argument(
                        name: "x_extent",
                        type: .uint,
                    ),
                    Argument(
                        name: "y_extent",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "button",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    Argument(
                        name: "button",
                        type: .uint,
                    ),
                    Argument(
                        name: "state",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "axis",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    Argument(
                        name: "axis",
                        type: .uint,
                    ),
                    Argument(
                        name: "value",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "frame",
                    arguments: [
                    ],
                ),
                Message(
                    name: "axis_source",
                    arguments: [
                    Argument(
                        name: "axis_source",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "axis_stop",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    Argument(
                        name: "axis",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "axis_discrete",
                    arguments: [
                    Argument(
                        name: "time",
                        type: .uint,
                    ),
                    Argument(
                        name: "axis",
                        type: .uint,
                    ),
                    Argument(
                        name: "value",
                        type: .fixed,
                    ),
                    Argument(
                        name: "discrete",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 1
                ),
                ],
            events: [
                ],
        )
    /// Pointer Relative Motion Event
    /// 
    /// The pointer has moved by a relative amount to the previous request.
    /// Values are in the global compositor space.
    /// 
    /// - Parameters:
    ///   - time: timestamp with millisecond granularity
    ///   - dx: displacement on the x-axis
    ///   - dy: displacement on the y-axis
    public func motion(time: UInt32, dx: Double, dy: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(time),
            .fixed(dx),
            .fixed(dy),
        ])
    }

    /// Pointer Absolute Motion Event
    /// 
    /// The pointer has moved in an absolute coordinate frame.
    /// Value of x can range from 0 to x_extent, value of y can range from 0
    /// to y_extent.
    /// 
    /// - Parameters:
    ///   - time: timestamp with millisecond granularity
    ///   - x: position on the x-axis
    ///   - y: position on the y-axis
    ///   - xExtent: extent of the x-axis
    ///   - yExtent: extent of the y-axis
    public func motionAbsolute(time: UInt32, x: UInt32, y: UInt32, xExtent: UInt32, yExtent: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(time),
            .uint(x),
            .uint(y),
            .uint(xExtent),
            .uint(yExtent),
        ])
    }

    /// Button Event
    /// 
    /// A button was pressed or released.
    /// 
    /// - Parameters:
    ///   - time: timestamp with millisecond granularity
    ///   - button: button that produced the event
    ///   - state: physical state of the button
    public func button(time: UInt32, button: UInt32, state: WlPointer.ButtonState) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .uint(time),
            .uint(button),
            .uint(state.rawValue),
        ])
    }

    /// Axis Event
    /// 
    /// Scroll and other axis requests.
    /// 
    /// - Parameters:
    ///   - time: timestamp with millisecond granularity
    ///   - axis: axis type
    ///   - value: length of vector in touchpad coordinates
    public func axis(time: UInt32, axis: WlPointer.Axis, value: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(time),
            .uint(axis.rawValue),
            .fixed(value),
        ])
    }

    /// End Of A Pointer Event Sequence
    /// 
    /// Indicates the set of events that logically belong together.
    public func frame() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    /// Axis Source Event
    /// 
    /// Source information for scroll and other axis.
    /// 
    /// - Parameters:
    ///   - axisSource: source of the axis event
    public func axisSource(axisSource: WlPointer.AxisSource) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .uint(axisSource.rawValue),
        ])
    }

    /// Axis Stop Event
    /// 
    /// Stop notification for scroll and other axes.
    /// 
    /// - Parameters:
    ///   - time: timestamp with millisecond granularity
    ///   - axis: the axis stopped with this event
    public func axisStop(time: UInt32, axis: WlPointer.Axis) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .uint(time),
            .uint(axis.rawValue),
        ])
    }

    /// Axis Click Event
    /// 
    /// Discrete step information for scroll and other axes.
    /// This event allows the client to extend data normally sent using the axis
    /// event with discrete value.
    /// 
    /// - Parameters:
    ///   - time: timestamp with millisecond granularity
    ///   - axis: axis type
    ///   - value: length of vector in touchpad coordinates
    ///   - discrete: number of steps
    public func axisDiscrete(time: UInt32, axis: WlPointer.Axis, value: Double, discrete: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .uint(time),
            .uint(axis.rawValue),
            .fixed(value),
            .int(discrete),
        ])
    }

    /// Destroy The Virtual Pointer Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 1 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 1) }
        self.markDead()
        connection.send(self, 8, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrVirtualPointerUnstableV1)
    }
    
    public enum Error: UInt32 {
        /// client sent invalid axis enumeration value
        case invalidAxis = 0

        /// client sent invalid axis source enumeration value
        case invalidAxisSource = 1
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
/// Virtual Pointer Manager
/// 
/// This object allows clients to create individual virtual pointer objects.
public final class ZwlrVirtualPointerManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_virtual_pointer_manager_v1",
            version: 2,
            enums: [],
            requests: [
                Message(
                    name: "create_virtual_pointer",
                    arguments: [
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat"
                    ),
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwlr_virtual_pointer_v1"
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 1
                ),
                Message(
                    name: "create_virtual_pointer_with_output",
                    arguments: [
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat"
                    ),
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output"
                    ),
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwlr_virtual_pointer_v1"
                    ),
                    ],
                    since: 2
                ),
                ],
            events: [
                ],
        )
    /// Create A New Virtual Pointer
    /// 
    /// Creates a new virtual pointer. The optional seat is a suggestion to the
    /// compositor.
    /// 
    /// - Parameters:
    public func createVirtualPointer(seat: WlSeat? = nil, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrVirtualPointerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwlrVirtualPointerV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(seat?.id ?? 0),
            .object(id.id),
        ])
        return id
    }

    /// Destroy The Virtual Pointer Manager
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 1 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 1) }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    /// Create A New Virtual Pointer
    /// 
    /// Creates a new virtual pointer. The seat and the output arguments are
    /// optional. If the seat argument is set, the compositor should assign the
    /// input device to the requested seat. If the output argument is set, the
    /// compositor should map the input device to the requested output.
    /// 
    /// - Parameters:
    public func createVirtualPointerWithOutput(seat: WlSeat? = nil, output: WlOutput? = nil, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrVirtualPointerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let id = connection.createProxy(type: ZwlrVirtualPointerV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(seat?.id ?? 0),
            .object(output?.id ?? 0),
            .object(id.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrVirtualPointerUnstableV1)
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

public let WlrVirtualPointerUnstableV1 = Protocol(
        name: "wlr_virtual_pointer_unstable_v1",
        interfaces: [
            ZwlrVirtualPointerV1.interface,
ZwlrVirtualPointerManagerV1.interface
        ]
    )

#endif