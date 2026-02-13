import Foundation
import SwiftWayland

public final class ZxdgShellV6: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_shell_v6"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func createPositioner() throws(WaylandProxyError)  -> ZxdgPositionerV6 {
        let id = connection.createProxy(type: ZxdgPositionerV6.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getXdgSurface(surface: WlSurface) throws(WaylandProxyError)  -> ZxdgSurfaceV6 {
        let id = connection.createProxy(type: ZxdgSurfaceV6.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    public func pong(serial: UInt32) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
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
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.ping(serial: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
