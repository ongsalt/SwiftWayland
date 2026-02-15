import CoreFoundation
import Foundation

public enum ConnectionError: Error {
    case noXdgRuntimeDirectory
    case socket(SocketError)
    case invalidFds([Int32])
    case connectionClosed
}

// TODO: map error, or we should stop throwing and use reulst instead

public final class Connection: @unchecked Sendable {
    // this should be weak
    let socket: BufferedSocket
    var proxies: WeakMap<ObjectId, WlProxyBase> = [:]
    var queues: [EventQueue] = []
    private(set) var currentId: ObjectId = 1  // wldisplay's id must be 1
    private(set) public lazy var display: WlDisplay = createProxy(
        type: WlDisplay.self, version: 1, id: 1)

    public var proxiesList: [ObjectId: WlProxyBase] {
        proxies.upgrade()
    }

    var mainQueue: EventQueue {
        queues[0]
    }

    init(socket: Socket2) {
        self.socket = BufferedSocket(socket)
        queues.append(EventQueue(connection: self))
        // we force to create it now
        display.onEvent = { event in
            switch event {
            case .error(let obj, let code, let message):
                print("[Wayland] Fatal Error \(message) (code: \(code), target: \(obj))")
            // how to throw tho
            case .deleteId(let id):
                self.removeObject(id: id)
            }
        }
    }

    package func plsReadAndPutMessageIntoQueues(wait: Bool = false) throws(SocketError) {
        let res = socket.receiveUntilDone(wait: wait)
        if case .failure(let error) = res {
            // what to do??
            throw error
        }

        while socket.data.count >= Message.HEADER_SIZE {
            let result = Result {
                try Message(readBlocking: socket)
            }.mapError { $0 as! BufferedSocketError }

            guard case .success(let message) = result else {
                break
            }

            guard let receiver = self.proxies[message.objectId] else {
                print("[Wayland] Unknown receiver, object might be deallocated \(message)")
                continue
            }

            let event = (receiver as! any WlProxy).parse(message: message, connection: self)
            receiver.queue.enqueue(event, receiver: receiver.id)
        }
    }

    public func flush() throws(ConnectionError) {
        try self.socket.flush().mapError { e in
            switch e {
            case .invalidFds(let fds): ConnectionError.invalidFds(fds)
            case .closed: ConnectionError.connectionClosed
            default: fatalError("unhandle error \(e)")
            }
        }.get()
    }

    public func dispatch(wait: Bool = false) throws {
        try self.mainQueue.dispatch(wait: wait)
    }

    public func roundtrip() throws {
        try self.mainQueue.roundtrip()
    }

    // --- SPI export ---

    @discardableResult
    public func send(message: Message) -> Int {
        let data = Data(message)
        socket.write(data: data, fds: message.fds)
        return data.count
    }

    public func get(id: ObjectId) -> (any WlProxy)? {
        proxies[id] as! (any WlProxy)?
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

    public func createProxy<T>(
        type: T.Type, version: UInt32, id: ObjectId? = nil, _queue: EventQueue? = nil
    ) -> T
    where T: WlProxy, T: WlProxyBase {
        let id = id ?? nextId()
        let obj = T(connection: self, id: id, version: version, queue: _queue ?? self.mainQueue)
        // print("[Wayland] create \(obj) with id: \(id)")
        // dump(obj)
        proxies[obj.id] = obj
        return obj
    }

    public func createCallback(fn: @escaping (UInt32) -> Void, _queue: EventQueue? = nil)
        -> WlCallback
    {
        // this must be alive until it got call
        let callback = WlCallback(
            connection: self,
            id: nextId(),
            version: 1,
            queue: _queue ?? self.mainQueue
        )
        proxies[callback.id] = callback

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

    // TODO: @spi for this
    public func removeObject(id: ObjectId) {
        proxies[id] = nil
    }

    deinit {
        print("Closing because refcounted")
    }

    public static func fromEnv() throws(ConnectionError) -> Self {
        guard let xdgRuntimeDirectory = ProcessInfo.processInfo.environment["XDG_RUNTIME_DIR"]
        else {
            throw .noXdgRuntimeDirectory
        }

        let waylandDisplay = ProcessInfo.processInfo.environment["WAYLAND_DISPLAY"] ?? "wayland-0"
        let waylandPath = "\(xdgRuntimeDirectory)/\(waylandDisplay)"

        let socket = Result {
            try Socket2(connectTo: waylandPath)
        }

        return switch socket {
        case .success(let socket): Self(socket: socket)
        case .failure(let error): throw .socket(error as! SocketError)
        }
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
            //     try! connection.dispatchBlocking(wait: true)
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
