import Foundation


public protocol WlInterface {
    static var name: String { get }
}

// this was never used???? 
// TODO: confirm it
// public protocol WlEnum: WLDecodable {}
// extension WlEnum where Self: RawRepresentable, Self.RawValue == UInt32 {
//     public static func decode(message: Message, connection: Connection, version: UInt32)
//         -> Self
//     {
//         Self(rawValue: 0)!
//     }
// }

public protocol WlProxy: Identifiable, WlInterface, AnyObject {
    associatedtype Event: WlEventEnum = NoEvent
    var version: UInt32 { get }
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

    init(connection: Connection, id: ObjectId, version: UInt32)
}

extension WlProxy {
    func parseAndDispatch(message: Message, connection: Connection) {
        let event = Event.decode(message: message, connection: connection, version: self.version)
        #if DEBUG
            // print("[Wayland] dispatch \(event) to \(self)")
        #endif
        self.onEvent(event)
    }
}

public protocol WlEventEnum {
    // TOOD: make this failable
    static func decode(message: Message, connection: Connection, version: UInt32) -> Self
}

public struct NoEvent: WlEventEnum {
    static public func decode(message: Message, connection: Connection, version: UInt32) -> NoEvent {
        let obj = connection.get(id: message.objectId)!
        fatalError("\(obj) has no event associated with it")
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

    public required init(connection: Connection, id: ObjectId, version: UInt32) {
        self.connection = connection
        self.id = id
        self.version = version
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
