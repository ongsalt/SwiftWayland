import Foundation
import SwiftWayland

public final class WpColorManagementOutputV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_management_output_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getImageDescription() throws(WaylandProxyError)  -> WpImageDescriptionV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(imageDescription.id)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case imageDescriptionChanged
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.imageDescriptionChanged
            default:
                fatalError("Unknown message")
            }
        }
    }
}
