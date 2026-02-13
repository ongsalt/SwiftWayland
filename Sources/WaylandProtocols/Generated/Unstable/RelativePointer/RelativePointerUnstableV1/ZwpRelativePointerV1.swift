import Foundation
import SwiftWayland

public final class ZwpRelativePointerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_relative_pointer_v1"
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
        case relativeMotion(utimeHi: UInt32, utimeLo: UInt32, dx: Double, dy: Double, dxUnaccel: Double, dyUnaccel: Double)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.relativeMotion(utimeHi: r.readUInt(), utimeLo: r.readUInt(), dx: r.readFixed(), dy: r.readFixed(), dxUnaccel: r.readFixed(), dyUnaccel: r.readFixed())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
