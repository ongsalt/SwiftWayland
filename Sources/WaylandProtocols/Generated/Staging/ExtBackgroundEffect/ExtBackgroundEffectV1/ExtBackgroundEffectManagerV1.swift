import Foundation
import SwiftWayland

public final class ExtBackgroundEffectManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_background_effect_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getBackgroundEffect(surface: WlSurface) throws(WaylandProxyError) -> ExtBackgroundEffectSurfaceV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ExtBackgroundEffectSurfaceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case backgroundEffectExists = 0
    }
    
    public enum Capability: UInt32, WlEnum {
        case blur = 1
    }
    
    public enum Event: WlEventEnum {
        case capabilities(flags: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.capabilities(flags: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
