import Foundation
import SwiftWayland

public final class WpDrmLeaseDeviceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_drm_lease_device_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func createLeaseRequest() throws(WaylandProxyError)  -> WpDrmLeaseRequestV1 {
        let id = connection.createProxy(type: WpDrmLeaseRequestV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func release() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    public enum Event: WlEventEnum {
        case drmFd(fd: FileHandle)
        case connector(id: WpDrmLeaseConnectorV1)
        case done
        case released
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.drmFd(fd: r.readFd())
            case 1:
                return Self.connector(id: connection.createProxy(type: WpDrmLeaseConnectorV1.self, id: r.readNewId()))
            case 2:
                return Self.done
            case 3:
                return Self.released
            default:
                fatalError("Unknown message")
            }
        }
    }
}
