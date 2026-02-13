import Foundation
import SwiftWayland

public final class ZwpFullscreenShellV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_fullscreen_shell_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func release() {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
    }
    
    public func presentSurface(surface: WlSurface, method: UInt32, output: WlOutput) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(surface),
            .uint(method),
            .object(output)
        ])
        connection.send(message: message)
    }
    
    public func presentSurfaceForMode(surface: WlSurface, output: WlOutput, framerate: Int32) -> ZwpFullscreenShellModeFeedbackV1 {
        let feedback = connection.createProxy(type: ZwpFullscreenShellModeFeedbackV1.self)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(surface),
            .object(output),
            .int(framerate),
            .newId(feedback.id)
        ])
        connection.send(message: message)
        return feedback
    }
    
    public enum Capability: UInt32, WlEnum {
        case arbitraryModes = 1
        case cursorPlane = 2
    }
    
    public enum PresentMethod: UInt32, WlEnum {
        case `default` = 0
        case center = 1
        case zoom = 2
        case zoomCrop = 3
        case stretch = 4
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidMethod = 0
        case role = 1
    }
    
    public enum Event: WlEventEnum {
        case capability(capability: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.capability(capability: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
