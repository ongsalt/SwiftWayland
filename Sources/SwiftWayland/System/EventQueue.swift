import SwiftWaylandCommon

public class EventQueue {
    var raw: OpaquePointer

    init(raw: OpaquePointer) {
        self.raw = raw
    }
}