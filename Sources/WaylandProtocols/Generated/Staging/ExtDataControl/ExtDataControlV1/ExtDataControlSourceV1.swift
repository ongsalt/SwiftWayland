import Foundation
import SwiftWayland

public final class ExtDataControlSourceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_data_control_source_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func offer(mimeType: String) throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .string(mimeType)
        ])
        connection.send(message: message)
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidOffer = 1
    }
    
    public enum Event: WlEventEnum {
        case send(mimeType: String, fd: FileHandle)
        case cancelled
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.send(mimeType: r.readString(), fd: r.readFd())
            case 1:
                return Self.cancelled
            default:
                fatalError("Unknown message")
            }
        }
    }
}
