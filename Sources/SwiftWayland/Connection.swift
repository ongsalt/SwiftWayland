import Foundation

public enum InitWaylandError: Error {
    case noXdgRuntimeDirectory
    case cannotOpenSocket
    case cannotConnect
}

public class Connection: @unchecked Sendable {
    let wire: Wire
    public init(wire: Wire) {
        self.wire = wire
    }

    public static func fromEnv() async throws -> Connection {
        Connection(wire: try await Wire.fromEnv())
    }

    // ????
    func register(object: AnyObject) {
        
    }
}
