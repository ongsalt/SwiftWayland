import CWayland
import Foundation

struct CArgumentReader: ArgumentReader {
    var current: UnsafePointer<wl_argument>
    let parent: any Proxy

    init(_ args: UnsafePointer<wl_argument>, parent: any Proxy) {
        self.current = args
        self.parent = parent
    }

    private mutating func consume() -> wl_argument {
        let value = self.current.pointee
        self.current = self.current.advanced(by: 1)
        return value
    }

    mutating func int() -> Int32 {
        consume().i
    }

    mutating func uint() -> UInt32 {
        consume().u
    }

    mutating func fd() -> FileHandle {
        FileHandle(fileDescriptor: consume().h)
    }

    mutating func array() -> UnsafeRawBufferPointer {
        let array = consume().a!
        return UnsafeRawBufferPointer(
            start: array.pointee.data, 
            count: array.pointee.size
        )
    }

    mutating func string() -> String {
        String(cString: consume().s)
    }

    mutating func object() -> any Proxy {
        Unmanaged<AnyObject>.fromOpaque(
            wl_proxy_get_user_data(consume().o!)
        ).takeUnretainedValue() as! any Proxy
    }

    mutating func object<P>(type: P.Type) -> P where P: Proxy {
        object() as! P
    }

    mutating func newId<P>(type: P.Type) -> P where P: Proxy {
        parent.connection.createSwiftObject(from: consume().o, type: type)
    }
}
