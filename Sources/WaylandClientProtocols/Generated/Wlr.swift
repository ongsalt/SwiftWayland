import Foundation
import WaylandClient

#if WLR
/// Manager To Control Data Devices
/// 
/// This interface is a manager that allows creating per-seat data device
/// controls.
public final class ZwlrDataControlManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_data_control_manager_v1",
            version: 2,
            requests: [
                Message(
                    name: "create_data_source",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_data_control_source_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_data_device",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_data_control_device_v1",
                        )
                        ,
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Create A New Data Source
    /// 
    /// Create a new data source.
    /// 
    /// - Returns: data source to create
    public func createDataSource(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrDataControlSourceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwlrDataControlSourceV1.self, version, _queue, [
            .newId,
        ])
        return id
    }

    /// Get A Data Device For A Seat
    /// 
    /// Create a data device that can be used to manage a seat's selection.
    /// 
    /// - Parameters:
    public func getDataDevice(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrDataControlDeviceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwlrDataControlDeviceV1.self, version, _queue, [
            .newId,
            .object(seat),
        ])
        return id
    }

    /// Destroy The Manager
    /// 
    /// All objects created by the manager will still remain valid, until their
    /// appropriate destroy request has been called.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrDataControlUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Manage A Data Device For A Seat
/// 
/// This interface allows a client to manage a seat's selection.
/// When the seat is destroyed, this object becomes inert.
public final class ZwlrDataControlDeviceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_data_control_device_v1",
            version: 2,
            requests: [
                Message(
                    name: "set_selection",
                    arguments: [
                        Argument(
                            name: "source",
                            type: .object,
                            interface: "zwlr_data_control_source_v1",
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_primary_selection",
                    arguments: [
                        Argument(
                            name: "source",
                            type: .object,
                            interface: "zwlr_data_control_source_v1",
                            nullable: true,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
            ],
            events: [
                Message(
                    name: "data_offer",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_data_control_offer_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "selection",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .object,
                            interface: "zwlr_data_control_offer_v1",
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "finished",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "primary_selection",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .object,
                            interface: "zwlr_data_control_offer_v1",
                            nullable: true,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
            ],
        )
    /// Copy Data To The Selection
    /// 
    /// This request asks the compositor to set the selection to the data from
    /// the source on behalf of the client.
    /// The given source may not be used in any further set_selection or
    /// set_primary_selection requests. Attempting to use a previously used
    /// source is a protocol error.
    /// To unset the selection, set the source to NULL.
    /// 
    /// - Parameters:
    public func setSelection(source: ZwlrDataControlSourceV1? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(source),
        ])
    }

    /// Destroy This Data Device
    /// 
    /// Destroys the data device object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    /// Copy Data To The Primary Selection
    /// 
    /// This request asks the compositor to set the primary selection to the
    /// data from the source on behalf of the client.
    /// The given source may not be used in any further set_selection or
    /// set_primary_selection requests. Attempting to use a previously used
    /// source is a protocol error.
    /// To unset the primary selection, set the source to NULL.
    /// The compositor will ignore this request if it does not support primary
    /// selection.
    /// 
    /// - Parameters:
    public func setPrimarySelection(source: ZwlrDataControlSourceV1? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 2, [
            .object(source),
        ])
    }

    
    public static let `protocol`: Protocol = WlrDataControlUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// source given to set_selection or set_primary_selection was already used before
        case usedSource = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Introduce A New Wlr_Data_Control_Offer
        /// 
        /// The data_offer event introduces a new wlr_data_control_offer object,
        /// which will subsequently be used in either the
        /// wlr_data_control_device.selection event (for the regular clipboard
        /// selections) or the wlr_data_control_device.primary_selection event (for
        /// the primary clipboard selections). Immediately following the
        /// wlr_data_control_device.data_offer event, the new data_offer object
        /// will send out wlr_data_control_offer.offer events to describe the MIME
        /// types it offers.
        case dataOffer(id: ZwlrDataControlOfferV1)

        /// Advertise New Selection
        /// 
        /// The selection event is sent out to notify the client of a new
        /// wlr_data_control_offer for the selection for this device. The
        /// wlr_data_control_device.data_offer and the wlr_data_control_offer.offer
        /// events are sent out immediately before this event to introduce the data
        /// offer object. The selection event is sent to a client when a new
        /// selection is set. The wlr_data_control_offer is valid until a new
        /// wlr_data_control_offer or NULL is received. The client must destroy the
        /// previous selection wlr_data_control_offer, if any, upon receiving this
        /// event.
        /// The first selection event is sent upon binding the
        /// wlr_data_control_device object.
        case selection(id: ZwlrDataControlOfferV1)

        /// This Data Control Is No Longer Valid
        /// 
        /// This data control object is no longer valid and should be destroyed by
        /// the client.
        case finished

        /// Advertise New Primary Selection
        /// 
        /// The primary_selection event is sent out to notify the client of a new
        /// wlr_data_control_offer for the primary selection for this device. The
        /// wlr_data_control_device.data_offer and the wlr_data_control_offer.offer
        /// events are sent out immediately before this event to introduce the data
        /// offer object. The primary_selection event is sent to a client when a
        /// new primary selection is set. The wlr_data_control_offer is valid until
        /// a new wlr_data_control_offer or NULL is received. The client must
        /// destroy the previous primary selection wlr_data_control_offer, if any,
        /// upon receiving this event.
        /// If the compositor supports primary selection, the first
        /// primary_selection event is sent upon binding the
        /// wlr_data_control_device object.
        case primarySelection(id: ZwlrDataControlOfferV1)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.dataOffer(id: r.newId(type: ZwlrDataControlOfferV1.self))
            case 1:
                self = Self.selection(id: r.object(type: ZwlrDataControlOfferV1.self))
            case 2:
                self = Self.finished
            case 3:
                self = Self.primarySelection(id: r.object(type: ZwlrDataControlOfferV1.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Offer To Transfer Data
/// 
/// The wlr_data_control_source object is the source side of a
/// wlr_data_control_offer. It is created by the source client in a data
/// transfer and provides a way to describe the offered data and a way to
/// respond to requests to transfer the data.
public final class ZwlrDataControlSourceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_data_control_source_v1",
            version: 1,
            requests: [
                Message(
                    name: "offer",
                    arguments: [
                        Argument(
                            name: "mime_type",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "send",
                    arguments: [
                        Argument(
                            name: "mime_type",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "cancelled",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Add An Offered Mime Type
    /// 
    /// This request adds a MIME type to the set of MIME types advertised to
    /// targets. Can be called several times to offer multiple types.
    /// Calling this after wlr_data_control_device.set_selection is a protocol
    /// error.
    /// 
    /// - Parameters:
    ///   - mimeType: MIME type offered by the data source
    public func offer(mimeType: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(mimeType),
        ])
    }

    /// Destroy This Source
    /// 
    /// Destroys the data source object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrDataControlUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// offer sent after wlr_data_control_device.set_selection
        case invalidOffer = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Send The Data
        /// 
        /// Request for data from the client. Send the data as the specified MIME
        /// type over the passed file descriptor, then close it.
        case send(mimeType: String, fd: FileHandle)

        /// Selection Was Cancelled
        /// 
        /// This data source is no longer valid. The data source has been replaced
        /// by another data source.
        /// The client should clean up and destroy this data source.
        case cancelled

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.send(mimeType: r.string(), fd: r.fd())
            case 1:
                self = Self.cancelled
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Offer To Transfer Data
/// 
/// A wlr_data_control_offer represents a piece of data offered for transfer
/// by another client (the source client). The offer describes the different
/// MIME types that the data can be converted to and provides the mechanism
/// for transferring the data directly from the source client.
public final class ZwlrDataControlOfferV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_data_control_offer_v1",
            version: 1,
            requests: [
                Message(
                    name: "receive",
                    arguments: [
                        Argument(
                            name: "mime_type",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "offer",
                    arguments: [
                        Argument(
                            name: "mime_type",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Request That The Data Is Transferred
    /// 
    /// To transfer the offered data, the client issues this request and
    /// indicates the MIME type it wants to receive. The transfer happens
    /// through the passed file descriptor (typically created with the pipe
    /// system call). The source client writes the data in the MIME type
    /// representation requested and then closes the file descriptor.
    /// The receiving client reads from the read end of the pipe until EOF and
    /// then closes its end, at which point the transfer is complete.
    /// This request may happen multiple times for different MIME types.
    /// 
    /// - Parameters:
    ///   - mimeType: MIME type desired by receiver
    ///   - fd: file descriptor for data transfer
    public func receive(mimeType: String, fd: FileHandle) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(mimeType),
            .fd(fd),
        ])
    }

    /// Destroy This Offer
    /// 
    /// Destroys the data offer object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrDataControlUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Advertise Offered Mime Type
        /// 
        /// Sent immediately after creating the wlr_data_control_offer object.
        /// One event per offered MIME type.
        case offer(mimeType: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.offer(mimeType: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WlrDataControlUnstableV1Protocol = Protocol(
        name: "wlr_data_control_unstable_v1",
        interfaces: [
            ZwlrDataControlManagerV1.interface,
ZwlrDataControlDeviceV1.interface,
ZwlrDataControlSourceV1.interface,
ZwlrDataControlOfferV1.interface
        ]
    )

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
                        )
                        ,
                        Argument(
                            name: "overlay_cursor",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
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
        let frame = connection.sendConstructor(self, 0, ZwlrExportDmabufFrameV1.self, version, _queue, [
            .newId,
            .int(overlayCursor),
            .object(output),
        ])
        return frame
    }

    /// Destroy The Manager
    /// 
    /// All objects created by the manager will still remain valid, until their
    /// appropriate destroy request has been called.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrExportDmabufUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
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
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "frame",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "offset_x",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "offset_y",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "buffer_flags",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "format",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "mod_high",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "mod_low",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "num_objects",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "object",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                        Argument(
                            name: "size",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "offset",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "stride",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "plane_index",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "ready",
                    arguments: [
                        Argument(
                            name: "tv_sec_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_sec_lo",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_nsec",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "cancel",
                    arguments: [
                        Argument(
                            name: "reason",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Delete This Object, Used Or Not
    /// 
    /// Unreferences the frame. This request must be called as soon as it's no
    /// longer used.
    /// It can be called at any time by the client. The client will still have
    /// to close any FDs it has been given.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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

    deinit {
        if self.isAlive {
            connection.destroy(self)
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
                self = Self.frame(width: r.uint(), height: r.uint(), offsetX: r.uint(), offsetY: r.uint(), bufferFlags: r.uint(), flags: try r.`enum`(Flags.self), format: r.uint(), modHigh: r.uint(), modLow: r.uint(), numObjects: r.uint())
            case 1:
                self = Self.object(index: r.uint(), fd: r.fd(), size: r.uint(), offset: r.uint(), stride: r.uint(), planeIndex: r.uint())
            case 2:
                self = Self.ready(tvSecHi: r.uint(), tvSecLo: r.uint(), tvNsec: r.uint())
            case 3:
                self = Self.cancel(reason: try r.`enum`(CancelReason.self))
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

/// List And Control Opened Apps
/// 
/// The purpose of this protocol is to enable the creation of taskbars
/// and docks by providing them with a list of opened applications and
/// letting them request certain actions on them, like maximizing, etc.
/// After a client binds the zwlr_foreign_toplevel_manager_v1, each opened
/// toplevel window will be sent via the toplevel event
public final class ZwlrForeignToplevelManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_foreign_toplevel_manager_v1",
            version: 3,
            requests: [
                Message(
                    name: "stop",
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "toplevel",
                    arguments: [
                        Argument(
                            name: "toplevel",
                            type: .newId,
                            interface: "zwlr_foreign_toplevel_handle_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "finished",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Stop Sending Events
    /// 
    /// Indicates the client no longer wishes to receive events for new toplevels.
    /// However the compositor may emit further toplevel_created events, until
    /// the finished event is emitted.
    /// The client must not send any more requests after this one.
    public func stop() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrForeignToplevelManagementUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// A Toplevel Has Been Created
        /// 
        /// This event is emitted whenever a new toplevel window is created. It
        /// is emitted for all toplevels, regardless of the app that has created
        /// them.
        /// All initial details of the toplevel(title, app_id, states, etc.) will
        /// be sent immediately after this event via the corresponding events in
        /// zwlr_foreign_toplevel_handle_v1.
        case toplevel(toplevel: ZwlrForeignToplevelHandleV1)

        /// The Compositor Has Finished With The Toplevel Manager
        /// 
        /// This event indicates that the compositor is done sending events to the
        /// zwlr_foreign_toplevel_manager_v1. The server will destroy the object
        /// immediately after sending this request, so it will become invalid and
        /// the client should free any resources associated with it.
        case finished

        public var isDestructor: Bool {
            switch self {
                case .finished:
                    true
                default:
                    false
            }
        }

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.toplevel(toplevel: r.newId(type: ZwlrForeignToplevelHandleV1.self))
            case 1:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// An Opened Toplevel
/// 
/// A zwlr_foreign_toplevel_handle_v1 object represents an opened toplevel
/// window. Each app may have multiple opened toplevels.
/// Each toplevel has a list of outputs it is visible on, conveyed to the
/// client with the output_enter and output_leave events.
public final class ZwlrForeignToplevelHandleV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_foreign_toplevel_handle_v1",
            version: 3,
            requests: [
                Message(
                    name: "set_maximized",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "unset_maximized",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_minimized",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "unset_minimized",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "activate",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "close",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_rectangle",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_fullscreen",
                    arguments: [
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                            nullable: true,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "unset_fullscreen",
                    arguments: [
                    ],
                    since: 2
                )
                ,
            ],
            events: [
                Message(
                    name: "title",
                    arguments: [
                        Argument(
                            name: "title",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "app_id",
                    arguments: [
                        Argument(
                            name: "app_id",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "output_enter",
                    arguments: [
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "output_leave",
                    arguments: [
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "state",
                    arguments: [
                        Argument(
                            name: "state",
                            type: .array,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "closed",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "parent",
                    arguments: [
                        Argument(
                            name: "parent",
                            type: .object,
                            interface: "zwlr_foreign_toplevel_handle_v1",
                            nullable: true,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
            ],
        )
    /// Requests That The Toplevel Be Maximized
    /// 
    /// Requests that the toplevel be maximized. If the maximized state actually
    /// changes, this will be indicated by the state event.
    public func setMaximized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Requests That The Toplevel Be Unmaximized
    /// 
    /// Requests that the toplevel be unmaximized. If the maximized state actually
    /// changes, this will be indicated by the state event.
    public func unsetMaximized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Requests That The Toplevel Be Minimized
    /// 
    /// Requests that the toplevel be minimized. If the minimized state actually
    /// changes, this will be indicated by the state event.
    public func setMinimized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    /// Requests That The Toplevel Be Unminimized
    /// 
    /// Requests that the toplevel be unminimized. If the minimized state actually
    /// changes, this will be indicated by the state event.
    public func unsetMinimized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    /// Activate The Toplevel
    /// 
    /// Request that this toplevel be activated on the given seat.
    /// There is no guarantee the toplevel will be actually activated.
    /// 
    /// - Parameters:
    public func activate(seat: WlSeat) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(seat),
        ])
    }

    /// Request That The Toplevel Be Closed
    /// 
    /// Send a request to the toplevel to close itself. The compositor would
    /// typically use a shell-specific method to carry out this request, for
    /// example by sending the xdg_toplevel.close event. However, this gives
    /// no guarantees the toplevel will actually be destroyed. If and when
    /// this happens, the zwlr_foreign_toplevel_handle_v1.closed event will
    /// be emitted.
    public func close() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
        ])
    }

    /// The Rectangle Which Represents The Toplevel
    /// 
    /// The rectangle of the surface specified in this request corresponds to
    /// the place where the app using this protocol represents the given toplevel.
    /// It can be used by the compositor as a hint for some operations, e.g
    /// minimizing. The client is however not required to set this, in which
    /// case the compositor is free to decide some default value.
    /// If the client specifies more than one rectangle, only the last one is
    /// considered.
    /// The dimensions are given in surface-local coordinates.
    /// Setting width=height=0 removes the already-set rectangle.
    /// 
    /// - Parameters:
    public func setRectangle(surface: WlSurface, x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .object(surface),
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
    }

    /// Destroy The Zwlr_Foreign_Toplevel_Handle_V1 Object
    /// 
    /// Destroys the zwlr_foreign_toplevel_handle_v1 object.
    /// This request should be called either when the client does not want to
    /// use the toplevel anymore or after the closed event to finalize the
    /// destruction of the object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 7, [
        ])
    }

    /// Request That The Toplevel Be Fullscreened
    /// 
    /// Requests that the toplevel be fullscreened on the given output. If the
    /// fullscreen state and/or the outputs the toplevel is visible on actually
    /// change, this will be indicated by the state and output_enter/leave
    /// events.
    /// The output parameter is only a hint to the compositor. Also, if output
    /// is NULL, the compositor should decide which output the toplevel will be
    /// fullscreened on, if at all.
    /// 
    /// - Parameters:
    public func setFullscreen(output: WlOutput? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 8, [
            .object(output),
        ])
    }

    /// Request That The Toplevel Be Unfullscreened
    /// 
    /// Requests that the toplevel be unfullscreened. If the fullscreen state
    /// actually changes, this will be indicated by the state event.
    public func unsetFullscreen() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 9, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrForeignToplevelManagementUnstableV1Protocol
    
    public enum State: UInt32 {
        /// the toplevel is maximized
        case maximized = 0

        /// the toplevel is minimized
        case minimized = 1

        /// the toplevel is active
        case activated = 2

        /// the toplevel is fullscreen
        case fullscreen = 3
    }

    public enum Error: UInt32 {
        /// the provided rectangle is invalid
        case invalidRectangle = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Title Change
        /// 
        /// This event is emitted whenever the title of the toplevel changes.
        case title(title: String)

        /// App-Id Change
        /// 
        /// This event is emitted whenever the app-id of the toplevel changes.
        case appId(appId: String)

        /// Toplevel Entered An Output
        /// 
        /// This event is emitted whenever the toplevel becomes visible on
        /// the given output. A toplevel may be visible on multiple outputs.
        case outputEnter(output: WlOutput)

        /// Toplevel Left An Output
        /// 
        /// This event is emitted whenever the toplevel stops being visible on
        /// the given output. It is guaranteed that an entered-output event
        /// with the same output has been emitted before this event.
        case outputLeave(output: WlOutput)

        /// The Toplevel State Changed
        /// 
        /// This event is emitted immediately after the zlw_foreign_toplevel_handle_v1
        /// is created and each time the toplevel state changes, either because of a
        /// compositor action or because of a request in this protocol.
        case state(state: UnsafeRawBufferPointer)

        /// All Information About The Toplevel Has Been Sent
        /// 
        /// This event is sent after all changes in the toplevel state have been
        /// sent.
        /// This allows changes to the zwlr_foreign_toplevel_handle_v1 properties
        /// to be seen as atomic, even if they happen via multiple events.
        case done

        /// This Toplevel Has Been Destroyed
        /// 
        /// This event means the toplevel has been destroyed. It is guaranteed there
        /// won't be any more events for this zwlr_foreign_toplevel_handle_v1. The
        /// toplevel itself becomes inert so any requests will be ignored except the
        /// destroy request.
        case closed

        /// Parent Change
        /// 
        /// This event is emitted whenever the parent of the toplevel changes.
        /// No event is emitted when the parent handle is destroyed by the client.
        case parent(parent: ZwlrForeignToplevelHandleV1)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.title(title: r.string())
            case 1:
                self = Self.appId(appId: r.string())
            case 2:
                self = Self.outputEnter(output: r.object(type: WlOutput.self))
            case 3:
                self = Self.outputLeave(output: r.object(type: WlOutput.self))
            case 4:
                self = Self.state(state: r.array())
            case 5:
                self = Self.done
            case 6:
                self = Self.closed
            case 7:
                self = Self.parent(parent: r.object(type: ZwlrForeignToplevelHandleV1.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WlrForeignToplevelManagementUnstableV1Protocol = Protocol(
        name: "wlr_foreign_toplevel_management_unstable_v1",
        interfaces: [
            ZwlrForeignToplevelManagerV1.interface,
ZwlrForeignToplevelHandleV1.interface
        ]
    )

/// Manager To Create Per-Output Gamma Controls
/// 
/// This interface is a manager that allows creating per-output gamma
/// controls.
public final class ZwlrGammaControlManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_gamma_control_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "get_gamma_control",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_gamma_control_v1",
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Get A Gamma Control For An Output
    /// 
    /// Create a gamma control that can be used to adjust gamma tables for the
    /// provided output.
    /// 
    /// - Parameters:
    public func getGammaControl(output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrGammaControlV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwlrGammaControlV1.self, version, _queue, [
            .newId,
            .object(output),
        ])
        return id
    }

    /// Destroy The Manager
    /// 
    /// All objects created by the manager will still remain valid, until their
    /// appropriate destroy request has been called.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrGammaControlUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Adjust Gamma Tables For An Output
/// 
/// This interface allows a client to adjust gamma tables for a particular
/// output.
/// The client will receive the gamma size, and will then be able to set gamma
/// tables. At any time the compositor can send a failed event indicating that
/// this object is no longer valid.
/// There can only be at most one gamma control object per output, which
/// has exclusive access to this particular output. When the gamma control
/// object is destroyed, the gamma table is restored to its original value.
public final class ZwlrGammaControlV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_gamma_control_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_gamma",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "gamma_size",
                    arguments: [
                        Argument(
                            name: "size",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "failed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Set The Gamma Table
    /// 
    /// Set the gamma table. The file descriptor can be memory-mapped to provide
    /// the raw gamma table, which contains successive gamma ramps for the red,
    /// green and blue channels. Each gamma ramp is an array of 16-byte unsigned
    /// integers which has the same length as the gamma size.
    /// The file descriptor data must have the same length as three times the
    /// gamma size.
    /// 
    /// - Parameters:
    ///   - fd: gamma table file descriptor
    public func setGamma(fd: FileHandle) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .fd(fd),
        ])
    }

    /// Destroy This Control
    /// 
    /// Destroys the gamma control object. If the object is still valid, this
    /// restores the original gamma tables.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrGammaControlUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// invalid gamma tables
        case invalidGamma = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Size Of Gamma Ramps
        /// 
        /// Advertise the size of each gamma ramp.
        /// This event is sent immediately when the gamma control object is created.
        case gammaSize(size: UInt32)

        /// Object No Longer Valid
        /// 
        /// This event indicates that the gamma control is no longer valid. This
        /// can happen for a number of reasons, including:
        /// - The output doesn't support gamma tables
        /// - Setting the gamma tables failed
        /// - Another client already has exclusive gamma control for this output
        /// - The compositor has transferred gamma control to another client
        /// Upon receiving this event, the client should destroy this object.
        case failed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.gammaSize(size: r.uint())
            case 1:
                self = Self.failed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WlrGammaControlUnstableV1Protocol = Protocol(
        name: "wlr_gamma_control_unstable_v1",
        interfaces: [
            ZwlrGammaControlManagerV1.interface,
ZwlrGammaControlV1.interface
        ]
    )

/// Inhibits Input Events To Other Clients
/// 
/// Clients can use this interface to prevent input events from being sent to
/// any surfaces but its own, which is useful for example in lock screen
/// software. It is assumed that access to this interface will be locked down
/// to whitelisted clients by the compositor.
/// Note! This protocol is deprecated and not intended for production use.
/// For screen lockers, use the ext-session-lock-v1 protocol.
public final class ZwlrInputInhibitManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_input_inhibit_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "get_inhibitor",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_input_inhibitor_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Inhibit Input To Other Clients
    /// 
    /// Activates the input inhibitor. As long as the inhibitor is active, the
    /// compositor will not send input events to other clients.
    public func getInhibitor(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrInputInhibitorV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwlrInputInhibitorV1.self, version, _queue, [
            .newId,
        ])
        return id
    }

    
    public static let `protocol`: Protocol = WlrInputInhibitUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// an input inhibitor is already in use on the compositor
        case alreadyInhibited = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Inhibits Input To Other Clients
/// 
/// While this resource exists, input to clients other than the owner of the
/// inhibitor resource will not receive input events. Any client which
/// previously had focus will receive a leave event and will not be given
/// focus again. The client that owns this resource will receive all input
/// events normally. The compositor will also disable all of its own input
/// processing (such as keyboard shortcuts) while the inhibitor is active.
/// The compositor may continue to send input events to selected clients,
/// such as an on-screen keyboard (via the input-method protocol).
public final class ZwlrInputInhibitorV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_input_inhibitor_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Input Inhibitor Object
    /// 
    /// Destroy the inhibitor and allow other clients to receive input.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrInputInhibitUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let WlrInputInhibitUnstableV1Protocol = Protocol(
        name: "wlr_input_inhibit_unstable_v1",
        interfaces: [
            ZwlrInputInhibitManagerV1.interface,
ZwlrInputInhibitorV1.interface
        ]
    )

/// Create Surfaces That Are Layers Of The Desktop
/// 
/// Clients can use this interface to assign the surface_layer role to
/// wl_surfaces. Such surfaces are assigned to a "layer" of the output and
/// rendered with a defined z-depth respective to each other. They may also be
/// anchored to the edges and corners of a screen and specify input handling
/// semantics. This interface should be suitable for the implementation of
/// many desktop shell components, and a broad number of other applications
/// that interact with the desktop.
public final class ZwlrLayerShellV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_layer_shell_v1",
            version: 5,
            requests: [
                Message(
                    name: "get_layer_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_layer_surface_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "layer",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "namespace",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 3
                )
                ,
            ],
        )
    /// Create A Layer_Surface From A Surface
    /// 
    /// Create a layer surface for an existing surface. This assigns the role of
    /// layer_surface, or raises a protocol error if another role is already
    /// assigned.
    /// Creating a layer surface from a wl_surface which has a buffer attached
    /// or committed is a client error, and any attempts by a client to attach
    /// or manipulate a buffer prior to the first layer_surface.configure call
    /// must also be treated as errors.
    /// After creating a layer_surface object and setting it up, the client
    /// must perform an initial commit without any buffer attached.
    /// The compositor will reply with a layer_surface.configure event.
    /// The client must acknowledge it and is then allowed to attach a buffer
    /// to map the surface.
    /// You may pass NULL for output to allow the compositor to decide which
    /// output to use. Generally this will be the one that the user most
    /// recently interacted with.
    /// Clients can specify a namespace that defines the purpose of the layer
    /// surface.
    /// 
    /// - Parameters:
    ///   - layer: layer to add this surface to
    ///   - namespace: namespace for the layer surface
    public func getLayerSurface(surface: WlSurface, output: WlOutput? = nil, layer: Layer, namespace: String, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrLayerSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwlrLayerSurfaceV1.self, version, _queue, [
            .newId,
            .object(surface),
            .object(output),
            .uint(layer.rawValue),
            .string(namespace),
        ])
        return id
    }

    /// Destroy The Layer_Shell Object
    /// 
    /// This request indicates that the client will not use the layer_shell
    /// object any more. Objects that have been created through this instance
    /// are not affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrLayerShellUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// wl_surface has another role
        case role = 0

        /// layer value is invalid
        case invalidLayer = 1

        /// wl_surface has a buffer attached or committed
        case alreadyConstructed = 2
    }

    public enum Layer: UInt32 {
        case background = 0

        case bottom = 1

        case top = 2

        case overlay = 3
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Layer Metadata Interface
/// 
/// An interface that may be implemented by a wl_surface, for surfaces that
/// are designed to be rendered as a layer of a stacked desktop-like
/// environment.
/// Layer surface state (layer, size, anchor, exclusive zone,
/// margin, interactivity) is double-buffered, and will be applied at the
/// time wl_surface.commit of the corresponding wl_surface is called.
/// Attaching a null buffer to a layer surface unmaps it.
/// Unmapping a layer_surface means that the surface cannot be shown by the
/// compositor until it is explicitly mapped again. The layer_surface
/// returns to the state it had right after layer_shell.get_layer_surface.
/// The client can re-map the surface by performing a commit without any
/// buffer attached, waiting for a configure event and handling it as usual.
public final class ZwlrLayerSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_layer_surface_v1",
            version: 5,
            requests: [
                Message(
                    name: "set_size",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_anchor",
                    arguments: [
                        Argument(
                            name: "anchor",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_exclusive_zone",
                    arguments: [
                        Argument(
                            name: "zone",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_margin",
                    arguments: [
                        Argument(
                            name: "top",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "right",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "bottom",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "left",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_keyboard_interactivity",
                    arguments: [
                        Argument(
                            name: "keyboard_interactivity",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_popup",
                    arguments: [
                        Argument(
                            name: "popup",
                            type: .object,
                            interface: "xdg_popup",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "ack_configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_layer",
                    arguments: [
                        Argument(
                            name: "layer",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "set_exclusive_edge",
                    arguments: [
                        Argument(
                            name: "edge",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 5
                )
                ,
            ],
            events: [
                Message(
                    name: "configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "closed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Sets The Size Of The Surface
    /// 
    /// Sets the size of the surface in surface-local coordinates. The
    /// compositor will display the surface centered with respect to its
    /// anchors.
    /// If you pass 0 for either value, the compositor will assign it and
    /// inform you of the assignment in the configure event. You must set your
    /// anchor to opposite edges in the dimensions you omit; not doing so is a
    /// protocol error. Both values are 0 by default.
    /// Size is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setSize(width: UInt32, height: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(width),
            .uint(height),
        ])
    }

    /// Configures The Anchor Point Of The Surface
    /// 
    /// Requests that the compositor anchor the surface to the specified edges
    /// and corners. If two orthogonal edges are specified (e.g. 'top' and
    /// 'left'), then the anchor point will be the intersection of the edges
    /// (e.g. the top left corner of the output); otherwise the anchor point
    /// will be centered on that edge, or in the center if none is specified.
    /// Anchor is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setAnchor(_ anchor: Anchor) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(anchor.rawValue),
        ])
    }

    /// Configures The Exclusive Geometry Of This Surface
    /// 
    /// Requests that the compositor avoids occluding an area with other
    /// surfaces. The compositor's use of this information is
    /// implementation-dependent - do not assume that this region will not
    /// actually be occluded.
    /// A positive value is only meaningful if the surface is anchored to one
    /// edge or an edge and both perpendicular edges. If the surface is not
    /// anchored, anchored to only two perpendicular edges (a corner), anchored
    /// to only two parallel edges or anchored to all edges, a positive value
    /// will be treated the same as zero.
    /// A positive zone is the distance from the edge in surface-local
    /// coordinates to consider exclusive.
    /// Surfaces that do not wish to have an exclusive zone may instead specify
    /// how they should interact with surfaces that do. If set to zero, the
    /// surface indicates that it would like to be moved to avoid occluding
    /// surfaces with a positive exclusive zone. If set to -1, the surface
    /// indicates that it would not like to be moved to accommodate for other
    /// surfaces, and the compositor should extend it all the way to the edges
    /// it is anchored to.
    /// For example, a panel might set its exclusive zone to 10, so that
    /// maximized shell surfaces are not shown on top of it. A notification
    /// might set its exclusive zone to 0, so that it is moved to avoid
    /// occluding the panel, but shell surfaces are shown underneath it. A
    /// wallpaper or lock screen might set their exclusive zone to -1, so that
    /// they stretch below or over the panel.
    /// The default value is 0.
    /// Exclusive zone is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setExclusiveZone(zone: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(zone),
        ])
    }

    /// Sets A Margin From The Anchor Point
    /// 
    /// Requests that the surface be placed some distance away from the anchor
    /// point on the output, in surface-local coordinates. Setting this value
    /// for edges you are not anchored to has no effect.
    /// The exclusive zone includes the margin.
    /// Margin is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setMargin(top: Int32, `right`: Int32, bottom: Int32, `left`: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .int(top),
            .int(`right`),
            .int(bottom),
            .int(`left`),
        ])
    }

    /// Requests Keyboard Events
    /// 
    /// Set how keyboard events are delivered to this surface. By default,
    /// layer shell surfaces do not receive keyboard events; this request can
    /// be used to change this.
    /// This setting is inherited by child surfaces set by the get_popup
    /// request.
    /// Layer surfaces receive pointer, touch, and tablet events normally. If
    /// you do not want to receive them, set the input region on your surface
    /// to an empty region.
    /// Keyboard interactivity is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    public func setKeyboardInteractivity(_ keyboardInteractivity: KeyboardInteractivity) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(keyboardInteractivity.rawValue),
        ])
    }

    /// Assign This Layer_Surface As An Xdg_Popup Parent
    /// 
    /// This assigns an xdg_popup's parent to this layer_surface.  This popup
    /// should have been created via xdg_surface::get_popup with the parent set
    /// to NULL, and this request must be invoked before committing the popup's
    /// initial state.
    /// See the documentation of xdg_popup for more details about what an
    /// xdg_popup is and how it is used.
    /// 
    /// - Parameters:
    public func getPopup(popup: XdgPopup) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .object(popup),
        ])
    }

    /// Ack A Configure Event
    /// 
    /// When a configure event is received, if a client commits the
    /// surface in response to the configure event, then the client
    /// must make an ack_configure request sometime before the commit
    /// request, passing along the serial of the configure event.
    /// If the client receives multiple configure events before it
    /// can respond to one, it only has to ack the last configure event.
    /// A client is not required to commit immediately after sending
    /// an ack_configure request - it may even ack_configure several times
    /// before its next surface commit.
    /// A client may send multiple ack_configure requests before committing, but
    /// only the last request sent before a commit indicates which configure
    /// event the client really is responding to.
    /// 
    /// - Parameters:
    ///   - serial: the serial from the configure event
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .uint(serial),
        ])
    }

    /// Destroy The Layer_Surface
    /// 
    /// This request destroys the layer surface.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 7, [
        ])
    }

    /// Change The Layer Of The Surface
    /// 
    /// Change the layer that the surface is rendered on.
    /// Layer is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - _: layer to move this surface to
    public func setLayer(_ layer: ZwlrLayerShellV1.Layer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 8, [
            .uint(layer.rawValue),
        ])
    }

    /// Set The Edge The Exclusive Zone Will Be Applied To
    /// 
    /// Requests an edge for the exclusive zone to apply. The exclusive
    /// edge will be automatically deduced from anchor points when possible,
    /// but when the surface is anchored to a corner, it will be necessary
    /// to set it explicitly to disambiguate, as it is not possible to deduce
    /// which one of the two corner edges should be used.
    /// The edge must be one the surface is anchored to, otherwise the
    /// invalid_exclusive_edge protocol error will be raised.
    /// 
    /// - Parameters:
    public func setExclusiveEdge(edge: Anchor) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        connection.send(self, 9, [
            .uint(edge.rawValue),
        ])
    }

    
    public static let `protocol`: Protocol = WlrLayerShellUnstableV1Protocol
    
    public enum KeyboardInteractivity: UInt32 {
        case `none` = 0

        case exclusive = 1

        case onDemand = 2
    }

    public enum Error: UInt32 {
        /// provided surface state is invalid
        case invalidSurfaceState = 0

        /// size is invalid
        case invalidSize = 1

        /// anchor bitfield is invalid
        case invalidAnchor = 2

        /// keyboard interactivity is invalid
        case invalidKeyboardInteractivity = 3

        /// exclusive edge is invalid given the surface anchors
        case invalidExclusiveEdge = 4
    }

    public struct Anchor: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// the top edge of the anchor rectangle
        public static let top = Anchor(rawValue: 1)

        /// the bottom edge of the anchor rectangle
        public static let bottom = Anchor(rawValue: 2)

        /// the left edge of the anchor rectangle
        public static let `left` = Anchor(rawValue: 4)

        /// the right edge of the anchor rectangle
        public static let `right` = Anchor(rawValue: 8)
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Suggest A Surface Change
        /// 
        /// The configure event asks the client to resize its surface.
        /// Clients should arrange their surface for the new states, and then send
        /// an ack_configure request with the serial sent in this configure event at
        /// some point before committing the new surface.
        /// The client is free to dismiss all but the last configure event it
        /// received.
        /// The width and height arguments specify the size of the window in
        /// surface-local coordinates.
        /// The size is a hint, in the sense that the client is free to ignore it if
        /// it doesn't resize, pick a smaller size (to satisfy aspect ratio or
        /// resize in steps of NxM pixels). If the client picks a smaller size and
        /// is anchored to two opposite anchors (e.g. 'top' and 'bottom'), the
        /// surface will be centered on this axis.
        /// If the width or height arguments are zero, it means the client should
        /// decide its own window dimension.
        case configure(serial: UInt32, width: UInt32, height: UInt32)

        /// Surface Should Be Closed
        /// 
        /// The closed event is sent by the compositor when the surface will no
        /// longer be shown. The output may have been destroyed or the user may
        /// have asked for it to be removed. Further changes to the surface will be
        /// ignored. The client should destroy the resource after receiving this
        /// event, and create a new surface if they so choose.
        case closed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(serial: r.uint(), width: r.uint(), height: r.uint())
            case 1:
                self = Self.closed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WlrLayerShellUnstableV1Protocol = Protocol(
        name: "wlr_layer_shell_unstable_v1",
        interfaces: [
            ZwlrLayerShellV1.interface,
ZwlrLayerSurfaceV1.interface
        ]
    )

/// Output Device Configuration Manager
/// 
/// This interface is a manager that allows reading and writing the current
/// output device configuration.
/// Output devices that display pixels (e.g. a physical monitor or a virtual
/// output in a window) are represented as heads. Heads cannot be created nor
/// destroyed by the client, but they can be enabled or disabled and their
/// properties can be changed. Each head may have one or more available modes.
/// Whenever a head appears (e.g. a monitor is plugged in), it will be
/// advertised via the head event. Immediately after the output manager is
/// bound, all current heads are advertised.
/// Whenever a head's properties change, the relevant wlr_output_head events
/// will be sent. Not all head properties will be sent: only properties that
/// have changed need to.
/// Whenever a head disappears (e.g. a monitor is unplugged), a
/// wlr_output_head.finished event will be sent.
/// After one or more heads appear, change or disappear, the done event will
/// be sent. It carries a serial which can be used in a create_configuration
/// request to update heads properties.
/// The information obtained from this protocol should only be used for output
/// configuration purposes. This protocol is not designed to be a generic
/// output property advertisement protocol for regular clients. Instead,
/// protocols such as xdg-output should be used.
public final class ZwlrOutputManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_manager_v1",
            version: 4,
            requests: [
                Message(
                    name: "create_configuration",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_output_configuration_v1",
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "stop",
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "head",
                    arguments: [
                        Argument(
                            name: "head",
                            type: .newId,
                            interface: "zwlr_output_head_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "finished",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Create A New Output Configuration Object
    /// 
    /// Create a new output configuration object. This allows to update head
    /// properties.
    /// 
    /// - Parameters:
    public func createConfiguration(serial: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrOutputConfigurationV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwlrOutputConfigurationV1.self, version, _queue, [
            .newId,
            .uint(serial),
        ])
        return id
    }

    /// Stop Sending Events
    /// 
    /// Indicates the client no longer wishes to receive events for output
    /// configuration changes. However the compositor may emit further events,
    /// until the finished event is emitted.
    /// The client must not send any more requests after this one.
    public func stop() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Introduce A New Head
        /// 
        /// This event introduces a new head. This happens whenever a new head
        /// appears (e.g. a monitor is plugged in) or after the output manager is
        /// bound.
        case head(head: ZwlrOutputHeadV1)

        /// Sent All Information About Current Configuration
        /// 
        /// This event is sent after all information has been sent after binding to
        /// the output manager object and after any subsequent changes. This applies
        /// to child head and mode objects as well. In other words, this event is
        /// sent whenever a head or mode is created or destroyed and whenever one of
        /// their properties has been changed. Not all state is re-sent each time
        /// the current configuration changes: only the actual changes are sent.
        /// This allows changes to the output configuration to be seen as atomic,
        /// even if they happen via multiple events.
        /// A serial is sent to be used in a future create_configuration request.
        case done(serial: UInt32)

        /// The Compositor Has Finished With The Manager
        /// 
        /// This event indicates that the compositor is done sending manager events.
        /// The compositor will destroy the object immediately after sending this
        /// event, so it will become invalid and the client should release any
        /// resources associated with it.
        case finished

        public var isDestructor: Bool {
            switch self {
                case .finished:
                    true
                default:
                    false
            }
        }

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.head(head: r.newId(type: ZwlrOutputHeadV1.self))
            case 1:
                self = Self.done(serial: r.uint())
            case 2:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Output Device
/// 
/// A head is an output device. The difference between a wl_output object and
/// a head is that heads are advertised even if they are turned off. A head
/// object only advertises properties and cannot be used directly to change
/// them.
/// A head has some read-only properties: modes, name, description and
/// physical_size. These cannot be changed by clients.
/// Other properties can be updated via a wlr_output_configuration object.
/// Properties sent via this interface are applied atomically via the
/// wlr_output_manager.done event. No guarantees are made regarding the order
/// in which properties are sent.
public final class ZwlrOutputHeadV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_head_v1",
            version: 4,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 3
                )
                ,
            ],
            events: [
                Message(
                    name: "name",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "description",
                    arguments: [
                        Argument(
                            name: "description",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "physical_size",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .newId,
                            interface: "zwlr_output_mode_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "enabled",
                    arguments: [
                        Argument(
                            name: "enabled",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "current_mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .object,
                            interface: "zwlr_output_mode_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "position",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "transform",
                    arguments: [
                        Argument(
                            name: "transform",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "scale",
                    arguments: [
                        Argument(
                            name: "scale",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "finished",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "make",
                    arguments: [
                        Argument(
                            name: "make",
                            type: .string,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "model",
                    arguments: [
                        Argument(
                            name: "model",
                            type: .string,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "serial_number",
                    arguments: [
                        Argument(
                            name: "serial_number",
                            type: .string,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "adaptive_sync",
                    arguments: [
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
            ],
        )
    /// Destroy The Head Object
    /// 
    /// This request indicates that the client will no longer use this head
    /// object.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
    public enum AdaptiveSyncState: UInt32 {
        /// adaptive sync is disabled
        case disabled = 0

        /// adaptive sync is enabled
        case enabled = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Head Name
        /// 
        /// This event describes the head name.
        /// The naming convention is compositor defined, but limited to alphanumeric
        /// characters and dashes (-). Each name is unique among all wlr_output_head
        /// objects, but if a wlr_output_head object is destroyed the same name may
        /// be reused later. The names will also remain consistent across sessions
        /// with the same hardware and software configuration.
        /// Examples of names include 'HDMI-A-1', 'WL-1', 'X11-1', etc. However, do
        /// not assume that the name is a reflection of an underlying DRM
        /// connector, X11 connection, etc.
        /// If this head matches a wl_output, the wl_output.name event must report
        /// the same name.
        /// The name event is sent after a wlr_output_head object is created. This
        /// event is only sent once per object, and the name does not change over
        /// the lifetime of the wlr_output_head object.
        case name(name: String)

        /// Head Description
        /// 
        /// This event describes a human-readable description of the head.
        /// The description is a UTF-8 string with no convention defined for its
        /// contents. Examples might include 'Foocorp 11" Display' or 'Virtual X11
        /// output via :1'. However, do not assume that the name is a reflection of
        /// the make, model, serial of the underlying DRM connector or the display
        /// name of the underlying X11 connection, etc.
        /// If this head matches a wl_output, the wl_output.description event must
        /// report the same name.
        /// The description event is sent after a wlr_output_head object is created.
        /// This event is only sent once per object, and the description does not
        /// change over the lifetime of the wlr_output_head object.
        case description(description: String)

        /// Head Physical Size
        /// 
        /// This event describes the physical size of the head. This event is only
        /// sent if the head has a physical size (e.g. is not a projector or a
        /// virtual device).
        /// The physical size event is sent after a wlr_output_head object is created. This
        /// event is only sent once per object, and the physical size does not change over
        /// the lifetime of the wlr_output_head object.
        case physicalSize(width: Int32, height: Int32)

        /// Introduce A Mode
        /// 
        /// This event introduces a mode for this head. It is sent once per
        /// supported mode.
        case mode(mode: ZwlrOutputModeV1)

        /// Head Is Enabled Or Disabled
        /// 
        /// This event describes whether the head is enabled. A disabled head is not
        /// mapped to a region of the global compositor space.
        /// When a head is disabled, some properties (current_mode, position,
        /// transform and scale) are irrelevant.
        case enabled(enabled: Int32)

        /// Current Mode
        /// 
        /// This event describes the mode currently in use for this head. It is only
        /// sent if the output is enabled.
        case currentMode(mode: ZwlrOutputModeV1)

        /// Current Position
        /// 
        /// This events describes the position of the head in the global compositor
        /// space. It is only sent if the output is enabled.
        case position(x: Int32, y: Int32)

        /// Current Transformation
        /// 
        /// This event describes the transformation currently applied to the head.
        /// It is only sent if the output is enabled.
        case transform(transform: Int32)

        /// Current Scale
        /// 
        /// This events describes the scale of the head in the global compositor
        /// space. It is only sent if the output is enabled.
        case scale(scale: Double)

        /// The Head Has Disappeared
        /// 
        /// This event indicates that the head is no longer available. The head
        /// object becomes inert. Clients should send a destroy request and release
        /// any resources associated with it.
        case finished

        /// Head Manufacturer
        /// 
        /// This event describes the manufacturer of the head.
        /// Together with the model and serial_number events the purpose is to
        /// allow clients to recognize heads from previous sessions and for example
        /// load head-specific configurations back.
        /// It is not guaranteed this event will be ever sent. A reason for that
        /// can be that the compositor does not have information about the make of
        /// the head or the definition of a make is not sensible in the current
        /// setup, for example in a virtual session. Clients can still try to
        /// identify the head by available information from other events but should
        /// be aware that there is an increased risk of false positives.
        /// If sent, the make event is sent after a wlr_output_head object is
        /// created and only sent once per object. The make does not change over
        /// the lifetime of the wlr_output_head object.
        /// It is not recommended to display the make string in UI to users. For
        /// that the string provided by the description event should be preferred.
        case make(make: String)

        /// Head Model
        /// 
        /// This event describes the model of the head.
        /// Together with the make and serial_number events the purpose is to
        /// allow clients to recognize heads from previous sessions and for example
        /// load head-specific configurations back.
        /// It is not guaranteed this event will be ever sent. A reason for that
        /// can be that the compositor does not have information about the model of
        /// the head or the definition of a model is not sensible in the current
        /// setup, for example in a virtual session. Clients can still try to
        /// identify the head by available information from other events but should
        /// be aware that there is an increased risk of false positives.
        /// If sent, the model event is sent after a wlr_output_head object is
        /// created and only sent once per object. The model does not change over
        /// the lifetime of the wlr_output_head object.
        /// It is not recommended to display the model string in UI to users. For
        /// that the string provided by the description event should be preferred.
        case model(model: String)

        /// Head Serial Number
        /// 
        /// This event describes the serial number of the head.
        /// Together with the make and model events the purpose is to allow clients
        /// to recognize heads from previous sessions and for example load head-
        /// specific configurations back.
        /// It is not guaranteed this event will be ever sent. A reason for that
        /// can be that the compositor does not have information about the serial
        /// number of the head or the definition of a serial number is not sensible
        /// in the current setup. Clients can still try to identify the head by
        /// available information from other events but should be aware that there
        /// is an increased risk of false positives.
        /// If sent, the serial number event is sent after a wlr_output_head object
        /// is created and only sent once per object. The serial number does not
        /// change over the lifetime of the wlr_output_head object.
        /// It is not recommended to display the serial_number string in UI to
        /// users. For that the string provided by the description event should be
        /// preferred.
        case serialNumber(serialNumber: String)

        /// Current Adaptive Sync State
        /// 
        /// This event describes whether adaptive sync is currently enabled for
        /// the head or not. Adaptive sync is also known as Variable Refresh
        /// Rate or VRR.
        case adaptiveSync(state: AdaptiveSyncState)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.name(name: r.string())
            case 1:
                self = Self.description(description: r.string())
            case 2:
                self = Self.physicalSize(width: r.int(), height: r.int())
            case 3:
                self = Self.mode(mode: r.newId(type: ZwlrOutputModeV1.self))
            case 4:
                self = Self.enabled(enabled: r.int())
            case 5:
                self = Self.currentMode(mode: r.object(type: ZwlrOutputModeV1.self))
            case 6:
                self = Self.position(x: r.int(), y: r.int())
            case 7:
                self = Self.transform(transform: r.int())
            case 8:
                self = Self.scale(scale: r.fixed())
            case 9:
                self = Self.finished
            case 10:
                self = Self.make(make: r.string())
            case 11:
                self = Self.model(model: r.string())
            case 12:
                self = Self.serialNumber(serialNumber: r.string())
            case 13:
                self = Self.adaptiveSync(state: try r.`enum`(AdaptiveSyncState.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Output Mode
/// 
/// This object describes an output mode.
/// Some heads don't support output modes, in which case modes won't be
/// advertised.
/// Properties sent via this interface are applied atomically via the
/// wlr_output_manager.done event. No guarantees are made regarding the order
/// in which properties are sent.
public final class ZwlrOutputModeV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_mode_v1",
            version: 3,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 3
                )
                ,
            ],
            events: [
                Message(
                    name: "size",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "refresh",
                    arguments: [
                        Argument(
                            name: "refresh",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preferred",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "finished",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Mode Object
    /// 
    /// This request indicates that the client will no longer use this mode
    /// object.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Mode Size
        /// 
        /// This event describes the mode size. The size is given in physical
        /// hardware units of the output device. This is not necessarily the same as
        /// the output size in the global compositor space. For instance, the output
        /// may be scaled or transformed.
        case size(width: Int32, height: Int32)

        /// Mode Refresh Rate
        /// 
        /// This event describes the mode's fixed vertical refresh rate. It is only
        /// sent if the mode has a fixed refresh rate.
        case refresh(refresh: Int32)

        /// Mode Is Preferred
        /// 
        /// This event advertises this mode as preferred.
        case preferred

        /// The Mode Has Disappeared
        /// 
        /// This event indicates that the mode is no longer available. The mode
        /// object becomes inert. Clients should send a destroy request and release
        /// any resources associated with it.
        case finished

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.size(width: r.int(), height: r.int())
            case 1:
                self = Self.refresh(refresh: r.int())
            case 2:
                self = Self.preferred
            case 3:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Output Configuration
/// 
/// This object is used by the client to describe a full output configuration.
/// First, the client needs to setup the output configuration. Each head can
/// be either enabled (and configured) or disabled. It is a protocol error to
/// send two enable_head or disable_head requests with the same head. It is a
/// protocol error to omit a head in a configuration.
/// Then, the client can apply or test the configuration. The compositor will
/// then reply with a succeeded, failed or cancelled event. Finally the client
/// should destroy the configuration object.
public final class ZwlrOutputConfigurationV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_configuration_v1",
            version: 4,
            requests: [
                Message(
                    name: "enable_head",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_output_configuration_head_v1",
                        )
                        ,
                        Argument(
                            name: "head",
                            type: .object,
                            interface: "zwlr_output_head_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "disable_head",
                    arguments: [
                        Argument(
                            name: "head",
                            type: .object,
                            interface: "zwlr_output_head_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "apply",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "test",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "succeeded",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "failed",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "cancelled",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Enable And Configure A Head
    /// 
    /// Enable a head. This request creates a head configuration object that can
    /// be used to change the head's properties.
    /// 
    /// - Parameters:
    ///   - head: the head to be enabled
    /// 
    /// - Returns: a new object to configure the head
    public func enableHead(head: ZwlrOutputHeadV1, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrOutputConfigurationHeadV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwlrOutputConfigurationHeadV1.self, version, _queue, [
            .newId,
            .object(head),
        ])
        return id
    }

    /// Disable A Head
    /// 
    /// Disable a head.
    /// 
    /// - Parameters:
    ///   - head: the head to be disabled
    public func disableHead(head: ZwlrOutputHeadV1) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(head),
        ])
    }

    /// Apply The Configuration
    /// 
    /// Apply the new output configuration.
    /// In case the configuration is successfully applied, there is no guarantee
    /// that the new output state matches completely the requested
    /// configuration. For instance, a compositor might round the scale if it
    /// doesn't support fractional scaling.
    /// After this request has been sent, the compositor must respond with an
    /// succeeded, failed or cancelled event. Sending a request that isn't the
    /// destructor is a protocol error.
    public func apply() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    /// Test The Configuration
    /// 
    /// Test the new output configuration. The configuration won't be applied,
    /// but will only be validated.
    /// Even if the compositor succeeds to test a configuration, applying it may
    /// fail.
    /// After this request has been sent, the compositor must respond with an
    /// succeeded, failed or cancelled event. Sending a request that isn't the
    /// destructor is a protocol error.
    public func test() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    /// Destroy The Output Configuration
    /// 
    /// Using this request a client can tell the compositor that it is not going
    /// to use the configuration object anymore. Any changes to the outputs
    /// that have not been applied will be discarded.
    /// This request also destroys wlr_output_configuration_head objects created
    /// via this object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 4, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// head has been configured twice
        case alreadyConfiguredHead = 1

        /// head has not been configured
        case unconfiguredHead = 2

        /// request sent after configuration has been applied or tested
        case alreadyUsed = 3
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Configuration Changes Succeeded
        /// 
        /// Sent after the compositor has successfully applied the changes or
        /// tested them.
        /// Upon receiving this event, the client should destroy this object.
        /// If the current configuration has changed, events to describe the changes
        /// will be sent followed by a wlr_output_manager.done event.
        case succeeded

        /// Configuration Changes Failed
        /// 
        /// Sent if the compositor rejects the changes or failed to apply them. The
        /// compositor should revert any changes made by the apply request that
        /// triggered this event.
        /// Upon receiving this event, the client should destroy this object.
        case failed

        /// Configuration Has Been Cancelled
        /// 
        /// Sent if the compositor cancels the configuration because the state of an
        /// output changed and the client has outdated information (e.g. after an
        /// output has been hotplugged).
        /// The client can create a new configuration with a newer serial and try
        /// again.
        /// Upon receiving this event, the client should destroy this object.
        case cancelled

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.succeeded
            case 1:
                self = Self.failed
            case 2:
                self = Self.cancelled
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Head Configuration
/// 
/// This object is used by the client to update a single head's configuration.
/// It is a protocol error to set the same property twice.
public final class ZwlrOutputConfigurationHeadV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_configuration_head_v1",
            version: 4,
            requests: [
                Message(
                    name: "set_mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .object,
                            interface: "zwlr_output_mode_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_custom_mode",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "refresh",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_position",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_transform",
                    arguments: [
                        Argument(
                            name: "transform",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_scale",
                    arguments: [
                        Argument(
                            name: "scale",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_adaptive_sync",
                    arguments: [
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
            ],
        )
    /// Set The Mode
    /// 
    /// This request sets the head's mode.
    /// 
    /// - Parameters:
    public func setMode(_ mode: ZwlrOutputModeV1) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(mode),
        ])
    }

    /// Set A Custom Mode
    /// 
    /// This request assigns a custom mode to the head. The size is given in
    /// physical hardware units of the output device. If set to zero, the
    /// refresh rate is unspecified.
    /// It is a protocol error to set both a mode and a custom mode.
    /// 
    /// - Parameters:
    ///   - width: width of the mode in hardware units
    ///   - height: height of the mode in hardware units
    ///   - refresh: vertical refresh rate in mHz or zero
    public func setCustomMode(width: Int32, height: Int32, refresh: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .int(width),
            .int(height),
            .int(refresh),
        ])
    }

    /// Set The Position
    /// 
    /// This request sets the head's position in the global compositor space.
    /// 
    /// - Parameters:
    ///   - x: x position in the global compositor space
    ///   - y: y position in the global compositor space
    public func setPosition(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(x),
            .int(y),
        ])
    }

    /// Set The Transform
    /// 
    /// This request sets the head's transform.
    /// 
    /// - Parameters:
    public func setTransform(_ transform: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .int(transform),
        ])
    }

    /// Set The Scale
    /// 
    /// This request sets the head's scale.
    /// 
    /// - Parameters:
    public func setScale(_ scale: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .fixed(scale),
        ])
    }

    /// Enable/Disable Adaptive Sync
    /// 
    /// This request enables/disables adaptive sync. Adaptive sync is also
    /// known as Variable Refresh Rate or VRR.
    /// 
    /// - Parameters:
    public func setAdaptiveSync(state: ZwlrOutputHeadV1.AdaptiveSyncState) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 5, [
            .uint(state.rawValue),
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// property has already been set
        case alreadySet = 1

        /// mode doesn't belong to head
        case invalidMode = 2

        /// mode is invalid
        case invalidCustomMode = 3

        /// transform value outside enum
        case invalidTransform = 4

        /// scale negative or zero
        case invalidScale = 5

        /// invalid enum value used in the set_adaptive_sync request
        case invalidAdaptiveSyncState = 6
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let WlrOutputManagementUnstableV1Protocol = Protocol(
        name: "wlr_output_management_unstable_v1",
        interfaces: [
            ZwlrOutputManagerV1.interface,
ZwlrOutputHeadV1.interface,
ZwlrOutputModeV1.interface,
ZwlrOutputConfigurationV1.interface,
ZwlrOutputConfigurationHeadV1.interface
        ]
    )

/// Manager To Create Per-Output Power Management
/// 
/// This interface is a manager that allows creating per-output power
/// management mode controls.
public final class ZwlrOutputPowerManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_power_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "get_output_power",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_output_power_v1",
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Get A Power Management For An Output
    /// 
    /// Create an output power management mode control that can be used to
    /// adjust the power management mode for a given output.
    /// 
    /// - Parameters:
    public func getOutputPower(output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrOutputPowerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwlrOutputPowerV1.self, version, _queue, [
            .newId,
            .object(output),
        ])
        return id
    }

    /// Destroy The Manager
    /// 
    /// All objects created by the manager will still remain valid, until their
    /// appropriate destroy request has been called.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputPowerManagementUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Adjust Power Management Mode For An Output
/// 
/// This object offers requests to set the power management mode of
/// an output.
public final class ZwlrOutputPowerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_power_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "failed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Set An Outputs Power Save Mode
    /// 
    /// Set an output's power save mode to the given mode. The mode change
    /// is effective immediately. If the output does not support the given
    /// mode a failed event is sent.
    /// 
    /// - Parameters:
    ///   - _: the power save mode to set
    public func setMode(_ mode: Mode) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(mode.rawValue),
        ])
    }

    /// Destroy This Power Management
    /// 
    /// Destroys the output power management mode control object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputPowerManagementUnstableV1Protocol
    
    public enum Mode: UInt32 {
        /// Output is turned off.
        case off = 0

        /// Output is turned on, no power saving
        case on = 1
    }

    public enum Error: UInt32 {
        /// nonexistent power save mode
        case invalidMode = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Report A Power Management Mode Change
        /// 
        /// Report the power management mode change of an output.
        /// The mode event is sent after an output changed its power
        /// management mode. The reason can be a client using set_mode or the
        /// compositor deciding to change an output's mode.
        /// This event is also sent immediately when the object is created
        /// so the client is informed about the current power management mode.
        case mode(mode: Mode)

        /// Object No Longer Valid
        /// 
        /// This event indicates that the output power management mode control
        /// is no longer valid. This can happen for a number of reasons,
        /// including:
        /// - The output doesn't support power management
        /// - Another client already has exclusive power management mode control
        /// for this output
        /// - The output disappeared
        /// Upon receiving this event, the client should destroy this object.
        case failed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.mode(mode: try r.`enum`(Mode.self))
            case 1:
                self = Self.failed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WlrOutputPowerManagementUnstableV1Protocol = Protocol(
        name: "wlr_output_power_management_unstable_v1",
        interfaces: [
            ZwlrOutputPowerManagerV1.interface,
ZwlrOutputPowerV1.interface
        ]
    )

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
            requests: [
                Message(
                    name: "capture_output",
                    arguments: [
                        Argument(
                            name: "frame",
                            type: .newId,
                            interface: "zwlr_screencopy_frame_v1",
                        )
                        ,
                        Argument(
                            name: "overlay_cursor",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "capture_output_region",
                    arguments: [
                        Argument(
                            name: "frame",
                            type: .newId,
                            interface: "zwlr_screencopy_frame_v1",
                        )
                        ,
                        Argument(
                            name: "overlay_cursor",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                        Argument(
                            name: "x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
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
        let frame = connection.sendConstructor(self, 0, ZwlrScreencopyFrameV1.self, version, _queue, [
            .newId,
            .int(overlayCursor),
            .object(output),
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
        let frame = connection.sendConstructor(self, 1, ZwlrScreencopyFrameV1.self, version, _queue, [
            .newId,
            .int(overlayCursor),
            .object(output),
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
        connection.destroy(self)
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrScreencopyUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
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
            requests: [
                Message(
                    name: "copy",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "copy_with_damage",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                    since: 2
                )
                ,
            ],
            events: [
                Message(
                    name: "buffer",
                    arguments: [
                        Argument(
                            name: "format",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "stride",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "flags",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "ready",
                    arguments: [
                        Argument(
                            name: "tv_sec_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_sec_lo",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_nsec",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "failed",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "damage",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "linux_dmabuf",
                    arguments: [
                        Argument(
                            name: "format",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "buffer_done",
                    arguments: [
                    ],
                    since: 3
                )
                ,
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
            .object(buffer),
        ])
    }

    /// Delete This Object, Used Or Not
    /// 
    /// Destroys the frame. This request can be sent at any time by the client.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
            .object(buffer),
        ])
    }

    
    public static let `protocol`: Protocol = WlrScreencopyUnstableV1Protocol
    
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
        public static let yInvert = Flags(rawValue: 1)
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
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

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.buffer(format: try r.`enum`(WlShm.Format.self), width: r.uint(), height: r.uint(), stride: r.uint())
            case 1:
                self = Self.flags(flags: try r.`enum`(Flags.self))
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
            requests: [
                Message(
                    name: "motion",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "dx",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "dy",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "motion_absolute",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "x",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "x_extent",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "y_extent",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "button",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "button",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "axis",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "axis",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "value",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "frame",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "axis_source",
                    arguments: [
                        Argument(
                            name: "axis_source",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "axis_stop",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "axis",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "axis_discrete",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "axis",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "value",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "discrete",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 1
                )
                ,
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
        connection.destroy(self)
        connection.send(self, 8, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrVirtualPointerUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// client sent invalid axis enumeration value
        case invalidAxis = 0

        /// client sent invalid axis source enumeration value
        case invalidAxisSource = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
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
            requests: [
                Message(
                    name: "create_virtual_pointer",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_virtual_pointer_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 1
                )
                ,
                Message(
                    name: "create_virtual_pointer_with_output",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_virtual_pointer_v1",
                        )
                        ,
                    ],
                    since: 2
                )
                ,
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
        let id = connection.sendConstructor(self, 0, ZwlrVirtualPointerV1.self, version, _queue, [
            .object(seat),
            .newId,
        ])
        return id
    }

    /// Destroy The Virtual Pointer Manager
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 1 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 1) }
        connection.destroy(self)
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
        let id = connection.sendConstructor(self, 2, ZwlrVirtualPointerV1.self, version, _queue, [
            .object(seat),
            .object(output),
            .newId,
        ])
        return id
    }

    
    public static let `protocol`: Protocol = WlrVirtualPointerUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let WlrVirtualPointerUnstableV1Protocol = Protocol(
        name: "wlr_virtual_pointer_unstable_v1",
        interfaces: [
            ZwlrVirtualPointerV1.interface,
ZwlrVirtualPointerManagerV1.interface
        ]
    )

#endif
