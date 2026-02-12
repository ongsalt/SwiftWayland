import Foundation

public enum InitWaylandError: Error {
    case noXdgRuntimeDirectory
    case cannotOpenSocket
    case cannotConnect
}

public final class Connection: @unchecked Sendable {
    var proxies: [ObjectId: WlProxyProtocol] = [:]
    private(set) var currentId: ObjectId = 0
    let socket: Socket

    var pendingMessages: [Message] = []

    private(set) public var display: WlDisplay!  // id 1

    init(socket: Socket) {
        self.socket = socket
        display = createProxy(type: WlDisplay.self)
        startProcessingEvent()
    }

    func nextId() -> ObjectId {
        currentId += 1
        return currentId
    }

    func createProxy<T>(type: T.Type) -> T where T: WlProxyProtocol {
        let obj = T(connection: self, id: nextId())
        proxies[obj.id] = obj
        return obj
    }

    func removeObject(id: ObjectId) {
        proxies.removeValue(forKey: id)
    }

    func startProcessingEvent() {
        Task {
            for await event in socket.event {
                switch event {
                case .write:
                    print("write")
                    for m in pendingMessages {
                        try await send(message: m)
                    }

                case .read:
                    let message = try await Message(readFrom: socket)

                    guard let receiver = self.proxies[message.objectId] else {
                        print("Bad wayland message: unknown receiver")
                        print(message)
                        print(message.arguments as NSData)
                        break
                    }

                    receiver.parseAndDispatch(message: message)

                // receiver.onEvent()

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

    @discardableResult
    func send(message: Message) async throws -> Int {
        let data = Data(message)
        try await socket.write(data)
        return data.count
    }

    func queueSend(message: Message) {
        pendingMessages.append(message)
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
