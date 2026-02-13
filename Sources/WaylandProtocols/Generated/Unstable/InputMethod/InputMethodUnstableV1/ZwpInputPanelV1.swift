import Foundation
import SwiftWayland

public final class ZwpInputPanelV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_panel_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func getInputPanelSurface(surface: WlSurface) throws(WaylandProxyError) -> ZwpInputPanelSurfaceV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputPanelSurfaceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
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
