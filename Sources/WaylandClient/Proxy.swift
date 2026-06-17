import CWayland
import Foundation

public protocol Proxy: AnyObject, Identifiable {
    associatedtype Event: MessageProtocol = NoEvent

    var connection: Connection { get }
    var queue: EventQueue { get }

    var raw: OpaquePointer { get }
    var id: UInt32 { get }
    var version: UInt32 { get }

    var isAlive: Bool { get }
    var onEvent: ((Event) -> Void)? { get }

    init(id: UInt32, version: UInt32, queue: EventQueue, raw: OpaquePointer, connection: Connection)

    static var interface: Interface { get }
    static var `protocol`: Protocol { get }
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

    public static func destroy(_ proxy: any Proxy) {
        proxy.connection.destroy(proxy)
    }
}

// for codegen conveneince
// TODO: make this spi
open class BaseProxy {
    public let raw: OpaquePointer
    public let connection: Connection
    public let queue: EventQueue
    public let id: UInt32
    public let version: UInt32

    public package(set) var isAlive: Bool = true

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
}

public struct NoEvent: MessageProtocol {
    public init(from reader: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {}
}

public enum DecodingError: Error {
    case unknownEnumCase(case: UInt32, enumName: String)
    case badMessage(opcode: UInt32)
}

public protocol MessageProtocol {
    var isDestructor: Bool { get }
    init(from reader: inout some ArgumentReader, opcode: UInt32) throws(DecodingError)
}

extension MessageProtocol {
    public var isDestructor: Bool { false }
}

// only wire type
public protocol ArgumentReader {
    mutating func int() -> Int32
    mutating func uint() -> UInt32
    mutating func fd() -> FileHandle
    // NON OWNING, do not free this
    mutating func array() -> UnsafeRawBufferPointer

    mutating func string() -> String
    mutating func nullableString() -> String?

    mutating func object() -> (any Proxy)?
    mutating func object<P>(type: P.Type) -> P? where P: Proxy

    // it now can be null when either object is actually nullable OR its dead
    // mutating func nullableObject() -> (any Proxy)?

    mutating func newId<P: Proxy>(type: P.Type) -> P
}

extension ArgumentReader {
    public mutating func fixed() -> Double {
        Double(self.int()) / 256
    }

    public mutating func `enum`<T>(_ type: T.Type) throws(DecodingError) -> T
    where T: RawRepresentable, T.RawValue == UInt32 {
        let rawValue = self.uint()
        guard let instance = T(rawValue: rawValue) else {
            throw .unknownEnumCase(case: rawValue, enumName: String(describing: T.self))
        }
        return instance
    }

}

public enum WaylandProxyError: Error {
    case destroyed
    case unsupportedVersion(current: UInt32, required: UInt32)
}

class _Proxy1: BaseProxy, Proxy {
    required init(
        id: UInt32, version: UInt32, queue: EventQueue, raw: OpaquePointer, connection: Connection
    ) {
        fatalError()
    }

    static var interface: SwiftWaylandCommon.Interface { fatalError() }
    static var `protocol`: SwiftWaylandCommon.`Protocol` { fatalError() }

    let onEvent: ((NoEvent) -> Void)?

    func destructor1() {

    }

    // backing libwayland object gone WHEN
    // - call its destructor
    // - got destructor message
    // - deinit
}
