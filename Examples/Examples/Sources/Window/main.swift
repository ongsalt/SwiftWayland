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
        connection.roundtrip()
    }
}

RunLoop.main.run()
