import Foundation
import SwiftWayland

public final class ZwpPrimarySelectionOfferV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_primary_selection_offer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func receive(mimeType: String, fd: FileHandle) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .string(mimeType),
            .fd(fd)
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
    
    public enum Event: WlEventEnum {
        case offer(mimeType: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.offer(mimeType: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
