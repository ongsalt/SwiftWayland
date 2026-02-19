import CWayland
import Foundation
import SwiftWaylandBackend
import SwiftWaylandCommon

@main
public struct Playground {
    public static func main() {
        let interfaces = CRuntimeInfo.shared.add(protocol: coreProtocol)
        dump(coreProtocol)
        // let displayInterface = interfaces[0]
        // let registryInterface = interfaces[1]

        let d = CRuntimeInfo.shared.interfaces["wl_registry"]
        print(d?.pointee)

        let display = wl_display_connect(nil)
        // let registry = wl_display_get_registry(display)
        var i = wl_registry_interface
        let registry = wl_proxy_create(display, &i)
        // let registry = wl_proxy_create(display, d)
        // wl_proxy_marshal_array(display, 1, nil)
        // let id = wl_proxy_get_id(registry)
        // print(id)

        print("registry = \(registry)")

        let r: Registry = Registry()
        let unm = Unmanaged.passRetained(r).toOpaque()
        print("unm = \(unm)")

        var arg = wl_argument(o: registry)
        wl_proxy_marshal_array(display!, 1, &arg)


        print("arg = \(arg.n)")

        let msg: Box<String> = Box("ksdjfhuydsgifu")
        let ptr = Unmanaged.passRetained(msg).toOpaque()

        wl_proxy_add_dispatcher(registry!, dispatchFn, nil, unm)


        print("Roundtripping...")
        wl_display_roundtrip(display)
    }
}
