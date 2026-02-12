import Foundation
import SwiftWayland

public final class WpColorRepresentationManagerV1: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func destroy() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.queueSend(message: message)
    }
    
    public func getSurface(surface: WlSurface) -> WpColorRepresentationSurfaceV1 {
        let id = connection.createProxy(type: WpColorRepresentationSurfaceV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case surfaceExists = 1
    }
    
    public enum Event: WlEventEnum {
        case supportedAlphaMode(alphaMode: UInt32)
        case supportedCoefficientsAndRanges(coefficients: UInt32, range: UInt32)
        case done
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments, connection: connection)
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
