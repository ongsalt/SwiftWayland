import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WLR
/// Manager To Inform Clients And Begin Capturing
/// 
/// This object is a manager with which to start capturing from sources.
public final class ZwlrExportDmabufManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_export_dmabuf_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "capture_output",
                    arguments: [
                        Argument(
                            name: "frame",
                            type: .newId,
                            interface: "zwlr_export_dmabuf_frame_v1",
                        ),
                        Argument(
                            name: "overlay_cursor",
                            type: .int,
                        ),
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        ),
                    ],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
        )
    /// Capture A Frame From An Output
    /// 
    /// Capture the next frame of an entire output.
    /// 
    /// - Parameters:
    ///   - overlayCursor: include custom client hardware cursor on top of the frame
    public func captureOutput(overlayCursor: Int32, output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrExportDmabufFrameV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let frame = connection.createProxy(type: ZwlrExportDmabufFrameV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(frame.id),
            .int(overlayCursor),
            .object(output.id),
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
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrExportDmabufUnstableV1Protocol
    
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

/// A Dma-Buf Frame
/// 
/// This object represents a single DMA-BUF frame.
/// If the capture is successful, the compositor will first send a "frame"
/// event, followed by one or several "object". When the frame is available
/// for readout, the "ready" event is sent.
/// If the capture failed, the "cancel" event is sent. This can happen anytime
/// before the "ready" event.
/// Once either a "ready" or a "cancel" event is received, the client should
/// destroy the frame. Once an "object" event is received, the client is
/// responsible for closing the associated file descriptor.
/// All frames are read-only and may not be written into or altered.
public final class ZwlrExportDmabufFrameV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_export_dmabuf_frame_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "frame",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .uint,
                        ),
                        Argument(
                            name: "height",
                            type: .uint,
                        ),
                        Argument(
                            name: "offset_x",
                            type: .uint,
                        ),
                        Argument(
                            name: "offset_y",
                            type: .uint,
                        ),
                        Argument(
                            name: "buffer_flags",
                            type: .uint,
                        ),
                        Argument(
                            name: "flags",
                            type: .uint,
                        ),
                        Argument(
                            name: "format",
                            type: .uint,
                        ),
                        Argument(
                            name: "mod_high",
                            type: .uint,
                        ),
                        Argument(
                            name: "mod_low",
                            type: .uint,
                        ),
                        Argument(
                            name: "num_objects",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "object",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .uint,
                        ),
                        Argument(
                            name: "fd",
                            type: .fd,
                        ),
                        Argument(
                            name: "size",
                            type: .uint,
                        ),
                        Argument(
                            name: "offset",
                            type: .uint,
                        ),
                        Argument(
                            name: "stride",
                            type: .uint,
                        ),
                        Argument(
                            name: "plane_index",
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
                    name: "cancel",
                    arguments: [
                        Argument(
                            name: "reason",
                            type: .uint,
                        ),
                    ],
                ),
            ]
        )
    /// Delete This Object, Used Or Not
    /// 
    /// Unreferences the frame. This request must be called as soon as it's no
    /// longer used.
    /// It can be called at any time by the client. The client will still have
    /// to close any FDs it has been given.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrExportDmabufUnstableV1Protocol
    
    public enum Flags: UInt32 {
        /// clients should copy frame before processing
        case transient = 1
    }

    public enum CancelReason: UInt32 {
        /// temporary error, source will produce more frames
        case temporary = 0

        /// fatal error, source will not produce frames
        case permanent = 1

        /// temporary error, source will produce more frames
        case resizing = 2
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

    public enum Event: MessageProtocol {
        /// A Frame Description
        /// 
        /// Main event supplying the client with information about the frame. If the
        /// capture didn't fail, this event is always emitted first before any other
        /// events.
        /// This event is followed by a number of "object" as specified by the
        /// "num_objects" argument.
        case frame(width: UInt32, height: UInt32, offsetX: UInt32, offsetY: UInt32, bufferFlags: UInt32, flags: Flags, format: UInt32, modHigh: UInt32, modLow: UInt32, numObjects: UInt32)

        /// An Object Description
        /// 
        /// Event which serves to supply the client with the file descriptors
        /// containing the data for each object.
        /// After receiving this event, the client must always close the file
        /// descriptor as soon as they're done with it and even if the frame fails.
        case object(index: UInt32, fd: FileHandle, size: UInt32, offset: UInt32, stride: UInt32, planeIndex: UInt32)

        /// Indicates Frame Is Available For Reading
        /// 
        /// This event is sent as soon as the frame is presented, indicating it is
        /// available for reading. This event includes the time at which
        /// presentation happened at.
        /// The timestamp is expressed as tv_sec_hi, tv_sec_lo, tv_nsec triples,
        /// each component being an unsigned 32-bit value. Whole seconds are in
        /// tv_sec which is a 64-bit value combined from tv_sec_hi and tv_sec_lo,
        /// and the additional fractional part in tv_nsec as nanoseconds. Hence,
        /// for valid timestamps tv_nsec must be in [0, 999999999]. The seconds part
        /// may have an arbitrary offset at start.
        /// After receiving this event, the client should destroy this object.
        case ready(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32)

        /// Indicates The Frame Is No Longer Valid
        /// 
        /// If the capture failed or if the frame is no longer valid after the
        /// "frame" event has been emitted, this event will be used to inform the
        /// client to scrap the frame.
        /// If the failure is temporary, the client may capture again the same
        /// source. If the failure is permanent, any further attempts to capture the
        /// same source will fail again.
        /// After receiving this event, the client should destroy this object.
        case cancel(reason: CancelReason)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.frame(width: r.uint(), height: r.uint(), offsetX: r.uint(), offsetY: r.uint(), bufferFlags: r.uint(), flags: try _parseEnum(into: Flags.self, r.uint()), format: r.uint(), modHigh: r.uint(), modLow: r.uint(), numObjects: r.uint())
            case 1:
                self = Self.object(index: r.uint(), fd: r.fd(), size: r.uint(), offset: r.uint(), stride: r.uint(), planeIndex: r.uint())
            case 2:
                self = Self.ready(tvSecHi: r.uint(), tvSecLo: r.uint(), tvNsec: r.uint())
            case 3:
                self = Self.cancel(reason: try _parseEnum(into: CancelReason.self, r.uint()))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WlrExportDmabufUnstableV1Protocol = Protocol(
        name: "wlr_export_dmabuf_unstable_v1",
        interfaces: [
            ZwlrExportDmabufManagerV1.interface,
ZwlrExportDmabufFrameV1.interface
        ]
    )

#endif