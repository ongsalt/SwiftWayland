public protocol Backend {
    associatedtype ObjectId = Void
    associatedtype EventQueue = Void

    var mainQueue: EventQueue { get }

    func send(
        _ opjectId: UInt32,
        _ opcode: UInt32,
        _ args: [Arg],
        version: UInt32,
        queue: EventQueue
    )

    func sendWithReturn<T>(
        _ opjectId: UInt32,
        _ opcode: UInt32,
        _ args: [Arg],
        version: UInt32,
        type: T.Type,
        queue: EventQueue
    ) where T: Proxy
    
    func flush() async throws
    // func plsReadAndPutMessageIntoQueues
}

extension Backend {
    // func roundtrip() async throws {
    //     // mainQueue.roundtrip()
    // }
}
