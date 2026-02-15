import Foundation

public protocol WlInterface {
    static var name: String { get }
}

public protocol WlProxy: Identifiable, WlInterface, AnyObject {
    associatedtype Event: WlEventEnum = NoEvent
    var version: UInt32 { get }
    var id: ObjectId {
        get
    }

    var queue: EventQueue {
        get
    }

    var connection: Connection {
        get
    }

    var onEvent: ((Event) -> Void)? {
        get
        set
    }

    init(connection: Connection, id: ObjectId, version: UInt32, queue: EventQueue)
}

extension WlProxy {
    nonisolated package func parse(message: Message, connection: Connection) throws(WaylandEventDecodeError) -> Event {
        try Event.decode(message: message, connection: connection, version: self.version)
    }

    nonisolated package func dispatch(event: any WlEventEnum) {
        guard let onEvent else {
            return
        }
        if let event = event as? Event {
            #if DEBUG
                // print("[Wayland] dispatch \(event) to \(self)")
            #endif
            onEvent(event)
        } else {
            fatalError("Invalid event type: \(event)")
        }
    }
}


public enum WaylandEventDecodeError: Error {
    // case objectNotFound(id: ObjectId)
    case noEvent
}

// TODO: rename this to WlEvent
public protocol WlEventEnum {
    // TOOD: make this failable
    static func decode(message: Message, connection: Connection, version: UInt32) throws(WaylandEventDecodeError) -> Self
}

public struct NoEvent: WlEventEnum {
    static public func decode(message: Message, connection: Connection, version: UInt32) throws(WaylandEventDecodeError) -> NoEvent
    {
        let obj = connection.get(id: message.objectId)!
        print("\(obj) has no event associated with it")
        throw .noEvent
    }
}

public enum WaylandProxyState {
    // case beforeBound
    case alive
    case dropped
}

open class WlProxyBase {
    public let id: ObjectId
    public var connection: Connection
    public var _state: WaylandProxyState = .alive
    public let version: UInt32
    public let queue: EventQueue

    public required init(connection: Connection, id: ObjectId, version: UInt32, queue: EventQueue) {
        self.connection = connection
        self.id = id
        self.version = version
        self.queue = queue
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
    case unsupportedVersion(current: UInt32, required: UInt32)
}
