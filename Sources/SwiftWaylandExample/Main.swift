import Foundation
import Glibc
import SwiftWayland

@main
@MainActor
public struct SwiftWayland {
    public static func main() {
        Task {
            // let connection = try! Connection.fromEnv()
            do {
                // let w = Window(connection: connection)
                // try await w.start()
                // Unmanaged.passRetained(w)
                try await testConnection()
            } catch {
                print("Error: \(error)")
            }

            // while !Task.isCancelled {
            //     try connection.roundtrip()
            // }
        }
        RunLoop.main.run()
    }
}

func testConnection() async throws {
    let connection = try! Connection.fromEnv()

    let display = connection.display!
    display.onEvent = { event in
        switch event {
        case .deleteId(let id):
            print(" - Delete id \(id)")
            // connection.removeObject(id: id)
        default:
            break
        }
    }

    try display.sync { data in
        print("> Callback: Sync \(data)")
    }
    let registry = try display.getRegistry()

    // registry.onEvent = { event in
    //     // print(event)
    // }

    print(connection.proxiesList)
    try connection.flush()
    try connection.dispatch(force: true)
    // try connection.dispatch(force: true)

    print()
    print("[DONE]")

}
