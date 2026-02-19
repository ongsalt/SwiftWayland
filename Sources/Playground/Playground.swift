import CWayland
import Foundation
import SwiftWaylandCommon
import SwiftWaylandBackend

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
        // wl_proxy_marshal_array(display, 1, nil)

        var arg = wl_argument()
        let registry = wl_proxy_marshal_array_flags(display!, 1, d, 1, 0, &arg)

        print("arg = \(arg.n)")

        let msg: Box<String> = Box("ksdjfhuydsgifu")
        let ptr = Unmanaged.passRetained(msg).toOpaque()

        wl_proxy_add_dispatcher(registry!, dispatchFn, ptr, nil)

        print("Roundtripping...")
        wl_display_roundtrip(display)
    }
}
