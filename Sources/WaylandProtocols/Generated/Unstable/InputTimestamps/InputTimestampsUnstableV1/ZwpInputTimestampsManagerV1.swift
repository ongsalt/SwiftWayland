import Foundation
import SwiftWayland

public final class ZwpInputTimestampsManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_input_timestamps_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getKeyboardTimestamps(keyboard: WlKeyboard) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(keyboard)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getPointerTimestamps(pointer: WlPointer) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getTouchTimestamps(touch: WlTouch) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpInputTimestampsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(touch)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
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
