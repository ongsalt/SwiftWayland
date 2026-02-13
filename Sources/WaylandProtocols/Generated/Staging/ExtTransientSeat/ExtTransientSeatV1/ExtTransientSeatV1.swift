import Foundation
import SwiftWayland

public final class ExtTransientSeatV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_transient_seat_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case ready(globalName: UInt32)
        case denied
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.ready(globalName: r.readUInt())
            case 1:
                return Self.denied
            default:
                fatalError("Unknown message")
            }
        }
    }
}
