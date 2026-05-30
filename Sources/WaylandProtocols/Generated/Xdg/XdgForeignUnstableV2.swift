import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if XDG
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
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "export_toplevel",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zxdg_exported_v2"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                ],
            events: [
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
        let id = connection.createProxy(type: ZxdgExportedV2.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgForeignUnstableV2Protocol)
    }
    
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
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "import_toplevel",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "zxdg_imported_v2"
                    ),
                    Argument(
                        name: "handle",
                        type: .string,
                    ),
                    ],
                ),
                ],
            events: [
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
        let id = connection.createProxy(type: ZxdgImportedV2.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .string(handle),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgForeignUnstableV2Protocol)
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
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "handle",
                    arguments: [
                    Argument(
                        name: "handle",
                        type: .string,
                    ),
                    ],
                ),
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

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgForeignUnstableV2Protocol)
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
        /// The Exported Surface Handle
        /// 
        /// The handle event contains the unique handle of this exported surface
        /// reference. It may be shared with any client, which then can use it to
        /// import the surface by calling xdg_importer.import_toplevel. A handle
        /// may be used to import the surface multiple times.
        case handle(handle: String)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
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
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_parent_of",
                    arguments: [
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                ],
            events: [
                Message(
                    name: "destroyed",
                    arguments: [
                    ],
                ),
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
            .object(surface.id),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgForeignUnstableV2Protocol)
    }
    
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

    public enum Event: Decodable {
        /// The Imported Surface Handle Has Been Destroyed
        /// 
        /// The imported surface handle has been destroyed and any relationship set
        /// up has been invalidated. This may happen for various reasons, for
        /// example if the exported surface or the exported surface handle has been
        /// destroyed, if the handle used for importing was invalid.
        case destroyed

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
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

#endif