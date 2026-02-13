import Foundation
import Glibc
import SwiftWayland

@main
@MainActor
public struct SwiftWayland {
    public static func main() {
        Task {
            do {
                // let w = Window(connection: try! Connection.fromEnv())
                // try await w.start()
                await testConnection()
            } catch {
                print("Error: \(error)")
            }
        }
        RunLoop.main.run()
    }
}

func testConnection() async {
    let connection = try! Connection.fromEnv()

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

    try! connection.roundtrip()
    try! connection.roundtrip()

}
