import Foundation
import WaylandClient

let connection = Connection()
let w = Window(connection: connection)
do {
    try w.start()
} catch {
    print("Error: \(error)")
    exit(1)
}
connection.flush()

let source = connection.makeReadSource()
source.setEventHandler {
    if connection.prepareRead() {
        connection.readEvents()
    }
    connection.dispatchPending()
    connection.flush()
}
source.resume()

RunLoop.main.run()
