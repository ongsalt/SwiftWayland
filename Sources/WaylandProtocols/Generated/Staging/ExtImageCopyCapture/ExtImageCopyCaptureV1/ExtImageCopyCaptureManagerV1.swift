import Foundation
import SwiftWayland

/// Manager To Inform Clients And Begin Capturing
/// 
/// This object is a manager which offers requests to start capturing from a
/// source.
public final class ExtImageCopyCaptureManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_copy_capture_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Capture An Image Capture Source
    /// 
    /// Create a capturing session for an image capture source.
    /// If the paint_cursors option is set, cursors shall be composited onto
    /// the captured frame. The cursor must not be composited onto the frame
    /// if this flag is not set.
    /// If the options bitfield is invalid, the invalid_option protocol error
    /// is sent.
    public func createSession(source: ExtImageCaptureSourceV1, options: UInt32) throws(WaylandProxyError) -> ExtImageCopyCaptureSessionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let session = connection.createProxy(type: ExtImageCopyCaptureSessionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(session.id),
            WaylandData.object(source),
            WaylandData.uint(options)
        ])
        connection.send(message: message)
        return session
    }
    
    /// Capture The Pointer Cursor Of An Image Capture Source
    /// 
    /// Create a cursor capturing session for the pointer of an image capture
    /// source.
    public func createPointerCursorSession(source: ExtImageCaptureSourceV1, pointer: WlPointer) throws(WaylandProxyError) -> ExtImageCopyCaptureCursorSessionV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let session = connection.createProxy(type: ExtImageCopyCaptureCursorSessionV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(session.id),
            WaylandData.object(source),
            WaylandData.object(pointer)
        ])
        connection.send(message: message)
        return session
    }
    
    /// Destroy The Manager
    /// 
    /// Destroy the manager object.
    /// Other objects created via this interface are unaffected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Invalid Option Flag
        case invalidOption = 1
    }
    
    public enum Options: UInt32, WlEnum {
        /// Paint Cursors Onto Captured Frames
        case paintCursors = 1
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
