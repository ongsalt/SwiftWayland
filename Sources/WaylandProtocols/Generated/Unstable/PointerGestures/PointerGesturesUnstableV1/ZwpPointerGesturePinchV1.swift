import Foundation
import SwiftWayland

/// A Pinch Gesture Object
/// 
/// A pinch gesture object notifies a client about a multi-finger pinch
/// gesture detected on an indirect input device such as a touchpad.
/// The gesture is usually initiated by multiple fingers moving towards
/// each other or away from each other, or by two or more fingers rotating
/// around a logical center of gravity. The precise conditions of when
/// such a gesture is detected are implementation-dependent.
/// A gesture consists of three stages: begin, update (optional) and end.
/// There cannot be multiple simultaneous hold, pinch or swipe gestures on a
/// same pointer/seat, how compositors prevent these situations is
/// implementation-dependent.
/// A gesture may be cancelled by the compositor or the hardware.
/// Clients should not consider performing permanent or irreversible
/// actions until the end of a gesture has been received.
public final class ZwpPointerGesturePinchV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_pointer_gesture_pinch_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Pinch Gesture Object
    /// 
    /// 
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Multi-Finger Pinch Begin
        /// 
        /// This event is sent when a multi-finger pinch gesture is detected
        /// on the device.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Fingers: number of fingers
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)
        
        /// Multi-Finger Pinch Motion
        /// 
        /// This event is sent when a multi-finger pinch gesture changes the
        /// position of the logical center, the rotation or the relative scale.
        /// The dx and dy coordinates are relative coordinates in the
        /// surface coordinate space of the logical center of the gesture.
        /// The scale factor is an absolute scale compared to the
        /// pointer_gesture_pinch.begin event, e.g. a scale of 2 means the fingers
        /// are now twice as far apart as on pointer_gesture_pinch.begin.
        /// The rotation is the relative angle in degrees clockwise compared to the previous
        /// pointer_gesture_pinch.begin or pointer_gesture_pinch.update event.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Dx: delta x coordinate in surface coordinate space
        ///   - Dy: delta y coordinate in surface coordinate space
        ///   - Scale: scale relative to the initial finger position
        ///   - Rotation: angle in degrees cw relative to the previous event
        case update(time: UInt32, dx: Double, dy: Double, scale: Double, rotation: Double)
        
        /// Multi-Finger Pinch End
        /// 
        /// This event is sent when a multi-finger pinch gesture ceases to
        /// be valid. This may happen when one or more fingers are lifted or
        /// the gesture is cancelled.
        /// When a gesture is cancelled, the client should undo state changes
        /// caused by this gesture. What causes a gesture to be cancelled is
        /// implementation-dependent.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Cancelled: 1 if the gesture was cancelled, 0 otherwise
        case end(serial: UInt32, time: UInt32, cancelled: Int32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.begin(serial: r.readUInt(), time: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, fingers: r.readUInt())
            case 1:
                return Self.update(time: r.readUInt(), dx: r.readFixed(), dy: r.readFixed(), scale: r.readFixed(), rotation: r.readFixed())
            case 2:
                return Self.end(serial: r.readUInt(), time: r.readUInt(), cancelled: r.readInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
