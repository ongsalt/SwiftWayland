import Foundation
import SwiftWayland

/// Idle Notification
/// 
/// This interface is used by the compositor to send idle notification events
/// to clients.
/// Initially the notification object is not idle. The notification object
/// becomes idle when no user activity has happened for at least the timeout
/// duration, starting from the creation of the notification object. User
/// activity may include input events or a presence sensor, but is
/// compositor-specific.
/// How this notification responds to idle inhibitors depends on how
/// it was constructed. If constructed from the
/// get_idle_notification request, then if an idle inhibitor is
/// active (e.g. another client has created a zwp_idle_inhibitor_v1
/// on a visible surface), the compositor must not make the
/// notification object idle. However, if constructed from the
/// get_input_idle_notification request, then idle inhibitors are
/// ignored, and only input from the user, e.g. from a keyboard or
/// mouse, counts as activity.
/// When the notification object becomes idle, an idled event is sent. When
/// user activity starts again, the notification object stops being idle,
/// a resumed event is sent and the timeout is restarted.
public final class ExtIdleNotificationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_idle_notification_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Notification Object
    /// 
    /// Destroy the notification object.
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
        /// Notification Object Is Idle
        /// 
        /// This event is sent when the notification object becomes idle.
        /// It's a compositor protocol error to send this event twice without a
        /// resumed event in-between.
        case idled
        
        /// Notification Object Is No Longer Idle
        /// 
        /// This event is sent when the notification object stops being idle.
        /// It's a compositor protocol error to send this event twice without an
        /// idled event in-between. It's a compositor protocol error to send this
        /// event prior to any idled event.
        case resumed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.idled
            case 1:
                return Self.resumed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
