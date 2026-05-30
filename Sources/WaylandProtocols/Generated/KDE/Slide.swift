import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
public final class KdeSlideManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_slide_manager",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "create",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "org_kde_kwin_slide"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "unset",
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
                ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeSlide {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeSlide.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// 
    /// - Parameters:
    public func unset(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface.id),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: Slide)
    }
    
    public typealias Event = NoEvent
}
/// Slide A Surface From A Location To Another
/// 
/// Ask the compositor to move the surface from a location to another
/// with a slide animation.
/// The from argument provides a clue about where the slide animation
/// begins, offset is the distance from screen edge to begin the animation.
public final class KdeSlide: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_slide",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "commit",
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_location",
                    arguments: [
                    Argument(
                        name: "location",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_offset",
                    arguments: [
                    Argument(
                        name: "offset",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// 
    /// - Parameters:
    public func setLocation(_ location: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(location),
        ])
    }

    /// 
    /// - Parameters:
    public func setOffset(_ offset: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(offset),
        ])
    }

    /// Release The Slide Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 3, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: Slide)
    }
    
    public enum Location: UInt32 {
        case `left` = 0

        case top = 1

        case `right` = 2

        case bottom = 3
    }

    var destructor: Destructor? = .release

    enum Destructor {
        case release
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .release: try? self.release()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}

public let Slide = Protocol(
        name: "slide",
        interfaces: [
            KdeSlideManager.interface,
KdeSlide.interface
        ]
    )

#endif