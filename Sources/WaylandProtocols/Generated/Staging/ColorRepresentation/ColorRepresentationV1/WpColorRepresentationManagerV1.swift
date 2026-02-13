import Foundation
import SwiftWayland

public final class WpColorRepresentationManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_color_representation_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getSurface(surface: WlSurface) throws(WaylandProxyError) -> WpColorRepresentationSurfaceV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorRepresentationSurfaceV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case surfaceExists = 1
    }
    
    public enum Event: WlEventEnum {
        case supportedAlphaMode(alphaMode: UInt32)
        case supportedCoefficientsAndRanges(coefficients: UInt32, range: UInt32)
        case done
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.supportedAlphaMode(alphaMode: r.readUInt())
            case 1:
                return Self.supportedCoefficientsAndRanges(coefficients: r.readUInt(), range: r.readUInt())
            case 2:
                return Self.done
            default:
                fatalError("Unknown message")
            }
        }
    }
}
