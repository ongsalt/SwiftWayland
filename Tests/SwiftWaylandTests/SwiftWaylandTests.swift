import Testing

@testable import SwiftWayland

// TODO: parsing test
// TODO: it must at least run

@Test func `It must at least run`() async throws {
    let connection = try! Connection.fromEnv()

    let display = connection.display!
    let registry = try display.getRegistry()

    await confirmation { confirm in
        registry.onEvent = { event in
            switch event {
            case .global(_, let interface, _) where interface == WlDisplay.name:
                confirm()
            default:
                break
            }

        }

        try! connection.roundtrip()
        try! connection.roundtrip()
    }

}
