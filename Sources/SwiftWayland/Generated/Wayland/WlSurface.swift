import Foundation

public final class WlSurface: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_surface"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func attach(buffer: WlBuffer, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(buffer),
            .int(x),
            .int(y)
        ])
        connection.send(message: message)
    }
    
    public func damage(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func frame(callback: @escaping (UInt32) -> Void) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let callback = connection.createCallback(fn: callback)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .newId(callback.id)
        ])
        connection.send(message: message)
    }
    
    public func setOpaqueRegion(region: WlRegion) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [
            .object(region)
        ])
        connection.send(message: message)
    }
    
    public func setInputRegion(region: WlRegion) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 5, contents: [
            .object(region)
        ])
        connection.send(message: message)
    }
    
    public func commit() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 6, contents: [])
        connection.send(message: message)
    }
    
    public func setBufferTransform(transform: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let message = Message(objectId: self.id, opcode: 7, contents: [
            .int(transform)
        ])
        connection.send(message: message)
    }
    
    public func setBufferScale(scale: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 8, contents: [
            .int(scale)
        ])
        connection.send(message: message)
    }
    
    public func damageBuffer(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let message = Message(objectId: self.id, opcode: 9, contents: [
            .int(x),
            .int(y),
            .int(width),
            .int(height)
        ])
        connection.send(message: message)
    }
    
    public func offset(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        let message = Message(objectId: self.id, opcode: 10, contents: [
            .int(x),
            .int(y)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidScale = 0
        case invalidTransform = 1
        case invalidSize = 2
        case invalidOffset = 3
        case defunctRoleObject = 4
    }
    
    public enum Event: WlEventEnum {
        case enter(output: WlOutput)
        case leave(output: WlOutput)
        case preferredBufferScale(factor: Int32)
        case preferredBufferTransform(transform: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.enter(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 1:
                return Self.leave(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 2:
                return Self.preferredBufferScale(factor: r.readInt())
            case 3:
                return Self.preferredBufferTransform(transform: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
