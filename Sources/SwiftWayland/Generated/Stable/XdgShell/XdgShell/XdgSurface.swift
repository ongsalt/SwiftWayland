import Foundation

public final class XdgSurface: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_surface"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func getToplevel() -> XdgToplevel {
        let id = connection.createProxy(type: XdgToplevel.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getPopup(parent: XdgSurface, positioner: XdgPositioner) -> XdgPopup {
        let id = connection.createProxy(type: XdgPopup.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id),
            .object(parent),
            .object(positioner)
        ])
        connection.send(message: message)
        return id
    }
    
    public func setWindowGeometry(x: Int32, y: Int32, width: Int32, height: Int32) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func ackConfigure(serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .uint(serial)
        ])
        connection.send(message: message)
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
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
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
