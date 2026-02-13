import Foundation
import SwiftWayland

public final class WpDrmLeaseV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_drm_lease_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case leaseFd(leasedFd: FileHandle)
        case finished
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.leaseFd(leasedFd: r.readFd())
            case 1:
                return Self.finished
            default:
                fatalError("Unknown message")
            }
        }
    }
}
