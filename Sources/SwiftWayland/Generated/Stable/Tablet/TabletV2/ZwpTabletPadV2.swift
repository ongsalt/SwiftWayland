import Foundation

public final class ZwpTabletPadV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_pad_v2"
    public var onEvent: (Event) -> Void = { _ in }

    public func setFeedback(button: UInt32, description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(button),
            .string(description),
            .uint(serial)
        ])
        connection.send(message: message)
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum ButtonState: UInt32, WlEnum {
        case released = 0
        case pressed = 1
    }
    
    public enum Event: WlEventEnum {
        case group(padGroup: ZwpTabletPadGroupV2)
        case path(path: String)
        case buttons(buttons: UInt32)
        case done
        case button(time: UInt32, button: UInt32, state: UInt32)
        case enter(serial: UInt32, tablet: ZwpTabletV2, surface: WlSurface)
        case leave(serial: UInt32, surface: WlSurface)
        case removed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.group(padGroup: connection.createProxy(type: ZwpTabletPadGroupV2.self, id: r.readNewId()))
            case 1:
                return Self.path(path: r.readString())
            case 2:
                return Self.buttons(buttons: r.readUInt())
            case 3:
                return Self.done
            case 4:
                return Self.button(time: r.readUInt(), button: r.readUInt(), state: r.readUInt())
            case 5:
                return Self.enter(serial: r.readUInt(), tablet: connection.get(as: ZwpTabletV2.self, id: r.readObjectId())!, surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 6:
                return Self.leave(serial: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!)
            case 7:
                return Self.removed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
