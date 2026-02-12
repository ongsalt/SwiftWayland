import Foundation
import SwiftWayland

public final class ZxdgShellV6: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func createPositioner() -> ZxdgPositionerV6 {
        let id = connection.createProxy(type: ZxdgPositionerV6.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func getXdgSurface(surface: WlSurface) -> ZxdgSurfaceV6 {
        let id = connection.createProxy(type: ZxdgSurfaceV6.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func pong(serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case role = 0
        case defunctSurfaces = 1
        case notTheTopmostPopup = 2
        case invalidPopupParent = 3
        case invalidSurfaceState = 4
        case invalidPositioner = 5
    }
    
    public enum Event: WlEventEnum {
        case ping(serial: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.ping(serial: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
