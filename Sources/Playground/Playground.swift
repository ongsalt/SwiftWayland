import CWayland
import Foundation
import SwiftWayland
import SwiftWaylandCommon

@main
public struct Playground {
    public static func main() {
        // let interfaces = CRuntimeInfo.shared.add(protocol: Wayland)
        // // let displayInterface = interfaces[0]
        // // let registryInterface = interfaces[1]

        // let d = CRuntimeInfo.shared.interfaces["wl_registry"]

        let display = wl_display_connect(nil)
        // let registry = wl_display_get_registry(display)
        let registry = wl_display_get_registry(display)
        // let registry = wl_proxy_create(display, d)
        // wl_proxy_marshal_array(display, 1, nil)
        // let id = wl_proxy_get_id(registry)
        // print(id)
        var wlc = wl_compositor_interface
        wl_display_roundtrip(display)

        let compositor = wl_registry_bind(registry, 1, &wlc, 6)
        wl_display_roundtrip(display)

        // var arg = wl_argument(o: registry)
        // wl_proxy_marshal_array(display!, 1, &arg)

        

        print("Roundtripping...")
    }
}

