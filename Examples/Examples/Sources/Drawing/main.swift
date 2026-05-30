import Foundation
import SwiftWayland
import WaylandProtocols

Task {
    let connection = Connection()
    let w = DrawingWindow(connection: connection)
    do {
        try w.start()
    } catch {
        print("Error: \(error)")
    }

    while !Task.isCancelled {
        try await Task.sleep(for: .microseconds(16))
        connection.roundtrip()
        try w.commitIfNeeded()
    }
}

RunLoop.main.run()
