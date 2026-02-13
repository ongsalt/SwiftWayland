import Foundation
import SwiftWayland

public final class WpFractionalScaleV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_fractional_scale_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case preferredScale(scale: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.preferredScale(scale: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
