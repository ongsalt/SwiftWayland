import Foundation
import SwiftWayland

public final class WpCursorShapeManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_cursor_shape_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getPointer(pointer: WlPointer) throws(WaylandProxyError) -> WpCursorShapeDeviceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let cursorShapeDevice = connection.createProxy(type: WpCursorShapeDeviceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(cursorShapeDevice.id),
            WaylandData.object(pointer)
        ])
        connection.send(message: message)
        return cursorShapeDevice
    }
    
    public func getTabletToolV2(tabletTool: ZwpTabletToolV2) throws(WaylandProxyError) -> WpCursorShapeDeviceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let cursorShapeDevice = connection.createProxy(type: WpCursorShapeDeviceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(cursorShapeDevice.id),
            WaylandData.object(tabletTool)
        ])
        connection.send(message: message)
        return cursorShapeDevice
    }
    
    deinit {
        try! self.destroy()
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
