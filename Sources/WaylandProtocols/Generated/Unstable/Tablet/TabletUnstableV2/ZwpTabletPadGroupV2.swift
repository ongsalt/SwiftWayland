import Foundation
import SwiftWayland

public final class ZwpTabletPadGroupV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_pad_group_v2"
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
        case buttons(buttons: Data)
        case ring(ring: ZwpTabletPadRingV2)
        case strip(strip: ZwpTabletPadStripV2)
        case modes(modes: UInt32)
        case done
        case modeSwitch(time: UInt32, serial: UInt32, mode: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.buttons(buttons: r.readArray())
            case 1:
                return Self.ring(ring: connection.createProxy(type: ZwpTabletPadRingV2.self, version: version, id: r.readNewId()))
            case 2:
                return Self.strip(strip: connection.createProxy(type: ZwpTabletPadStripV2.self, version: version, id: r.readNewId()))
            case 3:
                return Self.modes(modes: r.readUInt())
            case 4:
                return Self.done
            case 5:
                return Self.modeSwitch(time: r.readUInt(), serial: r.readUInt(), mode: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
