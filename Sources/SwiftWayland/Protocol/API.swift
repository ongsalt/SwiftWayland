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
public protocol WLDecodable {
    static func decode(message: Message) -> Self
}

public protocol WlEnum: WLDecodable {}

extension WlEnum where Self: RawRepresentable, Self.RawValue == UInt32 {
    public static func decode(message: Message) -> Self {
        Self(rawValue: 0)!
    }
}

private nonisolated(unsafe) var currentId: ObjectId = 1  // wl_display is always 1

public protocol WlProxy: Identifiable {
    associatedtype Event: WlEventEnum
    var id: ObjectId {
        get
    }

    var connection: Connection {
        get
    }

    var onEvent: ((Event) -> Void) {
        get
        set
    }

    init(connection: Connection, id: ObjectId)
}

extension WlProxy {
    func parseAndDispatch(message: Message) {
        let event = Event.decode(message: message)
        self.onEvent(event)
    }
}

public protocol WlEventEnum: WLDecodable {}

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
