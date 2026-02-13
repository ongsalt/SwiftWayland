import Foundation
import SwiftWayland

public final class ZxdgPositionerV6: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_positioner_v6"
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
        case `left` = 4
        case `right` = 8
    }
    
    public enum Gravity: UInt32, WlEnum {
        case `none` = 0
        case top = 1
        case bottom = 2
        case `left` = 4
        case `right` = 8
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
