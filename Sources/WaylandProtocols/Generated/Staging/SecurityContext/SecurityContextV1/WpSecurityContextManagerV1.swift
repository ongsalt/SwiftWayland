import Foundation
import SwiftWayland

public final class WpSecurityContextManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_security_context_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func createListener(listenFd: FileHandle, closeFd: FileHandle) throws(WaylandProxyError)  -> WpSecurityContextV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpSecurityContextV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .fd(listenFd),
            .fd(closeFd)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidListenFd = 1
        case nested = 2
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
