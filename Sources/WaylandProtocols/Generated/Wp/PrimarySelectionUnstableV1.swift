import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// X Primary Selection Emulation
/// 
/// The primary selection device manager is a singleton global object that
/// provides access to the primary selection. It allows to create
/// wp_primary_selection_source objects, as well as retrieving the per-seat
/// wp_primary_selection_device objects.
public final class ZwpPrimarySelectionDeviceManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_primary_selection_device_manager_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "create_source",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_primary_selection_source_v1",
                    ),
                    ],
                ),
                Message(
                    name: "get_device",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zwp_primary_selection_device_v1",
                    ),
                    Argument(
                        name: "seat",
                        type: .object,
                        interface: "wl_seat",
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
    /// Create A New Primary Selection Source
    /// 
    /// Create a new primary selection source.
    public func createSource(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPrimarySelectionSourceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPrimarySelectionSourceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
        ])
        return id
    }

    /// Create A New Primary Selection Device
    /// 
    /// Create a new data device for a given seat.
    /// 
    /// - Parameters:
    public func getDevice(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPrimarySelectionDeviceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPrimarySelectionDeviceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(seat.id),
        ])
        return id
    }

    /// Destroy The Primary Selection Device Manager
    /// 
    /// Destroy the primary selection device manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WpPrimarySelectionUnstableV1Protocol)
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
public final class ZwpPrimarySelectionDeviceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_primary_selection_device_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "set_selection",
                    arguments: [
                    Argument(
                        name: "source",
                        type: .object,
                        interface: "zwp_primary_selection_source_v1",
                        nullable: true,
                    ),
                    Argument(
                        name: "serial",
                        type: .uint,
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
                    name: "data_offer",
                    arguments: [
                    Argument(
                        name: "offer",
                        type: .newId,
                        interface: "zwp_primary_selection_offer_v1",
                    ),
                    ],
                ),
                Message(
                    name: "selection",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .object,
                        interface: "zwp_primary_selection_offer_v1",
                        nullable: true,
                    ),
                    ],
                ),
                ],
        )
    /// Set The Primary Selection
    /// 
    /// Replaces the current selection. The previous owner of the primary
    /// selection will receive a wp_primary_selection_source.cancelled event.
    /// To unset the selection, set the source to NULL.
    /// 
    /// - Parameters:
    ///   - serial: serial of the event that triggered this request
    public func setSelection(source: ZwpPrimarySelectionSourceV1? = nil, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(source?.id ?? 0),
            .uint(serial),
        ])
    }

    /// Destroy The Primary Selection Device
    /// 
    /// Destroy the primary selection device.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WpPrimarySelectionUnstableV1Protocol)
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
        /// Introduce A New Wp_Primary_Selection_Offer
        /// 
        /// Introduces a new wp_primary_selection_offer object that may be used
        /// to receive the current primary selection. Immediately following this
        /// event, the new wp_primary_selection_offer object will send
        /// wp_primary_selection_offer.offer events to describe the offered mime
        /// types.
        case dataOffer(offer: ZwpPrimarySelectionOfferV1)

        /// Advertise A New Primary Selection
        /// 
        /// The wp_primary_selection_device.selection event is sent to notify the
        /// client of a new primary selection. This event is sent after the
        /// wp_primary_selection.data_offer event introducing this object, and after
        /// the offer has announced its mimetypes through
        /// wp_primary_selection_offer.offer.
        /// The data_offer is valid until a new offer or NULL is received
        /// or until the client loses keyboard focus. The client must destroy the
        /// previous selection data_offer, if any, upon receiving this event.
        case selection(id: ZwpPrimarySelectionOfferV1)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.dataOffer(offer: r.newId(type: ZwpPrimarySelectionOfferV1.self))
            case 1:
                self = Self.selection(id: r.object(type: ZwpPrimarySelectionOfferV1.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Offer To Transfer Primary Selection Contents
/// 
/// A wp_primary_selection_offer represents an offer to transfer the contents
/// of the primary selection clipboard to the client. Similar to
/// wl_data_offer, the offer also describes the mime types that the data can
/// be converted to and provides the mechanisms for transferring the data
/// directly to the client.
public final class ZwpPrimarySelectionOfferV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_primary_selection_offer_v1",
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
    /// To transfer the contents of the primary selection clipboard, the client
    /// issues this request and indicates the mime type that it wants to
    /// receive. The transfer happens through the passed file descriptor
    /// (typically created with the pipe system call). The source client writes
    /// the data in the mime type representation requested and then closes the
    /// file descriptor.
    /// The receiving client reads from the read end of the pipe until EOF and
    /// closes its end, at which point the transfer is complete.
    /// 
    /// - Parameters:
    public func receive(mimeType: String, fd: FileHandle) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(mimeType),
            .fd(fd),
        ])
    }

    /// Destroy The Primary Selection Offer
    /// 
    /// Destroy the primary selection offer.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WpPrimarySelectionUnstableV1Protocol)
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
        /// Sent immediately after creating announcing the
        /// wp_primary_selection_offer through
        /// wp_primary_selection_device.data_offer. One event is sent per offered
        /// mime type.
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
/// Offer To Replace The Contents Of The Primary Selection
/// 
/// The source side of a wp_primary_selection_offer, it provides a way to
/// describe the offered data and respond to requests to transfer the
/// requested contents of the primary selection clipboard.
public final class ZwpPrimarySelectionSourceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_primary_selection_source_v1",
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
    /// This request adds a mime type to the set of mime types advertised to
    /// targets. Can be called several times to offer multiple types.
    /// 
    /// - Parameters:
    public func offer(mimeType: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(mimeType),
        ])
    }

    /// Destroy The Primary Selection Source
    /// 
    /// Destroy the primary selection source.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: WpPrimarySelectionUnstableV1Protocol)
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
        /// Send The Primary Selection Contents
        /// 
        /// Request for the current primary selection contents from the client.
        /// Send the specified mime type over the passed file descriptor, then
        /// close it.
        case send(mimeType: String, fd: FileHandle)

        /// Request For Primary Selection Contents Was Canceled
        /// 
        /// This primary selection source is no longer valid. The client should
        /// clean up and destroy this primary selection source.
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

public let WpPrimarySelectionUnstableV1Protocol = Protocol(
        name: "wp_primary_selection_unstable_v1",
        interfaces: [
            ZwpPrimarySelectionDeviceManagerV1.interface,
ZwpPrimarySelectionDeviceV1.interface,
ZwpPrimarySelectionOfferV1.interface,
ZwpPrimarySelectionSourceV1.interface
        ]
    )

#endif