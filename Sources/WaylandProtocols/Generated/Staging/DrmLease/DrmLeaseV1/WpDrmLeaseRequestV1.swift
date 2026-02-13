import Foundation
import SwiftWayland

public final class WpDrmLeaseRequestV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_drm_lease_request_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func requestConnector(connector: WpDrmLeaseConnectorV1) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .object(connector)
        ])
        connection.queueSend(message: message)
    }
    
    public func submit() -> WpDrmLeaseV1 {
        let id = connection.createProxy(type: WpDrmLeaseV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case wrongDevice = 0
        case duplicateConnector = 1
        case emptyLease = 2
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
