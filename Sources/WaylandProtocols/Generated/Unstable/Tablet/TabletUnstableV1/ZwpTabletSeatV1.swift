import Foundation
import SwiftWayland

public final class ZwpTabletSeatV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_seat_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case tabletAdded(id: ZwpTabletV1)
        case toolAdded(id: ZwpTabletToolV1)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.tabletAdded(id: connection.createProxy(type: ZwpTabletV1.self, version: version, id: r.readNewId()))
            case 1:
                return Self.toolAdded(id: connection.createProxy(type: ZwpTabletToolV1.self, version: version, id: r.readNewId()))
            default:
                fatalError("Unknown message")
            }
        }
    }
}
