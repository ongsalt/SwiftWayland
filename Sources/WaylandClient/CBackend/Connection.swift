import CWayland
import Foundation
import SwiftWaylandCommon

public class Connection {
    let rawDisplay: OpaquePointer
    public private(set) var mainQueue: EventQueue
    var knownProxies: [UInt32: any Proxy] = [:]
    var knownQueues: [OpaquePointer: EventQueue] = [:]

    var fd: Int32 {
        wl_display_get_fd(rawDisplay)
    }

    public private(set) lazy var display: WlDisplay = WlDisplay(
        id: 1, version: 1, queue: mainQueue, raw: rawDisplay, connection: self)

    public init(rawDisplay: OpaquePointer) {
        self.rawDisplay = rawDisplay
        let rawQueue = wl_proxy_get_queue(rawDisplay)!
        self.mainQueue = EventQueue(raw: rawQueue, display: rawDisplay)
        knownQueues[rawQueue] = mainQueue
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
        _ args: borrowing [Arg],
    ) -> Output {
        let proxy = _send2(
            proxy, opcode,
            returning: interface,
            version: version,
            on: queue,
            args: args
        )!
        return self.createSwiftObject(from: proxy, type: interface)
    }

    public func send(
        _ proxy: any Proxy,
        _ opcode: UInt32,
        _ args: borrowing [Arg],
    ) {
        _ = _send2(proxy, opcode, args: args)
    }

    private func _send2(
        _ proxy: any Proxy,
        _ opcode: UInt32,
        returning interface: (any Proxy.Type)? = nil,
        version: UInt32 = 0,
        on queue: EventQueue? = nil,
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
                defered.append {
                    arr.deallocate()
                }
                arguments.append(wl_argument(a: arr))
            case .fd(let fd):
                arguments.append(wl_argument(h: fd.fileDescriptor))
            case .fixed(let d):
                arguments.append(wl_argument(f: Int32(d * 256)))
            case .uint(let u):
                arguments.append(wl_argument(u: u))
            case .string(let s):
                let buffer = s?.cString(using: .utf8)!.toBuffer()
                defered.append {
                    buffer?.deallocate()
                }
                arguments.append(wl_argument(s: buffer?.baseAddress))
            case .object(let proxy):
                arguments.append(wl_argument(o: proxy?.raw))
            case .newId:
                // gonna be ignored anyway
                arguments.append(wl_argument())
            }
        }

        var sender = proxy.raw
        // if queue was set, then create proxy to self first
        if let queue {
            sender = OpaquePointer(wl_proxy_create_wrapper(UnsafeMutableRawPointer(sender)))
            wl_proxy_set_queue(sender, queue.raw)
        }

        let interfacePtr = interface?.ensureLoaded()
        if interface != nil && interfacePtr == nil {
            fatalError("Failed to load wl_interface for \(interface?.interface.name)")
        }
        let flags: UInt32 =
            if queue != nil && queue !== self.mainQueue { UInt32(WL_MARSHAL_FLAG_DESTROY) } else {
                0
            }
        let returnValue = wl_proxy_marshal_array_flags(
            sender, opcode, interfacePtr, version, flags, &arguments)

        return returnValue
    }

    func createSwiftObject<T: Proxy>(from raw: OpaquePointer, type: T.Type) -> T {
        let instance = T(
            id: wl_proxy_get_id(raw),
            version: wl_proxy_get_version(raw),
            queue: self.knownQueues[wl_proxy_get_queue(raw)]!,
            raw: raw,
            connection: self
        )

        wl_proxy_add_dispatcher(raw, dispatchFn, nil, Unmanaged.passUnretained(instance).toOpaque())
        knownProxies[instance.id] = instance
        return instance
    }

    public func createCallback(
        fn: @escaping (UInt32) -> Void,
        queue: EventQueue?
    ) -> WlCallback {
        var rawParent = rawDisplay
        if let queue {
            rawParent = OpaquePointer(wl_proxy_create_wrapper(UnsafeMutableRawPointer(rawParent)))
            wl_proxy_set_queue(rawParent, queue.raw)
        }

        let ptr = wl_proxy_create(rawParent, WlCallback.ensureLoaded())!
        let callback = self.createSwiftObject(from: ptr, type: WlCallback.self)

        callback.onEvent = { event in
            switch event {
            case .done(let callbackData):
                fn(callbackData)
            }
        }

        if queue != nil && queue !== self.mainQueue {
            wl_proxy_destroy(rawParent)
        }

        return callback
    }

    public func createEventQueue(name: String? = nil) -> EventQueue {
        let handle =
            if let name {
                wl_display_create_queue_with_name(rawDisplay, name)
            } else {
                wl_display_create_queue(rawDisplay)
            }

        return EventQueue(raw: handle!, display: rawDisplay)
    }

    /// Actually calling wl_proxy_destroy
    public func destroy(_ proxy: any Proxy) {
        deregister(proxyId: proxy.id)
        wl_proxy_destroy(proxy.raw)
        if let p = proxy as? BaseProxy {
            p.markDead()
        }
    }

    /// Remove it from swift-side object list. and remove reference to it
    func deregister(proxyId: UInt32) {
        if let p = knownProxies[proxyId] {
            wl_proxy_set_user_data(p.raw, nil)
        }
        knownProxies[proxyId] = nil
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

extension Array {
    fileprivate consuming func toBuffer() -> UnsafeBufferPointer<Element> {
        let buffer = UnsafeMutableBufferPointer<Element>.allocate(capacity: self.count)
        _ = buffer.initialize(from: self)
        return UnsafeBufferPointer(buffer)
    }
}

// TODO: userData maybe
public let dispatchFn: wl_dispatcher_func_t = { _, target, opcode, _, args in
    guard
        let userData = wl_proxy_get_user_data(OpaquePointer(target)),
        let proxy =
            Unmanaged<AnyObject>.fromOpaque(userData).takeUnretainedValue()
            as? (any Proxy)
    else {
        print(
            "wl_proxy outlive swift object: target=\(target) userData=\(wl_proxy_get_user_data(OpaquePointer(target)))"
        )
        return -1
    }

    let ok = proxy.dispatch(opcode: opcode, args: args!)
    return if ok { 0 } else { -1 }  // or -1 on failure
}

// When created we gonna wl_proxy_set_user_data and point to RawProxy

extension Proxy {
    fileprivate func dispatch(opcode: UInt32, args: UnsafePointer<wl_argument>) -> Bool {
        do {
            var reader = CArgumentReader(args, parent: self)
            let event = try Self.Event(from: &reader, opcode: opcode)
            if event.isDestructor {
                (self as? BaseProxy)?.isAlive = false
                self.connection.deregister(proxyId: self.id)
            }
            self.onEvent?(event)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
