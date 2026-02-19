import SwiftWaylandCommon

class Display {
    static let interface = Interface(
        name: "wl_display",
        version: 1,
        enums: [],
        requests: [
            Message(
                name: "sync",
                arguments: [
                    // TODO:
                ]
            ),
            Message(
                name: "get_registry",
                arguments: [
                    Argument(name: "registry", type: .newId, interface: "wl_registry")
                ]
            ),
        ],
        events: []
    )
}

class Registry {
    static let interface = Interface(
        name: "wl_registry",
        version: 1,
        enums: [],
        requests: [],
        events: [
            Message(
                name: "global",
                arguments: [
                    Argument(name: "name", type: .uint),
                    Argument(name: "interface", type: .string),
                    Argument(name: "version", type: .uint),
                ]
            )
        ]
    )
}

let coreProtocol = Protocol(
    name: "wayland",
    interfaces: [Registry.interface, Display.interface]
)
