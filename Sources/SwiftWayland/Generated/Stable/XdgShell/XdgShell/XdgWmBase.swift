import Foundation

public final class XdgWmBase: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_wm_base"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func createPositioner() throws(WaylandProxyError)  -> XdgPositioner {
        let id = connection.createProxy(type: XdgPositioner.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
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
        case unresponsive = 6
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
