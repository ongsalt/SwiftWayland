public protocol Backend {
    associatedtype ObjectId: ObjectIdProtocol = UInt32
    associatedtype Queue: EventQueue
    var mainQueue: Queue { get }

    func send(
        _ objectId: ObjectId,  // wellllll, now i understand why they call it this
        _ opcode: UInt32,
        _ args: [Arg],
        queue: Queue?
    )

    func createProxy<T>(type: T.Type, version: UInt32, parent: some Proxy, queue: Queue) -> T
    where T: Proxy

    func flush() async throws
    // func plsReadAndPutMessageIntoQueues
}

extension Backend {
    public func send(
        _ objectId: any ObjectIdProtocol,  // wellllll, now i understand why they call it this
        _ opcode: UInt32,
        _ args: [Arg],
        queue: (any EventQueue)?
    ) {
        send(objectId as! Self.ObjectId, opcode, args, queue: queue as? Self.Queue)
    }

    public func createProxy<T>(
        type: T.Type,
        version: UInt32,
        parent: some Proxy,
        queue: any EventQueue
    ) -> T where T: Proxy {
        createProxy(type: type, version: version, parent: parent, queue: queue as! Self.Queue)
    }
}

public protocol ObjectIdProtocol {
    var actualId: UInt32 { get }
}

// this should be in swift backend
extension UInt32: ObjectIdProtocol {
    public var actualId: UInt32 { self }
}

extension Backend {
    // func roundtrip() async throws {
    //     // mainQueue.roundtrip()
    // }
}
