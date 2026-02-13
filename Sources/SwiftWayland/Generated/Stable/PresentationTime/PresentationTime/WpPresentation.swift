import Foundation

public final class WpPresentation: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_presentation"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func feedback(surface: WlSurface) throws(WaylandProxyError) -> WpPresentationFeedback {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let callback = connection.createProxy(type: WpPresentationFeedback.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .object(surface),
            .newId(callback.id)
        ])
        connection.send(message: message)
        return callback
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidTimestamp = 0
        case invalidFlag = 1
    }
    
    public enum Event: WlEventEnum {
        case clockId(clkId: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.clockId(clkId: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
