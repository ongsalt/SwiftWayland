import Foundation
import SwiftWayland

public final class ZwpPointerGesturesV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_pointer_gestures_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func getSwipeGesture(pointer: WlPointer) throws(WaylandProxyError)  -> ZwpPointerGestureSwipeV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPointerGestureSwipeV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id),
            .object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getPinchGesture(pointer: WlPointer) throws(WaylandProxyError)  -> ZwpPointerGesturePinchV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPointerGesturePinchV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    public consuming func release() throws(WaylandProxyError) {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    public func getHoldGesture(pointer: WlPointer) throws(WaylandProxyError)  -> ZwpPointerGestureHoldV1 {
        guard self._state == .alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let id = connection.createProxy(type: ZwpPointerGestureHoldV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .newId(id.id),
            .object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.release()
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
