import Foundation

// typealias WLCallback = () -> Void

// TODO: see swift Decodable
public protocol WLDecodable {
    static func decode(message: Message, connection: Connection) -> Self
}

public protocol WlInterface {
    static var name: String { get }
}

public protocol WlEnum: WLDecodable {}

extension WlEnum where Self: RawRepresentable, Self.RawValue == UInt32 {
    public static func decode(message: Message, connection: Connection) -> Self {
        Self(rawValue: 0)!
    }
}

public protocol WlProxy: Identifiable, WlInterface {
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
    func parseAndDispatch(message: Message, connection: Connection) {
        let event = Event.decode(message: message, connection: connection)
        print("[Wayland] dispatch \(event) to \(self)")
        self.onEvent(event)
    }
}

public protocol WlEventEnum: WLDecodable {}

open class WlProxyBase {
    public let id: ObjectId
    public unowned var connection: Connection

    public required init(connection: Connection, id: ObjectId) {
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
