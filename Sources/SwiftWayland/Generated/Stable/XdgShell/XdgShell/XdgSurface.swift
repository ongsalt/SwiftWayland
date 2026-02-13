import Foundation

public final class XdgSurface: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_surface"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getToplevel() throws(WaylandProxyError) -> XdgToplevel {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgToplevel.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getPopup(parent: XdgSurface, positioner: XdgPositioner) throws(WaylandProxyError) -> XdgPopup {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgPopup.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .object(parent),
            .object(positioner)
        ])
        connection.send(message: message)
        return id
    }
    
    public func setWindowGeometry(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case notConstructed = 1
        case alreadyConstructed = 2
        case unconfiguredBuffer = 3
        case invalidSerial = 4
        case invalidSize = 5
        case defunctRoleObject = 6
    }
    
    public enum Event: WlEventEnum {
        case configure(serial: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(serial: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
