import CoreFoundation
import Foundation

public enum InitWaylandError: Error {
    case noXdgRuntimeDirectory
    case cannotOpenSocket
    case cannotConnect
}

public final class Connection: @unchecked Sendable {
    // this should be weak
    var proxies: [ObjectId: Weak<AnyObject>] = [:]
    private(set) var currentId: ObjectId = 1  // wldisplay's id must be 1
    let socket: BufferedSocket

    private(set) public lazy var display: WlDisplay = createProxy(
        type: WlDisplay.self, version: nextId(), id: 1)

    init(socket: Socket2) {
        self.socket = BufferedSocket(socket)
        // we force to create it now
        display.onEvent = { event in
            switch event {
            case .error(let obj, let code, let message):
                print("[Wayland] Error \(message) (code: \(code), target: \(obj))")
            case .deleteId(let id):
                self.removeObject(id: id)
            }
        }
    }

    public func dispatch(force: Bool = false) throws {
        // var shouldRun = force

        // var error: SocketError? = nil
        // do {
        try socket.receiveUntilDone(force: force)
        // } catch let e {
        //     error = e
        // }

        // print("DataAvailable: \(socket.dataAvailable)")
        while socket.data.count >= Message.HEADER_SIZE {
            // shouldRun = false
            let result = Result {
                try Message(readBlocking: socket)
            }.mapError { $0 as! BufferedSocketError }

            guard case .success(let message) = result else {
                // print("not enought data \(socket.data.count) \(socket.data as NSData)")
                try socket.receiveUntilDone(force: false)
                // print("received \(socket.data.count)")
                continue
            }

            guard let receiver: Weak<AnyObject> = self.proxies[message.objectId] else {
                print("Bad wayland message: unknown receiver")
                print(message)
                print(message.arguments as NSData)
                continue
            }

            guard let receiver = receiver.value else {
                print("Bad wayland message: object is already dropped")
                print(message)
                print(message.arguments as NSData)
                break
            }

            (receiver as! any WlProxy).parseAndDispatch(
                message: message, connection: self)
        }

        // if let error {
        //     throw error
        // }
    }

    public func flush() throws {
        try self.socket.flush()
    }

    public func roundtrip() throws {
        var shouldStop = false
        try display.sync { _ in
            shouldStop = true
        }
        try self.flush()
        while !shouldStop {
            try self.dispatch(force: true)
        }
    }
    @discardableResult
    public func send(message: Message) -> Int {
        let data = Data(message)
        socket.write(data: data, fds: message.fds)
        return data.count
    }

    public func get(id: ObjectId) -> (any WlProxy)? {
        proxies[id]?.value as? ((any WlProxy)?) ?? nil
    }

    public func get<T>(as type: T.Type, id: ObjectId) -> T? where T: WlProxy {
        if let obj = proxies[id] {
            (obj as! T)
        } else {
            nil
        }
    }

    func nextId() -> ObjectId {
        currentId += 1
        // while proxies.keys.contains(currentId) {
        //     // currentId += numericCast(rand())
        // }
        return currentId
    }

    public func createProxy<T>(type: T.Type, version: UInt32, id: ObjectId? = nil) -> T
    where T: WlProxy {
        let id = id ?? nextId()
        let obj = T(connection: self, id: id, version: version)
        // print("[Wayland] create \(obj) with id: \(id)")
        // dump(obj)
        proxies[obj.id] = Weak(obj)
        return obj
    }

    public func createCallback(fn: @escaping (UInt32) -> Void) -> WlCallback {
        // this must be alive until it got call
        let callback = WlCallback(connection: self, id: nextId(), version: 1)
        proxies[callback.id] = Weak(callback)

        // lmao
        let ref = Unmanaged.passRetained(callback)
        callback.onEvent = { event in
            if case .done(let callbackData) = event {
                fn(callbackData)
                ref.release()
            } else {
                fatalError("wtf")
            }
        }

        return callback
    }

    public var proxiesList: [(UInt32, any WlProxy)] {
        proxies.lazy.map { (k, v) in
            (k, v.value as? any WlProxy)
        }.filter { (_, v) in
            v != nil
        }.map { (k, v) in
            (k, v!)
        }
    }

    // TODO: @spi for this
    public func removeObject(id: ObjectId) {
        // this is not needed tho, because its a already weak??
        // todo delete_id req
        if let v = proxies[id]?.value {
            print(v)
        }
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

        return try Self(socket: Socket2(connectTo: waylandPath))
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
}
