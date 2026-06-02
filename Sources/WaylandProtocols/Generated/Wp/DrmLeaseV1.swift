import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Lease Device
/// 
/// This protocol is used by Wayland compositors which act as Direct
/// Rendering Manager (DRM) masters to lease DRM resources to Wayland
/// clients.
/// The compositor will advertise one wp_drm_lease_device_v1 global for each
/// DRM node. Some time after a client binds to the wp_drm_lease_device_v1
/// global, the compositor will send a drm_fd event followed by zero, one or
/// more connector events. After all currently available connectors have been
/// sent, the compositor will send a wp_drm_lease_device_v1.done event.
/// When the list of connectors available for lease changes the compositor
/// will send wp_drm_lease_device_v1.connector events for added connectors and
/// wp_drm_lease_connector_v1.withdrawn events for removed connectors,
/// followed by a wp_drm_lease_device_v1.done event.
/// The compositor will indicate when a device is gone by removing the global
/// via a wl_registry.global_remove event. Upon receiving this event, the
/// client should destroy any matching wp_drm_lease_device_v1 object.
/// To destroy a wp_drm_lease_device_v1 object, the client must first issue
/// a release request. Upon receiving this request, the compositor will
/// immediately send a released event and destroy the object. The client must
/// continue to process and discard drm_fd and connector events until it
/// receives the released event. Upon receiving the released event, the
/// client can safely cleanup any client-side resources.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpDrmLeaseDeviceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_drm_lease_device_v1",
            version: 1,
            requests: [
                Message(
                    name: "create_lease_request",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_drm_lease_request_v1",
                        ),
                    ],
                ),
                Message(
                    name: "release",
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "drm_fd",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
                        ),
                    ],
                ),
                Message(
                    name: "connector",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_drm_lease_connector_v1",
                        ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [],
                ),
                Message(
                    name: "released",
                    type: .destructor,
                    arguments: [],
                ),
            ]
        )
    /// Create A Lease Request Object
    /// 
    /// Creates a lease request object.
    /// See the documentation for wp_drm_lease_request_v1 for details.
    public func createLeaseRequest(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpDrmLeaseRequestV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpDrmLeaseRequestV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
        ])
        return id
    }

    /// Release This Object
    /// 
    /// Indicates the client no longer wishes to use this object. In response
    /// the compositor will immediately send the released event and destroy
    /// this object. It can however not guarantee that the client won't receive
    /// connector events before the released event. The client must not send any
    /// requests after this one, doing so will raise a wl_display error.
    /// Existing connectors, lease request and leases will not be affected.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: DrmLeaseV1Protocol)
    }
    
    public enum Event: Decodable {
        /// Open A Non-Master Fd For This Drm Node
        /// 
        /// The compositor will send this event when the wp_drm_lease_device_v1
        /// global is bound, although there are no guarantees as to how long this
        /// takes - the compositor might need to wait until regaining DRM master.
        /// The included fd is a non-master DRM file descriptor opened for this
        /// device and the compositor must not authenticate it.
        /// The purpose of this event is to give the client the ability to
        /// query DRM and discover information which may help them pick the
        /// appropriate DRM device or select the appropriate connectors therein.
        case drmFd(fd: FileHandle)

        /// Advertise Connectors Available For Leases
        /// 
        /// The compositor will use this event to advertise connectors available for
        /// lease by clients. This object may be passed into a lease request to
        /// indicate the client would like to lease that connector, see
        /// wp_drm_lease_request_v1.request_connector for details. While the
        /// compositor will make a best effort to not send disconnected connectors,
        /// no guarantees can be made.
        /// The compositor must send the drm_fd event before sending connectors.
        /// After the drm_fd event it will send all available connectors but may
        /// send additional connectors at any time.
        case connector(id: WpDrmLeaseConnectorV1)

        /// Signals Grouping Of Connectors
        /// 
        /// The compositor will send this event to indicate that it has sent all
        /// currently available connectors after the client binds to the global or
        /// when it updates the connector list, for example on hotplug, drm master
        /// change or when a leased connector becomes available again. It will
        /// similarly send this event to group wp_drm_lease_connector_v1.withdrawn
        /// events of connectors of this device.
        case done

        /// The Compositor Has Finished Using The Device
        /// 
        /// This event is sent in response to the release request and indicates
        /// that the compositor is done sending connector events.
        /// The compositor will destroy this object immediately after sending the
        /// event and it will become invalid. The client should release any
        /// resources associated with this device after receiving this event.
        case released

        public init(from r: some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.drmFd(fd: r.fd())
            case 1:
                self = Self.connector(id: r.newId(type: WpDrmLeaseConnectorV1.self))
            case 2:
                self = Self.done
            case 3:
                self = Self.released
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Leasable Drm Connector
/// 
/// Represents a DRM connector which is available for lease. These objects are
/// created via wp_drm_lease_device_v1.connector events, and should be passed
/// to lease requests via wp_drm_lease_request_v1.request_connector.
/// Immediately after the wp_drm_lease_connector_v1 object is created the
/// compositor will send a name, a description, a connector_id and a done
/// event. When the description is updated the compositor will send a
/// description event followed by a done event.
public final class WpDrmLeaseConnectorV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_drm_lease_connector_v1",
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
                    name: "name",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "description",
                    arguments: [
                        Argument(
                            name: "description",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "connector_id",
                    arguments: [
                        Argument(
                            name: "connector_id",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [],
                ),
                Message(
                    name: "withdrawn",
                    arguments: [],
                ),
            ]
        )
    /// Destroy Connector
    /// 
    /// The client may send this request to indicate that it will not use this
    /// connector. Clients are encouraged to send this after receiving the
    /// "withdrawn" event so that the server can release the resources
    /// associated with this connector offer. Neither existing lease requests
    /// nor leases will be affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: DrmLeaseV1Protocol)
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
        /// Name
        /// 
        /// The compositor sends this event once the connector is created to
        /// indicate the name of this connector. This will not change for the
        /// duration of the Wayland session, but is not guaranteed to be consistent
        /// between sessions.
        /// If the compositor supports wl_output version 4 and this connector
        /// corresponds to a wl_output, the compositor should use the same name as
        /// for the wl_output.
        case name(name: String)

        /// Description
        /// 
        /// The compositor sends this event once the connector is created to provide
        /// a human-readable description for this connector, which may be presented
        /// to the user. The compositor may send this event multiple times over the
        /// lifetime of this object to reflect changes in the description.
        case description(description: String)

        /// Connector_Id
        /// 
        /// The compositor sends this event once the connector is created to
        /// indicate the DRM object ID which represents the underlying connector
        /// that is being offered. Note that the final lease may include additional
        /// object IDs, such as CRTCs and planes.
        case connectorId(connectorId: UInt32)

        /// All Properties Have Been Sent
        /// 
        /// This event is sent after all properties of a connector have been sent.
        /// This allows changes to the properties to be seen as atomic even if they
        /// happen via multiple events.
        case done

        /// Lease Offer Withdrawn
        /// 
        /// Sent to indicate that the compositor will no longer honor requests for
        /// DRM leases which include this connector. The client may still issue a
        /// lease request including this connector, but the compositor will send
        /// wp_drm_lease_v1.finished without issuing a lease fd. Compositors are
        /// encouraged to send this event when they lose access to connector, for
        /// example when the connector is hot-unplugged, when the connector gets
        /// leased to a client or when the compositor loses DRM master.
        /// If a client holds a lease for the connector, the status of the lease
        /// remains the same. The client should destroy the object after receiving
        /// this event.
        case withdrawn

        public init(from r: some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.name(name: r.string())
            case 1:
                self = Self.description(description: r.string())
            case 2:
                self = Self.connectorId(connectorId: r.uint())
            case 3:
                self = Self.done
            case 4:
                self = Self.withdrawn
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Drm Lease Request
/// 
/// A client that wishes to lease DRM resources will attach the list of
/// connectors advertised with wp_drm_lease_device_v1.connector that they
/// wish to lease, then use wp_drm_lease_request_v1.submit to submit the
/// request.
public final class WpDrmLeaseRequestV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_drm_lease_request_v1",
            version: 1,
            requests: [
                Message(
                    name: "request_connector",
                    arguments: [
                        Argument(
                            name: "connector",
                            type: .object,
                            interface: "wp_drm_lease_connector_v1",
                        ),
                    ],
                ),
                Message(
                    name: "submit",
                    type: .destructor,
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_drm_lease_v1",
                        ),
                    ],
                ),
            ],
        )
    /// Request A Connector For This Lease
    /// 
    /// Indicates that the client would like to lease the given connector.
    /// This is only used as a suggestion, the compositor may choose to
    /// include any resources in the lease it issues, or change the set of
    /// leased resources at any time. Compositors are however encouraged to
    /// include the requested connector and other resources necessary
    /// to drive the connected output in the lease.
    /// Requesting a connector that was created from a different lease device
    /// than this lease request raises the wrong_device error. Requesting a
    /// connector twice will raise the duplicate_connector error.
    /// 
    /// - Parameters:
    public func requestConnector(connector: WpDrmLeaseConnectorV1) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(connector.id),
        ])
    }

    /// Submit The Lease Request
    /// 
    /// Submits the lease request and creates a new wp_drm_lease_v1 object.
    /// After calling submit the compositor will immediately destroy this
    /// object, issuing any more requests will cause a wl_display error.
    /// The compositor doesn't make any guarantees about the events of the
    /// lease object, clients cannot expect an immediate response.
    /// Not requesting any connectors before submitting the lease request
    /// will raise the empty_lease error.
    public func submit(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpDrmLeaseV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        let id = connection.createProxy(type: WpDrmLeaseV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: DrmLeaseV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// requested a connector from a different lease device
        case wrongDevice = 0

        /// requested a connector twice
        case duplicateConnector = 1

        /// requested a lease without requesting a connector
        case emptyLease = 2
    }

    public typealias Event = NoEvent
}

