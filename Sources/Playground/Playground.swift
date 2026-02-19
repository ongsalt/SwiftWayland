import CWayland
import Foundation
import SwiftWaylandBackend
import SwiftWaylandCommon

@main
public struct Playground {
    public static func main() {
        let interfaces = CRuntimeInfo.shared.add(protocol: coreProtocol)
        // let displayInterface = interfaces[0]
        // let registryInterface = interfaces[1]

        let d = CRuntimeInfo.shared.interfaces["wl_registry"]

        let display = wl_display_connect(nil)
        // let registry = wl_display_get_registry(display)
        var i = wl_registry_interface
        let registry = wl_proxy_create(display, &i)
        // let registry = wl_proxy_create(display, d)
        // wl_proxy_marshal_array(display, 1, nil)
        // let id = wl_proxy_get_id(registry)
        // print(id)


        let r: Registry = Registry(raw: LibWaylandProxyInfo(ptr: registry!))
        let unm = Unmanaged.passRetained(r).toOpaque() // this must not be in the protocol side
        r.onEvent = { event in
            print(event)
        }

        var arg = wl_argument(o: registry)
        wl_proxy_marshal_array(display!, 1, &arg)

        wl_proxy_add_dispatcher(registry!, dispatchFn, nil, unm)

        print("Roundtripping...")
        wl_display_roundtrip(display)
    }
}
