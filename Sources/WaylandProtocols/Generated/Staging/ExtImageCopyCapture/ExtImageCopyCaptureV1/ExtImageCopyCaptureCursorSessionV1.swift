import Foundation
import SwiftWayland

/// Cursor Capture Session
/// 
/// This object represents a cursor capture session. It extends the base
/// capture session with cursor-specific metadata.
public final class ExtImageCopyCaptureCursorSessionV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_copy_capture_cursor_session_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Delete This Object
    /// 
    /// Destroys the session. This request can be sent at any time by the
    /// client.
    /// This request doesn't affect ext_image_copy_capture_frame_v1 objects created by
    /// this object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Get Image Copy Capturer Session
    /// 
    /// Gets the image copy capture session for this cursor session.
    /// The session will produce frames of the cursor image. The compositor may
    /// pause the session when the cursor leaves the captured area.
    /// This request must not be sent more than once, or else the
    /// duplicate_session protocol error is raised.
    public func getCaptureSession() throws(WaylandProxyError) -> ExtImageCopyCaptureSessionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let session = connection.createProxy(type: ExtImageCopyCaptureSessionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(session.id)
        ])
        connection.send(message: message)
        return session
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Get_Capture_Session Sent Twice
        case duplicateSession = 1
    }
    
    public enum Event: WlEventEnum {
        /// Cursor Entered Captured Area
        /// 
        /// Sent when a cursor enters the captured area. It shall be generated
        /// before the "position" and "hotspot" events when and only when a cursor
        /// enters the area.
        /// The cursor enters the captured area when the cursor image intersects
        /// with the captured area. Note, this is different from e.g.
        /// wl_pointer.enter.
        case enter
        
        /// Cursor Left Captured Area
        /// 
        /// Sent when a cursor leaves the captured area. No "position" or "hotspot"
        /// event is generated for the cursor until the cursor enters the captured
        /// area again.
        case leave
        
        /// Position Changed
        /// 
        /// Cursors outside the image capture source do not get captured and no
        /// event will be generated for them.
        /// The given position is the position of the cursor's hotspot and it is
        /// relative to the main buffer's top left corner in transformed buffer
        /// pixel coordinates. The coordinates may be negative or greater than the
        /// main buffer size.
        /// 
        /// - Parameters:
        ///   - X: position x coordinates
        ///   - Y: position y coordinates
        case position(x: Int32, y: Int32)
        
        /// Hotspot Changed
        /// 
        /// The hotspot describes the offset between the cursor image and the
        /// position of the input device.
        /// The given coordinates are the hotspot's offset from the origin in
        /// buffer coordinates.
        /// Clients should not apply the hotspot immediately: the hotspot becomes
        /// effective when the next ext_image_copy_capture_frame_v1.ready event is received.
        /// Compositors may delay this event until the client captures a new frame.
        /// 
        /// - Parameters:
        ///   - X: hotspot x coordinates
        ///   - Y: hotspot y coordinates
        case hotspot(x: Int32, y: Int32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.enter
            case 1:
                return Self.leave
            case 2:
                return Self.position(x: r.readInt(), y: r.readInt())
            case 3:
                return Self.hotspot(x: r.readInt(), y: r.readInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
