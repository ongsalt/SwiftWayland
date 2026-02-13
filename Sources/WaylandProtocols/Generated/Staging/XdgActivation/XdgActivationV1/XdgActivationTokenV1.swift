import Foundation
import SwiftWayland

public final class XdgActivationTokenV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_activation_token_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func setSerial(serial: UInt32, seat: WlSeat) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .uint(serial),
            .object(seat)
        ])
        connection.send(message: message)
    }
    
    public func setAppId(appId: String) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .string(appId)
        ])
        connection.send(message: message)
    }
    
    public func setSurface(surface: WlSurface) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .object(surface)
        ])
        connection.send(message: message)
    }
    
    public func commit() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case alreadyUsed = 0
    }
    
    public enum Event: WlEventEnum {
        case done(token: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.done(token: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
