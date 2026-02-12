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

        
        // var msg = Data()
        // msg.append(u32: 1)  // wl_display id
        // msg.append(u16: 1)  // wl_display_get_registry
        // msg.append(u16: Message.HEADER_SIZE + 4)  // size
        // msg.append(u32: currentId)  // ???

        // wl_display::get_registry

        let registry = try await connection.display.getRegistry()
        print(registry.id)

        registry.onEvent = { event in 
            print(event)
        }
    }
}
