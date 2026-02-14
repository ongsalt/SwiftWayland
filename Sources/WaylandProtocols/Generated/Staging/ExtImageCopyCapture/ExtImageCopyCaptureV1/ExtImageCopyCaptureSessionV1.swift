import Foundation
import SwiftWayland

/// Image Copy Capture Session
/// 
/// This object represents an active image copy capture session.
/// After a capture session is created, buffer constraint events will be
/// emitted from the compositor to tell the client which buffer types and
/// formats are supported for reading from the session. The compositor may
/// re-send buffer constraint events whenever they change.
/// To advertise buffer constraints, the compositor must send in no
/// particular order: zero or more shm_format and dmabuf_format events, zero
/// or one dmabuf_device event, and exactly one buffer_size event. Then the
/// compositor must send a done event.
/// When the client has received all the buffer constraints, it can create a
/// buffer accordingly, attach it to the capture session using the
/// attach_buffer request, set the buffer damage using the damage_buffer
/// request and then send the capture request.
public final class ExtImageCopyCaptureSessionV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_copy_capture_session_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A Frame
    /// 
    /// Create a capture frame for this session.
    /// At most one frame object can exist for a given session at any time. If
    /// a client sends a create_frame request before a previous frame object
    /// has been destroyed, the duplicate_frame protocol error is raised.
    public func createFrame() throws(WaylandProxyError) -> ExtImageCopyCaptureFrameV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let frame = connection.createProxy(type: ExtImageCopyCaptureFrameV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(frame.id)
        ])
        connection.send(message: message)
        return frame
    }
    
    /// Delete This Object
    /// 
    /// Destroys the session. This request can be sent at any time by the
    /// client.
    /// This request doesn't affect ext_image_copy_capture_frame_v1 objects created by
    /// this object.
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
        /// Create_Frame Sent Before Destroying Previous Frame
        case duplicateFrame = 1
    }
    
    public enum Event: WlEventEnum {
        /// Image Capture Source Dimensions
        /// 
        /// Provides the dimensions of the source image in buffer pixel coordinates.
        /// The client must attach buffers that match this size.
        /// 
        /// - Parameters:
        ///   - Width: buffer width
        ///   - Height: buffer height
        case bufferSize(width: UInt32, height: UInt32)
        
        /// Shm Buffer Format
        /// 
        /// Provides the format that must be used for shared-memory buffers.
        /// This event may be emitted multiple times, in which case the client may
        /// choose any given format.
        /// 
        /// - Parameters:
        ///   - Format: shm format
        case shmFormat(format: UInt32)
        
        /// Dma-Buf Device
        /// 
        /// This event advertises the device buffers must be allocated on for
        /// dma-buf buffers.
        /// In general the device is a DRM node. The DRM node type (primary vs.
        /// render) is unspecified. Clients must not rely on the compositor sending
        /// a particular node type. Clients cannot check two devices for equality
        /// by comparing the dev_t value.
        /// 
        /// - Parameters:
        ///   - Device: device dev_t value
        case dmabufDevice(device: Data)
        
        /// Dma-Buf Format
        /// 
        /// Provides the format that must be used for dma-buf buffers.
        /// The client may choose any of the modifiers advertised in the array of
        /// 64-bit unsigned integers.
        /// This event may be emitted multiple times, in which case the client may
        /// choose any given format.
        /// 
        /// - Parameters:
        ///   - Format: drm format code
        ///   - Modifiers: drm format modifiers
        case dmabufFormat(format: UInt32, modifiers: Data)
        
        /// All Constraints Have Been Sent
        /// 
        /// This event is sent once when all buffer constraint events have been
        /// sent.
        /// The compositor must always end a batch of buffer constraint events with
        /// this event, regardless of whether it sends the initial constraints or
        /// an update.
        case done
        
        /// Session Is No Longer Available
        /// 
        /// This event indicates that the capture session has stopped and is no
        /// longer available. This can happen in a number of cases, e.g. when the
        /// underlying source is destroyed, if the user decides to end the image
        /// capture, or if an unrecoverable runtime error has occurred.
        /// The client should destroy the session after receiving this event.
        case stopped
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.bufferSize(width: r.readUInt(), height: r.readUInt())
            case 1:
                return Self.shmFormat(format: r.readUInt())
            case 2:
                return Self.dmabufDevice(device: r.readArray())
            case 3:
                return Self.dmabufFormat(format: r.readUInt(), modifiers: r.readArray())
            case 4:
                return Self.done
            case 5:
                return Self.stopped
            default:
                fatalError("Unknown message")
            }
        }
    }
}
