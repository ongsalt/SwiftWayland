import Foundation
import SwiftWayland

public final class ZwpInputTimestampsV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_timestamps_v1"
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
        case timestamp(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.timestamp(tvSecHi: r.readUInt(), tvSecLo: r.readUInt(), tvNsec: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
