import CWayland
import Foundation
import SwiftWaylandCommon

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
            let event = try Self.Event.init(from: CArgumentReader(args), opcode: opcode)
            self.onEvent?(event)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
