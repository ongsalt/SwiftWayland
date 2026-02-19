import SwiftWaylandCommon

class SystemBackend: Backend {
    // func createProxy<T>(type: T.Type, version: UInt32, id: (), parent: some SwiftWaylandCommon.Proxy, queue: ()?) -> T where T : SwiftWaylandCommon.Proxy {
    //     fatalError()
    // }

    var mainQueue: () = ()

    func send(_ opjectId: UInt32, _ opcode: UInt32, _ args: [Arg], version: UInt32, queue: EventQueue) {

    }

    func sendWithReturn<T: Proxy>(_ opjectId: UInt32, _ opcode: UInt32, _ args: [Arg], version: UInt32, type: T.Type, queue: EventQueue) {

    }

    func flush() async throws {

    }

    func dispatch() async throws {

    }

    func roundtrip() async throws {

    }
}
