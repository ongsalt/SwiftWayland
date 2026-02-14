import Foundation
import SwiftWayland

/// A Hold Gesture Object
/// 
/// A hold gesture object notifies a client about a single- or
/// multi-finger hold gesture detected on an indirect input device such as
/// a touchpad. The gesture is usually initiated by one or more fingers
/// being held down without significant movement. The precise conditions
/// of when such a gesture is detected are implementation-dependent.
/// In particular, this gesture may be used to cancel kinetic scrolling.
/// A hold gesture consists of two stages: begin and end. Unlike pinch and
/// swipe there is no update stage.
/// There cannot be multiple simultaneous hold, pinch or swipe gestures on a
/// same pointer/seat, how compositors prevent these situations is
/// implementation-dependent.
/// A gesture may be cancelled by the compositor or the hardware.
/// Clients should not consider performing permanent or irreversible
/// actions until the end of a gesture has been received.
public final class ZwpPointerGestureHoldV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_pointer_gesture_hold_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Hold Gesture Object
    /// 
    /// 
    /// 
    /// Available since version 3
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
        /// Multi-Finger Hold Begin
        /// 
        /// This event is sent when a hold gesture is detected on the device.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Fingers: number of fingers
        /// 
        /// Available since version 3
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)
        
        /// Multi-Finger Hold End
        /// 
        /// This event is sent when a hold gesture ceases to
        /// be valid. This may happen when the holding fingers are lifted or
        /// the gesture is cancelled, for example if the fingers move past an
        /// implementation-defined threshold, the finger count changes or the hold
        /// gesture changes into a different type of gesture.
        /// When a gesture is cancelled, the client may need to undo state changes
        /// caused by this gesture. What causes a gesture to be cancelled is
        /// implementation-dependent.
        /// 
        /// - Parameters:
        ///   - Time: timestamp with millisecond granularity
        ///   - Cancelled: 1 if the gesture was cancelled, 0 otherwise
        /// 
        /// Available since version 3
        case end(serial: UInt32, time: UInt32, cancelled: Int32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.begin(serial: r.readUInt(), time: r.readUInt(), surface: connection.get(as: WlSurface.self, id: r.readObjectId())!, fingers: r.readUInt())
            case 1:
                return Self.end(serial: r.readUInt(), time: r.readUInt(), cancelled: r.readInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
