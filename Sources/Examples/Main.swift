import Foundation
import Glibc
import SwiftWayland

@main
@MainActor
public struct SwiftWaylandExample {
    public static func main() {
        // Task {
        //     try await testConnection()
        // }
        Task {
            let connection = try! Connection.fromEnv()
            let w = Window(connection: connection)
            do {
                try await w.start()
            } catch {
                print("Error: \(error)")
                print(connection.proxiesList)
            }

            while !Task.isCancelled {
                try await Task.sleep(for: .microseconds(16))
                try await connection.roundtripAsync()
            }
        }
        RunLoop.main.run()
    }
}

func testConnection() async throws {
    let connection = try! Connection.fromEnv()

    let display = connection.display
    let registry = try Globals(connection: connection)
    print(display)

    try display.sync { data in
        print("> Callback: Sync \(data)")
    }

    try await connection.roundtripAsync()
    print(registry.globals)

    print("[DONE]")

}
