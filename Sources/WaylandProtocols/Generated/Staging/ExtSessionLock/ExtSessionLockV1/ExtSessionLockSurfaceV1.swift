import Foundation
import SwiftWayland

public final class ExtSessionLockSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_session_lock_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case commitBeforeFirstAck = 0
        case nullBuffer = 1
        case dimensionsMismatch = 2
        case invalidSerial = 3
    }
    
    public enum Event: WlEventEnum {
        case configure(serial: UInt32, width: UInt32, height: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(serial: r.readUInt(), width: r.readUInt(), height: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
