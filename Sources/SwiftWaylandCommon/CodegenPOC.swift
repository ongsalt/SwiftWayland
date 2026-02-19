import Foundation

public protocol Proxy {
    associatedtype Event: Decodable = NoEvent
    associatedtype Request: Encodable = NoRequest
    associatedtype ObjectId = Void
    // associatedtype Queue: EventQueue
    associatedtype Queue = AnyObject
    // associatedtype UserData

    static var interface: Shared<Interface> { get }
    var interface: Shared<Interface> { get }

    var version: UInt32 { get }
    var id: ObjectId {
        get
    }

    var onEvent: ((Event) -> Void)? { get }

    // var queue: EventQueue {
    //     get
    // }

    // var userData: UserData {
    //     get
    //     set
    // }
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
    func fixed() -> Double {
        Double(self.int()) / 256
    }
}

// fd read into an immediate buffer -> see which object
