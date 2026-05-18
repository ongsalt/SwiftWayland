import Foundation
import Glibc
import SwiftWayland
import WaylandProtocols

Task {
    let connection = Connection()
    let w = Window(connection: connection)
    do {
        try w.start()
    } catch {
        print("Error: \(error)")
    }

    while !Task.isCancelled {
        try await Task.sleep(for: .microseconds(16))
        try connection.roundtrip()
    }
}

RunLoop.main.run()

func testConnection() throws {
    let connection = Connection()

    let display = connection.display
    print(display)

    let registry = try Globals(connection: connection)
    // try display.sync { data in
    //     print("sync")
    // }
    try connection.roundtrip()

    let compositor = try registry.bind(version: 1...6, type: WlCompositor.self)
    let surface = try compositor.createSurface()
    try connection.roundtrip()

    let xdgWmBase = try registry.bind(version: 6...6, type: XdgWmBase.self)

    xdgWmBase.onEvent = {
        switch $0 {
        case .ping(let serial):
            print("ping \(serial)")
            try? xdgWmBase.pong(serial: serial)
        }
    }
    let x = try xdgWmBase.getXdgSurface(surface: surface)
    let toplevel = try x.getToplevel()
    try toplevel.setTitle(title: "hihi")
    try surface.commit()

    try connection.roundtrip()

    

    // print("[DONE]")
    // print(connection)

}
