import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Protocol For Managing Pipewire Feeds Of The Different Displays And Windows
/// 
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class ZkdeScreencastUnstableV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zkde_screencast_unstable_v1",
            version: 6,
            requests: [
                Message(
                    name: "stream_output",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        ),
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        ),
                        Argument(
                            name: "pointer",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "stream_window",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        ),
                        Argument(
                            name: "window_uuid",
                            type: .string,
                        ),
                        Argument(
                            name: "pointer",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "stream_virtual_output",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        ),
                        Argument(
                            name: "name",
                            type: .string,
                        ),
                        Argument(
                            name: "width",
                            type: .int,
                        ),
                        Argument(
                            name: "height",
                            type: .int,
                        ),
                        Argument(
                            name: "scale",
                            type: .fixed,
                        ),
                        Argument(
                            name: "pointer",
                            type: .uint,
                        ),
                    ],
                    since: 2
                ),
                Message(
                    name: "stream_region",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        ),
                        Argument(
                            name: "x",
                            type: .int,
                        ),
                        Argument(
                            name: "y",
                            type: .int,
                        ),
                        Argument(
                            name: "width",
                            type: .uint,
                        ),
                        Argument(
                            name: "height",
                            type: .uint,
                        ),
                        Argument(
                            name: "scale",
                            type: .fixed,
                        ),
                        Argument(
                            name: "pointer",
                            type: .uint,
                        ),
                    ],
                    since: 3
                ),
                Message(
                    name: "stream_virtual_output_with_description",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        ),
                        Argument(
                            name: "name",
                            type: .string,
                        ),
                        Argument(
                            name: "description",
                            type: .string,
                        ),
                        Argument(
                            name: "width",
                            type: .int,
                        ),
                        Argument(
                            name: "height",
                            type: .int,
                        ),
                        Argument(
                            name: "scale",
                            type: .fixed,
                        ),
                        Argument(
                            name: "pointer",
                            type: .uint,
                        ),
                    ],
                    since: 4
                ),
            ],
        )
    /// Requests A Feed From A Given Source
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - pointer: Requested pointer mode
    public func streamOutput(output: WlOutput, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(stream.id),
            .object(output.id),
            .uint(pointer),
        ])
        return stream
    }

    /// Requests A Feed From A Given Source
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - windowUuid: window Identifier
    ///   - pointer: Requested pointer mode
    public func streamWindow(windowUuid: String, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(stream.id),
            .string(windowUuid),
            .uint(pointer),
        ])
        return stream
    }

    /// Destroy The Zkde_Screencast_Unstable_V1
    /// 
    /// Destroy the zkde_screencast_unstable_v1 object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    /// Requests A Feed From A New Virtual Output
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - name: name of the created output
    ///   - width: Logical width resolution
    ///   - height: Logical height resolution
    ///   - scale: Scaling factor of the display where it's to be displayed
    ///   - pointer: Requested pointer mode
    public func streamVirtualOutput(name: String, width: Int32, height: Int32, scale: Double, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 3, [
            .object(stream.id),
            .string(name),
            .int(width),
            .int(height),
            .fixed(scale),
            .uint(pointer),
        ])
        return stream
    }

    /// Requests A Feed From Region In The Workspace
    /// 
    /// Since version 5, the compositor will choose the highest scale
    /// factor for the region if the given scale is 0.0.
    /// 
    /// - Parameters:
    ///   - x: Logical left position
    ///   - y: Logical top position
    ///   - width: Logical width resolution
    ///   - height: Logical height resolution
    ///   - scale: Scaling factor of the output recording
    ///   - pointer: Requested pointer mode
    public func streamRegion(x: Int32, y: Int32, width: UInt32, height: UInt32, scale: Double, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 4, [
            .object(stream.id),
            .int(x),
            .int(y),
            .uint(width),
            .uint(height),
            .fixed(scale),
            .uint(pointer),
        ])
        return stream
    }

    /// Requests A Feed From A New Virtual Output
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - name: name of the created output
    ///   - description: user visible description of the created output
    ///   - width: Logical width resolution
    ///   - height: Logical height resolution
    ///   - scale: Scaling factor of the display where it's to be displayed
    ///   - pointer: Requested pointer mode
    public func streamVirtualOutputWithDescription(name: String, description: String, width: Int32, height: Int32, scale: Double, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 5, [
            .object(stream.id),
            .string(name),
            .string(description),
            .int(width),
            .int(height),
            .fixed(scale),
            .uint(pointer),
        ])
        return stream
    }

    
    public static let `protocol`: Protocol = ZkdeScreencastUnstableV1Protocol
    
    public enum Pointer: UInt32 {
        /// No cursor
        case hidden = 1

        /// Render the cursor on the stream
        case embedded = 2

        /// Send metadata about where the cursor is through PipeWire
        case `metadata` = 4
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

public final class ZkdeScreencastStreamUnstableV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zkde_screencast_stream_unstable_v1",
            version: 6,
            requests: [
                Message(
                    name: "close",
                    type: .destructor,
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "closed",
                    arguments: [],
                ),
                Message(
                    name: "created",
                    arguments: [
                        Argument(
                            name: "node",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "failed",
                    arguments: [
                        Argument(
                            name: "error",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "serial",
                    arguments: [
                        Argument(
                            name: "object_serial_hi",
                            type: .uint,
                        ),
                        Argument(
                            name: "object_serial_low",
                            type: .uint,
                        ),
                    ],
                    since: 6
                ),
            ]
        )
    /// Indicates We Are Done With The Stream And The Communication Is Over.
    /// 
    /// 
    public func close() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = ZkdeScreencastUnstableV1Protocol
    
    var destructor: Destructor? = .close

    enum Destructor {
        case close
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .close: try? self.close()
                case nil: break
            }
        }
    }

    public enum Event: MessageProtocol {
        /// Notifies That The Server Has Stopped The Stream. Clients Should Now Call Close.
        /// 
        /// 
        case closed

        /// Notifies About A Pipewire Feed Being Created
        /// 
        /// Deprecated since version 6, use the object serial from the serial event instead
        case created(node: UInt32)

        /// Offers An Error Message So The Client Knows The Created Event Will Not Arrive, And The Client Should Close The Resource.
        /// 
        /// 
        case failed(error: String)

        /// The Pipewire Object Serial
        /// 
        /// The pipewire object serial of the stream. Should be preferred over the node id which is prone to id reuse.
        /// Will be sent before the created event.
        case serial(objectSerialHi: UInt32, objectSerialLow: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.closed
            case 1:
                self = Self.created(node: r.uint())
            case 2:
                self = Self.failed(error: r.string())
            case 3:
                self = Self.serial(objectSerialHi: r.uint(), objectSerialLow: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let ZkdeScreencastUnstableV1Protocol = Protocol(
        name: "zkde_screencast_unstable_v1",
        interfaces: [
            ZkdeScreencastUnstableV1.interface,
ZkdeScreencastStreamUnstableV1.interface
        ]
    )

#endif