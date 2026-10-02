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

let source = connection.attach()

RunLoop.main.run()
