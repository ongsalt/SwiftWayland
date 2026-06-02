import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
public final class OrgKdePlasmaVirtualDesktopManagement: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_virtual_desktop_management",
            version: 4,
            requests: [
                Message(
                    name: "get_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_plasma_virtual_desktop",
                        ),
                        Argument(
                            name: "desktop_id",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "request_create_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        ),
                        Argument(
                            name: "position",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "request_remove_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "desktop_id",
                            type: .string,
                        ),
                    ],
                ),
            ],
            events: [
                Message(
                    name: "desktop_created",
                    arguments: [
                        Argument(
                            name: "desktop_id",
                            type: .string,
                        ),
                        Argument(
                            name: "position",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "desktop_removed",
                    arguments: [
                        Argument(
                            name: "desktop_id",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [],
                ),
                Message(
                    name: "rows",
                    arguments: [
                        Argument(
                            name: "rows",
                            type: .uint,
                        ),
                    ],
                    since: 2
                ),
            ]
        )
    /// Get The Org_Kde_Plasma_Virtual_Desktop Interface For A Desktop
    /// 
    /// Given the id of a particular virtual desktop, get the corresponding org_kde_plasma_virtual_desktop which represents only the desktop with that id.
    /// Warning! The protocol described in this file is a desktop environment
    /// implementation detail. Regular clients must not use this protocol.
    /// Backward incompatible changes may be added without bumping the major
    /// version of the extension.
    /// 
    /// - Parameters:
    ///   - desktopId: Unique id of the desktop
    public func getVirtualDesktop(desktopId: String, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaVirtualDesktop {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdePlasmaVirtualDesktop.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .string(desktopId),
        ])
        return id
    }

    /// Ask For The Creation Of A New Desktop At A Specified Position
    /// 
    /// Ask the server to create a new virtual desktop, and position it at a specified position. If the position is zero or less, it will be positioned at the beginning, if the position is the count or more, it will be positioned at the end.
    /// 
    /// - Parameters:
    ///   - name: The user readable name we want for the desktop
    ///   - position: The position we want for the desktop
    public func requestCreateVirtualDesktop(name: String, position: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .string(name),
            .uint(position),
        ])
    }

    /// Ask For A Desktop Removal Identified By Id
    /// 
    /// Ask the server to get rid of a virtual desktop, the server may or may not acconsent to the request.
    /// 
    /// - Parameters:
    ///   - desktopId: Unique id of the desktop
    public func requestRemoveVirtualDesktop(desktopId: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .string(desktopId),
        ])
    }

    
    public static let `protocol`: Protocol = OrgKdePlasmaVirtualDesktopProtocol
    
    public enum Event: Decodable {
        /// Emitted When A New Desktop Has Been Created
        /// 
        /// 
        case desktopCreated(desktopId: String, position: UInt32)

        /// Emitted When A Desktop Has Been Removed
        /// 
        /// 
        case desktopRemoved(desktopId: String)

        /// Sent All Information About Desktops
        /// 
        /// This event is sent after all other properties have been sent after
        /// binding to the desktop manager global and after all changes to
        /// org_kde_plasma_virtual_desktop_management and org_kde_plasma_virtual_desktop
        /// properties have been sent.
        /// This allows changes to org_kde_plasma_virtual_desktop_management and
        /// org_kde_plasma_virtual_desktop properties to be seen as atomic, even
        /// if they happen via multiple events.
        case done

        case rows(rows: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.desktopCreated(desktopId: r.string(), position: r.uint())
            case 1:
                self = Self.desktopRemoved(desktopId: r.string())
            case 2:
                self = Self.done
            case 3:
                self = Self.rows(rows: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public final class OrgKdePlasmaVirtualDesktop: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_virtual_desktop",
            version: 4,
            requests: [
                Message(
                    name: "request_activate",
                    arguments: [],
                ),
                Message(
                    name: "request_enter_output",
                    arguments: [
                        Argument(
                            name: "output_name",
                            type: .string,
                        ),
                    ],
                    since: 4
                ),
            ],
            events: [
                Message(
                    name: "desktop_id",
                    arguments: [
                        Argument(
                            name: "desktop_id",
                            type: .string,
                        ),
                    ],
                ),
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
                    name: "activated",
                    arguments: [],
                ),
                Message(
                    name: "deactivated",
                    arguments: [],
                ),
                Message(
                    name: "done",
                    arguments: [],
                ),
                Message(
                    name: "removed",
                    arguments: [],
                ),
                Message(
                    name: "position",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .uint,
                        ),
                    ],
                    since: 3
                ),
                Message(
                    name: "output_entered",
                    arguments: [
                        Argument(
                            name: "output_name",
                            type: .string,
                        ),
                    ],
                    since: 4
                ),
            ]
        )
    /// Requests This Desktop To Be Activated
    /// 
    /// Request the server to set the status of this desktop to active: The server is free to consent or deny the request. This will be the new "current" virtual desktop of the system.
    public func requestActivate() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Requests This Desktop To Be Activated On An Output
    /// 
    /// Request the server to activate the desktop on a given output.
    /// The server may deny the request.
    /// If the request is granted, the server will deactivate the previous desktop on the output.
    /// The server may activate the desktop on other outputs as well.
    /// 
    /// - Parameters:
    ///   - outputName: name of the output
    public func requestEnterOutput(outputName: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 1, [
            .string(outputName),
        ])
    }

    
    public static let `protocol`: Protocol = OrgKdePlasmaVirtualDesktopProtocol
    
    public enum Event: Decodable {
        /// The Desktop Got An Id
        /// 
        /// The format of the id is decided by the compositor implementation. A desktop id univocally identifies a virtual desktop and must be guaranteed to never exist two desktops with the same id. The format of the string id is up to the server implementation.
        case desktopId(desktopId: String)

        case name(name: String)

        /// The Desktop Has Been Activated
        /// 
        /// The desktop will be the new "current" desktop of the system. The server may support either one virtual desktop active at a time, or other combinations such as one virtual desktop active per screen.
        /// Windows associated to this virtual desktop will be shown.
        case activated

        /// This Desktop Is No Longer Active
        /// 
        /// Windows that were associated only to this desktop will be hidden.
        case deactivated

        /// Sent All Information About Desktops
        /// 
        /// This event is sent after all other properties has been
        /// sent after binding to the desktop object and after any
        /// other property changes done after that. This allows
        /// changes to the org_kde_plasma_virtual_desktop properties to be seen as
        /// atomic, even if they happen via multiple events.
        case done

        /// This Desktop Has Been Removed
        /// 
        /// This virtual desktop has just been removed by the server:
        /// All windows will lose the association to this desktop.
        case removed

        /// Virtual Desktop Position
        /// 
        /// The position of the virtual desktop in the desktop list. The virtual
        /// desktop position is in the [0, N - 1] range, where N is the number of
        /// virtual desktops.
        case position(index: UInt32)

        /// This Desktop Became Active On An Output
        /// 
        /// This event is sent when the desktop becomes active on an output. The desktop can be active on multiple
        /// outputs simultaneously. Each output has exactly one active desktop at a time (the one that entered it last).
        case outputEntered(outputName: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.desktopId(desktopId: r.string())
            case 1:
                self = Self.name(name: r.string())
            case 2:
                self = Self.activated
            case 3:
                self = Self.deactivated
            case 4:
                self = Self.done
            case 5:
                self = Self.removed
            case 6:
                self = Self.position(index: r.uint())
            case 7:
                self = Self.outputEntered(outputName: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let OrgKdePlasmaVirtualDesktopProtocol = Protocol(
        name: "org_kde_plasma_virtual_desktop",
        interfaces: [
            OrgKdePlasmaVirtualDesktopManagement.interface,
OrgKdePlasmaVirtualDesktop.interface
        ]
    )

#endif