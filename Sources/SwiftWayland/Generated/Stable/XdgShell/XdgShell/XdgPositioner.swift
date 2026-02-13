import Foundation

public final class XdgPositioner: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_positioner"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setSize(width: Int32, height: Int32) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .int(width),
            .int(height)
        ])
        connection.queueSend(message: message)
    }
    
    public func setAnchorRect(x: Int32, y: Int32, width: Int32, height: Int32) {
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.queueSend(message: message)
    }
    
    public func setAnchor(anchor: UInt32) {
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .uint(anchor)
        ])
        connection.queueSend(message: message)
    }
    
    public func setGravity(gravity: UInt32) {
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .uint(gravity)
        ])
        connection.queueSend(message: message)
    }
    
    public func setConstraintAdjustment(constraintAdjustment: UInt32) {
        let message = Message(objectId: self.id, opcode: 5, contents: [
            .uint(constraintAdjustment)
        ])
        connection.queueSend(message: message)
    }
    
    public func setOffset(x: Int32, y: Int32) {
        let message = Message(objectId: self.id, opcode: 6, contents: [
            .int(x),
            .int(y)
        ])
        connection.queueSend(message: message)
    }
    
    public func setReactive() {
        let message = Message(objectId: self.id, opcode: 7, contents: [])
        connection.queueSend(message: message)
    }
    
    public func setParentSize(parentWidth: Int32, parentHeight: Int32) {
        let message = Message(objectId: self.id, opcode: 8, contents: [
            .int(parentWidth),
            .int(parentHeight)
        ])
        connection.queueSend(message: message)
    }
    
    public func setParentConfigure(serial: UInt32) {
        let message = Message(objectId: self.id, opcode: 9, contents: [
            .uint(serial)
        ])
        connection.queueSend(message: message)
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
        
    
        public static func decode(message: Message, connection: Connection) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