/// A Drm Lease
/// 
/// A DRM lease object is used to transfer the DRM file descriptor to the
/// client and manage the lifetime of the lease.
/// Some time after the wp_drm_lease_v1 object is created, the compositor
/// will reply with the lease request's result. If the lease request is
/// granted, the compositor will send a lease_fd event. If the lease request
/// is denied, the compositor will send a finished event without a lease_fd
/// event.
public final class WpDrmLeaseV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_drm_lease_v1",
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
                    name: "lease_fd",
                    arguments: [
                        Argument(
                            name: "leased_fd",
                            type: .fd,
                        ),
                    ],
                ),
                Message(
                    name: "finished",
                    arguments: [],
                ),
            ]
        )
    /// Destroys The Lease Object
    /// 
    /// The client should send this to indicate that it no longer wishes to use
    /// this lease. The compositor should use drmModeRevokeLease on the
    /// appropriate file descriptor, if necessary.
    /// Upon destruction, the compositor should advertise the connector for
    /// leasing again by sending the connector event through the
    /// wp_drm_lease_device_v1 interface.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: DrmLeaseV1Protocol)
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
        /// Shares The Drm File Descriptor
        /// 
        /// This event returns a file descriptor suitable for use with DRM-related
        /// ioctls. The client should use drmModeGetLease to enumerate the DRM
        /// objects which have been leased to them. The compositor guarantees it
        /// will not use the leased DRM objects itself until it sends the finished
        /// event. If the compositor cannot or will not grant a lease for the
        /// requested connectors, it will not send this event, instead sending the
        /// finished event.
        /// The compositor will send this event at most once during this objects
        /// lifetime.
        case leaseFd(leasedFd: FileHandle)

        /// Sent When The Lease Has Been Revoked
        /// 
        /// The compositor uses this event to either reject a lease request, or if
        /// it previously sent a lease_fd, to notify the client that the lease has
        /// been revoked. If the client requires a new lease, they should destroy
        /// this object and submit a new lease request. The compositor will send
        /// no further events for this object after sending the finish event.
        /// Compositors should revoke the lease when any of the leased resources
        /// become unavailable, namely when a hot-unplug occurs or when the
        /// compositor loses DRM master. Compositors may advertise the connector
        /// for leasing again, if the resource is available, by sending the
        /// connector event through the wp_drm_lease_device_v1 interface.
        case finished

        public init(from r: some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.leaseFd(leasedFd: r.fd())
            case 1:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let DrmLeaseV1Protocol = Protocol(
        name: "drm_lease_v1",
        interfaces: [
            WpDrmLeaseDeviceV1.interface,
WpDrmLeaseConnectorV1.interface,
WpDrmLeaseRequestV1.interface,
WpDrmLeaseV1.interface
        ]
    )

#endif