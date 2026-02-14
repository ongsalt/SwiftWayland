import Foundation

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
public final class WlRegistry: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_registry"
    public var onEvent: (Event) -> Void = { _ in }

    // request `bind` can not (yet) be generated 
    // [WaylandScanner.Argument(name: "name", type: WaylandScanner.Primitive.uint, interface: nil, enum: nil, summary: Optional("unique numeric name of the object")), WaylandScanner.Argument(name: "id", type: WaylandScanner.Primitive.newId, interface: nil, enum: nil, summary: Optional("bounded object"))]
    
    public enum Event: WlEventEnum {
        /// Announce Global Object
        /// 
        /// Notify the client of global objects.
        /// The event notifies the client that a global object with
        /// the given name is now available, and it implements the
        /// given version of the given interface.
        /// 
        /// - Parameters:
        ///   - Name: numeric name of the global object
        ///   - Interface: interface implemented by the object
        ///   - Version: interface version
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
        /// 
        /// - Parameters:
        ///   - Name: numeric name of the global object
        case globalRemove(name: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.global(name: r.readUInt(), interface: r.readString(), version: r.readUInt())
            case 1:
                return Self.globalRemove(name: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
