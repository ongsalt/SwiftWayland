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
    /// Asynchronous Roundtrip
    /// 
    /// The sync request asks the server to emit the 'done' event
    /// on the returned wl_callback object.  Since requests are
    /// handled in-order and events are delivered in-order, this can
    /// be used as a barrier to ensure all previous requests and the
    /// resulting events have been handled.
    /// The object returned by this request will be destroyed by the
    /// compositor after the callback is fired and as such the client must not
    /// attempt to use it after that point.
    /// The callback_data passed in the callback is undefined and should be ignored.
    /// 
    /// - Parameters:
    ///   - callback: callback object for the sync request
    ///   - queue: queue to associated with created objects
    public func sync(callback: @escaping (UInt32) -> Void, queue _queue: EventQueue? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let callback = backend.createCallback(fn: callback, parent: self, queue: _queue ?? self.queue)
        backend.send(self.id, 0, [
            .newId(callback.id),
        ], queue: nil)
    }

    /// Get Global Registry Object
    /// 
    /// This request creates a registry object that allows the client
    /// to list and bind the global objects available from the
    /// compositor.
    /// It should be noted that the server side resources consumed in
    /// response to a get_registry request can only be released when the
    /// client disconnects, not when the client side proxy is destroyed.
    /// Therefore, clients should invoke get_registry as infrequently as
    /// possible to avoid wasting memory.
    /// 
    /// - Parameters:
    ///   - queue: queue to associated with created objects
    /// 
    /// - Returns: global registry object
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

/// Global Registry Object
/// 
/// The singleton global registry object.  The server has a number of
/// global objects that are available to all clients.  These objects
/// typically represent an actual object in the server (for example,
/// an input device) or they are singleton objects that provide
/// extension functionality.
/// When a client creates a registry object, the registry object
/// will emit a global event for each global currently in the
/// registry.  Globals come and go as a result of device or
/// monitor hotplugs, reconfiguration or other events, and the
/// registry will send out global and global_remove events to
/// keep the client up to date with the changes.  To mark the end
/// of the initial burst of events, the client can use the
/// wl_display.sync request immediately after calling
/// wl_display.get_registry.
/// A client can bind to a global object by using the bind
/// request.  This creates a client-side handle that lets the object
/// emit events to the client and lets the client invoke requests on
/// the object.
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
        /// Announce Global Object
        /// 
        /// Notify the client of global objects.
        /// The event notifies the client that a global object with
        /// the given name is now available, and it implements the
        /// given version of the given interface.
        case global(name: UInt32, interface: String, version: UInt32)

        /// Announce Removal Of Global Object
        /// 
        /// Notify the client of removed global objects.
        /// This event notifies the client that the global identified
        /// by name is no longer available.  If the client bound to
        /// the global using the bind request, the client should now
        /// destroy that object.
        /// The object remains valid and requests to the object will be
        /// ignored until the client destroys it, to avoid races between
        /// the global going away and a client sending a request to it.
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