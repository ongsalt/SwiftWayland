import Foundation
import SwiftWayland
import WaylandProtocols

let connection = Connection()
let test = ClipboardTest(connection: connection)
do {
    try test.start()
} catch {
    print("Error: \(error)")
    exit(1)
}
connection.flush()

let source = connection.makeReadSource()
source.setEventHandler {
    if connection.prepareRead() { connection.readEvents() }
    connection.dispatchPending()
    connection.flush()
}
source.resume()

RunLoop.main.run()
