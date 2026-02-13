import Foundation
import SwiftWayland

public final class WpColorManagementSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_management_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func setImageDescription(imageDescription: WpImageDescriptionV1, renderIntent: UInt32) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(imageDescription),
            .uint(renderIntent)
        ])
        connection.send(message: message)
    }
    
    public func unsetImageDescription() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case renderIntent = 0
        case imageDescription = 1
        case inert = 2
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
