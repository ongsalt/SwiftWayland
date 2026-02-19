public protocol Backend {
    associatedtype ObjectId = Void
    associatedtype EventQueue = Void

    var mainQueue: EventQueue { get }

    func send(
        _ objectId: ObjectId,
        _ opcode: UInt32,
        _ args: [Arg],
        version: UInt32,
        queue: EventQueue
    )

    func createProxy<T>(type: T.Type, version: UInt32, id: ObjectId, parent: some Proxy, queue: EventQueue) -> T where T : Proxy

    func flush() async throws
    // func plsReadAndPutMessageIntoQueues
}

extension Backend {
    // func roundtrip() async throws {
    //     // mainQueue.roundtrip()
    // }
}


