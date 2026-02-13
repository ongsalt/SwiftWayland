import Foundation
import Glibc
import SwiftWayland

@main
@MainActor
public struct SwiftWayland {
    public static var connection: Connection! = nil
    public static var flusher: AutoFlusher! = nil

    public static func main() {
        Task {
            do {
                try await start()
            } catch {
                print("error: \(error)")
            }
            // flusher = AutoFlusher(connection: connection)
            // flusher.start()
        }

        RunLoop.main.run()
    }

    static func start() async throws {
        connection = try Connection.fromEnv()

        let display = connection.display!
        display.onEvent = { event in
            switch event {
            case .deleteId(let id):
                print("___---- Delete id \(id)")
            default:
                break
            }
        }

        let registry = display.getRegistry()

        registry.onEvent = { event in
            print(event)
        }

        try connection.roundtrip()
        try connection.roundtrip()
    }
}
