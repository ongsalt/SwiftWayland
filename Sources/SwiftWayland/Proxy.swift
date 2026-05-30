import Foundation

public protocol Proxy: AnyObject {
    associatedtype Event: Decodable = NoEvent
    associatedtype Request: Encodable = NoRequest

    var connection: Connection { get }

    // TODO: find a way so it that we dont need to copy this everytime, making it a class???
    static var interface: Interface { get }
    var interface: Interface { get }

    var version: UInt32 { get }
    var id: UInt32 {
        get
    }

    var isAlive: Bool { get }
    var onEvent: ((Event) -> Void)? { get }

    var raw: OpaquePointer { get }

    var queue: EventQueue {
        get
    }

    init(id: UInt32, version: UInt32, queue: EventQueue, raw: OpaquePointer, connection: Connection)
}

extension Proxy {
    public var interface: Interface {
        Self.interface
    }
}

open class BaseProxy {
    public let id: UInt32
    public let version: UInt32
    public private(set) var isAlive: Bool = true
    public let queue: EventQueue
    public let raw: OpaquePointer
    public let connection: Connection

    public typealias Event = NoEvent

    public required init(id: UInt32, version: UInt32, queue: EventQueue, raw: OpaquePointer, connection: Connection) {
        self.id = id
        self.version = version
        self.queue = queue
        self.raw = raw
        self.connection = connection

        Self.ensureLoaded()
    }

    package func markDead() {
        self.isAlive = false
    }

    @_spi(SwiftWaylandPrivate)
    open class func ensureLoaded() {
        
    }
}

public struct NoEvent: Decodable {
    public init(from reader: any ArgumentReader, opcode: UInt32) throws(DecodingError) {}
}

public struct NoRequest: Encodable {
    public func encode() -> [Arg] {
        []
    }
}

public enum DecodingError: Error {
    case unknownOpcode(UInt32)
    case objectNotFound(id: UInt32)
    case unknownEnumCase(case: UInt32, enumName: String)
}

public protocol Decodable {
    init(from reader: any ArgumentReader, opcode: UInt32) throws(DecodingError)
}

public protocol Encodable {
    func encode() -> [Arg]
}

public protocol ArgumentReader {
    func int() -> Int32
    func uint() -> UInt32
    func fd() -> FileHandle
    func array() -> Data
    func string() -> String

    func object() -> any Proxy
    func object<P: Proxy>(type: P.Type) -> P
    func newId<P: Proxy>(type: P.Type) -> P  // version???
}

extension ArgumentReader {
    public func fixed() -> Double {
        Double(self.int()) / 256
    }
}

// fd read into an immediate buffer -> see which object

public enum WaylandProxyError: Error {
    case destroyed
    case unsupportedVersion(current: UInt32, required: UInt32)
}
