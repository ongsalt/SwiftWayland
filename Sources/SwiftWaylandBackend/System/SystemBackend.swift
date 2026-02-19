import CWayland
import Foundation
import SwiftWaylandCommon

class SystemBackend: Backend {
    typealias ObjectId = LibWaylandProxyInfo
    typealias EventQueue = Void

    let runtimeInfo: CRuntimeInfo
    // let display: WlDisplay
    let rawDisplay: OpaquePointer
    var mainQueue: EventQueue = ()

    var knownProxies: [UInt32: any Proxy] = [:]

    init(runtimeInfo: CRuntimeInfo, rawDisplay: OpaquePointer) {
        self.runtimeInfo = runtimeInfo
        self.rawDisplay = rawDisplay
    }

    func send(
        _ raw: ObjectId, _ opcode: UInt32, _ args: [Arg], version: UInt32, queue: EventQueue
    ) {
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
                    wl_argument(o: (knownProxies[id]?.raw as! LibWaylandProxyInfo).ptr)  // fuckkkkkkkkk
                // if we have a newId, create it, then make it a .object instead, we create an object before calling send anyway, sooo sammeeee
                case .newId(let id):
                    wl_argument(o: (knownProxies[id]?.raw as! LibWaylandProxyInfo).ptr)
                }
        }
        wl_proxy_marshal_array(raw.ptr, opcode, arguments.baseAddress)
    }

    func createProxy<T>(
        type: T.Type, version: UInt32, id: ObjectId, parent: some Proxy, queue: EventQueue
    ) -> T where T: Proxy {

        let ptr = wl_proxy_create(rawDisplay, runtimeInfo.interfaces[type.interface.name]!)
        let info = LibWaylandProxyInfo(ptr: ptr!)
        let obj = T(raw: info)

        wl_proxy_add_dispatcher(ptr, dispatchFn, nil, Unmanaged.passUnretained(obj).toOpaque())

        // put this into known list???
        // libwayland-client already does this tho
        return obj
    }

    func destroy(proxy: some Proxy) {
        guard let info = proxy.raw as? LibWaylandProxyInfo else {
            fatalError("\(proxy) is not managed by this backend (\(Self.self))")
        }
        wl_proxy_destroy(info.ptr)
    }

    let _queue = DispatchQueue(label: "lt.ongsa.SwiftWayland.libwayland-client-backend")
    // TODO: proper async
    func flush() async throws {
        wl_display_flush(self.rawDisplay)
    }

    func dispatch() async throws {
        wl_display_dispatch_pending(rawDisplay)
    }

    func roundtrip() async throws {
        wl_display_roundtrip(self.rawDisplay)
    }
}

public struct LibWaylandProxyInfo: RawProxy {
    public let ptr: OpaquePointer
    public var id: UInt32 {
        wl_proxy_get_id(ptr)
    }

    public init(ptr: OpaquePointer) {
        self.ptr = ptr
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
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
