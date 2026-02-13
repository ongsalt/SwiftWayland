import Foundation

public final class ZwpTabletSeatV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_seat_v2"
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
        case tabletAdded(id: ZwpTabletV2)
        case toolAdded(id: ZwpTabletToolV2)
        case padAdded(id: ZwpTabletPadV2)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.tabletAdded(id: connection.createProxy(type: ZwpTabletV2.self, id: r.readNewId()))
            case 1:
                return Self.toolAdded(id: connection.createProxy(type: ZwpTabletToolV2.self, id: r.readNewId()))
            case 2:
                return Self.padAdded(id: connection.createProxy(type: ZwpTabletPadV2.self, id: r.readNewId()))
            default:
                fatalError("Unknown message")
            }
        }
    }
}
