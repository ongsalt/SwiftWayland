import Foundation
import SwiftWayland

public final class ZxdgToplevelV6: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_toplevel_v6"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setParent(parent: ZxdgToplevelV6) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(parent)
        ])
        connection.send(message: message)
    }
    
    public func setTitle(title: String) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .string(title)
        ])
        connection.send(message: message)
    }
    
    public func setAppId(appId: String) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .string(appId)
        ])
        connection.send(message: message)
    }
    
    public func showWindowMenu(seat: WlSeat, serial: UInt32, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .object(seat),
            .uint(serial),
            .int(x),
            .int(y)
        ])
        connection.send(message: message)
    }
    
    public func move(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            .object(seat),
            .uint(serial)
        ])
        connection.send(message: message)
    }
    
    public func resize(seat: WlSeat, serial: UInt32, edges: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            .object(seat),
            .uint(serial),
            .uint(edges)
        ])
        connection.send(message: message)
    }
    
    public func setMaxSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func setMinSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func setMaximized() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 9, contents: [])
        connection.send(message: message)
    }
    
    public func unsetMaximized() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 10, contents: [])
        connection.send(message: message)
    }
    
    public func setFullscreen(output: WlOutput) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 11, contents: [
            .object(output)
        ])
        connection.send(message: message)
    }
    
    public func unsetFullscreen() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 12, contents: [])
        connection.send(message: message)
    }
    
    public func setMinimized() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 13, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
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
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
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
