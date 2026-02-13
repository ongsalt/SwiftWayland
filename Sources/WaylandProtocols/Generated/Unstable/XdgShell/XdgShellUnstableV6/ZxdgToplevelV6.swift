import Foundation
import SwiftWayland

public final class ZxdgToplevelV6: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_toplevel_v6"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setParent(parent: ZxdgToplevelV6) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(parent)
        ])
        connection.queueSend(message: message)
    }
    
    public func setTitle(title: String) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .string(title)
        ])
        connection.queueSend(message: message)
    }
    
    public func setAppId(appId: String) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .string(appId)
        ])
        connection.queueSend(message: message)
    }
    
    public func showWindowMenu(seat: WlSeat, serial: UInt32, x: Int32, y: Int32) {
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .object(seat),
            .uint(serial),
            .int(x),
            .int(y)
        ])
        connection.queueSend(message: message)
    }
    
    public func move(seat: WlSeat, serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 5, contents: [
            .object(seat),
            .uint(serial)
        ])
        connection.queueSend(message: message)
    }
    
    public func resize(seat: WlSeat, serial: UInt32, edges: UInt32) {
        let message = Message(objectId: self.id, opcode: 6, contents: [
            .object(seat),
            .uint(serial),
            .uint(edges)
        ])
        connection.queueSend(message: message)
    }
    
    public func setMaxSize(width: Int32, height: Int32) {
        let message = Message(objectId: self.id, opcode: 7, contents: [
            .int(width),
            .int(height)
        ])
        connection.queueSend(message: message)
    }
    
    public func setMinSize(width: Int32, height: Int32) {
        let message = Message(objectId: self.id, opcode: 8, contents: [
            .int(width),
            .int(height)
        ])
        connection.queueSend(message: message)
    }
    
    public func setMaximized() {
        let message = Message(objectId: self.id, opcode: 9, contents: [])
        connection.queueSend(message: message)
    }
    
    public func unsetMaximized() {
        let message = Message(objectId: self.id, opcode: 10, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setFullscreen(output: WlOutput) {
        let message = Message(objectId: self.id, opcode: 11, contents: [
            .object(output)
        ])
        connection.queueSend(message: message)
    }
    
    public func unsetFullscreen() {
        let message = Message(objectId: self.id, opcode: 12, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setMinimized() {
        let message = Message(objectId: self.id, opcode: 13, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum ResizeEdge: UInt32, WlEnum {
        case `none` = 0
        case top = 1
        case bottom = 2
        case `left` = 4
        case topLeft = 5
        case bottomLeft = 6
        case `right` = 8
        case topRight = 9
        case bottomRight = 10
    }
    
    public enum State: UInt32, WlEnum {
        case maximized = 1
        case fullscreen = 2
        case resizing = 3
        case activated = 4
    }
    
    public enum Event: WlEventEnum {
        case configure(width: Int32, height: Int32, states: Data)
        case close
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
            switch message.opcode {
            case 0:
                return Self.configure(width: r.readInt(), height: r.readInt(), states: r.readArray())
            case 1:
                return Self.close
            default:
                fatalError("Unknown message")
            }
        }
    }
}
