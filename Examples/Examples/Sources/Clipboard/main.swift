import WaylandClient
import Foundation

let connection = Connection()
let test = ClipboardTest(connection: connection)
do {
    try test.start()
} catch {
    print("Error: \(error)")
    exit(1)
}

while true {
    connection.dispatch()
}
