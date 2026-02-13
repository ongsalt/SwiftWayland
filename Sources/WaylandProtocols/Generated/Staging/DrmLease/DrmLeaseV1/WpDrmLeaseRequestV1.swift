import Foundation
import SwiftWayland

public final class WpDrmLeaseRequestV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_drm_lease_request_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func requestConnector(connector: WpDrmLeaseConnectorV1) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(connector)
        ])
        connection.send(message: message)
    }
    
    public consuming func submit() throws(WaylandProxyError)  -> WpDrmLeaseV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpDrmLeaseV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case wrongDevice = 0
        case duplicateConnector = 1
        case emptyLease = 2
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
