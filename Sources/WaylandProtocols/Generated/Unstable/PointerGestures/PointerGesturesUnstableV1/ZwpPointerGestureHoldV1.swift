import Foundation
import SwiftWayland

public final class ZwpPointerGestureHoldV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_pointer_gesture_hold_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)
        case end(serial: UInt32, time: UInt32, cancelled: Int32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.begin(serial: r.readUInt(), time: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, fingers: r.readUInt())
            case 1:
                return Self.end(serial: r.readUInt(), time: r.readUInt(), cancelled: r.readInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
