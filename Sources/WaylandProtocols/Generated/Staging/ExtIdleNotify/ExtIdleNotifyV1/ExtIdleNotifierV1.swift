import Foundation
import SwiftWayland

/// Idle Notification Manager
/// 
/// This interface allows clients to monitor user idle status.
/// After binding to this global, clients can create ext_idle_notification_v1
/// objects to get notified when the user is idle for a given amount of time.
public final class ExtIdleNotifierV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_idle_notifier_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Manager
    /// 
    /// Destroy the manager object. All objects created via this interface
    /// remain valid.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A Notification Object
    /// 
    /// Create a new idle notification object.
    /// The notification object has a minimum timeout duration and is tied to a
    /// seat. The client will be notified if the seat is inactive for at least
    /// the provided timeout. See ext_idle_notification_v1 for more details.
    /// A zero timeout is valid and means the client wants to be notified as
    /// soon as possible when the seat is inactive.
    /// 
    /// - Parameters:
    ///   - Timeout: minimum idle timeout in msec
    public func getIdleNotification(timeout: UInt32, seat: WlSeat) throws(WaylandProxyError) -> ExtIdleNotificationV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ExtIdleNotificationV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.uint(timeout),
            WaylandData.object(seat)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Create A Notification Object
    /// 
    /// Create a new idle notification object to track input from the
    /// user, such as keyboard and mouse movement. Because this object is
    /// meant to track user input alone, it ignores idle inhibitors.
    /// The notification object has a minimum timeout duration and is tied to a
    /// seat. The client will be notified if the seat is inactive for at least
    /// the provided timeout. See ext_idle_notification_v1 for more details.
    /// A zero timeout is valid and means the client wants to be notified as
    /// soon as possible when the seat is inactive.
    /// 
    /// - Parameters:
    ///   - Timeout: minimum idle timeout in msec
    /// 
    /// Available since version 2
    public func getInputIdleNotification(timeout: UInt32, seat: WlSeat) throws(WaylandProxyError) -> ExtIdleNotificationV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let id = connection.createProxy(type: ExtIdleNotificationV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(id.id),
            WaylandData.uint(timeout),
            WaylandData.object(seat)
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
