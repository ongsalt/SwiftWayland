import Foundation
import SwiftWayland

public final class ZxdgSurfaceV6: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_surface_v6"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func getToplevel() -> ZxdgToplevelV6 {
        let id = connection.createProxy(type: ZxdgToplevelV6.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getPopup(parent: ZxdgSurfaceV6, positioner: ZxdgPositionerV6) -> ZxdgPopupV6 {
        let id = connection.createProxy(type: ZxdgPopupV6.self)
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
