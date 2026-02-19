import CWayland
import Foundation
import SwiftWaylandCommon

@main
public struct Playground {
    public static func main() {
        let display = wl_display_connect(nil)
        // let registry = wl_display_get_registry(display)
        // wl_proxy_marshal_array(display, 1, nil)
        let registry = wl_proxy_marshal_array_constructor(display, 1, nil, nil)

        var listener = wl_registry_listener(
            global: { _, _, name, interface, version in
                let i = String(cString: interface!)
                print("[\(name)] \(i)  \(version)")
            },
            global_remove: { _, _, _ in

            }
        )

        let msg: Box<String> = Box("ksdjfhuydsgifu")
        let ptr = Unmanaged.passRetained(msg).toOpaque()

        wl_proxy_add_dispatcher(registry!, dispatchFn, ptr, nil)
        // wl_registry_add_listener(registry, &listener, nil)

        wl_display_roundtrip(display)
    }
}

public let dispatchFn: wl_dispatcher_func_t = { _, target, opcode, _, args in
    let firstArg = args?.pointee
    print("\(firstArg!.u)")
    // let name = String(cString: msg.t)

    // TODO: versioning: https://wayland.freedesktop.org/docs/html/apb.html
    // print("\(name) - \(signature)")
    // fd pos
    // let d = Unmanaged<Box<String>>.fromOpaque((userData!))
    // print(d)

    return 0
}

