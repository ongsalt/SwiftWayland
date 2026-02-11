/// what if we allow you to create an obejct without
/// display.createSurface -> Surface() ???
/// this is probably pain, in the end we need still to do display.attach(surface)
///
/// then protocol Dispatch<T: WlEvent> or just protocol DisplayListener
/// WlSurfaceDelegate ???

import Foundation

typealias WaylandInterface = Any

// we cant do this tho
protocol Dispatch<Interface> {
    associatedtype Interface: WlProxy

}

protocol WlDisplayDelegate {
    func event(interface: WlDisplay, event: WlDisplay.Event)
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

protocol WlProxy {
    associatedtype Event: WlEventEnum
}

internal protocol WlEventEnum {

}

class WlDisplay: WlProxy {
    // objectId -> connection search for that object -> Dispatch<WlDisplay> -> WlDisplay -> translateEvent -> Self.Event
    // 

    // TODO: make wl_callback a callback
    // special case of type="new_id" interface="wl_callback"
    func sync(_ callback: @Sendable () -> Void) {
        // connection.registerCallback(callback)
    }

    public enum Event: WlEventEnum { 
        case error(objectId: ObjectId, code: UInt32, message: String)
        case deleteId(id: UInt32)

        static func decode(message: Message) -> Self {
            .deleteId(id: 0)
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


class App {
    
}

extension App: WlDisplayDelegate {
    func event(interface: WlDisplay, event: WlDisplay.Event) {
        
    }
}