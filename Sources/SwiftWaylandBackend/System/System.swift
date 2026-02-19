import CWayland
import Foundation
import SwiftWaylandCommon

public let dispatchFn: wl_dispatcher_func_t = { _, target, opcode, _, args in
    // get the instance first
    let proxy =
        Unmanaged<AnyObject>.fromOpaque(
            wl_proxy_get_user_data(OpaquePointer(target!))
        ).takeUnretainedValue() as! any Proxy

    proxy.dispatch(opcode: opcode, args: args!)

    return 0  // or -1 on failure
}

// When create we gonnae wl_proxy_set_user_data and point to RawProxy

extension Proxy {
    func dispatch(opcode: UInt32, args: UnsafePointer<wl_argument>) {
        do {
            let event = try Self.Event.init(from: CArgumentReader(args), opcode: opcode)
            self.onEvent?(event)
        } catch {
            print(error)
        }
    }
}

class CArgumentReader: ArgumentReader {
    var current: UnsafePointer<wl_argument>
    init(_ args: UnsafePointer<wl_argument>) {
        self.current = args
    }

    private func consume() -> wl_argument {
        let value = self.current.pointee
        self.current = self.current.advanced(by: 1)
        return value
    }

    func int() -> Int32 {
        consume().i
    }

    func uint() -> UInt32 {
        consume().u
    }

    func fd() -> FileHandle {
        FileHandle(fileDescriptor: consume().h)
    }

    func array() -> Data {
        let array = consume().a!

        return Data(
            bytesNoCopy: array.pointee.data,
            count: array.pointee.size,
            deallocator: .custom { _, _ in wl_array_release(array) }
        )
    }

    func string() -> String {
        String(cString: consume().s)
    }

    func object() -> any Proxy {
        Unmanaged<AnyObject>.fromOpaque(
            wl_proxy_get_user_data(consume().o!)
        ).takeUnretainedValue() as! any Proxy
    }

    func object<P>(type: P.Type) -> P where P: Proxy {
        object() as! P
    }

    func newId<P>(type t: P.Type) -> P where P: Proxy {
        // managed by libwayland-client ???
        object(type: t)
    }
}
