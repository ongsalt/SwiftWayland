import Foundation

public final class ZwpTabletPadStripV2: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_tablet_pad_strip_v2"
    public var onEvent: (Event) -> Void = { _ in }

    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
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
    
    public enum Source: UInt32, WlEnum {
        case finger = 1
    }
    
    public enum Event: WlEventEnum {
        case source(source: UInt32)
        case position(position: UInt32)
        case stop
        case frame(time: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.source(source: r.readUInt())
            case 1:
                return Self.position(position: r.readUInt())
            case 2:
                return Self.stop
            case 3:
                return Self.frame(time: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
