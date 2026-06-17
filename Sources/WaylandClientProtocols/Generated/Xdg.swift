import Foundation
import WaylandClient

#if XDG
/// Window Decoration Manager
/// 
/// This interface allows a compositor to announce support for server-side
/// decorations.
/// A window decoration is a set of window controls as deemed appropriate by
/// the party managing them, such as user interface components used to move,
/// resize and change a window's state.
/// A client can use this protocol to request being decorated by a supporting
/// compositor.
/// If compositor and client do not negotiate the use of a server-side
/// decoration using this protocol, clients continue to self-decorate as they
/// see fit.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZxdgDecorationManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_decoration_manager_v1",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_toplevel_decoration",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zxdg_toplevel_decoration_v1",
                        )
                        ,
                        Argument(
                            name: "toplevel",
                            type: .object,
                            interface: "xdg_toplevel",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Decoration Manager Object
    /// 
    /// Destroy the decoration manager. This doesn't destroy objects created
    /// with the manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A New Toplevel Decoration Object
    /// 
    /// Create a new decoration object associated with the given toplevel.
    /// For objects of version 1, creating an xdg_toplevel_decoration from an
    /// xdg_toplevel which has a buffer attached or committed is a client
    /// error, and any attempts by a client to attach or manipulate a buffer
    /// prior to the first xdg_toplevel_decoration.configure event must also be
    /// treated as errors.
    /// For objects of version 2 or newer, creating an xdg_toplevel_decoration
    /// from an xdg_toplevel which has a buffer attached or committed is
    /// allowed. The initial decoration mode of the surface if a buffer is
    /// already attached depends on whether a xdg_toplevel_decoration object
    /// has been associated with the surface or not prior to this request.
    /// If an xdg_toplevel_decoration was associated with the surface, then
    /// destroyed without a surface commit, the previous decoration mode is
    /// retained.
    /// If no xdg_toplevel_decoration was associated with the surface prior to
    /// this request, or if a surface commit has been performed after a previous
    /// xdg_toplevel_decoration object associated with the surface was
    /// destroyed, the decoration mode is assumed to be client-side.
    /// 
    /// - Parameters:
    public func getToplevelDecoration(toplevel: XdgToplevel, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZxdgToplevelDecorationV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZxdgToplevelDecorationV1.self, version, _queue, [
            .newId,
            .object(toplevel),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XdgDecorationUnstableV1Protocol
    
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

/// Decoration Object For A Toplevel Surface
/// 
/// The decoration object allows the compositor to toggle server-side window
/// decorations for a toplevel surface. The client can request to switch to
/// another mode.
/// The xdg_toplevel_decoration object must be destroyed before its
/// xdg_toplevel.
public final class ZxdgToplevelDecorationV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_toplevel_decoration_v1",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
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
                    name: "unset_mode",
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "configure",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Decoration Object
    /// 
    /// Switch back to a mode without any server-side decorations at the next
    /// commit, unless a new xdg_toplevel_decoration is created for the surface
    /// first.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Decoration Mode
    /// 
    /// Set the toplevel surface decoration mode. This informs the compositor
    /// that the client prefers the provided decoration mode.
    /// After requesting a decoration mode, the compositor will respond by
    /// emitting an xdg_surface.configure event. The client should then update
    /// its content, drawing it without decorations if the received mode is
    /// server-side decorations. The client must also acknowledge the configure
    /// when committing the new content (see xdg_surface.ack_configure).
    /// The compositor can decide not to use the client's mode and enforce a
    /// different mode instead.
    /// Clients whose decoration mode depend on the xdg_toplevel state may send
    /// a set_mode request in response to an xdg_surface.configure event and wait
    /// for the next xdg_surface.configure event to prevent unwanted state.
    /// Such clients are responsible for preventing configure loops and must
    /// make sure not to send multiple successive set_mode requests with the
    /// same decoration mode.
    /// If an invalid mode is supplied by the client, the invalid_mode protocol
    /// error is raised by the compositor.
    /// 
    /// - Parameters:
    ///   - _: the decoration mode
    public func setMode(_ mode: Mode) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(mode.rawValue),
        ])
    }

    /// Unset The Decoration Mode
    /// 
    /// Unset the toplevel surface decoration mode. This informs the compositor
    /// that the client doesn't prefer a particular decoration mode.
    /// This request has the same semantics as set_mode.
    public func unsetMode() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = XdgDecorationUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// xdg_toplevel has a buffer attached before configure
        case unconfiguredBuffer = 0

        /// xdg_toplevel already has a decoration object
        case alreadyConstructed = 1

        /// xdg_toplevel destroyed before the decoration object
        case orphaned = 2

        /// invalid mode
        case invalidMode = 3
    }

    public enum Mode: UInt32 {
        /// no server-side window decoration
        case clientSide = 1

        /// server-side window decoration
        case serverSide = 2
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
        /// Notify A Decoration Mode Change
        /// 
        /// The configure event configures the effective decoration mode. The
        /// configured state should not be applied immediately. Clients must send an
        /// ack_configure in response to this event. See xdg_surface.configure and
        /// xdg_surface.ack_configure for details.
        /// A configure event can be sent at any time. The specified mode must be
        /// obeyed by the client.
        case configure(mode: Mode)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(mode: try _parseEnum(into: Mode.self, r.uint()))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let XdgDecorationUnstableV1Protocol = Protocol(
        name: "xdg_decoration_unstable_v1",
        interfaces: [
            ZxdgDecorationManagerV1.interface,
ZxdgToplevelDecorationV1.interface
        ]
    )

/// Interface For Exporting Surfaces
/// 
/// A global interface used for exporting surfaces that can later be imported
/// using xdg_importer.
public final class ZxdgExporterV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_exporter_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "export",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zxdg_exported_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Xdg_Exporter Object
    /// 
    /// Notify the compositor that the xdg_exporter object will no longer be
    /// used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Export A Surface
    /// 
    /// The export request exports the passed surface so that it can later be
    /// imported via xdg_importer. When called, a new xdg_exported object will
    /// be created and xdg_exported.handle will be sent immediately. See the
    /// corresponding interface and event for details.
    /// A surface may be exported multiple times, and each exported handle may
    /// be used to create an xdg_imported multiple times. Only xdg_surface
    /// surfaces may be exported.
    /// 
    /// - Parameters:
    ///   - surface: the surface to export
    /// 
    /// - Returns: the new xdg_exported object
    public func export(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZxdgExportedV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZxdgExportedV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XdgForeignUnstableV1Protocol
    
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

/// Interface For Importing Surfaces
/// 
/// A global interface used for importing surfaces exported by xdg_exporter.
/// With this interface, a client can create a reference to a surface of
/// another client.
public final class ZxdgImporterV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_importer_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "import",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zxdg_imported_v1",
                        )
                        ,
                        Argument(
                            name: "handle",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Xdg_Importer Object
    /// 
    /// Notify the compositor that the xdg_importer object will no longer be
    /// used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Import A Surface
    /// 
    /// The import request imports a surface from any client given a handle
    /// retrieved by exporting said surface using xdg_exporter.export. When
    /// called, a new xdg_imported object will be created. This new object
    /// represents the imported surface, and the importing client can
    /// manipulate its relationship using it. See xdg_imported for details.
    /// 
    /// - Parameters:
    ///   - handle: the exported surface handle
    /// 
    /// - Returns: the new xdg_imported object
    public func `import`(handle: String, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZxdgImportedV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZxdgImportedV1.self, version, _queue, [
            .newId,
            .string(handle),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XdgForeignUnstableV1Protocol
    
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

/// An Exported Surface Handle
/// 
/// An xdg_exported object represents an exported reference to a surface. The
/// exported surface may be referenced as long as the xdg_exported object not
/// destroyed. Destroying the xdg_exported invalidates any relationship the
/// importer may have established using xdg_imported.
public final class ZxdgExportedV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_exported_v1",
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
                    name: "handle",
                    arguments: [
                        Argument(
                            name: "handle",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Unexport The Exported Surface
    /// 
    /// Revoke the previously exported surface. This invalidates any
    /// relationship the importer may have set up using the xdg_imported created
    /// given the handle sent via xdg_exported.handle.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = XdgForeignUnstableV1Protocol
    
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
        /// The Exported Surface Handle
        /// 
        /// The handle event contains the unique handle of this exported surface
        /// reference. It may be shared with any client, which then can use it to
        /// import the surface by calling xdg_importer.import. A handle may be
        /// used to import the surface multiple times.
        case handle(handle: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.handle(handle: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// An Imported Surface Handle
/// 
/// An xdg_imported object represents an imported reference to surface exported
/// by some client. A client can use this interface to manipulate
/// relationships between its own surfaces and the imported surface.
public final class ZxdgImportedV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_imported_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_parent_of",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "destroyed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Xdg_Imported Object
    /// 
    /// Notify the compositor that it will no longer use the xdg_imported
    /// object. Any relationship that may have been set up will at this point
    /// be invalidated.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set As The Parent Of Some Surface
    /// 
    /// Set the imported surface as the parent of some surface of the client.
    /// The passed surface must be a toplevel xdg_surface. Calling this function
    /// sets up a surface to surface relation with the same stacking and positioning
    /// semantics as xdg_surface.set_parent.
    /// 
    /// - Parameters:
    ///   - surface: the child surface
    public func setParentOf(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface),
        ])
    }

    
    public static let `protocol`: Protocol = XdgForeignUnstableV1Protocol
    
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
        /// The Imported Surface Handle Has Been Destroyed
        /// 
        /// The imported surface handle has been destroyed and any relationship set
        /// up has been invalidated. This may happen for various reasons, for
        /// example if the exported surface or the exported surface handle has been
        /// destroyed, if the handle used for importing was invalid.
        case destroyed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.destroyed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let XdgForeignUnstableV1Protocol = Protocol(
        name: "xdg_foreign_unstable_v1",
        interfaces: [
            ZxdgExporterV1.interface,
ZxdgImporterV1.interface,
ZxdgExportedV1.interface,
ZxdgImportedV1.interface
        ]
    )

/// Interface For Exporting Surfaces
/// 
/// A global interface used for exporting surfaces that can later be imported
/// using xdg_importer.
public final class ZxdgExporterV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_exporter_v2",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "export_toplevel",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zxdg_exported_v2",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Xdg_Exporter Object
    /// 
    /// Notify the compositor that the xdg_exporter object will no longer be
    /// used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Export A Toplevel Surface
    /// 
    /// The export_toplevel request exports the passed surface so that it can later be
    /// imported via xdg_importer. When called, a new xdg_exported object will
    /// be created and xdg_exported.handle will be sent immediately. See the
    /// corresponding interface and event for details.
    /// A surface may be exported multiple times, and each exported handle may
    /// be used to create an xdg_imported multiple times. Only xdg_toplevel
    /// equivalent surfaces may be exported, otherwise an invalid_surface
    /// protocol error is sent.
    /// 
    /// - Parameters:
    ///   - surface: the surface to export
    /// 
    /// - Returns: the new xdg_exported object
    public func exportToplevel(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZxdgExportedV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZxdgExportedV2.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XdgForeignUnstableV2Protocol
    
    public enum Error: UInt32 {
        /// surface is not an xdg_toplevel
        case invalidSurface = 0
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

/// Interface For Importing Surfaces
/// 
/// A global interface used for importing surfaces exported by xdg_exporter.
/// With this interface, a client can create a reference to a surface of
/// another client.
public final class ZxdgImporterV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_importer_v2",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "import_toplevel",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zxdg_imported_v2",
                        )
                        ,
                        Argument(
                            name: "handle",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Xdg_Importer Object
    /// 
    /// Notify the compositor that the xdg_importer object will no longer be
    /// used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Import A Toplevel Surface
    /// 
    /// The import_toplevel request imports a surface from any client given a handle
    /// retrieved by exporting said surface using xdg_exporter.export_toplevel.
    /// When called, a new xdg_imported object will be created. This new object
    /// represents the imported surface, and the importing client can
    /// manipulate its relationship using it. See xdg_imported for details.
    /// 
    /// - Parameters:
    ///   - handle: the exported surface handle
    /// 
    /// - Returns: the new xdg_imported object
    public func importToplevel(handle: String, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZxdgImportedV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZxdgImportedV2.self, version, _queue, [
            .newId,
            .string(handle),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XdgForeignUnstableV2Protocol
    
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

/// An Exported Surface Handle
/// 
/// An xdg_exported object represents an exported reference to a surface. The
/// exported surface may be referenced as long as the xdg_exported object not
/// destroyed. Destroying the xdg_exported invalidates any relationship the
/// importer may have established using xdg_imported.
public final class ZxdgExportedV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_exported_v2",
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
                    name: "handle",
                    arguments: [
                        Argument(
                            name: "handle",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Unexport The Exported Surface
    /// 
    /// Revoke the previously exported surface. This invalidates any
    /// relationship the importer may have set up using the xdg_imported created
    /// given the handle sent via xdg_exported.handle.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = XdgForeignUnstableV2Protocol
    
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
        /// The Exported Surface Handle
        /// 
        /// The handle event contains the unique handle of this exported surface
        /// reference. It may be shared with any client, which then can use it to
        /// import the surface by calling xdg_importer.import_toplevel. A handle
        /// may be used to import the surface multiple times.
        case handle(handle: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.handle(handle: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// An Imported Surface Handle
/// 
/// An xdg_imported object represents an imported reference to surface exported
/// by some client. A client can use this interface to manipulate
/// relationships between its own surfaces and the imported surface.
public final class ZxdgImportedV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_imported_v2",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_parent_of",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "destroyed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Xdg_Imported Object
    /// 
    /// Notify the compositor that it will no longer use the xdg_imported
    /// object. Any relationship that may have been set up will at this point
    /// be invalidated.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set As The Parent Of Some Surface
    /// 
    /// Set the imported surface as the parent of some surface of the client.
    /// The passed surface must be an xdg_toplevel equivalent, otherwise an
    /// invalid_surface protocol error is sent. Calling this function sets up
    /// a surface to surface relation with the same stacking and positioning
    /// semantics as xdg_toplevel.set_parent.
    /// 
    /// - Parameters:
    ///   - surface: the child surface
    public func setParentOf(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface),
        ])
    }

    
    public static let `protocol`: Protocol = XdgForeignUnstableV2Protocol
    
    public enum Error: UInt32 {
        /// surface is not an xdg_toplevel
        case invalidSurface = 0
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
        /// The Imported Surface Handle Has Been Destroyed
        /// 
        /// The imported surface handle has been destroyed and any relationship set
        /// up has been invalidated. This may happen for various reasons, for
        /// example if the exported surface or the exported surface handle has been
        /// destroyed, if the handle used for importing was invalid.
        case destroyed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.destroyed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let XdgForeignUnstableV2Protocol = Protocol(
        name: "xdg_foreign_unstable_v2",
        interfaces: [
            ZxdgExporterV2.interface,
ZxdgImporterV2.interface,
ZxdgExportedV2.interface,
ZxdgImportedV2.interface
        ]
    )

/// Manage Xdg_Output Objects
/// 
/// A global factory interface for xdg_output objects.
public final class ZxdgOutputManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_output_manager_v1",
            version: 3,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_xdg_output",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zxdg_output_v1",
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
            ],
        )
    /// Destroy The Xdg_Output_Manager Object
    /// 
    /// Using this request a client can tell the server that it is not
    /// going to use the xdg_output_manager object anymore.
    /// Any objects already created through this instance are not affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create An Xdg Output From A Wl_Output
    /// 
    /// This creates a new xdg_output object for the given wl_output.
    /// 
    /// - Parameters:
    public func getXdgOutput(output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZxdgOutputV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZxdgOutputV1.self, version, _queue, [
            .newId,
            .object(output),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XdgOutputUnstableV1Protocol
    
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

/// Compositor Logical Output Region
/// 
/// An xdg_output describes part of the compositor geometry.
/// This typically corresponds to a monitor that displays part of the
/// compositor space.
/// For objects version 3 onwards, after all xdg_output properties have been
/// sent (when the object is created and when properties are updated), a
/// wl_output.done event is sent. This allows changes to the output
/// properties to be seen as atomic, even if they happen via multiple events.
public final class ZxdgOutputV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zxdg_output_v1",
            version: 3,
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
                    name: "logical_position",
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
                    name: "logical_size",
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
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "name",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                    ],
                    since: 2
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
                    since: 2
                )
                ,
            ],
        )
    /// Destroy The Xdg_Output Object
    /// 
    /// Using this request a client can tell the server that it is not
    /// going to use the xdg_output object anymore.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = XdgOutputUnstableV1Protocol
    
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
        /// Position Of The Output Within The Global Compositor Space
        /// 
        /// The position event describes the location of the wl_output within
        /// the global compositor space.
        /// The logical_position event is sent after creating an xdg_output
        /// (see xdg_output_manager.get_xdg_output) and whenever the location
        /// of the output changes within the global compositor space.
        case logicalPosition(x: Int32, y: Int32)

        /// Size Of The Output In The Global Compositor Space
        /// 
        /// The logical_size event describes the size of the output in the
        /// global compositor space.
        /// Most regular Wayland clients should not pay attention to the
        /// logical size and would rather rely on xdg_shell interfaces.
        /// Some clients such as Xwayland, however, need this to configure
        /// their surfaces in the global compositor space as the compositor
        /// may apply a different scale from what is advertised by the output
        /// scaling property (to achieve fractional scaling, for example).
        /// For example, for a wl_output mode 3840×2160 and a scale factor 2:
        /// - A compositor not scaling the monitor viewport in its compositing space
        /// will advertise a logical size of 3840×2160,
        /// - A compositor scaling the monitor viewport with scale factor 2 will
        /// advertise a logical size of 1920×1080,
        /// - A compositor scaling the monitor viewport using a fractional scale of
        /// 1.5 will advertise a logical size of 2560×1440.
        /// For example, for a wl_output mode 1920×1080 and a 90 degree rotation,
        /// the compositor will advertise a logical size of 1080x1920.
        /// The logical_size event is sent after creating an xdg_output
        /// (see xdg_output_manager.get_xdg_output) and whenever the logical
        /// size of the output changes, either as a result of a change in the
        /// applied scale or because of a change in the corresponding output
        /// mode(see wl_output.mode) or transform (see wl_output.transform).
        case logicalSize(width: Int32, height: Int32)

        /// All Information About The Output Have Been Sent
        /// 
        /// This event is sent after all other properties of an xdg_output
        /// have been sent.
        /// This allows changes to the xdg_output properties to be seen as
        /// atomic, even if they happen via multiple events.
        /// For objects version 3 onwards, this event is deprecated. Compositors
        /// are not required to send it anymore and must send wl_output.done
        /// instead.
        case done

        /// Name Of This Output
        /// 
        /// Many compositors will assign names to their outputs, show them to the
        /// user, allow them to be configured by name, etc. The client may wish to
        /// know this name as well to offer the user similar behaviors.
        /// The naming convention is compositor defined, but limited to
        /// alphanumeric characters and dashes (-). Each name is unique among all
        /// wl_output globals, but if a wl_output global is destroyed the same name
        /// may be reused later. The names will also remain consistent across
        /// sessions with the same hardware and software configuration.
        /// Examples of names include 'HDMI-A-1', 'WL-1', 'X11-1', etc. However, do
        /// not assume that the name is a reflection of an underlying DRM
        /// connector, X11 connection, etc.
        /// The name event is sent after creating an xdg_output (see
        /// xdg_output_manager.get_xdg_output). This event is only sent once per
        /// xdg_output, and the name does not change over the lifetime of the
        /// wl_output global.
        /// This event is deprecated, instead clients should use wl_output.name.
        /// Compositors must still support this event.
        case name(name: String)

        /// Human-Readable Description Of This Output
        /// 
        /// Many compositors can produce human-readable descriptions of their
        /// outputs.  The client may wish to know this description as well, to
        /// communicate the user for various purposes.
        /// The description is a UTF-8 string with no convention defined for its
        /// contents. Examples might include 'Foocorp 11" Display' or 'Virtual X11
        /// output via :1'.
        /// The description event is sent after creating an xdg_output (see
        /// xdg_output_manager.get_xdg_output) and whenever the description
        /// changes. The description is optional, and may not be sent at all.
        /// For objects of version 2 and lower, this event is only sent once per
        /// xdg_output, and the description does not change over the lifetime of
        /// the wl_output global.
        /// This event is deprecated, instead clients should use
        /// wl_output.description. Compositors must still support this event.
        case description(description: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.logicalPosition(x: r.int(), y: r.int())
            case 1:
                self = Self.logicalSize(width: r.int(), height: r.int())
            case 2:
                self = Self.done
            case 3:
                self = Self.name(name: r.string())
            case 4:
                self = Self.description(description: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let XdgOutputUnstableV1Protocol = Protocol(
        name: "xdg_output_unstable_v1",
        interfaces: [
            ZxdgOutputManagerV1.interface,
ZxdgOutputV1.interface
        ]
    )

/// Create Desktop-Style Surfaces
/// 
/// The xdg_wm_base interface is exposed as a global object enabling clients
/// to turn their wl_surfaces into windows in a desktop environment. It
/// defines the basic functionality needed for clients and the compositor to
/// create windows that can be dragged, resized, maximized, etc, as well as
/// creating transient windows such as popup menus.
public final class XdgWmBase: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_wm_base",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "create_positioner",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_positioner",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_xdg_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_surface",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "pong",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "ping",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy Xdg_Wm_Base
    /// 
    /// Destroy this xdg_wm_base object.
    /// Destroying a bound xdg_wm_base object while there are surfaces
    /// still alive created by this xdg_wm_base object instance is illegal
    /// and will result in a defunct_surfaces error.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A Positioner Object
    /// 
    /// Create a positioner object. A positioner object is used to position
    /// surfaces relative to some parent surface. See the interface description
    /// and xdg_surface.get_popup for details.
    public func createPositioner(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgPositioner {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, XdgPositioner.self, version, _queue, [
            .newId,
        ])
        return id
    }

    /// Create A Shell Surface From A Surface
    /// 
    /// This creates an xdg_surface for the given surface. An xdg_surface is
    /// used as basis to define a role to a given surface, such as xdg_toplevel
    /// or xdg_popup. It also manages functionality shared between xdg_surface
    /// based surface roles.
    /// While xdg_surface itself is not a role, the corresponding surface may
    /// only be assigned a role extending xdg_surface, such as xdg_toplevel or
    /// xdg_popup. It is illegal to create an xdg_surface for a wl_surface which
    /// already has anassigned role and this will result in a role error.
    /// See the documentation of xdg_surface for more details about what an
    /// xdg_surface is and how it is used.
    /// 
    /// - Parameters:
    public func getXdgSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgSurface {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 2, XdgSurface.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    /// Respond To A Ping Event
    /// 
    /// A client must respond to a ping event with a pong request or
    /// the client may be deemed unresponsive. See xdg_wm_base.ping
    /// and xdg_wm_base.error.unresponsive.
    /// 
    /// - Parameters:
    ///   - serial: serial of the ping event
    public func pong(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(serial),
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// given wl_surface has another role
        case role = 0

        /// xdg_wm_base was destroyed before children
        case defunctSurfaces = 1

        /// the client tried to map or destroy a non-topmost popup
        case notTheTopmostPopup = 2

        /// the client specified an invalid popup parent surface
        case invalidPopupParent = 3

        /// the client provided an invalid surface state
        case invalidSurfaceState = 4

        /// the client provided an invalid positioner
        case invalidPositioner = 5

        /// the client didn’t respond to a ping event in time
        case unresponsive = 6
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
        /// Check If The Client Is Alive
        /// 
        /// The ping event asks the client if it's still alive. Pass the
        /// serial specified in the event back to the compositor by sending
        /// a "pong" request back with the specified serial. See xdg_wm_base.pong.
        /// Compositors can use this to determine if the client is still
        /// alive. It's unspecified what will happen if the client doesn't
        /// respond to the ping request, or in what timeframe. Clients should
        /// try to respond in a reasonable amount of time. The “unresponsive”
        /// error is provided for compositors that wish to disconnect unresponsive
        /// clients.
        /// A compositor is free to ping in any way it wants, but a client must
        /// always respond to any xdg_wm_base object it created.
        case ping(serial: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.ping(serial: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Child Surface Positioner
/// 
/// The xdg_positioner provides a collection of rules for the placement of a
/// child surface relative to a parent surface. Rules can be defined to ensure
/// the child surface remains within the visible area's borders, and to
/// specify how the child surface changes its position, such as sliding along
/// an axis, or flipping around a rectangle. These positioner-created rules are
/// constrained by the requirement that a child surface must intersect with or
/// be at least partially adjacent to its parent surface.
/// See the various requests for details about possible rules.
/// At the time of the request, the compositor makes a copy of the rules
/// specified by the xdg_positioner. Thus, after the request is complete the
/// xdg_positioner object can be destroyed or reused; further changes to the
/// object will have no effect on previous usages.
/// For an xdg_positioner object to be considered complete, it must have a
/// non-zero size set by set_size, and a non-zero anchor rectangle set by
/// set_anchor_rect. Passing an incomplete xdg_positioner object when
/// positioning a surface raises an invalid_positioner error.
public final class XdgPositioner: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_positioner",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_size",
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
                    name: "set_anchor_rect",
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
                    name: "set_gravity",
                    arguments: [
                        Argument(
                            name: "gravity",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_constraint_adjustment",
                    arguments: [
                        Argument(
                            name: "constraint_adjustment",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_offset",
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
                    name: "set_reactive",
                    arguments: [
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "set_parent_size",
                    arguments: [
                        Argument(
                            name: "parent_width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "parent_height",
                            type: .int,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "set_parent_configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
            ],
        )
    /// Destroy The Xdg_Positioner Object
    /// 
    /// Notify the compositor that the xdg_positioner will no longer be used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Size Of The To-Be Positioned Rectangle
    /// 
    /// Set the size of the surface that is to be positioned with the positioner
    /// object. The size is in surface-local coordinates and corresponds to the
    /// window geometry. See xdg_surface.set_window_geometry.
    /// If a zero or negative size is set the invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - width: width of positioned rectangle
    ///   - height: height of positioned rectangle
    public func setSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .int(width),
            .int(height),
        ])
    }

    /// Set The Anchor Rectangle Within The Parent Surface
    /// 
    /// Specify the anchor rectangle within the parent surface that the child
    /// surface will be placed relative to. The rectangle is relative to the
    /// window geometry as defined by xdg_surface.set_window_geometry of the
    /// parent surface.
    /// When the xdg_positioner object is used to position a child surface, the
    /// anchor rectangle may not extend outside the window geometry of the
    /// positioned child's parent surface.
    /// If a negative size is set the invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - x: x position of anchor rectangle
    ///   - y: y position of anchor rectangle
    ///   - width: width of anchor rectangle
    ///   - height: height of anchor rectangle
    public func setAnchorRect(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
    }

    /// Set Anchor Rectangle Anchor
    /// 
    /// Defines the anchor point for the anchor rectangle. The specified anchor
    /// is used to derive an anchor point that the child surface will be
    /// positioned relative to. If a corner anchor is set (e.g. 'top_left' or
    /// 'bottom_right'), the anchor point will be at the specified corner;
    /// otherwise, the derived anchor point will be centered on the specified
    /// edge, or in the center of the anchor rectangle if no edge is specified.
    /// 
    /// - Parameters:
    ///   - _: anchor point
    public func setAnchor(_ anchor: Anchor) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(anchor.rawValue),
        ])
    }

    /// Set Child Surface Gravity
    /// 
    /// Defines in what direction a surface should be positioned, relative to
    /// the anchor point of the parent surface. If a corner gravity is
    /// specified (e.g. 'bottom_right' or 'top_left'), then the child surface
    /// will be placed towards the specified gravity; otherwise, the child
    /// surface will be centered over the anchor point on any axis that had no
    /// gravity specified. If the gravity is not in the ‘gravity’ enum, an
    /// invalid_input error is raised.
    /// 
    /// - Parameters:
    ///   - _: gravity direction
    public func setGravity(_ gravity: Gravity) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(gravity.rawValue),
        ])
    }

    /// Set The Adjustment To Be Done When Constrained
    /// 
    /// Specify how the window should be positioned if the originally intended
    /// position caused the surface to be constrained, meaning at least
    /// partially outside positioning boundaries set by the compositor. The
    /// adjustment is set by constructing a bitmask describing the adjustment to
    /// be made when the surface is constrained on that axis.
    /// If no bit for one axis is set, the compositor will assume that the child
    /// surface should not change its position on that axis when constrained.
    /// If more than one bit for one axis is set, the order of how adjustments
    /// are applied is specified in the corresponding adjustment descriptions.
    /// The default adjustment is none.
    /// 
    /// - Parameters:
    ///   - _: bit mask of constraint adjustments
    public func setConstraintAdjustment(_ constraintAdjustment: ConstraintAdjustment) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .uint(constraintAdjustment.rawValue),
        ])
    }

    /// Set Surface Position Offset
    /// 
    /// Specify the surface position offset relative to the position of the
    /// anchor on the anchor rectangle and the anchor on the surface. For
    /// example if the anchor of the anchor rectangle is at (x, y), the surface
    /// has the gravity bottom|right, and the offset is (ox, oy), the calculated
    /// surface position will be (x + ox, y + oy). The offset position of the
    /// surface is the one used for constraint testing. See
    /// set_constraint_adjustment.
    /// An example use case is placing a popup menu on top of a user interface
    /// element, while aligning the user interface element of the parent surface
    /// with some user interface element placed somewhere in the popup surface.
    /// 
    /// - Parameters:
    ///   - x: surface position x offset
    ///   - y: surface position y offset
    public func setOffset(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .int(x),
            .int(y),
        ])
    }

    /// Continuously Reconstrain The Surface
    /// 
    /// When set reactive, the surface is reconstrained if the conditions used
    /// for constraining changed, e.g. the parent window moved.
    /// If the conditions changed and the popup was reconstrained, an
    /// xdg_popup.configure event is sent with updated geometry, followed by an
    /// xdg_surface.configure event.
    public func setReactive() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 7, [
        ])
    }

    /// Set Parent Size
    /// 
    /// Set the parent window geometry the compositor should use when
    /// positioning the popup. The compositor may use this information to
    /// determine the future state the popup should be constrained using. If
    /// this doesn't match the dimension of the parent the popup is eventually
    /// positioned against, the behavior is undefined.
    /// The arguments are given in the surface-local coordinate space.
    /// 
    /// - Parameters:
    ///   - parentWidth: future window geometry width of parent
    ///   - parentHeight: future window geometry height of parent
    public func setParentSize(parentWidth: Int32, parentHeight: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 8, [
            .int(parentWidth),
            .int(parentHeight),
        ])
    }

    /// Set Parent Configure This Is A Response To
    /// 
    /// Set the serial of an xdg_surface.configure event this positioner will be
    /// used in response to. The compositor may use this information together
    /// with set_parent_size to determine what future state the popup should be
    /// constrained using.
    /// 
    /// - Parameters:
    ///   - serial: serial of parent configure event
    public func setParentConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 9, [
            .uint(serial),
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// invalid input provided
        case invalidInput = 0
    }

    public enum Anchor: UInt32 {
        case `none` = 0

        case top = 1

        case bottom = 2

        case `left` = 3

        case `right` = 4

        case topLeft = 5

        case bottomLeft = 6

        case topRight = 7

        case bottomRight = 8
    }

    public enum Gravity: UInt32 {
        case `none` = 0

        case top = 1

        case bottom = 2

        case `left` = 3

        case `right` = 4

        case topLeft = 5

        case bottomLeft = 6

        case topRight = 7

        case bottomRight = 8
    }

    public struct ConstraintAdjustment: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public static let `none`: ConstraintAdjustment = []

        public static let slideX = ConstraintAdjustment(rawValue: 1)

        public static let slideY = ConstraintAdjustment(rawValue: 2)

        public static let flipX = ConstraintAdjustment(rawValue: 4)

        public static let flipY = ConstraintAdjustment(rawValue: 8)

        public static let resizeX = ConstraintAdjustment(rawValue: 16)

        public static let resizeY = ConstraintAdjustment(rawValue: 32)
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

/// Desktop User Interface Surface Base Interface
/// 
/// An interface that may be implemented by a wl_surface, for
/// implementations that provide a desktop-style user interface.
/// It provides a base set of functionality required to construct user
/// interface elements requiring management by the compositor, such as
/// toplevel windows, menus, etc. The types of functionality are split into
/// xdg_surface roles.
/// Creating an xdg_surface does not set the role for a wl_surface. In order
/// to map an xdg_surface, the client must create a role-specific object
/// using, e.g., get_toplevel, get_popup. The wl_surface for any given
/// xdg_surface can have at most one role, and may not be assigned any role
/// not based on xdg_surface.
/// A role must be assigned before any other requests are made to the
/// xdg_surface object.
/// The client must call wl_surface.commit on the corresponding wl_surface
/// for the xdg_surface state to take effect.
/// Creating an xdg_surface from a wl_surface which has a buffer attached or
/// committed is a client error, and any attempts by a client to attach or
/// manipulate a buffer prior to the first xdg_surface.configure call must
/// also be treated as errors.
/// After creating a role-specific object and setting it up (e.g. by sending
/// the title, app ID, size constraints, parent, etc), the client must
/// perform an initial commit without any buffer attached. The compositor
/// will reply with initial wl_surface state such as
/// wl_surface.preferred_buffer_scale followed by an xdg_surface.configure
/// event. The client must acknowledge it and is then allowed to attach a
/// buffer to map the surface.
/// Mapping an xdg_surface-based role surface is defined as making it
/// possible for the surface to be shown by the compositor. Note that
/// a mapped surface is not guaranteed to be visible once it is mapped.
/// For an xdg_surface to be mapped by the compositor, the following
/// conditions must be met:
/// (1) the client has assigned an xdg_surface-based role to the surface
/// (2) the client has set and committed the xdg_surface state and the
/// role-dependent state to the surface
/// (3) the client has committed a buffer to the surface
/// A newly-unmapped surface is considered to have met condition (1) out
/// of the 3 required conditions for mapping a surface if its role surface
/// has not been destroyed, i.e. the client must perform the initial commit
/// again before attaching a buffer.
public final class XdgSurface: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_surface",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_toplevel",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_toplevel",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_popup",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_popup",
                        )
                        ,
                        Argument(
                            name: "parent",
                            type: .object,
                            interface: "xdg_surface",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "positioner",
                            type: .object,
                            interface: "xdg_positioner",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_window_geometry",
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
                    ],
                )
                ,
            ],
        )
    /// Destroy The Xdg_Surface
    /// 
    /// Destroy the xdg_surface object. An xdg_surface must only be destroyed
    /// after its role object has been destroyed, otherwise
    /// a defunct_role_object error is raised.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Assign The Xdg_Toplevel Surface Role
    /// 
    /// This creates an xdg_toplevel object for the given xdg_surface and gives
    /// the associated wl_surface the xdg_toplevel role.
    /// See the documentation of xdg_toplevel for more details about what an
    /// xdg_toplevel is and how it is used.
    public func getToplevel(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgToplevel {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, XdgToplevel.self, version, _queue, [
            .newId,
        ])
        return id
    }

    /// Assign The Xdg_Popup Surface Role
    /// 
    /// This creates an xdg_popup object for the given xdg_surface and gives
    /// the associated wl_surface the xdg_popup role.
    /// If null is passed as a parent, a parent surface must be specified using
    /// some other protocol, before committing the initial state.
    /// See the documentation of xdg_popup for more details about what an
    /// xdg_popup is and how it is used.
    /// 
    /// - Parameters:
    ///   - parent: parent surface for this popup
    ///   - positioner: positioner for this popup
    public func getPopup(parent: XdgSurface? = nil, positioner: XdgPositioner, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgPopup {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 2, XdgPopup.self, version, _queue, [
            .newId,
            .object(parent),
            .object(positioner),
        ])
        return id
    }

    /// Set The New Window Geometry
    /// 
    /// The window geometry of a surface is its "visible bounds" from the
    /// user's perspective. Client-side decorations often have invisible
    /// portions like drop-shadows which should be ignored for the
    /// purposes of aligning, placing and constraining windows. Note that
    /// in some situations, compositors may clip rendering to the window
    /// geometry, so the client should avoid putting functional elements
    /// outside of it.
    /// The window geometry is double-buffered state, see wl_surface.commit.
    /// When maintaining a position, the compositor should treat the (x, y)
    /// coordinate of the window geometry as the top left corner of the window.
    /// A client changing the (x, y) window geometry coordinate should in
    /// general not alter the position of the window.
    /// Once the window geometry of the surface is set, it is not possible to
    /// unset it, and it will remain the same until set_window_geometry is
    /// called again, even if a new subsurface or buffer is attached.
    /// If never set, the value is the full bounds of the surface,
    /// including any subsurfaces. This updates dynamically on every
    /// commit. This unset is meant for extremely simple clients.
    /// The arguments are given in the surface-local coordinate space of
    /// the wl_surface associated with this xdg_surface, and may extend outside
    /// of the wl_surface itself to mark parts of the subsurface tree as part of
    /// the window geometry.
    /// When applied, the effective window geometry will be the set window
    /// geometry clamped to the bounding rectangle of the combined
    /// geometry of the surface of the xdg_surface and the associated
    /// subsurfaces.
    /// The effective geometry will not be recalculated unless a new call to
    /// set_window_geometry is done and the new pending surface state is
    /// subsequently applied.
    /// The width and height of the effective window geometry must be
    /// greater than zero. Setting an invalid size will raise an
    /// invalid_size error.
    /// 
    /// - Parameters:
    ///   - x: x coordinate of the top-left corner of the window inside this surface
    ///   - y: y coordinate of the top-left corner of the window inside this surface
    ///   - width: width of the window
    ///   - height: height of the window
    public func setWindowGeometry(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
    }

    /// Ack A Configure Event
    /// 
    /// When a configure event is received, if a client commits the
    /// surface in response to the configure event, then the client
    /// must make an ack_configure request sometime before the commit
    /// request, passing along the serial of the configure event.
    /// For instance, for toplevel surfaces the compositor might use this
    /// information to move a surface to the top left only when the client has
    /// drawn itself for the maximized or fullscreen state.
    /// If the client receives multiple configure events before it
    /// can respond to one, it only has to ack the last configure event.
    /// Acking a configure event that was never sent raises an invalid_serial
    /// error.
    /// A client is not required to commit immediately after sending
    /// an ack_configure request - it may even ack_configure several times
    /// before its next surface commit.
    /// A client may send multiple ack_configure requests before committing, but
    /// only the last request sent before a commit indicates which configure
    /// event the client really is responding to.
    /// Sending an ack_configure request consumes the serial number sent with
    /// the request, as well as serial numbers sent by all configure events
    /// sent on this xdg_surface prior to the configure event referenced by
    /// the committed serial.
    /// It is an error to issue multiple ack_configure requests referencing a
    /// serial from the same configure event, or to issue an ack_configure
    /// request referencing a serial from a configure event issued before the
    /// event identified by the last ack_configure request for the same
    /// xdg_surface. Doing so will raise an invalid_serial error.
    /// 
    /// - Parameters:
    ///   - serial: the serial from the configure event
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(serial),
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// Surface was not fully constructed
        case notConstructed = 1

        /// Surface was already constructed
        case alreadyConstructed = 2

        /// Attaching a buffer to an unconfigured surface
        case unconfiguredBuffer = 3

        /// Invalid serial number when acking a configure event
        case invalidSerial = 4

        /// Width or height was zero or negative
        case invalidSize = 5

        /// Surface was destroyed before its role object
        case defunctRoleObject = 6
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
        /// Suggest A Surface Change
        /// 
        /// The configure event marks the end of a configure sequence. A configure
        /// sequence is a set of one or more events configuring the state of the
        /// xdg_surface, including the final xdg_surface.configure event.
        /// Where applicable, xdg_surface surface roles will during a configure
        /// sequence extend this event as a latched state sent as events before the
        /// xdg_surface.configure event. Such events should be considered to make up
        /// a set of atomically applied configuration states, where the
        /// xdg_surface.configure commits the accumulated state.
        /// Clients should arrange their surface for the new states, and then send
        /// an ack_configure request with the serial sent in this configure event at
        /// some point before committing the new surface.
        /// If the client receives multiple configure events before it can respond
        /// to one, it is free to discard all but the last event it received.
        case configure(serial: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(serial: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Toplevel Surface
/// 
/// This interface defines an xdg_surface role which allows a surface to,
/// among other things, set window-like properties such as maximize,
/// fullscreen, and minimize, set application-specific metadata like title and
/// id, and well as trigger user interactive operations such as interactive
/// resize and move.
/// An xdg_toplevel by default is responsible for providing the full intended
/// visual representation of the toplevel, which depending on the window
/// state, may mean things like a title bar, window controls and drop shadow.
/// Unmapping an xdg_toplevel means that the surface cannot be shown
/// by the compositor until it is explicitly mapped again.
/// All active operations (e.g., move, resize) are canceled and all
/// attributes (e.g. title, state, stacking, ...) are discarded for
/// an xdg_toplevel surface when it is unmapped. The xdg_toplevel returns to
/// the state it had right after xdg_surface.get_toplevel. The client
/// can re-map the toplevel by performing a commit without any buffer
/// attached, waiting for a configure event and handling it as usual (see
/// xdg_surface description).
/// Attaching a null buffer to a toplevel unmaps the surface.
public final class XdgToplevel: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_parent",
                    arguments: [
                        Argument(
                            name: "parent",
                            type: .object,
                            interface: "xdg_toplevel",
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_title",
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
                    name: "set_app_id",
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
                    name: "show_window_menu",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
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
                    ],
                )
                ,
                Message(
                    name: "move",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
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
                    name: "resize",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "edges",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_max_size",
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
                    name: "set_min_size",
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
                )
                ,
                Message(
                    name: "unset_fullscreen",
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
            ],
            events: [
                Message(
                    name: "configure",
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
                            name: "states",
                            type: .array,
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
                    name: "configure_bounds",
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
                    since: 4
                )
                ,
                Message(
                    name: "wm_capabilities",
                    arguments: [
                        Argument(
                            name: "capabilities",
                            type: .array,
                        )
                        ,
                    ],
                    since: 5
                )
                ,
            ],
        )
    /// Destroy The Xdg_Toplevel
    /// 
    /// This request destroys the role surface and unmaps the surface;
    /// see "Unmapping" behavior in interface section for details.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Parent Of This Surface
    /// 
    /// Set the "parent" of this surface. This surface should be stacked
    /// above the parent surface and all other ancestor surfaces.
    /// Parent surfaces should be set on dialogs, toolboxes, or other
    /// "auxiliary" surfaces, so that the parent is raised when the dialog
    /// is raised.
    /// Setting a null parent for a child surface unsets its parent. Setting
    /// a null parent for a surface which currently has no parent is a no-op.
    /// Only mapped surfaces can have child surfaces. Setting a parent which
    /// is not mapped is equivalent to setting a null parent. If a surface
    /// becomes unmapped, its children's parent is set to the parent of
    /// the now-unmapped surface. If the now-unmapped surface has no parent,
    /// its children's parent is unset. If the now-unmapped surface becomes
    /// mapped again, its parent-child relationship is not restored.
    /// The parent toplevel must not be one of the child toplevel's
    /// descendants, and the parent must be different from the child toplevel,
    /// otherwise the invalid_parent protocol error is raised.
    /// 
    /// - Parameters:
    ///   - _: parent surface for this surface
    public func setParent(_ parent: XdgToplevel? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(parent),
        ])
    }

    /// Set Surface Title
    /// 
    /// Set a short title for the surface.
    /// This string may be used to identify the surface in a task bar,
    /// window list, or other user interface elements provided by the
    /// compositor.
    /// The string must be encoded in UTF-8.
    /// 
    /// - Parameters:
    ///   - _: title of the surface
    public func setTitle(_ title: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .string(title),
        ])
    }

    /// Set Application Id
    /// 
    /// Set an application identifier for the surface.
    /// The app ID identifies the general class of applications to which
    /// the surface belongs. The compositor can use this to group multiple
    /// surfaces together, or to determine how to launch a new application.
    /// For D-Bus activatable applications, the app ID is used as the D-Bus
    /// service name.
    /// The compositor shell will try to group application surfaces together
    /// by their app ID. As a best practice, it is suggested to select app
    /// ID's that match the basename of the application's .desktop file.
    /// For example, "org.freedesktop.FooViewer" where the .desktop file is
    /// "org.freedesktop.FooViewer.desktop".
    /// Like other properties, a set_app_id request can be sent after the
    /// xdg_toplevel has been mapped to update the property.
    /// See the desktop-entry specification [0] for more details on
    /// application identifiers and how they relate to well-known D-Bus
    /// names and .desktop files.
    /// [0] https://standards.freedesktop.org/desktop-entry-spec/
    /// 
    /// - Parameters:
    ///   - _: application identifier surface belongs to
    public func setAppId(_ appId: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .string(appId),
        ])
    }

    /// Show The Window Menu
    /// 
    /// Clients implementing client-side decorations might want to show
    /// a context menu when right-clicking on the decorations, giving the
    /// user a menu that they can use to maximize or minimize the window.
    /// This request asks the compositor to pop up such a window menu at
    /// the given position, relative to the local surface coordinates of
    /// the parent surface. There are no guarantees as to what menu items
    /// the window menu contains, or even if a window menu will be drawn
    /// at all.
    /// This request must be used in response to some sort of user action
    /// like a button press, key press, or touch down event.
    /// 
    /// - Parameters:
    ///   - seat: the wl_seat of the user event
    ///   - serial: the serial of the user event
    ///   - x: the x position to pop up the window menu at
    ///   - y: the y position to pop up the window menu at
    public func showWindowMenu(seat: WlSeat, serial: UInt32, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(seat),
            .uint(serial),
            .int(x),
            .int(y),
        ])
    }

    /// Start An Interactive Move
    /// 
    /// Start an interactive, user-driven move of the surface.
    /// This request must be used in response to some sort of user action
    /// like a button press, key press, or touch down event. The passed
    /// serial is used to determine the type of interactive move (touch,
    /// pointer, etc).
    /// The server may ignore move requests depending on the state of
    /// the surface (e.g. fullscreen or maximized), or if the passed serial
    /// is no longer valid.
    /// If triggered, the surface will lose the focus of the device
    /// (wl_pointer, wl_touch, etc) used for the move. It is up to the
    /// compositor to visually indicate that the move is taking place, such as
    /// updating a pointer cursor, during the move. There is no guarantee
    /// that the device focus will return when the move is completed.
    /// 
    /// - Parameters:
    ///   - seat: the wl_seat of the user event
    ///   - serial: the serial of the user event
    public func move(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .object(seat),
            .uint(serial),
        ])
    }

    /// Start An Interactive Resize
    /// 
    /// Start a user-driven, interactive resize of the surface.
    /// This request must be used in response to some sort of user action
    /// like a button press, key press, or touch down event. The passed
    /// serial is used to determine the type of interactive resize (touch,
    /// pointer, etc).
    /// The server may ignore resize requests depending on the state of
    /// the surface (e.g. fullscreen or maximized).
    /// If triggered, the client will receive configure events with the
    /// "resize" state enum value and the expected sizes. See the "resize"
    /// enum value for more details about what is required. The client
    /// must also acknowledge configure events using "ack_configure". After
    /// the resize is completed, the client will receive another "configure"
    /// event without the resize state.
    /// If triggered, the surface also will lose the focus of the device
    /// (wl_pointer, wl_touch, etc) used for the resize. It is up to the
    /// compositor to visually indicate that the resize is taking place,
    /// such as updating a pointer cursor, during the resize. There is no
    /// guarantee that the device focus will return when the resize is
    /// completed.
    /// The edges parameter specifies how the surface should be resized, and
    /// is one of the values of the resize_edge enum. Values not matching
    /// a variant of the enum will cause the invalid_resize_edge protocol error.
    /// The compositor may use this information to update the surface position
    /// for example when dragging the top left corner. The compositor may also
    /// use this information to adapt its behavior, e.g. choose an appropriate
    /// cursor image.
    /// 
    /// - Parameters:
    ///   - seat: the wl_seat of the user event
    ///   - serial: the serial of the user event
    ///   - edges: which edge or corner is being dragged
    public func resize(seat: WlSeat, serial: UInt32, edges: ResizeEdge) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .object(seat),
            .uint(serial),
            .uint(edges.rawValue),
        ])
    }

    /// Set The Maximum Size
    /// 
    /// Set a maximum size for the window.
    /// The client can specify a maximum size so that the compositor does
    /// not try to configure the window beyond this size.
    /// The width and height arguments are in window geometry coordinates.
    /// See xdg_surface.set_window_geometry.
    /// Values set in this way are double-buffered, see wl_surface.commit.
    /// The compositor can use this information to allow or disallow
    /// different states like maximize or fullscreen and draw accurate
    /// animations.
    /// Similarly, a tiling window manager may use this information to
    /// place and resize client windows in a more effective way.
    /// The client should not rely on the compositor to obey the maximum
    /// size. The compositor may decide to ignore the values set by the
    /// client and request a larger size.
    /// If never set, or a value of zero in the request, means that the
    /// client has no expected maximum size in the given dimension.
    /// As a result, a client wishing to reset the maximum size
    /// to an unspecified state can use zero for width and height in the
    /// request.
    /// Requesting a maximum size to be smaller than the minimum size of
    /// a surface is illegal and will result in an invalid_size error.
    /// The width and height must be greater than or equal to zero. Using
    /// strictly negative values for width or height will result in an
    /// invalid_size error.
    /// 
    /// - Parameters:
    ///   - width: maximum width of the window
    ///   - height: maximum height of the window
    public func setMaxSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .int(width),
            .int(height),
        ])
    }

    /// Set The Minimum Size
    /// 
    /// Set a minimum size for the window.
    /// The client can specify a minimum size so that the compositor does
    /// not try to configure the window below this size.
    /// The width and height arguments are in window geometry coordinates.
    /// See xdg_surface.set_window_geometry.
    /// Values set in this way are double-buffered, see wl_surface.commit.
    /// The compositor can use this information to allow or disallow
    /// different states like maximize or fullscreen and draw accurate
    /// animations.
    /// Similarly, a tiling window manager may use this information to
    /// place and resize client windows in a more effective way.
    /// The client should not rely on the compositor to obey the minimum
    /// size. The compositor may decide to ignore the values set by the
    /// client and request a smaller size.
    /// If never set, or a value of zero in the request, means that the
    /// client has no expected minimum size in the given dimension.
    /// As a result, a client wishing to reset the minimum size
    /// to an unspecified state can use zero for width and height in the
    /// request.
    /// Requesting a minimum size to be larger than the maximum size of
    /// a surface is illegal and will result in an invalid_size error.
    /// The width and height must be greater than or equal to zero. Using
    /// strictly negative values for width and height will result in an
    /// invalid_size error.
    /// 
    /// - Parameters:
    ///   - width: minimum width of the window
    ///   - height: minimum height of the window
    public func setMinSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .int(width),
            .int(height),
        ])
    }

    /// Maximize The Window
    /// 
    /// Maximize the surface.
    /// After requesting that the surface should be maximized, the compositor
    /// will respond by emitting a configure event. Whether this configure
    /// actually sets the window maximized is subject to compositor policies.
    /// The client must then update its content, drawing in the configured
    /// state. The client must also acknowledge the configure when committing
    /// the new content (see ack_configure).
    /// It is up to the compositor to decide how and where to maximize the
    /// surface, for example which output and what region of the screen should
    /// be used.
    /// If the surface was already maximized, the compositor will still emit
    /// a configure event with the "maximized" state.
    /// If the surface is in a fullscreen state, this request has no direct
    /// effect. It may alter the state the surface is returned to when
    /// unmaximized unless overridden by the compositor.
    public func setMaximized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
        ])
    }

    /// Unmaximize The Window
    /// 
    /// Unmaximize the surface.
    /// After requesting that the surface should be unmaximized, the compositor
    /// will respond by emitting a configure event. Whether this actually
    /// un-maximizes the window is subject to compositor policies.
    /// If available and applicable, the compositor will include the window
    /// geometry dimensions the window had prior to being maximized in the
    /// configure event. The client must then update its content, drawing it in
    /// the configured state. The client must also acknowledge the configure
    /// when committing the new content (see ack_configure).
    /// It is up to the compositor to position the surface after it was
    /// unmaximized; usually the position the surface had before maximizing, if
    /// applicable.
    /// If the surface was already not maximized, the compositor will still
    /// emit a configure event without the "maximized" state.
    /// If the surface is in a fullscreen state, this request has no direct
    /// effect. It may alter the state the surface is returned to when
    /// unmaximized unless overridden by the compositor.
    public func unsetMaximized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 10, [
        ])
    }

    /// Set The Window As Fullscreen On An Output
    /// 
    /// Make the surface fullscreen.
    /// After requesting that the surface should be fullscreened, the
    /// compositor will respond by emitting a configure event. Whether the
    /// client is actually put into a fullscreen state is subject to compositor
    /// policies. The client must also acknowledge the configure when
    /// committing the new content (see ack_configure).
    /// The output passed by the request indicates the client's preference as
    /// to which display it should be set fullscreen on. If this value is NULL,
    /// it's up to the compositor to choose which display will be used to map
    /// this surface.
    /// If the surface doesn't cover the whole output, the compositor will
    /// position the surface in the center of the output and compensate with
    /// border fill covering the rest of the output. The content of the
    /// border fill is undefined, but should be assumed to be in some way that
    /// attempts to blend into the surrounding area (e.g. solid black).
    /// If the fullscreened surface is not opaque, the compositor must make
    /// sure that other screen content not part of the same surface tree (made
    /// up of subsurfaces, popups or similarly coupled surfaces) are not
    /// visible below the fullscreened surface.
    /// 
    /// - Parameters:
    ///   - output: preferred output to place surface on
    public func setFullscreen(output: WlOutput? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 11, [
            .object(output),
        ])
    }

    /// Unset The Window As Fullscreen
    /// 
    /// Make the surface no longer fullscreen.
    /// After requesting that the surface should be unfullscreened, the
    /// compositor will respond by emitting a configure event.
    /// Whether this actually removes the fullscreen state of the client is
    /// subject to compositor policies.
    /// Making a surface unfullscreen sets states for the surface based on the following:
    /// * the state(s) it may have had before becoming fullscreen
    /// * any state(s) decided by the compositor
    /// * any state(s) requested by the client while the surface was fullscreen
    /// The compositor may include the previous window geometry dimensions in
    /// the configure event, if applicable.
    /// The client must also acknowledge the configure when committing the new
    /// content (see ack_configure).
    public func unsetFullscreen() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 12, [
        ])
    }

    /// Set The Window As Minimized
    /// 
    /// Request that the compositor minimize your surface. There is no
    /// way to know if the surface is currently minimized, nor is there
    /// any way to unset minimization on this surface.
    /// If you are looking to throttle redrawing when minimized, please
    /// instead use the wl_surface.frame event for this, as this will
    /// also work with live previews on windows in Alt-Tab, Expose or
    /// similar compositor features.
    public func setMinimized() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 13, [
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// provided value is         not a valid variant of the resize_edge enum
        case invalidResizeEdge = 0

        /// invalid parent toplevel
        case invalidParent = 1

        /// client provided an invalid min or max size
        case invalidSize = 2
    }

    public enum ResizeEdge: UInt32 {
        case `none` = 0

        case top = 1

        case bottom = 2

        case `left` = 4

        case topLeft = 5

        case bottomLeft = 6

        case `right` = 8

        case topRight = 9

        case bottomRight = 10
    }

    public enum State: UInt32 {
        /// the surface is maximized
        case maximized = 1

        /// the surface is fullscreen
        case fullscreen = 2

        /// the surface is being resized
        case resizing = 3

        /// the surface is now activated
        case activated = 4

        case tiledLeft = 5

        case tiledRight = 6

        case tiledTop = 7

        case tiledBottom = 8

        case suspended = 9

        case constrainedLeft = 10

        case constrainedRight = 11

        case constrainedTop = 12

        case constrainedBottom = 13
    }

    public enum WmCapabilities: UInt32 {
        /// show_window_menu is available
        case windowMenu = 1

        /// set_maximized and unset_maximized are available
        case maximize = 2

        /// set_fullscreen and unset_fullscreen are available
        case fullscreen = 3

        /// set_minimized is available
        case minimize = 4
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
        /// Suggest A Surface Change
        /// 
        /// This configure event asks the client to resize its toplevel surface or
        /// to change its state. The configured state should not be applied
        /// immediately. See xdg_surface.configure for details.
        /// The width and height arguments specify a hint to the window
        /// about how its surface should be resized in window geometry
        /// coordinates. See set_window_geometry.
        /// If the width or height arguments are zero, it means the client
        /// should decide its own window dimension. This may happen when the
        /// compositor needs to configure the state of the surface but doesn't
        /// have any information about any previous or expected dimension.
        /// The states listed in the event specify how the width/height
        /// arguments should be interpreted, and possibly how it should be
        /// drawn.
        /// The states are sent as an array of 32-bit unsigned integers in
        /// native endianness. State values are defined in the state enum.
        /// Clients must send an ack_configure in response to this event. See
        /// xdg_surface.configure and xdg_surface.ack_configure for details.
        case configure(width: Int32, height: Int32, states: UnsafeRawBufferPointer)

        /// Surface Wants To Be Closed
        /// 
        /// The close event is sent by the compositor when the user
        /// wants the surface to be closed. This should be equivalent to
        /// the user clicking the close button in client-side decorations,
        /// if your application has any.
        /// This is only a request that the user intends to close the
        /// window. The client may choose to ignore this request, or show
        /// a dialog to ask the user to save their data, etc.
        case close

        /// Recommended Window Geometry Bounds
        /// 
        /// The configure_bounds event may be sent prior to a xdg_toplevel.configure
        /// event to communicate the bounds a window geometry size is recommended
        /// to constrain to.
        /// The passed width and height are in surface coordinate space. If width
        /// and height are 0, it means bounds is unknown and equivalent to as if no
        /// configure_bounds event was ever sent for this surface.
        /// The bounds can for example correspond to the size of a monitor excluding
        /// any panels or other shell components, so that a surface isn't created in
        /// a way that it cannot fit.
        /// The bounds may change at any point, and in such a case, a new
        /// xdg_toplevel.configure_bounds will be sent, followed by
        /// xdg_toplevel.configure and xdg_surface.configure.
        case configureBounds(width: Int32, height: Int32)

        /// Compositor Capabilities
        /// 
        /// This event advertises the capabilities supported by the compositor. If
        /// a capability isn't supported, clients should hide or disable the UI
        /// elements that expose this functionality. For instance, if the
        /// compositor doesn't advertise support for minimized toplevels, a button
        /// triggering the set_minimized request should not be displayed.
        /// The compositor will ignore requests it doesn't support. For instance,
        /// a compositor which doesn't advertise support for minimized will ignore
        /// set_minimized requests.
        /// Compositors must send this event once before the first
        /// xdg_surface.configure event. When the capabilities change, compositors
        /// must send this event again and then send an xdg_surface.configure
        /// event.
        /// The configured state should not be applied immediately. See
        /// xdg_surface.configure for details.
        /// The capabilities are sent as an array of 32-bit unsigned integers in
        /// native endianness. Capability values are defined in the wm_capabilities enum.
        case wmCapabilities(capabilities: UnsafeRawBufferPointer)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(width: r.int(), height: r.int(), states: r.array())
            case 1:
                self = Self.close
            case 2:
                self = Self.configureBounds(width: r.int(), height: r.int())
            case 3:
                self = Self.wmCapabilities(capabilities: r.array())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Short-Lived, Popup Surfaces For Menus
/// 
/// A popup surface is a short-lived, temporary surface. It can be used to
/// implement for example menus, popovers, tooltips and other similar user
/// interface concepts.
/// A popup can be made to take an explicit grab. See xdg_popup.grab for
/// details.
/// When the popup is dismissed, a popup_done event will be sent out, and at
/// the same time the surface will be unmapped. See the xdg_popup.popup_done
/// event for details.
/// Explicitly destroying the xdg_popup object will also dismiss the popup and
/// unmap the surface. Clients that want to dismiss the popup when another
/// surface of their own is clicked should dismiss the popup using the destroy
/// request.
/// A newly created xdg_popup will be stacked on top of all previously created
/// xdg_popup surfaces associated with the same xdg_toplevel.
/// The parent of an xdg_popup must be mapped (see the xdg_surface
/// description) before the xdg_popup itself.
/// The client must call wl_surface.commit on the corresponding wl_surface
/// for the xdg_popup state to take effect.
public final class XdgPopup: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_popup",
            version: 7,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "grab",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
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
                    name: "reposition",
                    arguments: [
                        Argument(
                            name: "positioner",
                            type: .object,
                            interface: "xdg_positioner",
                        )
                        ,
                        Argument(
                            name: "token",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
            ],
            events: [
                Message(
                    name: "configure",
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
                    name: "popup_done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "repositioned",
                    arguments: [
                        Argument(
                            name: "token",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
            ],
        )
    /// Remove Xdg_Popup Interface
    /// 
    /// This destroys the popup. Explicitly destroying the xdg_popup
    /// object will also dismiss the popup, and unmap the surface.
    /// If this xdg_popup is not the "topmost" popup, the
    /// xdg_wm_base.not_the_topmost_popup protocol error will be sent.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Make The Popup Take An Explicit Grab
    /// 
    /// This request makes the created popup take an explicit grab. An explicit
    /// grab will be dismissed when the user dismisses the popup, or when the
    /// client destroys the xdg_popup. This can be done by the user clicking
    /// outside the surface, using the keyboard, or even locking the screen
    /// through closing the lid or a timeout.
    /// If the compositor denies the grab, the popup will be immediately
    /// dismissed.
    /// This request must be used in response to some sort of user action like a
    /// button press, key press, or touch down event. The serial number of the
    /// event should be passed as 'serial'.
    /// The parent of a grabbing popup must either be an xdg_toplevel surface or
    /// another xdg_popup with an explicit grab. If the parent is another
    /// xdg_popup it means that the popups are nested, with this popup now being
    /// the topmost popup.
    /// Nested popups must be destroyed in the reverse order they were created
    /// in, e.g. the only popup you are allowed to destroy at all times is the
    /// topmost one.
    /// When compositors choose to dismiss a popup, they may dismiss every
    /// nested grabbing popup as well. When a compositor dismisses popups, it
    /// will follow the same dismissing order as required from the client.
    /// If the topmost grabbing popup is destroyed, the grab will be returned to
    /// the parent of the popup, if that parent previously had an explicit grab.
    /// If the parent is a grabbing popup which has already been dismissed, this
    /// popup will be immediately dismissed. If the parent is a popup that did
    /// not take an explicit grab, an error will be raised.
    /// During a popup grab, the client owning the grab will receive pointer
    /// and touch events for all their surfaces as normal (similar to an
    /// "owner-events" grab in X11 parlance), while the top most grabbing popup
    /// will always have keyboard focus.
    /// 
    /// - Parameters:
    ///   - seat: the wl_seat of the user event
    ///   - serial: the serial of the user event
    public func grab(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(seat),
            .uint(serial),
        ])
    }

    /// Recalculate The Popup's Location
    /// 
    /// Reposition an already-mapped popup. The popup will be placed given the
    /// details in the passed xdg_positioner object, and a
    /// xdg_popup.repositioned followed by xdg_popup.configure and
    /// xdg_surface.configure will be emitted in response. Any parameters set
    /// by the previous positioner will be discarded.
    /// The passed token will be sent in the corresponding
    /// xdg_popup.repositioned event. The new popup position will not take
    /// effect until the corresponding configure event is acknowledged by the
    /// client. See xdg_popup.repositioned for details. The token itself is
    /// opaque, and has no other special meaning.
    /// If multiple reposition requests are sent, the compositor may skip all
    /// but the last one.
    /// If the popup is repositioned in response to a configure event for its
    /// parent, the client should send an xdg_positioner.set_parent_configure
    /// and possibly an xdg_positioner.set_parent_size request to allow the
    /// compositor to properly constrain the popup.
    /// If the popup is repositioned together with a parent that is being
    /// resized, but not in response to a configure event, the client should
    /// send an xdg_positioner.set_parent_size request.
    /// 
    /// - Parameters:
    ///   - token: reposition request token
    public func reposition(positioner: XdgPositioner, token: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 2, [
            .object(positioner),
            .uint(token),
        ])
    }

    
    public static let `protocol`: Protocol = XdgShellProtocol
    
    public enum Error: UInt32 {
        /// tried to grab after being mapped
        case invalidGrab = 0
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
        /// Configure The Popup Surface
        /// 
        /// This event asks the popup surface to configure itself given the
        /// configuration. The configured state should not be applied immediately.
        /// See xdg_surface.configure for details.
        /// The x and y arguments represent the position the popup was placed at
        /// given the xdg_positioner rule, relative to the upper left corner of the
        /// window geometry of the parent surface.
        /// For version 2 or older, the configure event for an xdg_popup is only
        /// ever sent once for the initial configuration. Starting with version 3,
        /// it may be sent again if the popup is setup with an xdg_positioner with
        /// set_reactive requested, or in response to xdg_popup.reposition requests.
        case configure(x: Int32, y: Int32, width: Int32, height: Int32)

        /// Popup Interaction Is Done
        /// 
        /// The popup_done event is sent out when a popup is dismissed by the
        /// compositor. The client should destroy the xdg_popup object at this
        /// point.
        case popupDone

        /// Signal The Completion Of A Repositioned Request
        /// 
        /// The repositioned event is sent as part of a popup configuration
        /// sequence, together with xdg_popup.configure and lastly
        /// xdg_surface.configure to notify the completion of a reposition request.
        /// The repositioned event is to notify about the completion of a
        /// xdg_popup.reposition request. The token argument is the token passed
        /// in the xdg_popup.reposition request.
        /// Immediately after this event is emitted, xdg_popup.configure and
        /// xdg_surface.configure will be sent with the updated size and position,
        /// as well as a new configure serial.
        /// The client should optionally update the content of the popup, but must
        /// acknowledge the new popup configuration for the new position to take
        /// effect. See xdg_surface.ack_configure for details.
        case repositioned(token: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(x: r.int(), y: r.int(), width: r.int(), height: r.int())
            case 1:
                self = Self.popupDone
            case 2:
                self = Self.repositioned(token: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let XdgShellProtocol = Protocol(
        name: "xdg_shell",
        interfaces: [
            XdgWmBase.interface,
XdgPositioner.interface,
XdgSurface.interface,
XdgToplevel.interface,
XdgPopup.interface
        ]
    )

/// Move A Window During A Drag
/// 
/// This protocol enhances normal drag and drop with the ability to move a
/// window at the same time. This allows having detachable parts of a window
/// that when dragged out of it become a new window and can be dragged over
/// an existing window to be reattached.
/// A typical workflow would be when the user starts dragging on top of a
/// detachable part of a window, the client would create a wl_data_source and
/// a xdg_toplevel_drag_v1 object and start the drag as normal via
/// wl_data_device.start_drag. Once the client determines that the detachable
/// window contents should be detached from the originating window, it creates
/// a new xdg_toplevel with these contents and issues a
/// xdg_toplevel_drag_v1.attach request before mapping it. From now on the new
/// window is moved by the compositor during the drag as if the client called
/// xdg_toplevel.move.
/// Dragging an existing window is similar. The client creates a
/// xdg_toplevel_drag_v1 object and attaches the existing toplevel before
/// starting the drag.
/// Clients use the existing drag and drop mechanism to detect when a window
/// can be docked or undocked. If the client wants to snap a window into a
/// parent window it should delete or unmap the dragged top-level. If the
/// contents should be detached again it attaches a new toplevel as described
/// above. If a drag operation is cancelled without being dropped, clients
/// should revert to the previous state, deleting any newly created windows
/// as appropriate. When a drag operation ends as indicated by
/// wl_data_source.dnd_drop_performed the dragged toplevel window's final
/// position is determined as if a xdg_toplevel_move operation ended.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgToplevelDragManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel_drag_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_xdg_toplevel_drag",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_toplevel_drag_v1",
                        )
                        ,
                        Argument(
                            name: "data_source",
                            type: .object,
                            interface: "wl_data_source",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Xdg_Toplevel_Drag_Manager_V1 Object
    /// 
    /// Destroy this xdg_toplevel_drag_manager_v1 object. Other objects,
    /// including xdg_toplevel_drag_v1 objects created by this factory, are not
    /// affected by this request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Get An Xdg_Toplevel_Drag For A Wl_Data_Source
    /// 
    /// Create an xdg_toplevel_drag for a drag and drop operation that is going
    /// to be started with data_source.
    /// This request can only be made on sources used in drag-and-drop, so it
    /// must be performed before wl_data_device.start_drag. Attempting to use
    /// the source other than for drag-and-drop such as in
    /// wl_data_device.set_selection will raise an invalid_source error.
    /// Destroying data_source while a toplevel is attached to the
    /// xdg_toplevel_drag is undefined.
    /// 
    /// - Parameters:
    public func getXdgToplevelDrag(dataSource: WlDataSource, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgToplevelDragV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, XdgToplevelDragV1.self, version, _queue, [
            .newId,
            .object(dataSource),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XdgToplevelDragV1Protocol
    
    public enum Error: UInt32 {
        /// data_source already used for toplevel drag
        case invalidSource = 0
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

/// Object Representing A Toplevel Move During A Drag
/// 
/// 
public final class XdgToplevelDragV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel_drag_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "attach",
                    arguments: [
                        Argument(
                            name: "toplevel",
                            type: .object,
                            interface: "xdg_toplevel",
                        )
                        ,
                        Argument(
                            name: "x_offset",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "y_offset",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy An Xdg_Toplevel_Drag_V1 Object
    /// 
    /// Destroy this xdg_toplevel_drag_v1 object. This request must only be
    /// called after the underlying wl_data_source drag has ended, as indicated
    /// by the dnd_drop_performed or cancelled events. In any other case an
    /// ongoing_drag error is raised.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Move A Toplevel With The Drag Operation
    /// 
    /// Request that the window will be moved with the cursor during the drag
    /// operation. The offset is a hint to the compositor how the toplevel
    /// should be positioned relative to the cursor hotspot in surface local
    /// coordinates and relative to the geometry of the toplevel being attached.
    /// See xdg_surface.set_window_geometry. For example it might only
    /// be used when an unmapped window is attached. The attached window
    /// does not participate in the selection of the drag target.
    /// If the toplevel is unmapped while it is attached, it is automatically
    /// detached from the drag. In this case this request has to be called again
    /// if the window should be attached after it is remapped.
    /// This request can be called multiple times but issuing it while a
    /// toplevel with an active role is attached raises a toplevel_attached
    /// error.
    /// 
    /// - Parameters:
    ///   - xOffset: dragged surface x offset
    ///   - yOffset: dragged surface y offset
    public func attach(toplevel: XdgToplevel, xOffset: Int32, yOffset: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(toplevel),
            .int(xOffset),
            .int(yOffset),
        ])
    }

    
    public static let `protocol`: Protocol = XdgToplevelDragV1Protocol
    
    public enum Error: UInt32 {
        /// valid toplevel already attached
        case toplevelAttached = 0

        /// drag has not ended
        case ongoingDrag = 1
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


public let XdgToplevelDragV1Protocol = Protocol(
        name: "xdg_toplevel_drag_v1",
        interfaces: [
            XdgToplevelDragManagerV1.interface,
XdgToplevelDragV1.interface
        ]
    )

/// Create Dialogs Related To Other Toplevels
/// 
/// The xdg_wm_dialog_v1 interface is exposed as a global object allowing
/// to register surfaces with a xdg_toplevel role as "dialogs" relative to
/// another toplevel.
/// The compositor may let this relation influence how the surface is
/// placed, displayed or interacted with.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgWmDialogV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_wm_dialog_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_xdg_dialog",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_dialog_v1",
                        )
                        ,
                        Argument(
                            name: "toplevel",
                            type: .object,
                            interface: "xdg_toplevel",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Dialog Manager Object
    /// 
    /// Destroys the xdg_wm_dialog_v1 object. This does not affect
    /// the xdg_dialog_v1 objects generated through it.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A Dialog Object
    /// 
    /// Creates a xdg_dialog_v1 object for the given toplevel. See the interface
    /// description for more details.
    /// Compositors must raise an already_used error if clients attempt to
    /// create multiple xdg_dialog_v1 objects for the same xdg_toplevel.
    /// 
    /// - Parameters:
    public func getXdgDialog(toplevel: XdgToplevel, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgDialogV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, XdgDialogV1.self, version, _queue, [
            .newId,
            .object(toplevel),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = XdgDialogV1Protocol
    
    public enum Error: UInt32 {
        /// the xdg_toplevel object has already been used to create a xdg_dialog_v1
        case alreadyUsed = 0
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

/// Dialog Object
/// 
/// A xdg_dialog_v1 object is an ancillary object tied to a xdg_toplevel. Its
/// purpose is hinting the compositor that the toplevel is a "dialog" (e.g. a
/// temporary window) relative to another toplevel (see
/// xdg_toplevel.set_parent). If the xdg_toplevel is destroyed, the xdg_dialog_v1
/// becomes inert.
/// Through this object, the client may provide additional hints about
/// the purpose of the secondary toplevel. This interface has no effect
/// on toplevels that are not attached to a parent toplevel.
public final class XdgDialogV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_dialog_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_modal",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "unset_modal",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Dialog Object
    /// 
    /// Destroys the xdg_dialog_v1 object. If this object is destroyed
    /// before the related xdg_toplevel, the compositor should unapply its
    /// effects.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Mark Dialog As Modal
    /// 
    /// Hints that the dialog has "modal" behavior. Modal dialogs typically
    /// require to be fully addressed by the user (i.e. closed) before resuming
    /// interaction with the parent toplevel, and may require a distinct
    /// presentation.
    /// Clients must implement the logic to filter events in the parent
    /// toplevel on their own.
    /// Compositors may choose any policy in event delivery to the parent
    /// toplevel, from delivering all events unfiltered to using them for
    /// internal consumption.
    public func setModal() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Mark Dialog As Not Modal
    /// 
    /// Drops the hint that this dialog has "modal" behavior. See
    /// xdg_dialog_v1.set_modal for more details.
    public func unsetModal() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = XdgDialogV1Protocol
    
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


public let XdgDialogV1Protocol = Protocol(
        name: "xdg_dialog_v1",
        interfaces: [
            XdgWmDialogV1.interface,
XdgDialogV1.interface
        ]
    )

/// Interface To Manage Toplevel Icons
/// 
/// This interface allows clients to create toplevel window icons and set
/// them on toplevel windows to be displayed to the user.
public final class XdgToplevelIconManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel_icon_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "create_icon",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "xdg_toplevel_icon_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_icon",
                    arguments: [
                        Argument(
                            name: "toplevel",
                            type: .object,
                            interface: "xdg_toplevel",
                        )
                        ,
                        Argument(
                            name: "icon",
                            type: .object,
                            interface: "xdg_toplevel_icon_v1",
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "icon_size",
                    arguments: [
                        Argument(
                            name: "size",
                            type: .int,
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
            ],
        )
    /// Destroy The Toplevel Icon Manager
    /// 
    /// Destroy the toplevel icon manager.
    /// This does not destroy objects created with the manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A New Icon Instance
    /// 
    /// Creates a new icon object. This icon can then be attached to a
    /// xdg_toplevel via the 'set_icon' request.
    public func createIcon(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgToplevelIconV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, XdgToplevelIconV1.self, version, _queue, [
            .newId,
        ])
        return id
    }

    /// Set An Icon On A Toplevel Window
    /// 
    /// This request assigns the icon 'icon' to 'toplevel', or clears the
    /// toplevel icon if 'icon' was null.
    /// This state is double-buffered and is applied on the next
    /// wl_surface.commit of the toplevel.
    /// After making this call, the xdg_toplevel_icon_v1 provided as 'icon'
    /// can be destroyed by the client without 'toplevel' losing its icon.
    /// The xdg_toplevel_icon_v1 is immutable from this point, and any
    /// future attempts to change it must raise the
    /// 'xdg_toplevel_icon_v1.immutable' protocol error.
    /// The compositor must set the toplevel icon from either the pixel data
    /// the icon provides, or by loading a stock icon using the icon name.
    /// See the description of 'xdg_toplevel_icon_v1' for details.
    /// If 'icon' is set to null, the icon of the respective toplevel is reset
    /// to its default icon (usually the icon of the application, derived from
    /// its desktop-entry file, or a placeholder icon).
    /// If this request is passed an icon with no pixel buffers or icon name
    /// assigned, the icon must be reset just like if 'icon' was null.
    /// 
    /// - Parameters:
    ///   - toplevel: the toplevel to act on
    public func setIcon(toplevel: XdgToplevel, icon: XdgToplevelIconV1? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(toplevel),
            .object(icon),
        ])
    }

    
    public static let `protocol`: Protocol = XdgToplevelIconV1Protocol
    
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
        /// Describes A Supported & Preferred Icon Size
        /// 
        /// This event indicates an icon size the compositor prefers to be
        /// available if the client has scalable icons and can render to any size.
        /// When the 'xdg_toplevel_icon_manager_v1' object is created, the
        /// compositor may send one or more 'icon_size' events to describe the list
        /// of preferred icon sizes. If the compositor has no size preference, it
        /// may not send any 'icon_size' event, and it is up to the client to
        /// decide a suitable icon size.
        /// A sequence of 'icon_size' events must be finished with a 'done' event.
        /// If the compositor has no size preferences, it must still send the
        /// 'done' event, without any preceding 'icon_size' events.
        case iconSize(size: Int32)

        /// All Information Has Been Sent
        /// 
        /// This event is sent after all 'icon_size' events have been sent.
        case done

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.iconSize(size: r.int())
            case 1:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Toplevel Window Icon
/// 
/// This interface defines a toplevel icon.
/// An icon can have a name, and multiple buffers.
/// In order to be applied, the icon must have either a name, or at least
/// one buffer assigned. Applying an empty icon (with no buffer or name) to
/// a toplevel should reset its icon to the default icon.
/// It is up to compositor policy whether to prefer using a buffer or loading
/// an icon via its name. See 'set_name' and 'add_buffer' for details.
public final class XdgToplevelIconV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel_icon_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_name",
                    arguments: [
                        Argument(
                            name: "icon_name",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "add_buffer",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                        Argument(
                            name: "scale",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Icon Object
    /// 
    /// Destroys the 'xdg_toplevel_icon_v1' object.
    /// The icon must still remain set on every toplevel it was assigned to,
    /// until the toplevel icon is reset explicitly.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set An Icon Name
    /// 
    /// This request assigns an icon name to this icon.
    /// Any previously set name is overridden.
    /// The compositor must resolve 'icon_name' according to the lookup rules
    /// described in the XDG icon theme specification[1] using the
    /// environment's current icon theme.
    /// If the compositor does not support icon names or cannot resolve
    /// 'icon_name' according to the XDG icon theme specification it must
    /// fall back to using pixel buffer data instead.
    /// If this request is made after the icon has been assigned to a toplevel
    /// via 'set_icon', an 'immutable' error must be raised.
    /// [1]: https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html
    /// 
    /// - Parameters:
    public func setName(iconName: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .string(iconName),
        ])
    }

    /// Add Icon Data From A Pixel Buffer
    /// 
    /// This request adds pixel data supplied as wl_buffer to the icon.
    /// The client should add pixel data for all icon sizes and scales that
    /// it can provide, or which are explicitly requested by the compositor
    /// via 'icon_size' events on xdg_toplevel_icon_manager_v1.
    /// The wl_buffer supplying pixel data as 'buffer' must be backed by wl_shm
    /// and must be a square (width and height being equal).
    /// If any of these buffer requirements are not fulfilled, a 'invalid_buffer'
    /// error must be raised.
    /// If this icon instance already has a buffer of the same size and scale
    /// from a previous 'add_buffer' request, data from the last request
    /// overrides the preexisting pixel data.
    /// The wl_buffer must be kept alive for as long as the xdg_toplevel_icon
    /// it is associated with is not destroyed, otherwise a 'no_buffer' error
    /// is raised. The buffer contents must not be modified after it was
    /// assigned to the icon. As a result, the region of the wl_shm_pool's
    /// backing storage used for the wl_buffer must not be modified after this
    /// request is sent. The wl_buffer.release event is unused.
    /// If this request is made after the icon has been assigned to a toplevel
    /// via 'set_icon', an 'immutable' error must be raised.
    /// 
    /// - Parameters:
    ///   - scale: the scaling factor of the icon, e.g. 1
    public func addBuffer(buffer: WlBuffer, scale: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(buffer),
            .int(scale),
        ])
    }

    
    public static let `protocol`: Protocol = XdgToplevelIconV1Protocol
    
    public enum Error: UInt32 {
        /// the provided buffer does not satisfy requirements
        case invalidBuffer = 1

        /// the icon has already been assigned to a toplevel and must not be changed
        case immutable = 2

        /// the provided buffer has been destroyed before the toplevel icon
        case noBuffer = 3
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


public let XdgToplevelIconV1Protocol = Protocol(
        name: "xdg_toplevel_icon_v1",
        interfaces: [
            XdgToplevelIconManagerV1.interface,
XdgToplevelIconV1.interface
        ]
    )

/// Protocol For Setting Toplevel Tags
/// 
/// In order to make some window properties like position, size,
/// "always on top" or user defined rules for window behavior persistent, the
/// compositor needs some way to identify windows even after the application
/// has been restarted.
/// This protocol allows clients to make this possible by setting a tag for
/// toplevels.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgToplevelTagManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel_tag_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_toplevel_tag",
                    arguments: [
                        Argument(
                            name: "toplevel",
                            type: .object,
                            interface: "xdg_toplevel",
                        )
                        ,
                        Argument(
                            name: "tag",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_toplevel_description",
                    arguments: [
                        Argument(
                            name: "toplevel",
                            type: .object,
                            interface: "xdg_toplevel",
                        )
                        ,
                        Argument(
                            name: "description",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy Toplevel Tag Object
    /// 
    /// Destroy this toplevel tag manager object. This request has no other
    /// effects.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set Tag
    /// 
    /// Set a tag for a toplevel. The tag may be shown to the user in UI, so
    /// it's preferable for it to be human readable, but it must be suitable
    /// for configuration files and should not be translated.
    /// Suitable tags would for example be "main window", "settings",
    /// "e-mail composer" or similar.
    /// The tag does not need to be unique across applications, and the client
    /// may set the same tag for multiple windows, for example if the user has
    /// opened the same UI twice. How the potentially resulting conflicts are
    /// handled is compositor policy.
    /// The client should set the tag as part of the initial commit on the
    /// associated toplevel, but it may set it at any time afterwards as well,
    /// for example if the purpose of the toplevel changes.
    /// 
    /// - Parameters:
    ///   - tag: untranslated tag
    public func setToplevelTag(toplevel: XdgToplevel, tag: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(toplevel),
            .string(tag),
        ])
    }

    /// Set Description
    /// 
    /// Set a description for a toplevel. This description may be shown to the
    /// user in UI or read by a screen reader for accessibility purposes, and
    /// should be translated.
    /// It is recommended to make the description the translation of the tag.
    /// The client should set the description as part of the initial commit on
    /// the associated toplevel, but it may set it at any time afterwards as
    /// well, for example if the purpose of the toplevel changes.
    /// 
    /// - Parameters:
    ///   - description: translated description
    public func setToplevelDescription(toplevel: XdgToplevel, description: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(toplevel),
            .string(description),
        ])
    }

    
    public static let `protocol`: Protocol = XdgToplevelTagV1Protocol
    
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


public let XdgToplevelTagV1Protocol = Protocol(
        name: "xdg_toplevel_tag_v1",
        interfaces: [
            XdgToplevelTagManagerV1.interface
        ]
    )

/// System Bell
/// 
/// This global interface enables clients to ring the system bell.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgSystemBellV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_system_bell_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "ring",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The System Bell Object
    /// 
    /// Notify that the object will no longer be used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Ring The System Bell
    /// 
    /// This requests rings the system bell on behalf of a client. How ringing
    /// the bell is implemented is up to the compositor. It may be an audible
    /// sound, a visual feedback of some kind, or any other thing including
    /// nothing.
    /// The passed surface should correspond to a toplevel like surface role,
    /// or be null, meaning the client doesn't have a particular toplevel it
    /// wants to associate the bell ringing with. See the xdg-shell protocol
    /// extension for a toplevel like surface role.
    /// 
    /// - Parameters:
    ///   - surface: associated surface
    public func ring(surface: WlSurface? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface),
        ])
    }

    
    public static let `protocol`: Protocol = XdgSystemBellV1Protocol
    
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


public let XdgSystemBellV1Protocol = Protocol(
        name: "xdg_system_bell_v1",
        interfaces: [
            XdgSystemBellV1.interface
        ]
    )

#endif
