import CWayland
import Foundation
import SwiftWaylandCommon

public class Connection {
    let runtimeInfo: CRuntimeInfo
    // let display: WlDisplay
    let rawDisplay: OpaquePointer
    public private(set) var mainQueue: EventQueue  // its actually SystemEventQueue
    var knownProxies: [UInt32: any Proxy] = [:]
    var knownQueues: [EventQueue] = []  // TODO: queue

    public private(set) lazy var display: WlDisplay = WlDisplay(
        id: 1, version: 1, queue: mainQueue, raw: rawDisplay, connection: self)

    public init(runtimeInfo: CRuntimeInfo, rawDisplay: OpaquePointer) {
        self.runtimeInfo = runtimeInfo
        self.rawDisplay = rawDisplay
        self.mainQueue = EventQueue(raw: wl_proxy_get_queue(rawDisplay))
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
        self.init(runtimeInfo: CRuntimeInfo.shared, rawDisplay: wl_display_connect(nil))
    }

    public func createQueue() {

    }

    public func send(
        _ proxy: any Proxy,
        _ opcode: UInt32,
        _ args: [Arg],
    ) {
        var arguments: [wl_argument] = []
        for arg in args {
            switch arg {
            case .int(let i):
                arguments.append(wl_argument(i: i))
            case .enum(let u):
                arguments.append(wl_argument(u: u))
            case .array(let data):
                arguments.append(wl_argument(a: data.toWlArray()))  // just why
            case .fd(let fd):
                arguments.append(wl_argument(h: fd.fileDescriptor))
            case .fixed(let d):
                arguments.append(wl_argument(f: Int32(d * 256)))
            case .uint(let u):
                arguments.append(wl_argument(u: u))
            case .string(let s):
                arguments.append(wl_argument(s: s.cString(using: .utf8)!.toBuffer().baseAddress))
            case .object(let id):
                arguments.append(wl_argument(o: knownProxies[id]!.raw))  // fuckkkkkkkkk
            // if we have a newId, create it, then make it a .object instead, we create an object before calling send anyway, sooo sammeeee
            case .newId(let id):
                arguments.append(wl_argument(o: knownProxies[id]!.raw))
            }
        }
        wl_proxy_marshal_array(proxy.raw, opcode, &arguments)
    }

    public func sendConstructor<T: Proxy>(
        _ proxy: any Proxy,
        _ opcode: UInt32,
        _ args: [Arg],
        version: UInt32,
        interface: T.Type,
        queue: EventQueue? = nil,
    ) -> T {
        var arguments: [wl_argument] = []
        for arg in args {
            switch arg {
            case .int(let i):
                arguments.append(wl_argument(i: i))
            case .enum(let u):
                arguments.append(wl_argument(u: u))
            case .array(let data):
                arguments.append(wl_argument(a: data.toWlArray()))  // just why
            case .fd(let fd):
                arguments.append(wl_argument(h: fd.fileDescriptor))
            case .fixed(let d):
                arguments.append(wl_argument(f: Int32(d * 256)))
            case .uint(let u):
                arguments.append(wl_argument(u: u))
            case .string(let s):
                arguments.append(wl_argument(s: s.cString(using: .utf8)!.toBuffer().baseAddress))
            case .object(let id):
                arguments.append(wl_argument(o: knownProxies[id]!.raw))  // fuckkkkkkkkk
            case .newId(_):
                arguments.append(wl_argument(n: 0))
            }
        }

        (T.self as? BaseProxy.Type)?.ensureLoaded()
        let interface = runtimeInfo.interfaces[interface.interface.name]!

        let ptr = wl_proxy_marshal_array_constructor_versioned(
            proxy.raw, opcode, &arguments, interface, version)
        return createObj(type: T.self, ptr: ptr!, queue: queue ?? mainQueue)
    }

    public func createProxy<T>(
        type: T.Type,
        version: UInt32,
        queue: EventQueue,
        parent: (any Proxy)? = nil,
    ) -> T where T: Proxy {
        let wrapper = OpaquePointer(
            wl_proxy_create_wrapper(UnsafeMutableRawPointer(parent?.raw ?? rawDisplay)))
        wl_proxy_set_queue(wrapper, queue.raw)

        (T.self as? BaseProxy.Type)?.ensureLoaded()

        let ptr = wl_proxy_create(rawDisplay, runtimeInfo.interfaces[type.interface.name]!)

        return createObj(type: type, ptr: ptr!, queue: queue)
    }

    private func createObj<T: Proxy>(type: T.Type, ptr: OpaquePointer, queue: EventQueue) -> T {
        let obj = T(
            id: wl_proxy_get_id(ptr), version: wl_proxy_get_version(ptr), queue: queue, raw: ptr,
            connection: self)

        wl_proxy_add_dispatcher(ptr, dispatchFn, nil, Unmanaged.passUnretained(obj).toOpaque())
        knownProxies[obj.id] = obj
        return obj
    }

    func destroy(proxy: some Proxy) {
        (proxy as? BaseProxy)?.markDead()
        knownProxies[proxy.id] = nil
        wl_proxy_destroy(proxy.raw)
    }

    public func flush() throws {
        wl_display_flush(rawDisplay)
    }

    public func dispatchPending() throws {
        wl_display_dispatch_pending(rawDisplay)
    }

    public func dispatch() throws {
        wl_display_dispatch(rawDisplay)
    }

    public func roundtrip() throws {
        wl_display_roundtrip(rawDisplay)
    }

    deinit {
        // print("Connection dropped with live proxies \(knownProxies)")
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

    fileprivate func toWlArray() -> UnsafeMutablePointer<wl_array> {
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
