import Foundation
import SwiftWayland

/// A Surface Displayed While The Session Is Locked
/// 
/// The client may use lock surfaces to display a screensaver, render a
/// dialog to enter a password and unlock the session, or however else it
/// sees fit.
/// On binding this interface the compositor will immediately send the
/// first configure event. After making the ack_configure request in
/// response to this event the client should attach and commit the first
/// buffer. Committing the surface before acking the first configure is a
/// protocol error. Committing the surface with a null buffer at any time
/// is a protocol error.
/// The compositor is free to handle keyboard/pointer focus for lock
/// surfaces however it chooses. A reasonable way to do this would be to
/// give the first lock surface created keyboard focus and change keyboard
/// focus if the user clicks on other surfaces.
public final class ExtSessionLockSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_session_lock_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Lock Surface Object
    /// 
    /// This informs the compositor that the lock surface object will no
    /// longer be used.
    /// It is recommended for a lock client to destroy lock surfaces if
    /// their corresponding wl_output global is removed.
    /// If a lock surface on an active output is destroyed before the
    /// ext_session_lock_v1.unlock_and_destroy event is sent, the compositor
    /// must fall back to rendering a solid color.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Ack A Configure Event
    /// 
    /// When a configure event is received, if a client commits the surface
    /// in response to the configure event, then the client must make an
    /// ack_configure request sometime before the commit request, passing
    /// along the serial of the configure event.
    /// If the client receives multiple configure events before it can
    /// respond to one, it only has to ack the last configure event.
    /// A client is not required to commit immediately after sending an
    /// ack_configure request - it may even ack_configure several times
    /// before its next surface commit.
    /// A client may send multiple ack_configure requests before committing,
    /// but only the last request sent before a commit indicates which
    /// configure event the client really is responding to.
    /// Sending an ack_configure request consumes the configure event
    /// referenced by the given serial, as well as all older configure events
    /// sent on this object.
    /// It is a protocol error to issue multiple ack_configure requests
    /// referencing the same configure event or to issue an ack_configure
    /// request referencing a configure event older than the last configure
    /// event acked for a given lock surface.
    /// 
    /// - Parameters:
    ///   - Serial: serial from the configure event
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Surface Committed Before First Ack_Configure Request
        case commitBeforeFirstAck = 0
        
        /// Surface Committed With A Null Buffer
        case nullBuffer = 1
        
        /// Failed To Match Ack'd Width/Height
        case dimensionsMismatch = 2
        
        /// Serial Provided In Ack_Configure Is Invalid
        case invalidSerial = 3
    }
    
    public enum Event: WlEventEnum {
        /// The Client Should Resize Its Surface
        /// 
        /// This event is sent once on binding the interface and may be sent again
        /// at the compositor's discretion, for example if output geometry changes.
        /// The width and height are in surface-local coordinates and are exact
        /// requirements. Failing to match these surface dimensions in the next
        /// commit after acking a configure is a protocol error.
        /// 
        /// - Parameters:
        ///   - Serial: serial for use in ack_configure
        case configure(serial: UInt32, width: UInt32, height: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(serial: r.readUInt(), width: r.readUInt(), height: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
