/// what if we allow you to create an obejct without
/// display.createSurface -> Surface() ???
/// this is probably pain, in the end we need still to do display.attach(surface)
///
/// then protocol Dispatch<T: WlEvent> or just protocol DisplayListener
/// WlSurfaceDelegate ???

import Foundation

typealias WaylandInterface = Any

// // Later:
// func laterOn(connection: Connection)  {
//     // connection.register(object: Dispatch())
// }

typealias WLCallback = () -> Void

// TODO: see swift Decodable
protocol WLDecodable {
    static func decode(message: Message) -> Self
}

protocol WlEnum: WLDecodable {}

extension WlEnum where Self: RawRepresentable, Self.RawValue == UInt32 {
    static func decode(message: Message) -> Self {
        Self(rawValue: 0)!
    }
}

private nonisolated(unsafe) var currentId: ObjectId = 1  // wl_display is always 1

protocol WlProxyProtocol: Identifiable {
    associatedtype Event: WlEventEnum
    var id: ObjectId {
        get
    }

    var onEvent: ((Event) -> Void) {
        get
        set
    }

    init(connection: Connection, id: ObjectId)
}

extension WlProxyProtocol {
    func parseAndDispatch(message: Message) {
        let event = Event.decode(message: message)
        self.onEvent(event)
    }
}

// extension WlProxy {
//     func decodeEvent(message: Message) -> Event? {
//         Event.decode(message: message)
//     }
// }

internal protocol WlEventEnum: WLDecodable {}

public class WlProxyBase {    
    public let id: ObjectId
    unowned var connection: Connection

    required init(connection: Connection, id: ObjectId) {
        self.connection = connection
        self.id = id
    }

    deinit {
        connection.removeObject(id: id)
    }
}

extension WlProxyBase: Hashable {
    public static func == (lhs: WlProxyBase, rhs: WlProxyBase) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// typealias Test = WlProxy & _WlProxy

public final class WlDisplay: WlProxyBase, WlProxyProtocol {
    var onEvent: (Event) -> Void = { _ in }

    // objectId -> connection search for that object -> Dispatch<WlDisplay> -> WlDisplay -> translateEvent -> Self.Event
    //

    // TODO: make wl_callback a callback
    // special case of type="new_id" interface="wl_callback"
    func sync(_ callback: @Sendable () -> Void) {
        // connection.registerCallback(callback)
    }

    func getRegistry() async throws -> WlRegistry {
        let registry = connection.createProxy(type: WlRegistry.self)
        let message = Message(objectId: 1, opcode: 1) { data in
            data.append(u32: registry.id) // newId
        }

        // this should not immediately fire, must schedule
        try await connection.send(message: message)

        return registry
    }

    public enum Event: WlEventEnum {
        case error(objectId: ObjectId, code: UInt32, message: String)
        case deleteId(id: UInt32)

        static func decode(message: Message) -> Self {
            let r = WLReader(data: message.arguments)
            return switch message.opcode {
            case 0:
                Self.error(objectId: r.readObjectId(), code: r.readUInt(), message: r.readString())
            case 1:
                Self.deleteId(id: r.readObjectId())
            default:
                fatalError("bad wayland server")
            }
        }
    }

    public enum Error: UInt32, WlEnum {  // : WaylandEnum
        case invalidObject
        case invalidMethod
        case noMemory
        case implementation

        // private static func decode() -> Error {

        // }

        // private func encode() {

        // }
    }
}

final class WlRegistry: WlProxyBase, WlProxyProtocol {
    var onEvent: (Event) -> Void = { _ in }

    // this must be custom code

    /// Deal with this wisely
    func bind<T>(name: UInt, type: T.Type) -> T where T: WlProxyProtocol {
        connection.createProxy(type: T.self)
    }

    public enum Event: WlEventEnum {
        case global(name: UInt32, interface: String, version: UInt32)
        case globalRemove(name: UInt32)

        static func decode(message: Message) -> Self {
            let r = WLReader(data: message.arguments)
            return switch message.opcode {
            case 0:
                Self.global(name: r.readUInt(), interface: r.readString(), version: r.readUInt())
            case 1:
                Self.globalRemove(name: r.readUInt())
            default:
                fatalError("bad wayland server")
            }
        }

    }
}
