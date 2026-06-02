import Foundation
import SwiftWayland
import WaylandProtocols

let connection = Connection()
let w = HexGridWindow(connection: connection)
do {
    try w.start()
} catch {
    print("Error: \(error)")
    exit(1)
}

let handle = connection.attach()

Task {
    while true {
        try await Task.sleep(for: .seconds(1))
        print("hi")
    }
}

RunLoop.main.run()
