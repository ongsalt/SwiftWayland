import Foundation

// typealias WLCallback = () -> Void

// TODO: see swift Decodable
public protocol WLDecodable {
    static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self
}

public protocol WlInterface {
    static var name: String { get }
}

public protocol WlEnum: WLDecodable {}

extension WlEnum where Self: RawRepresentable, Self.RawValue == UInt32 {
    public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
        Self(rawValue: 0)!
    }
}

public protocol WlProxy: Identifiable, WlInterface, AnyObject {
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

internal extension WlProxy {
    func parseAndDispatch(message: Message, connection: Connection, fdSource: BufferedSocket) {
        let event = Event.decode(message: message, connection: connection, fdSource: fdSource)
        print("[Wayland] dispatch \(event) to \(self)")
        self.onEvent(event)
    }
}

public protocol WlEventEnum: WLDecodable {}

public enum WaylandProxyState {
    case alive
    case dropped
    case consumed
}

open class WlProxyBase {
    public let id: ObjectId
    public var connection: Connection
    private var _state: WaylandProxyState = .alive

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


public enum WaylandProxyError: Error {
    case destroyed
}
