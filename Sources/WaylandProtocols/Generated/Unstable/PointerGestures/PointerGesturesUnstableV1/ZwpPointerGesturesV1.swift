import Foundation
import SwiftWayland

public final class ZwpPointerGesturesV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_pointer_gestures_v1"
    public var onEvent: (Event) -> Void = { _ in }

    public func getSwipeGesture(pointer: WlPointer) -> ZwpPointerGestureSwipeV1 {
        let id = connection.createProxy(type: ZwpPointerGestureSwipeV1.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id),
            .object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    public func getPinchGesture(pointer: WlPointer) -> ZwpPointerGesturePinchV1 {
        let id = connection.createProxy(type: ZwpPointerGesturePinchV1.self)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            .newId(id.id),
            .object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    public func release() {
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    public func getHoldGesture(pointer: WlPointer) -> ZwpPointerGestureHoldV1 {
        let id = connection.createProxy(type: ZwpPointerGestureHoldV1.self)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            .newId(id.id),
            .object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
