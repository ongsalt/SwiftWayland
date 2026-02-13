import Foundation
import SwiftWayland

public final class ZwpConfinedPointerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_confined_pointer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setRegion(region: WlRegion) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(region)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case confined
        case unconfined
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.confined
            case 1:
                return Self.unconfined
            default:
                fatalError("Unknown message")
            }
        }
    }
}
