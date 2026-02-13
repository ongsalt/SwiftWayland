import Foundation

public final class WlDataSource: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_data_source"
    public var onEvent: (Event) -> Void = { _ in }

    public func offer(mimeType: String) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .string(mimeType)
        ])
        connection.send(message: message)
    }
    
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func setActions(dndActions: UInt32) throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            .uint(dndActions)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidActionMask = 0
        case invalidSource = 1
    }
    
    public enum Event: WlEventEnum {
        case `target`(mimeType: String)
        case send(mimeType: String, fd: FileHandle)
        case cancelled
        case dndDropPerformed
        case dndFinished
        case action(dndAction: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.`target`(mimeType: r.readString())
            case 1:
                return Self.send(mimeType: r.readString(), fd: r.readFd())
            case 2:
                return Self.cancelled
            case 3:
                return Self.dndDropPerformed
            case 4:
                return Self.dndFinished
            case 5:
                return Self.action(dndAction: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
