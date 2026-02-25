import Foundation

public protocol Proxy: AnyObject {
    associatedtype Event: Decodable = NoEvent
    associatedtype Request: Encodable = NoRequest
    // associatedtype UserData
    // associatedtype Queue: EventQueue

    var backend: any Backend { get }

    // TODO: find a way so it that we dont need to copy this everytime, making it a class???
    static var interface: Interface { get }
    var interface: Interface { get }

    var version: UInt32 { get }
    var id: UInt32 {
        get
    }

    var isAlive: Bool { get }

    var raw: any RawProxy { get }
    var onEvent: ((Event) -> Void)? { get }

    var queue: any EventQueue {
        get
    }

    // var userData: UserData {
    //     get
    //     set
    // }

    init(raw: any RawProxy)
}

extension Proxy {
    public var interface: Interface {
        Self.interface
    }

    public var id: UInt32 {
        self.raw.id
    }

    public var version: UInt32 {
        self.raw.version
    }

    public var isAlive: Bool {
        self.raw.isAlive
    }

    public var queue: any EventQueue {
        self.raw.queue
    }
}

public protocol RawProxy {
    associatedtype B: Backend

    var id: UInt32 { get }
    var version: UInt32 { get }
    var backend: B { get }
    var isAlive: Bool { get }
    var queue: B.Queue { get }
}

open class BaseProxy {
    public let backend: any Backend
    public let raw: any RawProxy

    public required init(raw: any RawProxy) {
        self.backend = raw.backend
        self.raw = raw
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
