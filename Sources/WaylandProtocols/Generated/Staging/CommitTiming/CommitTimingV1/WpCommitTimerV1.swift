import Foundation
import SwiftWayland

/// Surface Commit Timer
/// 
/// An object to set a time constraint for a content update on a surface.
public final class WpCommitTimerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_commit_timer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Specify Time The Following Commit Takes Effect
    /// 
    /// Provide a timing constraint for a surface content update.
    /// A set_timestamp request may be made before a wl_surface.commit to
    /// tell the compositor that the content is intended to be presented
    /// as closely as possible to, but not before, the specified time.
    /// The time is in the domain of the compositor's presentation clock.
    /// An invalid_timestamp error will be generated for invalid tv_nsec.
    /// If a timestamp already exists on the surface, a timestamp_exists
    /// error is generated.
    /// Requesting set_timestamp after the commit_timer object's surface is
    /// destroyed will generate a "surface_destroyed" error.
    /// 
    /// - Parameters:
    ///   - TvSecHi: high 32 bits of the seconds part of target time
    ///   - TvSecLo: low 32 bits of the seconds part of target time
    ///   - TvNsec: nanoseconds part of target time
    public func setTimestamp(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.uint(tvSecHi),
            WaylandData.uint(tvSecLo),
            WaylandData.uint(tvNsec)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Timer
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object.
    /// Existing timing constraints are not affected by the destruction.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Timestamp Contains An Invalid Value
        case invalidTimestamp = 0
        
        /// Timestamp Exists
        case timestampExists = 1
        
        /// The Associated Surface No Longer Exists
        case surfaceDestroyed = 2
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
