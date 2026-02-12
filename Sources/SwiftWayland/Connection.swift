import Foundation

public enum InitWaylandError: Error {
    case noXdgRuntimeDirectory
    case cannotOpenSocket
    case cannotConnect
}

public final class Connection: @unchecked Sendable {
    var delegates: [any WLDelegate] = []  // TODO: make this safe
    var proxies: [any WlProxy] = []

    let socket: Socket
    init(socket: Socket) {
        self.socket = socket
        startProcessingEvent()
    }

    func startProcessingEvent() {
        Task { [] in
            for await event in socket.event {
                switch event {
                case .write:
                    print("write")
                case .read:
                    let message = try await Message(readFrom: socket)
                    print(message)
                    print(message.arguments as NSData)
                    
                    // let receiver = self.proxies.first { UInt32($0.id.hashValue) == message.objectId }
                    
                    // dispatch(receiver)

                    // 

                    

                // read it, put it to proper queue
                // each queue must call dispatch
                // or just ignore this and let swift do its thing
                case .error(let error):
                    print("error: \(error)")
                case .close:
                    // tell everyone its close
                    print("closing")
                    break
                }
            }
        }
    }

    func register(object: any WLDelegate) {
        self.delegates.append(object)
    }

    func unregister(object: any WLDelegate) {
        self.delegates.removeAll { $0.id == object.id }
    }

    func send(message: Message) async throws -> Int {
        let data = Data(message)
        try await socket.write(data)
        return data.count
    }

    deinit {
        print("Closing because refcounted")
        Task { [socket] in
            await socket.close()
        }
    }

    public static func fromEnv() async throws(InitWaylandError) -> Self {
        guard let xdgRuntimeDirectory = ProcessInfo.processInfo.environment["XDG_RUNTIME_DIR"]
        else {
            throw .noXdgRuntimeDirectory
        }

        let waylandDisplay = ProcessInfo.processInfo.environment["WAYLAND_DISPLAY"] ?? "wayland-0"
        let waylandPath = "\(xdgRuntimeDirectory)/\(waylandDisplay)"

        return try await Self(socket: connectToSocket(path: waylandPath))
    }

    private static func connectToSocket(path: String) async throws(InitWaylandError) -> Socket {
        var addr = sockaddr_un()
        addr.sun_family = UInt16(AF_UNIX)
        withUnsafeMutableBytes(of: &addr.sun_path) { ptr in
            ptr.copyBytes(from: path.utf8)
            ptr[path.count] = 0  // null terminated
        }

        let fd = Glibc.socket(AF_UNIX, Int32(SOCK_STREAM.rawValue), 0)
        guard fd != -1 else {
            throw .cannotOpenSocket
        }

        let c = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1, ) { ptr in
                connect(fd, ptr, UInt32(MemoryLayout<sockaddr_un>.size))
            }
        }
        guard c != -1 else {
            throw .cannotConnect
        }

        return Socket(fileDescriptor: fd)
    }
}
