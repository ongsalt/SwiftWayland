import Foundation
import SwiftWayland

/// A Swipe Gesture Object
/// 
/// A swipe gesture object notifies a client about a multi-finger swipe
/// gesture detected on an indirect input device such as a touchpad.
/// The gesture is usually initiated by multiple fingers moving in the
/// same direction but once initiated the direction may change.
/// The precise conditions of when such a gesture is detected are
/// implementation-dependent.
/// A gesture consists of three stages: begin, update (optional) and end.
/// There cannot be multiple simultaneous hold, pinch or swipe gestures on a
/// same pointer/seat, how compositors prevent these situations is
/// implementation-dependent.
/// A gesture may be cancelled by the compositor or the hardware.
/// Clients should not consider performing permanent or irreversible
/// actions until the end of a gesture has been received.
public final class ZwpPointerGestureSwipeV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_pointer_gesture_swipe_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Pointer Swipe Gesture Object
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
        /// Multi-Finger Swipe Begin
        /// 
        /// This event is sent when a multi-finger swipe gesture is detected
        /// on the device.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Fingers: number of fingers
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)
        
        /// Multi-Finger Swipe Motion
        /// 
        /// This event is sent when a multi-finger swipe gesture changes the
        /// position of the logical center.
        /// The dx and dy coordinates are relative coordinates of the logical
        /// center of the gesture compared to the previous event.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Dx: delta x coordinate in surface coordinate space
        ///   - Dy: delta y coordinate in surface coordinate space
        case update(time: UInt32, dx: Double, dy: Double)
        
        /// Multi-Finger Swipe End
        /// 
        /// This event is sent when a multi-finger swipe gesture ceases to
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
                return Self.update(time: r.readUInt(), dx: r.readFixed(), dy: r.readFixed())
            case 2:
                return Self.end(serial: r.readUInt(), time: r.readUInt(), cancelled: r.readInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
