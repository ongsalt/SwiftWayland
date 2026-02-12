import Foundation
import SwiftWayland

@main
@MainActor
public struct SwiftWayland {
    public static var connection: Connection! = nil

    private struct State {
        var compositor: WlCompositor?
        var shm: WlShm?
        var xdgWmBase: XdgWmBase?

        var surface: WlSurface?
        var xdgSurface: XdgSurface?
        var toplevel: XdgToplevel?
    }

    public static func main() {
        // Task { try await start() }
        try! start()
       
        RunLoop.main.run()
    }

    static func start() throws {
        connection = try Connection.fromEnv()

        let display = connection.display!
        display.onEvent = { event in
            switch event {
                case .deleteId(let id):
                    print("___---- Delete id \(id)")
                default:
                    break
            }
        }

        let registry = display.getRegistry()

        var state = State()

        registry.onEvent = { event in
            switch event {
            case .global(let name, let interface, let version):
                // print(interface)
                switch interface {
                case "wl_compositor":
                    state.compositor = registry.bind(name: name, version: version, interfaceName: "wl_compositor", type: WlCompositor.self)
                case "wl_shm":
                    state.shm = registry.bind(name: name, version: version, interfaceName: "wl_shm", type: WlShm.self)
                case "xdg_wm_base":
                    state.xdgWmBase = registry.bind(name: name, version: version, interfaceName: "xdg_wm_base", type: XdgWmBase.self)
                    state.xdgWmBase?.onEvent = { ev in
                        if case .ping(let serial) = ev {
                            state.xdgWmBase?.pong(serial: serial)
                        }
                    }
                default:
                    break
                }
            default:
                break
            }
        }

        // try await connection.flush()
        try connection.roundtrip()
        print(connection.pendingMessages)
        print(connection.proxies)

        try connection.roundtrip()


        guard
            let compositor = state.compositor,
            let xdgWmBase = state.xdgWmBase
        else {
            fatalError("Missing required globals")
        }

        let surface = compositor.createSurface()
        let xdgSurface = xdgWmBase.getXdgSurface(surface: surface)
        let toplevel = xdgSurface.getToplevel()
        toplevel.setTitle(title: "SwiftWayland")

        xdgSurface.onEvent = { ev in
            if case .configure(let serial) = ev {
                xdgSurface.ackConfigure(serial: serial)
                // TODO: attach a wl_buffer here and commit again after buffer setup
            }
        }

        state.surface = surface
        state.xdgSurface = xdgSurface
        state.toplevel = toplevel

        surface.commit()
        try connection.flush()
    }
}
