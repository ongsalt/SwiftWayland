import Foundation
import SwiftWayland

/// Commit Timing
/// 
/// When a compositor latches on to new content updates it will check for
/// any number of requirements of the available content updates (such as
/// fences of all buffers being signalled) to consider the update ready.
/// This protocol provides a method for adding a time constraint to surface
/// content. This constraint indicates to the compositor that a content
/// update should be presented as closely as possible to, but not before,
/// a specified time.
/// This protocol does not change the Wayland property that content
/// updates are applied in the order they are received, even when some
/// content updates contain timestamps and others do not.
/// To provide timestamps, this global factory interface must be used to
/// acquire a wp_commit_timing_v1 object for a surface, which may then be
/// used to provide timestamp information for commits.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpCommitTimingManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_commit_timing_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Unbind From The Commit Timing Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object. Existing objects created by this object
    /// are not affected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Request Commit Timer Interface For Surface
    /// 
    /// Establish a timing controller for a surface.
    /// Only one commit timer can be created for a surface, or a
    /// commit_timer_exists protocol error will be generated.
    public func getTimer(surface: WlSurface) throws(WaylandProxyError) -> WpCommitTimerV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpCommitTimerV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Commit Timer Already Exists For Surface
        case commitTimerExists = 0
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
