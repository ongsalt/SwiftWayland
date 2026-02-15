import Foundation
import Glibc
import SwiftWayland

@main
@MainActor
public struct SwiftWaylandExample {
    public static func main() {
        Task {
            let connection = try! Connection.fromEnv()
            do {
                let w = Window(connection: connection)
                try await w.start()
                Unmanaged.passRetained(w)
                // try await testConnection()
            } catch {
                print("Error: \(error)")
                print(connection.proxiesList)
            }

            while !Task.isCancelled {
                try await Task.sleep(for: .microseconds(16))
                try connection.roundtrip()
            }
        }
        RunLoop.main.run()
    }
}

func testConnection() async throws {
    let connection = try! Connection.fromEnv()

    let display = connection.display

    try display.sync { data in
        print("> Callback: Sync \(data)")
    }
    let registry = try display.getRegistry()

    registry.onEvent = { event in
        print(event)
    }
    try connection.roundtrip()

    print(connection.proxiesList)

    print("[DONE]")

}
