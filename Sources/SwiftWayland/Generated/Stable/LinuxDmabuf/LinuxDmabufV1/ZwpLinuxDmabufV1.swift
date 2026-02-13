import Foundation

public final class ZwpLinuxDmabufV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_dmabuf_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func createParams() throws(WaylandProxyError) -> ZwpLinuxBufferParamsV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let paramsId = connection.createProxy(type: ZwpLinuxBufferParamsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(paramsId.id)
        ])
        connection.send(message: message)
        return paramsId
    }
    
    public func getDefaultFeedback() throws(WaylandProxyError) -> ZwpLinuxDmabufFeedbackV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let id = connection.createProxy(type: ZwpLinuxDmabufFeedbackV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getSurfaceFeedback(surface: WlSurface) throws(WaylandProxyError) -> ZwpLinuxDmabufFeedbackV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let id = connection.createProxy(type: ZwpLinuxDmabufFeedbackV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .newId(id.id),
            .object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        case format(format: UInt32)
        case modifier(format: UInt32, modifierHi: UInt32, modifierLo: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.format(format: r.readUInt())
            case 1:
                return Self.modifier(format: r.readUInt(), modifierHi: r.readUInt(), modifierLo: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
