import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWaylandCommon
import SwiftWayland

/// Core Global Object
/// 
/// The core global object.  This is a special singleton object.  It
/// is used for internal Wayland protocol features.
public final class WlDisplay: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wl_display",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "sync",
                    arguments: [
                    Argument(
                        name: "callback",
                        type: .newId,
                    ),
                    ],
                ),
                Message(
                    name: "get_registry",
                    arguments: [
                    Argument(
                        name: "registry",
                        type: .newId,
                    ),
                    ],
                ),
                ],
            events: [
                Message(
                    name: "sync",
                    arguments: [
                    Argument(
                        name: "callback",
                        type: .newId,
                    ),
                    ],
                ),
                Message(
                    name: "get_registry",
                    arguments: [
                    Argument(
                        name: "registry",
                        type: .newId,
                    ),
                    ],
                ),
                ],
        )

    public func sync(callback: @escaping (UInt32) -> Void, queue _queue: EventQueue? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let callback = backend.createCallback(fn: callback, parent: self, queue: _queue ?? self.queue)
        backend.send(self.id, 0, [
            .newId(callback.id),
        ], queue: nil)
    }

    public func getRegistry(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WlRegistry {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let registry = backend.createProxy(type: WlRegistry.self, version: self.version, parent: self, queue: _queue ?? self.queue)
        backend.send(self.id, 1, [
            .newId(registry.id),
        ], queue: nil)
        return registry
    }

    public enum Error: UInt32 {
        /// server couldn't find object
        case invalidObject = 0

        /// method doesn't exist on the specified interface or malformed request
        case invalidMethod = 1

        /// server is out of memory
        case noMemory = 2

        /// implementation error in compositor
        case implementation = 3
    }

    public typealias Event = NoEvent
}

public final class WlRegistry: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wl_registry",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "bind",
                    arguments: [
                    Argument(
                        name: "name",
                        type: .uint,
                    ),
                    Argument(
                        name: "id",
                        type: .newId,
                    ),
                    ],
                ),
                ],
            events: [
                Message(
                    name: "bind",
                    arguments: [
                    Argument(
                        name: "name",
                        type: .uint,
                    ),
                    Argument(
                        name: "id",
                        type: .newId,
                    ),
                    ],
                ),
                ],
        )
    public enum Event: Decodable {
        case global(name: UInt32, interface: String, version: UInt32)
        case globalRemove(name: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.global(name: r.uint(), interface: r.string(), version: r.uint())
            case 1:
                self = Self.globalRemove(name: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}