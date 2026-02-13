import Foundation

public final class XdgPopup: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_popup"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func grab(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    public func reposition(positioner: XdgPositioner, token: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.object(positioner),
            WaylandData.uint(token)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidGrab = 0
    }
    
    public enum Event: WlEventEnum {
        case configure(x: Int32, y: Int32, width: Int32, height: Int32)
        case popupDone
        case repositioned(token: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(x: r.readInt(), y: r.readInt(), width: r.readInt(), height: r.readInt())
            case 1:
                return Self.popupDone
            case 2:
                return Self.repositioned(token: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
