import Foundation

public final class WlDisplay: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_display"
    public var onEvent: (Event) -> Void = { _ in }

    public func sync(callback: @escaping (UInt32) -> Void) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let callback = connection.createCallback(fn: callback)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(callback.id)
        ])
        connection.send(message: message)
    }
    
    public func getRegistry() throws(WaylandProxyError) -> WlRegistry {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let registry = connection.createProxy(type: WlRegistry.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(registry.id)
        ])
        connection.send(message: message)
        return registry
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidObject = 0
        case invalidMethod = 1
        case noMemory = 2
        case implementation = 3
    }
    
    public enum Event: WlEventEnum {
        case error(objectId: any WlProxy, code: UInt32, message: String)
        case deleteId(id: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.error(objectId: connection.get(id: r.readObjectId())!, code: r.readUInt(), message: r.readString())
            case 1:
                return Self.deleteId(id: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
