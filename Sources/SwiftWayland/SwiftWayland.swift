import Foundation



class App {
    
}

extension App: WlDisplayDelegate {
    func event(interface: WlDisplay, event: WlDisplay.Event) {
        print(event)
    }
}

extension App: WlRegistryDelegate {
    func event(interface: WlRegistry, event: WlRegistry.Event) {
        print(event)
    }
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

        var currentId: UInt32 = 1
        currentId += 1
        
        // var msg = Data()
        // msg.append(u32: 1)  // wl_display id
        // msg.append(u16: 1)  // wl_display_get_registry
        // msg.append(u16: Message.HEADER_SIZE + 4)  // size
        // msg.append(u32: currentId)  // ???

        let message = Message(objectId: 1, opcode: 1) { data in
            data.append(u32: currentId)
        }

        let app = App()
        connection.register(object: app)

        let sent = try await connection.send(message: message)
        print("Send: \(sent), \(message)")
    }
}
