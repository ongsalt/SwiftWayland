import Foundation
import CWayland

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
