import CoreFoundation
import Foundation

public enum InitWaylandError: Error {
    case noXdgRuntimeDirectory
    case cannotOpenSocket
    case cannotConnect
}

public final class Connection: @unchecked Sendable {
    // this should be weak
    public var proxies: [ObjectId: Weak<AnyObject>] = [:]
    private(set) var currentId: ObjectId = 1  // must be 1 becuase wldisplay is special case
    let socket: BufferedSocket

    private(set) public var display: WlDisplay!  // id 1

    init(socket: Socket2) {
        self.socket = BufferedSocket(socket)
        // TODO: what is wl_display's version tho
        display = createProxy(type: WlDisplay.self, version: 1, id: 1)

        display.onEvent = { event in
            print(event)
        }
    }

    public func dispatch(force: Bool = false) throws {
        var shouldRun = force

        // var error: SocketError? = nil
        // do {
        try socket.receiveUntilDone(force: force)
        // } catch let e {
        //     error = e
        // }

        while socket.dataAvailable || shouldRun {
            shouldRun = false
            let message = try Message(readBlocking: socket)

            guard let receiver: Weak<AnyObject> = self.proxies[message.objectId] else {
                print("Bad wayland message: unknown receiver")
                print(message)
                print(message.arguments as NSData)
                break
            }

            guard let receiver = receiver.value else {
                print("Bad wayland message: object is already dropped")
                print(message)
                print(message.arguments as NSData)
                break
            }

            (receiver as! any WlProxy).parseAndDispatch(message: message, connection: self, fdSource: self.socket)
        }

        // if let error {
        //     throw error
        // }
    }

    public func flush() throws {
        try self.socket.flush()
    }

    // how does this work
    public func roundtrip() throws {
        try flush()
        try dispatch(force: true)
    }

    @discardableResult
    public func send(message: Message) -> Int {
        let data = Data(message)
        socket.write(data: data, fds: message.fds)
        return data.count
    }

    public func get(id: ObjectId) -> (any WlProxy)? {
        proxies[id] as? any WlProxy
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
            // currentId += numericCast(rand())
        }
        return currentId
    }

    public func createProxy<T>(type: T.Type, version: UInt32, id: ObjectId? = nil) -> T where T: WlProxy {
        let id = id ?? nextId()
        let obj = T(connection: self, id: id, version: version)
        proxies[obj.id] = Weak(obj)
        return obj
    }

    // TODO: @spi for this
    public func removeObject(id: ObjectId) {
        // this is not needed tho, because its a already weak??
        // todo delete_id req
        proxies.removeValue(forKey: id)
    }

    deinit {
        print("Closing because refcounted")
    }

    public static func fromEnv() throws(InitWaylandError) -> Self {
        guard let xdgRuntimeDirectory = ProcessInfo.processInfo.environment["XDG_RUNTIME_DIR"]
        else {
            throw .noXdgRuntimeDirectory
        }

        let waylandDisplay = ProcessInfo.processInfo.environment["WAYLAND_DISPLAY"] ?? "wayland-0"
        let waylandPath = "\(xdgRuntimeDirectory)/\(waylandDisplay)"

        return try Self(socket: connectToSocket(path: waylandPath))
    }

    private static func connectToSocket(path: String) throws(InitWaylandError) -> Socket2 {
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

        return Socket2(fileDescriptor: fd)
    }
}

public final class AutoFlusher {
    let flushQueue: DispatchQueue = DispatchQueue(label: "SwiftWayland.AutoFlusher")
    let observer: CFRunLoopObserver
    let runLoop: CFRunLoop
    let connection: Connection

    public init(connection: Connection) {
        self.connection = connection
        let priority: Int = 0
        self.runLoop = CFRunLoopGetCurrent()

        observer = CFRunLoopObserverCreateWithHandler(
            nil, CFRunLoopActivity.beforeWaiting.rawValue, true, priority
        ) { observer, activity in
            print("Will sleep")
            // if !connection.pendingMessages.isEmpty {
            //     print("> Cant")
            //     try! connection.flush()
            // }

            // if !connection.socket.canRead {
            //     print("> Cant (can read)")
            //     try! connection.dispatchBlocking(force: true)
            // }
        }!
    }

    public func start() {
        CFRunLoopAddObserver(runLoop, observer, kCFRunLoopDefaultMode)
    }

    public func stop() {
        CFRunLoopRemoveObserver(runLoop, observer, kCFRunLoopDefaultMode)
    }

    deinit {
        print("AutoFlusher: deinit")
    }
}
