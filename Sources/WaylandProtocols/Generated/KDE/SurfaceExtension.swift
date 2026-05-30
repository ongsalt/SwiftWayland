import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
public final class QtSurfaceExtension: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "qt_surface_extension",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "get_extended_surface",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "qt_extended_surface"
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
    /// 
    /// - Parameters:
    public func getExtendedSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> QtExtendedSurface {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: QtExtendedSurface.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: SurfaceExtension)
    }
    
    public typealias Event = NoEvent
}
public final class QtExtendedSurface: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "qt_extended_surface",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "update_generic_property",
                    arguments: [
                    Argument(
                        name: "name",
                        type: .string,
                    ),
                    Argument(
                        name: "value",
                        type: .array,
                    ),
                    ],
                ),
                Message(
                    name: "set_content_orientation_mask",
                    arguments: [
                    Argument(
                        name: "orientation",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "set_window_flags",
                    arguments: [
                    Argument(
                        name: "flags",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "raise",
                    arguments: [
                    ],
                ),
                Message(
                    name: "lower",
                    arguments: [
                    ],
                ),
                ],
            events: [
                Message(
                    name: "onscreen_visibility",
                    arguments: [
                    Argument(
                        name: "visible",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "set_generic_property",
                    arguments: [
                    Argument(
                        name: "name",
                        type: .string,
                    ),
                    Argument(
                        name: "value",
                        type: .array,
                    ),
                    ],
                ),
                Message(
                    name: "close",
                    arguments: [
                    ],
                ),
                ],
        )
    /// 
    /// - Parameters:
    public func updateGenericProperty(name: String, value: Data) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(name),
            .array(value),
        ])
    }

    /// 
    /// - Parameters:
    public func setContentOrientationMask(orientation: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .int(orientation),
        ])
    }

    /// 
    /// - Parameters:
    public func setWindowFlags(flags: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(flags),
        ])
    }

    public func raise() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    public func lower() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: SurfaceExtension)
    }
    
    public enum Orientation: UInt32 {
        case primaryorientation = 0

        case portraitorientation = 1

        case landscapeorientation = 2

        case invertedportraitorientation = 4

        case invertedlandscapeorientation = 8
    }

    public enum Windowflag: UInt32 {
        case overridessystemgestures = 1

        case staysontop = 2

        case bypasswindowmanager = 4
    }

    public enum Event: Decodable {
        case onscreenVisibility(visible: Int32)

        case setGenericProperty(name: String, value: Data)

        case close

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.onscreenVisibility(visible: r.int())
            case 1:
                self = Self.setGenericProperty(name: r.string(), value: r.array())
            case 2:
                self = Self.close
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public let SurfaceExtension = Protocol(
        name: "surface_extension",
        interfaces: [
            QtSurfaceExtension.interface,
QtExtendedSurface.interface
        ]
    )

#endif