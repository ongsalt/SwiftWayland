import SwiftWaylandCommon

class Display {
    static let interface = Interface(
        name: "wl_display",
        version: 1,
        enums: [],
        requests: [
            Message(name: "get_registry", arguments: [])
        ],
        events: []
    )
}
