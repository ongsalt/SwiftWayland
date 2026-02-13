import Foundation
import SwiftWayland

public final class ZxdgPopupV6: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_popup_v6"
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
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidGrab = 0
    }
    
    public enum Event: WlEventEnum {
        case configure(x: Int32, y: Int32, width: Int32, height: Int32)
        case popupDone
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(x: r.readInt(), y: r.readInt(), width: r.readInt(), height: r.readInt())
            case 1:
                return Self.popupDone
            default:
                fatalError("Unknown message")
            }
        }
    }
}
