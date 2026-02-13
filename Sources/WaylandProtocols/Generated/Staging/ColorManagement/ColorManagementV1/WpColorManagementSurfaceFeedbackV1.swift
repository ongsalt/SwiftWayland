import Foundation
import SwiftWayland

public final class WpColorManagementSurfaceFeedbackV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_management_surface_feedback_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getPreferred() throws(WaylandProxyError)  -> WpImageDescriptionV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(imageDescription.id)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    public func getPreferredParametric() throws(WaylandProxyError)  -> WpImageDescriptionV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(imageDescription.id)
        ])
        connection.send(message: message)
        return imageDescription
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case inert = 0
        case unsupportedFeature = 1
    }
    
    public enum Event: WlEventEnum {
        case preferredChanged(identity: UInt32)
        case preferredChanged2(identityHi: UInt32, identityLo: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.preferredChanged(identity: r.readUInt())
            case 1:
                return Self.preferredChanged2(identityHi: r.readUInt(), identityLo: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
