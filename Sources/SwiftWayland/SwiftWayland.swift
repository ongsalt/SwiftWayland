import Foundation



class App {
    
}


@main
@MainActor
public struct SwiftWayland {
    public static var connection: Connection! = nil
    public static func main() throws {
        Task { try await bruh() }

        RunLoop.main.run()
    }

    static func bruh() async throws {
        connection = try await Connection.fromEnv()

        let registry = try await connection.display.getRegistry()
        print(registry.id)

        registry.onEvent = { event in 
            print(event)
        }

        // await connection.roundtrip()
        // print("Roundtripped")

        // registry.bind(name: 1, type: WlDisplay.self)
    }
}
