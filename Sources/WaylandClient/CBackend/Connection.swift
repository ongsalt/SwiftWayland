import CWayland
import Foundation
import SwiftWaylandCommon

public class Connection {
    let rawDisplay: OpaquePointer
    public private(set) var mainQueue: EventQueue
    var knownProxies: [UInt32: any Proxy] = [:]
    var knownQueues: [EventQueue] = []

    var fd: Int32 {
        wl_display_get_fd(rawDisplay)
    }

    public private(set) lazy var display: WlDisplay = WlDisplay(
        id: 1, version: 1, queue: mainQueue, raw: rawDisplay, connection: self)

    public init(rawDisplay: OpaquePointer) {
        self.rawDisplay = rawDisplay
        self.mainQueue = EventQueue(raw: wl_proxy_get_queue(rawDisplay), display: rawDisplay)
        knownQueues.append(mainQueue)

        self.display.onEvent = { e in
            switch e {
            case .deleteId(let id):
                print("the server said remove id \(id)")
            case .error(let objectId, let code, let message):
                print("[wayland] Error (\(code)) \(message) at \(objectId)")
            }
        }
    }

    public convenience init() {
        self.init(rawDisplay: wl_display_connect(nil))
    }

    public func send(
        _ proxy: any Proxy,
        _ opcode: UInt32,
        _ args: [Arg],
    ) {
        var freeList: [UnsafeMutableRawPointer] = []
        defer {
            for p in freeList {
                p.deallocate()
            }
        }

        var arguments: [wl_argument] = []
        for arg in args {
            switch arg {
            case .int(let i):
                arguments.append(wl_argument(i: i))
            case .enum(let u):
                arguments.append(wl_argument(u: u))
            case .array(let data):
                let arr = data.toWlArrayPtr()
                freeList.append(arr)
                arguments.append(wl_argument(a: arr))
            case .fd(let fd):
                arguments.append(wl_argument(h: fd.fileDescriptor))
            case .fixed(let d):
                arguments.append(wl_argument(f: Int32(d * 256)))
            case .uint(let u):
                arguments.append(wl_argument(u: u))
            case .string(let s):
                arguments.append(wl_argument(s: s.cString(using: .utf8)!.toBuffer().baseAddress))
            case .object(let id):
                arguments.append(wl_argument(o: id == 0 ? nil : knownProxies[id]?.raw))
            // if we have a newId, create it, then make it a .object instead, we create an object before calling send anyway, sooo sammeeee
            case .newId(let id):
                arguments.append(wl_argument(o: knownProxies[id]?.raw))
            }
        }
        wl_proxy_marshal_array(proxy.raw, opcode, &arguments)
    }

    public func createProxy<T>(
        type: T.Type,
        version: UInt32? = nil,
        queue: EventQueue? = nil,
        parent: (any Proxy)? = nil,  // unused?
    ) -> T where T: Proxy {
        var rawParent = parent?.raw ?? rawDisplay
        if let queue {
            rawParent = OpaquePointer(
                wl_proxy_create_wrapper(UnsafeMutableRawPointer(rawParent)))
            wl_proxy_set_queue(rawParent, queue.raw)
        }

        let interface = T.ensureLoaded()
        let ptr = wl_proxy_create(rawParent, interface)
        return createObj(type: type, ptr: ptr!, queue: queue ?? parent?.queue)
    }

    func createObj<T: Proxy>(
        type: T.Type, ptr: OpaquePointer, version: UInt32? = nil, queue: EventQueue? = nil
    ) -> T {
        let obj = T(
            id: wl_proxy_get_id(ptr),
            version: version ?? wl_proxy_get_version(ptr),
            queue: queue ?? self.mainQueue,
            raw: ptr,
            connection: self
        )

        wl_proxy_add_dispatcher(ptr, dispatchFn, nil, Unmanaged.passUnretained(obj).toOpaque())
        knownProxies[obj.id] = obj
        return obj
    }

    func createEventQueue(name: String? = nil) -> EventQueue {
        let handle =
            if let name {
                wl_display_create_queue_with_name(rawDisplay, name)
            } else {
                wl_display_create_queue(rawDisplay)
            }

        return EventQueue(raw: handle!, display: rawDisplay)
    }

