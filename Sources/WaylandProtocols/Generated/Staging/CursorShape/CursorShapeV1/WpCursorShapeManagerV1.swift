import Foundation
import SwiftWayland

public final class WpCursorShapeManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_cursor_shape_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func getPointer(pointer: WlPointer) -> WpCursorShapeDeviceV1 {
        let cursorShapeDevice = connection.createProxy(type: WpCursorShapeDeviceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(cursorShapeDevice.id),
            .object(pointer)
        ])
        connection.send(message: message)
        return cursorShapeDevice
    }
    
    public func getTabletToolV2(tabletTool: ZwpTabletToolV2) -> WpCursorShapeDeviceV1 {
        let cursorShapeDevice = connection.createProxy(type: WpCursorShapeDeviceV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(cursorShapeDevice.id),
            .object(tabletTool)
        ])
        connection.send(message: message)
        return cursorShapeDevice
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
