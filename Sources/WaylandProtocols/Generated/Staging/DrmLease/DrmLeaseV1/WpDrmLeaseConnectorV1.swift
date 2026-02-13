import Foundation
import SwiftWayland

public final class WpDrmLeaseConnectorV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_drm_lease_connector_v1"
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
        case name(name: String)
        case description(description: String)
        case connectorId(connectorId: UInt32)
        case done
        case withdrawn
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.name(name: r.readString())
            case 1:
                return Self.description(description: r.readString())
            case 2:
                return Self.connectorId(connectorId: r.readUInt())
            case 3:
                return Self.done
            case 4:
                return Self.withdrawn
            default:
                fatalError("Unknown message")
            }
        }
    }
}
