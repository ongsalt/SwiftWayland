import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WLR
/// Manager To Inform Clients And Begin Capturing
/// 
/// This object is a manager which offers requests to start capturing from a
/// source.
public final class ZwlrScreencopyManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_screencopy_manager_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "capture_output",
                    arguments: [
                    Argument(
                        name: "frame",
                        type: .newId,
                        interface: "zwlr_screencopy_frame_v1"
                    ),
                    Argument(
                        name: "overlay_cursor",
                        type: .int,
                    ),
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output"
                    ),
                    ],
                ),
                Message(
                    name: "capture_output_region",
                    arguments: [
                    Argument(
                        name: "frame",
                        type: .newId,
                        interface: "zwlr_screencopy_frame_v1"
                    ),
                    Argument(
                        name: "overlay_cursor",
                        type: .int,
                    ),
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output"
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
                        type: .int,
                    ),
                    Argument(
                        name: "height",
                        type: .int,
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
    /// Capture An Output
    /// 
    /// Capture the next frame of an entire output.
    /// 
    /// - Parameters:
    ///   - overlayCursor: composite cursor onto the frame
    public func captureOutput(overlayCursor: Int32, output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrScreencopyFrameV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let frame = connection.createProxy(type: ZwlrScreencopyFrameV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(frame.id),
            .int(overlayCursor),
            .object(output.id),
        ])
        return frame
    }

    /// Capture An Output's Region
    /// 
    /// Capture the next frame of an output's region.
    /// The region is given in output logical coordinates, see
    /// xdg_output.logical_size. The region will be clipped to the output's
    /// extents.
    /// 
    /// - Parameters:
    ///   - overlayCursor: composite cursor onto the frame
    public func captureOutputRegion(overlayCursor: Int32, output: WlOutput, x: Int32, y: Int32, width: Int32, height: Int32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrScreencopyFrameV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let frame = connection.createProxy(type: ZwlrScreencopyFrameV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(frame.id),
            .int(overlayCursor),
            .object(output.id),
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
        return frame
    }

    /// Destroy The Manager
    /// 
    /// All objects created by the manager will still remain valid, until their
    /// appropriate destroy request has been called.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrScreencopyUnstableV1Protocol)
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
/// A Frame Ready For Copy
/// 
/// This object represents a single frame.
/// When created, a series of buffer events will be sent, each representing a
/// supported buffer type. The "buffer_done" event is sent afterwards to
/// indicate that all supported buffer types have been enumerated. The client
/// will then be able to send a "copy" request. If the capture is successful,
/// the compositor will send a "flags" event followed by a "ready" event.
/// For objects version 2 or lower, wl_shm buffers are always supported, ie.
/// the "buffer" event is guaranteed to be sent.
/// If the capture failed, the "failed" event is sent. This can happen anytime
/// before the "ready" event.
/// Once either a "ready" or a "failed" event is received, the client should
/// destroy the frame.
public final class ZwlrScreencopyFrameV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_screencopy_frame_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "copy",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "copy_with_damage",
                    arguments: [
                    Argument(
                        name: "buffer",
                        type: .object,
                        interface: "wl_buffer"
                    ),
                    ],
                    since: 2
                ),
                ],
            events: [
                Message(
                    name: "buffer",
                    arguments: [
                    Argument(
                        name: "format",
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
                    Argument(
                        name: "stride",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "flags",
                    arguments: [
                    Argument(
                        name: "flags",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "ready",
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
                    name: "failed",
                    arguments: [
                    ],
                ),
                Message(
                    name: "damage",
                    arguments: [
                    Argument(
                        name: "x",
                        type: .uint,
                    ),
                    Argument(
                        name: "y",
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
                    since: 2
                ),
                Message(
                    name: "linux_dmabuf",
                    arguments: [
                    Argument(
                        name: "format",
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
                    since: 3
                ),
                Message(
                    name: "buffer_done",
                    arguments: [
                    ],
                    since: 3
                ),
                ],
        )
    /// Copy The Frame
    /// 
    /// Copy the frame to the supplied buffer. The buffer must have the
    /// correct size, see zwlr_screencopy_frame_v1.buffer and
    /// zwlr_screencopy_frame_v1.linux_dmabuf. The buffer needs to have a
    /// supported format.
    /// If the frame is successfully copied, "flags" and "ready" events are
    /// sent. Otherwise, a "failed" event is sent.
    /// 
    /// - Parameters:
    public func `copy`(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(buffer.id),
        ])
    }

    /// Delete This Object, Used Or Not
    /// 
    /// Destroys the frame. This request can be sent at any time by the client.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    /// Copy The Frame When It's Damaged
    /// 
    /// Same as copy, except it waits until there is damage to copy.
    /// 
    /// - Parameters:
    public func copyWithDamage(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 2, [
            .object(buffer.id),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrScreencopyUnstableV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// the object has already been used to copy a wl_buffer
        case alreadyUsed = 0

        /// buffer attributes are invalid
        case invalidBuffer = 1
    }

    public struct Flags: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// contents are y-inverted
        static let yInvert = Flags(rawValue: 1)
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
        /// Wl_Shm Buffer Information
        /// 
        /// Provides information about wl_shm buffer parameters that need to be
        /// used for this frame. This event is sent once after the frame is created
        /// if wl_shm buffers are supported.
        case buffer(format: WlShm.Format, width: UInt32, height: UInt32, stride: UInt32)

        /// Frame Flags
        /// 
        /// Provides flags about the frame. This event is sent once before the
        /// "ready" event.
        case flags(flags: Flags)

        /// Indicates Frame Is Available For Reading
        /// 
        /// Called as soon as the frame is copied, indicating it is available
        /// for reading. This event includes the time at which the presentation took place.
        /// The timestamp is expressed as tv_sec_hi, tv_sec_lo, tv_nsec triples,
        /// each component being an unsigned 32-bit value. Whole seconds are in
        /// tv_sec which is a 64-bit value combined from tv_sec_hi and tv_sec_lo,
        /// and the additional fractional part in tv_nsec as nanoseconds. Hence,
        /// for valid timestamps tv_nsec must be in [0, 999999999]. The seconds part
        /// may have an arbitrary offset at start.
        /// After receiving this event, the client should destroy the object.
        case ready(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32)

        /// Frame Copy Failed
        /// 
        /// This event indicates that the attempted frame copy has failed.
        /// After receiving this event, the client should destroy the object.
        case failed

        /// Carries The Coordinates Of The Damaged Region
        /// 
        /// This event is sent right before the ready event when copy_with_damage is
        /// requested. It may be generated multiple times for each copy_with_damage
        /// request.
        /// The arguments describe a box around an area that has changed since the
        /// last copy request that was derived from the current screencopy manager
        /// instance.
        /// The union of all regions received between the call to copy_with_damage
        /// and a ready event is the total damage since the prior ready event.
        case damage(x: UInt32, y: UInt32, width: UInt32, height: UInt32)

        /// Linux-Dmabuf Buffer Information
        /// 
        /// Provides information about linux-dmabuf buffer parameters that need to
        /// be used for this frame. This event is sent once after the frame is
        /// created if linux-dmabuf buffers are supported.
        case linuxDmabuf(format: UInt32, width: UInt32, height: UInt32)

        /// All Buffer Types Reported
        /// 
        /// This event is sent once after all buffer events have been sent.
        /// The client should proceed to create a buffer of one of the supported
        /// types, and send a "copy" request.
        case bufferDone

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.buffer(format: try _parseEnum(into: WlShm.Format.self, r.uint()), width: r.uint(), height: r.uint(), stride: r.uint())
            case 1:
                self = Self.flags(flags: try _parseEnum(into: Flags.self, r.uint()))
            case 2:
                self = Self.ready(tvSecHi: r.uint(), tvSecLo: r.uint(), tvNsec: r.uint())
            case 3:
                self = Self.failed
            case 4:
                self = Self.damage(x: r.uint(), y: r.uint(), width: r.uint(), height: r.uint())
            case 5:
                self = Self.linuxDmabuf(format: r.uint(), width: r.uint(), height: r.uint())
            case 6:
                self = Self.bufferDone
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let WlrScreencopyUnstableV1Protocol = Protocol(
        name: "wlr_screencopy_unstable_v1",
        interfaces: [
            ZwlrScreencopyManagerV1.interface,
ZwlrScreencopyFrameV1.interface
        ]
    )

#endif