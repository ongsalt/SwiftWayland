import Foundation
import SwiftWayland

public final class ZxdgToplevelDecorationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_toplevel_decoration_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setMode(mode: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .uint(mode)
        ])
        connection.send(message: message)
    }
    
    public func unsetMode() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case unconfiguredBuffer = 0
        case alreadyConstructed = 1
        case orphaned = 2
        case invalidMode = 3
    }
    
    public enum Mode: UInt32, WlEnum {
        case clientSide = 1
        case serverSide = 2
    }
    
    public enum Event: WlEventEnum {
        case configure(mode: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(mode: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
