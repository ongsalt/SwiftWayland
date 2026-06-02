import Foundation

public protocol Proxy: AnyObject, Identifiable {
    associatedtype Event: Decodable = NoEvent

    var connection: Connection { get }
    var queue: EventQueue { get }
    var id: UInt32 { get }
    var version: UInt32 { get }

    // TODO: find a way so it that we dont need to copy this everytime, making it a class???
    static var interface: Interface { get }

    var isAlive: Bool { get }
    var onEvent: ((Event) -> Void)? { get }
    var raw: OpaquePointer { get }

    init(id: UInt32, version: UInt32, queue: EventQueue, raw: OpaquePointer, connection: Connection)
}

extension Proxy {
    public var interface: Interface {
        _read { yield Self.interface }
    }
}

open class BaseProxy {
    public let raw: OpaquePointer
    public let connection: Connection
    public let queue: EventQueue
    public let id: UInt32
    public let version: UInt32
    public private(set) var isAlive: Bool = true

    public typealias Event = NoEvent

    public required init(
        id: UInt32, version: UInt32, queue: EventQueue, raw: OpaquePointer, connection: Connection
    ) {
        self.id = id
        self.version = version
        self.queue = queue
        self.raw = raw
        self.connection = connection

        Self.ensureLoaded()
    }

    package func markDead() {
        self.isAlive = false
        self.connection.destroy(proxy: self)
    }

    @_spi(SwiftWaylandPrivate)
    open class func ensureLoaded() {

    }
}

public struct NoEvent: Decodable {
    public init(from reader: some ArgumentReader, opcode: UInt32) throws(DecodingError) {}
}

public enum DecodingError: Error {
    case unknownOpcode(UInt32)
    case objectNotFound(id: UInt32)
    case unknownEnumCase(case: UInt32, enumName: String)
}

public protocol Decodable {
    init(from reader: some ArgumentReader, opcode: UInt32) throws(DecodingError)
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

public enum WaylandProxyError: Error {
    case destroyed
    case unsupportedVersion(current: UInt32, required: UInt32)
}