    func destroy(proxyId: UInt32) {
        guard let proxy = knownProxies[proxyId] else { return }
        knownProxies[proxyId] = nil
        wl_proxy_destroy(proxy.raw)
    }

    @discardableResult
    public func flush() -> Int32 {
        wl_display_flush(rawDisplay)
    }

    @discardableResult
    public func dispatchPending() -> Int32 {
        wl_display_dispatch_pending(rawDisplay)
    }

    @discardableResult
    public func dispatch() -> Int32 {
        wl_display_dispatch(rawDisplay)
    }

    @discardableResult
    public func roundtrip() -> Int32 {
        wl_display_roundtrip(rawDisplay)
    }

    @discardableResult
    public func prepareRead() -> Bool {
        wl_display_prepare_read(rawDisplay) == 0
    }

    /// Call if the poll returned an error or you decide not to read.
    public func cancelRead() {
        wl_display_cancel_read(rawDisplay)
    }

    /// Call when the fd is readable (after a successful prepareRead).
    /// Reads events from the socket into the queue without dispatching them.
    public func readEvents() {
        wl_display_read_events(rawDisplay)
    }

    public func disconnect() {
        wl_display_disconnect(self.rawDisplay)
    }

    public func makeReadSource(queue: DispatchQueue = .main) -> any DispatchSourceRead {
        DispatchSource.makeReadSource(fileDescriptor: fd, queue: queue)
    }

    @MainActor
    public func attach() -> Watch {
        var prepared = false

        func preparePoll() {
            while !self.prepareRead() {
                self.dispatchPending()
            }
            prepared = true
            self.flush()
        }

        let source = makeReadSource(queue: .main)
        source.setEventHandler {
            self.readEvents()
            prepared = false
            self.dispatchPending()

            if wl_display_get_error(self.rawDisplay) != 0 {
                source.cancel()
                return
            }

            preparePoll()
        }

        source.setCancelHandler {
            if prepared {
                self.cancelRead()
                prepared = false
            }
        }

        let observer = RunLoopObserver(on: [.beforeWaiting], runLoop: .main) { [weak self] _ in
            self?.flush()
        }

        preparePoll()
        source.resume()
        observer.start()

        return Watch {
            observer.stop()
            source.cancel()
        }
    }

    @MainActor
    public func run() {
        let watch = self.attach()
        RunLoop.main.run()
        _ = watch
    }

    deinit {
        disconnect()
    }
}

extension Data {
    fileprivate func toWlArray() -> wl_array {
        let buffer = UnsafeMutableRawBufferPointer.allocate(
            byteCount: self.count, alignment: MemoryLayout<Int8>.alignment)
        self.copyBytes(to: buffer)
        return wl_array(
            size: buffer.count,
            alloc: buffer.count,
            data: buffer.baseAddress
        )
    }

    fileprivate func toWlArrayPtr() -> UnsafeMutablePointer<wl_array> {
        let ptr = UnsafeMutablePointer<wl_array>.allocate(capacity: 1)
        ptr.initialize(to: self.toWlArray())
        return ptr
    }
}

extension Array {
    fileprivate func toBuffer() -> UnsafeBufferPointer<Element> {
        let buffer = UnsafeMutableBufferPointer<Element>.allocate(capacity: self.count)
        _ = buffer.initialize(from: self)
        return UnsafeBufferPointer(buffer)
    }
}

// TODO: userData maybe
public let dispatchFn: wl_dispatcher_func_t = { _, target, opcode, _, args in
    let proxy =
        Unmanaged<AnyObject>.fromOpaque(
            wl_proxy_get_user_data(OpaquePointer(target))!
        ).takeUnretainedValue() as! any Proxy

    let ok = proxy.dispatch(opcode: opcode, args: args!)
    return if ok { 0 } else { -1 }  // or -1 on failure
}

// When created we gonna wl_proxy_set_user_data and point to RawProxy

extension Proxy {
    fileprivate func dispatch(opcode: UInt32, args: UnsafePointer<wl_argument>) -> Bool {
        do {
            var reader = CArgumentReader(args, parent: self)
            let event = try Self.Event.init(from: &reader, opcode: opcode)
            if event.isDestructor {
                (self as? BaseProxy)?.isAlive = false
                self.connection.destroy(proxyId: self.id)
            }
            self.onEvent?(event)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
