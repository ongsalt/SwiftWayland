/// what if we allow you to create an obejct without
/// display.createSurface -> Surface() ???
/// this is probably pain, in the end we need still to do display.attach(surface)
///
/// then protocol Dispatch<T: WlEvent> or just protocol DisplayListener
/// WlSurfaceDelegate ???

import Foundation

typealias WaylandInterface = Any

protocol WLDelegate: Identifiable, AnyObject {}

protocol WlDisplayDelegate: WLDelegate {
    func event(interface: WlDisplay, event: WlDisplay.Event)
}

protocol WlRegistryDelegate: WLDelegate {
    func event(interface: WlRegistry, event: WlRegistry.Event)
}

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

protocol WlProxy: Identifiable {
    associatedtype Event: WlEventEnum

    init()
}

extension WlProxy {
    init() {
        self.init()
    }
}

internal protocol WlEventEnum {

}

final class WlDisplay: WlProxy {
    // objectId -> connection search for that object -> Dispatch<WlDisplay> -> WlDisplay -> translateEvent -> Self.Event
    //

    // TODO: make wl_callback a callback
    // special case of type="new_id" interface="wl_callback"
    func sync(_ callback: @Sendable () -> Void) {
        // connection.registerCallback(callback)
    }

    func getRegistry() -> WlRegistry {
        WlRegistry()
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

final class WlRegistry: WlProxy {
    // this must be custom code

    /// Deal with this wisely
    func bind<T: WlProxy>(name: UInt, type: T.Type) -> T {
        T()
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
