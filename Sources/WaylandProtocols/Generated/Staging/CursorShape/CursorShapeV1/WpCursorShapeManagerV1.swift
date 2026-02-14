import Foundation
import SwiftWayland

/// Cursor Shape Manager
/// 
/// This global offers an alternative, optional way to set cursor images. This
/// new way uses enumerated cursors instead of a wl_surface like
/// wl_pointer.set_cursor does.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpCursorShapeManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_cursor_shape_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Manager
    /// 
    /// Destroy the cursor shape manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Manage The Cursor Shape Of A Pointer Device
    /// 
    /// Obtain a wp_cursor_shape_device_v1 for a wl_pointer object.
    /// When the pointer capability is removed from the wl_seat, the
    /// wp_cursor_shape_device_v1 object becomes inert.
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
    
    /// Manage The Cursor Shape Of A Tablet Tool Device
    /// 
    /// Obtain a wp_cursor_shape_device_v1 for a zwp_tablet_tool_v2 object.
    /// When the zwp_tablet_tool_v2 is removed, the wp_cursor_shape_device_v1
    /// object becomes inert.
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
