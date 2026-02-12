import Foundation

public enum InitWaylandError: Error {
    case noXdgRuntimeDirectory
    case cannotOpenSocket
    case cannotConnect
}

public final class Connection: @unchecked Sendable {
    var proxies: [ObjectId: any WlProxy] = [:]
    private(set) var currentId: ObjectId = 1  // must be 1 becuase wldisplay is special case
    let socket: Socket

    var roundtripping: Bool {
        roundtrippingContinuation != nil
    }
    var roundtrippingContinuation: UnsafeContinuation<(), Never>? = nil
    var pendingMessages: [Message] = []

    private(set) public var display: WlDisplay!  // id 1

    init(socket: Socket) {
        self.socket = socket
        display = createProxy(type: WlDisplay.self, id: 1)
        startProcessingEvent()
    }

    // how does this work
    public func roundtrip() async throws {

        let callback = display.sync()
        try await flush()

        await withUnsafeContinuation { continuation in
            callback.onEvent = { _ in
                print("-- Callback")
                continuation.resume()
            }
        }
        

        // how do i wait for
        // block until there is an event
        // try await socket.done
    }

    public func get(id: ObjectId) -> (any WlProxy)? {
        proxies[id]
    }

    public func get<T>(as type: T.Type, id: ObjectId) -> T? where T: WlProxy {
        if let obj = proxies[id] {
            (obj as! T)
        } else {
            nil
        }
    }

    func nextId() -> ObjectId {
        while proxies.keys.contains(currentId) {
            currentId += 1
        }
        return currentId
    }

    public func createProxy<T>(type: T.Type, id: ObjectId? = nil) -> T where T: WlProxy {
        let id = id ?? nextId()
        let obj = T(connection: self, id: id)
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
                    // print("write")
                    try await flush()

                // if let c = roundtrippingContinuation {
                //     c.resume()
                //     // will this be run immediately or in next run loop pass
                //     // if first (js like) this gonna be fine
                //     // but if its second -> fuck
                // }

                case .read:
                    // print("read")
                    let message = try await Message(readFrom: socket)

                    guard let receiver = self.proxies[message.objectId] else {
                        print("Bad wayland message: unknown receiver")
                        print(message)
                        print(message.arguments as NSData)
                        break
                    }

                    receiver.parseAndDispatch(message: message, connection: self)
                    // print("done")

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
    public func send(message: Message) async throws -> Int {
        let data = Data(message)
        try await socket.write(data)
        return data.count
    }

    public func queueSend(message: Message) {
        pendingMessages.append(message)
    }

    public func flush() async throws {
        let msgs = pendingMessages
        pendingMessages = []
        for m in msgs {
            try await send(message: m)
        }
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
