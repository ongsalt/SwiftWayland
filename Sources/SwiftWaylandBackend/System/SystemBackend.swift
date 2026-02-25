import CWayland
import Foundation
import SwiftWaylandCommon

public class SystemBackend: Backend {
    public typealias ObjectId = LibWaylandProxyInfo
    public typealias Queue = SystemEventQueue

    let runtimeInfo: CRuntimeInfo
    // let display: WlDisplay
    let rawDisplay: OpaquePointer
    public private(set) var mainQueue: SystemEventQueue  // its actually SystemEventQueue

    var knownProxies: [UInt32: any Proxy] = [:]
    var knownQueues: [SystemEventQueue] = [] // TODO: queue

    init(runtimeInfo: CRuntimeInfo, rawDisplay: OpaquePointer) {
        self.runtimeInfo = runtimeInfo
        self.rawDisplay = rawDisplay
        self.mainQueue = SystemEventQueue()
        knownQueues.append(mainQueue)
    }

    convenience init() {
        self.init(runtimeInfo: CRuntimeInfo.shared, rawDisplay: wl_display_connect(nil))
    }

    public func send(
        _ objectId: ObjectId,
        _ opcode: UInt32,
        _ args: [Arg],
        queue: Queue?
    ) {
        // TODO: handle queue
        let arguments = UnsafeMutableBufferPointer<wl_argument>.allocate(capacity: args.count)
        for (index, arg) in args.enumerated() {
            arguments[index] =
                switch arg {
                case .int(let i): wl_argument(i: i)
                case .enum(let u): wl_argument(u: u)
                case .array(let data): wl_argument(a: data.toWlArray())  // just why
                case .fd(let fd): wl_argument(h: fd.fileDescriptor)
                case .fixed(let d): wl_argument(f: Int32(d * 256))
                case .uint(let u): wl_argument(u: u)
                case .string(let s): wl_argument(s: s.cString(using: .utf8)!.toBuffer().baseAddress)
                case .object(let id):
                    wl_argument(o: (knownProxies[id.actualId]?.raw as! LibWaylandProxyInfo).ptr)  // fuckkkkkkkkk
                // if we have a newId, create it, then make it a .object instead, we create an object before calling send anyway, sooo sammeeee
                case .newId(let id):
                    wl_argument(o: (knownProxies[id]?.raw as! LibWaylandProxyInfo).ptr)
                }
        }

        wl_proxy_marshal_array(objectId.ptr, opcode, arguments.baseAddress)
    }

    public func createProxy<T>(
        type: T.Type,
        version: UInt32,
        parent: some Proxy,
        queue: Queue
    ) -> T where T: Proxy {
        let ptr = wl_proxy_create(rawDisplay, runtimeInfo.interfaces[type.interface.name]!)
        let info = LibWaylandProxyInfo(ptr: ptr!, backend: self, queue: queue)
        let obj = T(raw: info)

        wl_proxy_add_dispatcher(ptr, dispatchFn, nil, Unmanaged.passUnretained(obj).toOpaque())

        // put this into known list???
        knownProxies[info.id] = obj
        return obj
    }

    func destroy(proxy: some Proxy) {
        let raw = proxy.raw as! LibWaylandProxyInfo
        raw.isAlive = false
        guard let info = proxy.raw as? LibWaylandProxyInfo else {
            fatalError("\(proxy) is not managed by this backend (\(Self.self))")
        }
        wl_proxy_destroy(info.ptr)
    }

    let _queue = DispatchQueue(label: "lt.ongsa.SwiftWayland.libwayland-client-backend")

    // TODO: proper async
    public func flush() async throws {
        wl_display_flush(self.rawDisplay)
        // wl_display_dispatch_queue_pending(OpaquePointer!, OpaquePointer!)
    }

    public func dispatch() async throws {
        wl_display_dispatch_pending(rawDisplay)
    }

    public func roundtrip() async throws {
        wl_display_roundtrip(self.rawDisplay)
    }
}

public final class LibWaylandProxyInfo: RawProxy, ObjectIdProtocol {
    public let ptr: OpaquePointer
    public let backend: SystemBackend
    public var id: UInt32 {
        wl_proxy_get_id(ptr)
    }
    public var actualId: UInt32 {
        id
    }
    public var queue: SystemEventQueue

    // TODO: lifetime
    public fileprivate(set) var isAlive: Bool = true

    public var version: UInt32 {
        wl_proxy_get_version(ptr)
    }

    public init(ptr: OpaquePointer, backend: SystemBackend, queue: SystemEventQueue) {
        self.ptr = ptr
        self.backend = backend
        self.queue = queue
    }

    static func == (lhs: LibWaylandProxyInfo, rhs: LibWaylandProxyInfo) -> Bool {
        return lhs.ptr == rhs.ptr
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
