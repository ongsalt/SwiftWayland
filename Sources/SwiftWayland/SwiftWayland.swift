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

        let registry = connection.display.getRegistry()
        print(registry.id)

        registry.onEvent = { event in 
            print(event)
        }

        // connection.queueSend(message: Message)
        try await connection.flush()
    }
}
