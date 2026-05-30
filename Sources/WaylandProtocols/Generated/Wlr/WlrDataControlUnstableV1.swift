import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

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
            enums: [],
            requests: [
                Message(
                    name: "create_data_source",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwlr_data_control_source_v1"
                    ),
                    ],
                ),
                Message(
                    name: "get_data_device",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwlr_data_control_device_v1"
                    ),
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat"
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
    /// Create A New Data Source
    /// 
    /// Create a new data source.
    /// 
    /// - Returns: data source to create
    public func createDataSource(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrDataControlSourceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwlrDataControlSourceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
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
        let id = connection.createProxy(type: ZwlrDataControlDeviceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(seat.id),
        ])
        return id
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
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrDataControlUnstableV1)
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
            enums: [],
            requests: [
                Message(
                    name: "set_selection",
                    arguments: [
                    Argument(
                        name: "source",
                        type: .object,
                        interface: "zwlr_data_control_source_v1"
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
                    name: "set_primary_selection",
                    arguments: [
                    Argument(
                        name: "source",
                        type: .object,
                        interface: "zwlr_data_control_source_v1"
                    ),
                    ],
                    since: 2
                ),
                ],
            events: [
                Message(
                    name: "data_offer",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwlr_data_control_offer_v1"
                    ),
                    ],
                ),
                Message(
                    name: "selection",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .object,
                        interface: "zwlr_data_control_offer_v1"
                    ),
                    ],
                ),
                Message(
                    name: "finished",
                    arguments: [
                    ],
                ),
                Message(
                    name: "primary_selection",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .object,
                        interface: "zwlr_data_control_offer_v1"
                    ),
                    ],
                    since: 2
                ),
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
            .object(source?.id ?? 0),
        ])
    }

    /// Destroy This Data Device
    /// 
    /// Destroys the data device object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
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
            .object(source?.id ?? 0),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrDataControlUnstableV1)
    }
    
    public enum Error: UInt32 {
        /// source given to set_selection or set_primary_selection was already used before
        case usedSource = 1
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

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
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
            enums: [],
            requests: [
                Message(
                    name: "offer",
                    arguments: [
                    Argument(
                        name: "mime_type",
                        type: .string,
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
                Message(
                    name: "send",
                    arguments: [
                    Argument(
                        name: "mime_type",
                        type: .string,
                    ),
                    Argument(
                        name: "fd",
                        type: .fd,
                    ),
                    ],
                ),
                Message(
                    name: "cancelled",
                    arguments: [
                    ],
                ),
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
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrDataControlUnstableV1)
    }
    
    public enum Error: UInt32 {
        /// offer sent after wlr_data_control_device.set_selection
        case invalidOffer = 1
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

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
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
            enums: [],
            requests: [
                Message(
                    name: "receive",
                    arguments: [
                    Argument(
                        name: "mime_type",
                        type: .string,
                    ),
                    Argument(
                        name: "fd",
                        type: .fd,
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
                Message(
                    name: "offer",
                    arguments: [
                    Argument(
                        name: "mime_type",
                        type: .string,
                    ),
                    ],
                ),
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
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WlrDataControlUnstableV1)
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
        /// Advertise Offered Mime Type
        /// 
        /// Sent immediately after creating the wlr_data_control_offer object.
        /// One event per offered MIME type.
        case offer(mimeType: String)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.offer(mimeType: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let WlrDataControlUnstableV1 = Protocol(
        name: "wlr_data_control_unstable_v1",
        interfaces: [
            ZwlrDataControlManagerV1.interface,
ZwlrDataControlDeviceV1.interface,
ZwlrDataControlSourceV1.interface,
ZwlrDataControlOfferV1.interface
        ]
    )

#endif