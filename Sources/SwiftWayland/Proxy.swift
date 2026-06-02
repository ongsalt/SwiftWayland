import CWayland
import Foundation

public protocol Proxy: AnyObject, Identifiable {
    associatedtype Event: Decodable = NoEvent

    var connection: Connection { get }
    var queue: EventQueue { get }
    var id: UInt32 { get }
    var version: UInt32 { get }

    // TODO: find a way so it that we dont need to copy this everytime, making it a class???
    static var interface: Interface { get }
    static var `protocol`: Protocol { get }

    var isAlive: Bool { get }
    var onEvent: ((Event) -> Void)? { get }
    var raw: OpaquePointer { get }

    init(id: UInt32, version: UInt32, queue: EventQueue, raw: OpaquePointer, connection: Connection)
}

extension Proxy {
    public var interface: Interface {
        _read { yield Self.interface }
    }

    static func ensureLoaded() -> UnsafePointer<wl_interface> {
        return CRuntimeInfo.shared.withLock {
            $0.addIfNotExists(protocol: self.protocol)
            return $0.interfaces[self.interface.name]!
        }
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
    }

    package func markDead() {
        self.isAlive = false
        self.connection.destroy(proxy: self)
    }
}

public struct NoEvent: Decodable {
    public init(from reader: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {}
}

public enum DecodingError: Error {
    case unknownOpcode(UInt32)
    case objectNotFound(id: UInt32)
    case unknownEnumCase(case: UInt32, enumName: String)
}

public protocol Decodable {
    init(from reader: inout some ArgumentReader, opcode: UInt32) throws(DecodingError)
}

public protocol ArgumentReader {
    mutating func int() -> Int32
    mutating func uint() -> UInt32
    mutating func fd() -> FileHandle
    mutating func array() -> Data
    mutating func string() -> String

    mutating func object() -> any Proxy
    mutating func object<P: Proxy>(type: P.Type) -> P
    mutating func newId<P: Proxy>(type: P.Type) -> P  // version???
}

extension ArgumentReader {
    public mutating func fixed() -> Double {
        Double(self.int()) / 256
    }
}

public enum WaylandProxyError: Error {
    case destroyed
    case unsupportedVersion(current: UInt32, required: UInt32)
}
