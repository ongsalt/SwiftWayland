import Foundation

public final class ZwpTabletV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_v2"
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
    
    public enum Bustype: UInt32, WlEnum {
        case usb = 3
        case bluetooth = 5
        case virtual = 6
        case serial = 17
        case i2c = 24
    }
    
    public enum Event: WlEventEnum {
        case name(name: String)
        case id(vid: UInt32, pid: UInt32)
        case path(path: String)
        case done
        case removed
        case bustype(bustype: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.name(name: r.readString())
            case 1:
                return Self.id(vid: r.readUInt(), pid: r.readUInt())
            case 2:
                return Self.path(path: r.readString())
            case 3:
                return Self.done
            case 4:
                return Self.removed
            case 5:
                return Self.bustype(bustype: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
