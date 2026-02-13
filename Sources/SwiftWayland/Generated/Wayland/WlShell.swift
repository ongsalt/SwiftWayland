import Foundation

public final class WlShell: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_shell"
    public var onEvent: (Event) -> Void = { _ in }

    public func getShellSurface(surface: WlSurface) throws(WaylandProxyError)  -> WlShellSurface {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlShellSurface.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum Error: UInt32, WlEnum {
        case role = 0
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
