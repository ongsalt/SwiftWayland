import Foundation
import SwiftWayland

public final class WpCursorShapeManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_cursor_shape_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func getPointer(pointer: WlPointer) throws(WaylandProxyError)  -> WpCursorShapeDeviceV1 {
        let cursorShapeDevice = connection.createProxy(type: WpCursorShapeDeviceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(cursorShapeDevice.id),
            .object(pointer)
        ])
        connection.send(message: message)
        return cursorShapeDevice
    }
    
    public func getTabletToolV2(tabletTool: ZwpTabletToolV2) throws(WaylandProxyError)  -> WpCursorShapeDeviceV1 {
        let cursorShapeDevice = connection.createProxy(type: WpCursorShapeDeviceV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(cursorShapeDevice.id),
            .object(tabletTool)
        ])
        connection.send(message: message)
        return cursorShapeDevice
    }
    
    deinit {
        try! self.destroy()
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
