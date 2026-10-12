import Testing
import Foundation
@testable import WaylandClient
import WaylandClientProtocols

@Test(.enabled(if: ProcessInfo.processInfo.environment["WAYLAND_DISPLAY"] != nil))
func `It must at least run`() throws {
    let connection = Connection()
    let globals = try Globals(connection: connection, roundtrip: true)
    #expect(!globals.globals.isEmpty)
}
