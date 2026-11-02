import CWayland
import SwiftWaylandCommon
import Synchronization

// The raw pointers are immutable and libwayland's display is thread-safe;
// everything mutable lives in `state`.
public final class Connection: @unchecked Sendable {
    let rawDisplay: OpaquePointer
    let rawMainQueue: OpaquePointer

    private struct State {
        // Proxies and queues retain their connection, so these caches must not retain them.
        weak var display: WlDisplay?
        weak var mainQueue: EventQueue?
        // Keyed by the wl_event_queue address.
        var createdQueues: [UInt: WeakQueue] = [:]
    }

    private let state = Mutex(State())

    var fd: Int32 {
        wl_display_get_fd(rawDisplay)
    }

    /// Recreate once in a while is fine. we cant hook its `onEvent` anyway
    public var display: WlDisplay {
        let mainQueue = self.mainQueue
        return state.withLock { state in
            if let display = state.display { return display }
            let display = WlDisplay(
                id: 1, version: 1, queue: mainQueue, raw: rawDisplay, connection: self)
            state.display = display
            return display
        }
    }

    /// The display's default queue. Recreated when no proxy holds it, like `display`.
    public var mainQueue: EventQueue {
        state.withLock { state in
            if let queue = state.mainQueue { return queue }
            let queue = EventQueue(raw: rawMainQueue, connection: self)
            state.mainQueue = queue
            return queue
        }
    }

    public init(rawDisplay: OpaquePointer) {
        self.rawDisplay = rawDisplay
        self.rawMainQueue = wl_proxy_get_queue(rawDisplay)!
    }

    public convenience init() {
        self.init(rawDisplay: wl_display_connect(nil))
    }

    // spi?
    public func sendConstructor<Output: Proxy>(
        _ proxy: any Proxy,
        _ opcode: UInt32,
        _ interface: Output.Type,
        _ version: UInt32,
        _ queue: EventQueue?,
        destructor: Bool = false,
        _ args: borrowing [Arg],
    ) -> Output {
        let proxy = send(
            proxy, opcode,
            returning: interface,
            version: version,
            on: queue,
            destructor: destructor,
            args: args
        )!
        return self.createSwiftObject(from: proxy, type: interface)
    }

    public func send(
        _ proxy: any Proxy,
        _ opcode: UInt32,
        _ args: borrowing [Arg],
        destructor: Bool = false,
    ) {
        _ = send(proxy, opcode, destructor: destructor, args: args)
    }

    private func send(
        _ proxy: any Proxy,
        _ opcode: UInt32,
        returning interface: (any Proxy.Type)? = nil,
        version: UInt32 = 0,
        on queue: EventQueue? = nil,
        destructor: Bool = false,
        args: [Arg],
    ) -> OpaquePointer? {  // return an wl_proxy if existed
        var defered: [() -> Void] = []
        defer {
            for fn in defered {
                fn()
            }
        }

        var arguments: [wl_argument] = []
        for arg in args {
            switch arg {
            case .int(let i):
                arguments.append(wl_argument(i: i))
            case .enum(let u):
                arguments.append(wl_argument(u: u))
            case .array(let buffer):
                let arr = UnsafeMutablePointer<wl_array>.allocate(capacity: 1)
                arr.initialize(
                    to: wl_array(
                        size: buffer.count,
                        alloc: buffer.count,
                        data: UnsafeMutableRawPointer(mutating: buffer.baseAddress),
                    ))
                defered.append { arr.deallocate() }
                arguments.append(wl_argument(a: arr))
            case .fd(let fd):
                arguments.append(wl_argument(h: fd))
            case .fixed(let d):
                arguments.append(wl_argument(f: Int32(d * 256)))
            case .uint(let u):
                arguments.append(wl_argument(u: u))
            case .string(let s):
                let buffer = s?.cString(using: .utf8)!.toBuffer()
                defered.append { buffer?.deallocate() }
                arguments.append(wl_argument(s: buffer?.baseAddress))
            case .object(let proxy):
                arguments.append(wl_argument(o: proxy?.raw))
            case .newId:
                // gonna be ignored anyway
                arguments.append(wl_argument())
            }
        }

        let interfacePtr = interface?.ensureLoaded()
        if let interface, interfacePtr == nil {
            fatalError("Failed to load wl_interface for \(interface.interface.name)")
        }
        let flags: UInt32 =
            if destructor {
                UInt32(WL_MARSHAL_FLAG_DESTROY)
            } else {
                0
            }

        return withRawProxy(of: proxy, on: queue) { parent in
            wl_proxy_marshal_array_flags(parent, opcode, interfacePtr, version, flags, &arguments)
        }
    }

