import Foundation
import SwiftWayland


public final class ZwpInputPanelSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_panel_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Set The Surface Type As A Keyboard
    /// 
    /// Set the input_panel_surface type to keyboard.
    /// A keyboard surface is only shown when a text input is active.
    public func setToplevel(output: WlOutput, position: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.object(output),
            WaylandData.uint(position)
        ])
        connection.send(message: message)
    }
    
    /// Set The Surface Type As An Overlay Panel
    /// 
    /// Set the input_panel_surface to be an overlay panel.
    /// This is shown near the input cursor above the application window when
    /// a text input is active.
    public func setOverlayPanel() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    public enum Position: UInt32, WlEnum {
        case centerBottom = 0
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
