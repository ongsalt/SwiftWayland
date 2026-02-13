import Foundation

public final class XdgToplevel: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setParent(parent: XdgToplevel) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(parent)
        ])
        connection.send(message: message)
    }
    
    public func setTitle(title: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.string(title)
        ])
        connection.send(message: message)
    }
    
    public func setAppId(appId: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.string(appId)
        ])
        connection.send(message: message)
    }
    
    public func showWindowMenu(seat: WlSeat, serial: UInt32, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial),
            WaylandData.int(x),
            WaylandData.int(y)
        ])
        connection.send(message: message)
    }
    
    public func move(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    public func resize(seat: WlSeat, serial: UInt32, edges: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial),
            WaylandData.uint(edges)
        ])
        connection.send(message: message)
    }
    
    public func setMaxSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    public func setMinSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    public func setMaximized() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 9, contents: [])
        connection.send(message: message)
    }
    
    public func unsetMaximized() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 10, contents: [])
        connection.send(message: message)
    }
    
    public func setFullscreen(output: WlOutput) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 11, contents: [
            WaylandData.object(output)
        ])
        connection.send(message: message)
    }
    
    public func unsetFullscreen() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 12, contents: [])
        connection.send(message: message)
    }
    
    public func setMinimized() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 13, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidResizeEdge = 0
        case invalidParent = 1
        case invalidSize = 2
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
        case tiledLeft = 5
        case tiledRight = 6
        case tiledTop = 7
        case tiledBottom = 8
        case suspended = 9
        case constrainedLeft = 10
        case constrainedRight = 11
        case constrainedTop = 12
        case constrainedBottom = 13
    }
    
    public enum WmCapabilities: UInt32, WlEnum {
        case windowMenu = 1
        case maximize = 2
        case fullscreen = 3
        case minimize = 4
    }
    
    public enum Event: WlEventEnum {
        case configure(width: Int32, height: Int32, states: Data)
        case close
        case configureBounds(width: Int32, height: Int32)
        case wmCapabilities(capabilities: Data)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(width: r.readInt(), height: r.readInt(), states: r.readArray())
            case 1:
                return Self.close
            case 2:
                return Self.configureBounds(width: r.readInt(), height: r.readInt())
            case 3:
                return Self.wmCapabilities(capabilities: r.readArray())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