    func createSwiftObject<T: Proxy>(from raw: OpaquePointer, type: T.Type) -> T {
        let instance = T(
            id: wl_proxy_get_id(raw),
            version: wl_proxy_get_version(raw),
            queue: self.queue(for: wl_proxy_get_queue(raw)),
            raw: raw,
            connection: self
        )

        wl_proxy_add_dispatcher(
            raw, dispatcherFunction, nil, Unmanaged.passUnretained(instance).toOpaque())
        return instance
    }

    func withRawProxy<T>(
        of parent: any Proxy, on queue: EventQueue? = nil, body: (OpaquePointer) -> T
    ) -> T {
        guard let queue else { return body(parent.raw) }

        // Proxies created through a wrapper are assigned to the wrapper's queue
        let wrapper = OpaquePointer(wl_proxy_create_wrapper(UnsafeMutableRawPointer(parent.raw)))!
        wl_proxy_set_queue(wrapper, queue.raw)
        defer { wl_proxy_wrapper_destroy(UnsafeMutableRawPointer(wrapper)) }

        return body(wrapper)
    }

    public func createEventQueue(name: String? = nil) -> EventQueue {
        let handle =
            if let name {
                wl_display_create_queue_with_name(rawDisplay, name)
            } else {
                wl_display_create_queue(rawDisplay)
            }

        let queue = EventQueue(raw: handle!, connection: self)
        state.withLock { state in
            state.createdQueues = state.createdQueues.filter { $0.value.queue != nil }
            state.createdQueues[UInt(bitPattern: handle)] = WeakQueue(queue: queue)
        }
        return queue
    }

    private func queue(for raw: OpaquePointer) -> EventQueue {
        if raw == rawMainQueue { return mainQueue }
        guard let queue = state.withLock({ $0.createdQueues[UInt(bitPattern: raw)]?.queue }) else {
            fatalError("Proxy belongs to an event queue that was already released")
        }
        return queue
    }

    public func destroy(_ proxy: any Proxy) {
        if let p = proxy as? BaseProxy, !p.markDead() { return }
        wl_proxy_set_user_data(proxy.raw, nil)
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

    /// Announces an intention to read from the socket, for the default queue.
    /// Returns nil if the queue still has events; dispatch them and try again.
    public func prepareRead() -> ReadGuard? {
        guard wl_display_prepare_read(rawDisplay) == 0 else { return nil }
        return ReadGuard(display: rawDisplay)
    }

    public func disconnect() {
        wl_display_disconnect(self.rawDisplay)
    }

    deinit {
        disconnect()
    }
}

// stolen from wayland-rs
/// A prepared read. libwayland's `read_events` waits for every prepared reader,
/// so hold one only while waiting for the socket, then `read()` or drop it (cancels).
public struct ReadGuard: ~Copyable {
    private let display: OpaquePointer

    init(display: OpaquePointer) {
        self.display = display
    }

    /// Reads events from the socket into their queues without dispatching them.
    /// Blocks while other threads still hold a prepared read.
    @discardableResult
    public consuming func read() -> Int32 {
        let result = wl_display_read_events(display)
        discard self
        return result
    }

    deinit {
        wl_display_cancel_read(display)
    }
}

private struct WeakQueue: Sendable {
    weak var queue: EventQueue?
}

extension Array {
    fileprivate consuming func toBuffer() -> UnsafeBufferPointer<Element> {
        let buffer = UnsafeMutableBufferPointer<Element>.allocate(capacity: self.count)
        _ = buffer.initialize(from: self)
        return UnsafeBufferPointer(buffer)
    }
}

// TODO: userData maybe
public let dispatcherFunction: wl_dispatcher_func_t = { _, target, opcode, _, args in
    guard
        let target = OpaquePointer(target),
        let userData = wl_proxy_get_user_data(target),
        let proxy =
            Unmanaged<AnyObject>.fromOpaque(userData).takeUnretainedValue()
            as? (any Proxy)
    else {
        return -1
    }

    let ok = proxy.dispatch(opcode: opcode, args: args!)
    return if ok { 0 } else { -1 }
}

extension Proxy {
    fileprivate func dispatch(opcode: UInt32, args: UnsafePointer<wl_argument>) -> Bool {
        do {
            var reader = CArgumentReader(args, parent: self)
            let event = try Self.Event(from: &reader, opcode: opcode)
            self.onEvent?(event)
            if event.isDestructor {
                self.connection.destroy(self)
            }
            return true
        } catch {
            print(error)
            return false
        }
    }
}
