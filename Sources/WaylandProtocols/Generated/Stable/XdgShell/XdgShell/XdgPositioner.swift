import Foundation

public final class XdgPositioner: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_positioner"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setSize(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    public func setAnchorRect(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    public func setAnchor(anchor: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.uint(anchor)
        ])
        connection.send(message: message)
    }
    
    public func setGravity(gravity: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            WaylandData.uint(gravity)
        ])
        connection.send(message: message)
    }
    
    public func setConstraintAdjustment(constraintAdjustment: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            WaylandData.uint(constraintAdjustment)
        ])
        connection.send(message: message)
    }
    
    public func setOffset(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [
            WaylandData.int(x),
            WaylandData.int(y)
        ])
        connection.send(message: message)
    }
    
    public func setReactive() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 7, contents: [])
        connection.send(message: message)
    }
    
    public func setParentSize(parentWidth: Int32, parentHeight: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            WaylandData.int(parentWidth),
            WaylandData.int(parentHeight)
        ])
        connection.send(message: message)
    }
    
    public func setParentConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 9, contents: [
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidInput = 0
    }
    
    public enum Anchor: UInt32, WlEnum {
        case `none` = 0
        case top = 1
        case bottom = 2
        case `left` = 3
        case `right` = 4
        case topLeft = 5
        case bottomLeft = 6
        case topRight = 7
        case bottomRight = 8
    }
    
    public enum Gravity: UInt32, WlEnum {
        case `none` = 0
        case top = 1
        case bottom = 2
        case `left` = 3
        case `right` = 4
        case topLeft = 5
        case bottomLeft = 6
        case topRight = 7
        case bottomRight = 8
    }
    
    public enum ConstraintAdjustment: UInt32, WlEnum {
        case `none` = 0
        case slideX = 1
        case slideY = 2
        case flipX = 4
        case flipY = 8
        case resizeX = 16
        case resizeY = 32
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
