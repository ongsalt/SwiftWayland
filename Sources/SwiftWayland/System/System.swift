import CWayland
import Foundation
import SwiftWaylandCommon

public let dispatchFn: wl_dispatcher_func_t = { user_data, target, opcode, _, args in

    // get the instance first
    let proxy =
        Unmanaged<AnyObject>.fromOpaque(
            wl_proxy_get_user_data(OpaquePointer(target))!
        ).takeUnretainedValue() as! any Proxy

    proxy.dispatch(opcode: opcode, args: args!)

    return 0  // or -1 on failure
}

// When created we gonna wl_proxy_set_user_data and point to RawProxy

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

