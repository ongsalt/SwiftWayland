import Foundation

public final class ZwpTabletPadGroupV2: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Event: WlEventEnum {
        case buttons(buttons: Data)
        case ring(ring: ZwpTabletPadRingV2)
        case strip(strip: ZwpTabletPadStripV2)
        case modes(modes: UInt32)
        case done
        case modeSwitch(time: UInt32, serial: UInt32, mode: UInt32)
        case dial(dial: ZwpTabletPadDialV2)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.buttons(buttons: r.readArray())
            case 1:
                return Self.ring(ring: connection.createProxy(type: ZwpTabletPadRingV2.self, id: r.readNewId()))
            case 2:
                return Self.strip(strip: connection.createProxy(type: ZwpTabletPadStripV2.self, id: r.readNewId()))
            case 3:
                return Self.modes(modes: r.readUInt())
            case 4:
                return Self.done
            case 5:
                return Self.modeSwitch(time: r.readUInt(), serial: r.readUInt(), mode: r.readUInt())
            case 6:
                return Self.dial(dial: connection.createProxy(type: ZwpTabletPadDialV2.self, id: r.readNewId()))
            default:
                fatalError("Unknown message")
            }
        }
    }
}
