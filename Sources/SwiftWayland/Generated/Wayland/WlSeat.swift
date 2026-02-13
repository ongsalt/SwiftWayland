import Foundation

public final class WlSeat: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_seat"
    public var onEvent: (Event) -> Void = { _ in }

    public func getPointer() throws(WaylandProxyError) -> WlPointer {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlPointer.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getKeyboard() throws(WaylandProxyError) -> WlKeyboard {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlKeyboard.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getTouch() throws(WaylandProxyError) -> WlTouch {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlTouch.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public consuming func release() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.release()
    }
    
    public enum Capability: UInt32, WlEnum {
        case pointer = 1
        case keyboard = 2
        case touch = 4
    }
    
    public enum Error: UInt32, WlEnum {
        case missingCapability = 0
    }
    
    public enum Event: WlEventEnum {
        case capabilities(capabilities: UInt32)
        case name(name: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.capabilities(capabilities: r.readUInt())
            case 1:
                return Self.name(name: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
