import Foundation
import SwiftWayland

public final class XdgShell: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_shell"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func useUnstableVersion(version: Int32) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .int(version)
        ])
        connection.send(message: message)
    }
    
    public func getXdgSurface(surface: WlSurface) throws(WaylandProxyError)  -> XdgSurface {
        let id = connection.createProxy(type: XdgSurface.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getXdgPopup(surface: WlSurface, parent: WlSurface, seat: WlSeat, serial: UInt32, x: Int32, y: Int32) throws(WaylandProxyError)  -> XdgPopup {
        let id = connection.createProxy(type: XdgPopup.self)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .newId(id.id),
            .object(surface),
            .object(parent),
            .object(seat),
            .uint(serial),
            .int(x),
            .int(y)
        ])
        connection.send(message: message)
        return id
    }
    
    public func pong(serial: UInt32) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Version: UInt32, WlEnum {
        case current = 5
    }
    
    public enum Error: UInt32, WlEnum {
        case role = 0
        case defunctSurfaces = 1
        case notTheTopmostPopup = 2
        case invalidPopupParent = 3
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
