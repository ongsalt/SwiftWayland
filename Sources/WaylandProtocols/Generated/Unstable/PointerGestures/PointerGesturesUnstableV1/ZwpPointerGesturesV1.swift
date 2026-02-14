import Foundation
import SwiftWayland

/// Touchpad Gestures
/// 
/// A global interface to provide semantic touchpad gestures for a given
/// pointer.
/// Three gestures are currently supported: swipe, pinch, and hold.
/// Pinch and swipe gestures follow a three-stage cycle: begin, update,
/// end. Hold gestures follow a two-stage cycle: begin and end. All
/// gestures are identified by a unique id.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpPointerGesturesV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_pointer_gestures_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Get Swipe Gesture
    /// 
    /// Create a swipe gesture object. See the
    /// wl_pointer_gesture_swipe interface for details.
    public func getSwipeGesture(pointer: WlPointer) throws(WaylandProxyError) -> ZwpPointerGestureSwipeV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPointerGestureSwipeV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Get Pinch Gesture
    /// 
    /// Create a pinch gesture object. See the
    /// wl_pointer_gesture_pinch interface for details.
    public func getPinchGesture(pointer: WlPointer) throws(WaylandProxyError) -> ZwpPointerGesturePinchV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpPointerGesturePinchV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(pointer)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Destroy The Pointer Gesture Object
    /// 
    /// Destroy the pointer gesture object. Swipe, pinch and hold objects
    /// created via this gesture object remain valid.
    /// 
    /// Available since version 2
    public consuming func release() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Get Hold Gesture
    /// 
    /// Create a hold gesture object. See the
    /// wl_pointer_gesture_hold interface for details.
    /// 
    /// Available since version 3
    public func getHoldGesture(pointer: WlPointer) throws(WaylandProxyError) -> ZwpPointerGestureHoldV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let id = connection.createProxy(type: ZwpPointerGestureHoldV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(pointer)
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
