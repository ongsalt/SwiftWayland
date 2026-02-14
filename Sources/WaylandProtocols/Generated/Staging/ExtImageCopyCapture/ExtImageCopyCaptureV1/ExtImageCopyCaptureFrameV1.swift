import Foundation
import SwiftWayland

/// Image Capture Frame
/// 
/// This object represents an image capture frame.
/// The client should attach a buffer, damage the buffer, and then send a
/// capture request.
/// If the capture is successful, the compositor must send the frame metadata
/// (transform, damage, presentation_time in any order) followed by the ready
/// event.
/// If the capture fails, the compositor must send the failed event.
public final class ExtImageCopyCaptureFrameV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_image_copy_capture_frame_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy This Object
    /// 
    /// Destroys the frame. This request can be sent at any time by the
    /// client.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Attach Buffer To Session
    /// 
    /// Attach a buffer to the session.
    /// The wl_buffer.release request is unused.
    /// The new buffer replaces any previously attached buffer.
    /// This request must not be sent after capture, or else the
    /// already_captured protocol error is raised.
    public func attachBuffer(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(buffer)
        ])
        connection.send(message: message)
    }
    
    /// Damage Buffer
    /// 
    /// Apply damage to the buffer which is to be captured next. This request
    /// may be sent multiple times to describe a region.
    /// The client indicates the accumulated damage since this wl_buffer was
    /// last captured. During capture, the compositor will update the buffer
    /// with at least the union of the region passed by the client and the
    /// region advertised by ext_image_copy_capture_frame_v1.damage.
    /// When a wl_buffer is captured for the first time, or when the client
    /// doesn't track damage, the client must damage the whole buffer.
    /// This is for optimisation purposes. The compositor may use this
    /// information to reduce copying.
    /// These coordinates originate from the upper left corner of the buffer.
    /// If x or y are strictly negative, or if width or height are negative or
    /// zero, the invalid_buffer_damage protocol error is raised.
    /// This request must not be sent after capture, or else the
    /// already_captured protocol error is raised.
    /// 
    /// - Parameters:
    ///   - X: region x coordinate
    ///   - Y: region y coordinate
    ///   - Width: region width
    ///   - Height: region height
    public func damageBuffer(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.int(x),
            WaylandData.int(y),
            WaylandData.int(width),
            WaylandData.int(height)
        ])
        connection.send(message: message)
    }
    
    /// Capture A Frame
    /// 
    /// Capture a frame.
    /// Unless this is the first successful captured frame performed in this
    /// session, the compositor may wait an indefinite amount of time for the
    /// source content to change before performing the copy.
    /// This request may only be sent once, or else the already_captured
    /// protocol error is raised. A buffer must be attached before this request
    /// is sent, or else the no_buffer protocol error is raised.
    public func capture() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Capture Sent Without Attach_Buffer
        case noBuffer = 1
        
        /// Invalid Buffer Damage
        case invalidBufferDamage = 2
        
        /// Capture Request Has Been Sent
        case alreadyCaptured = 3
    }
    
    public enum FailureReason: UInt32, WlEnum {
        case unknown = 0
        
        case bufferConstraints = 1
        
        case stopped = 2
    }
    
    public enum Event: WlEventEnum {
        /// Buffer Transform
        /// 
        /// This event is sent before the ready event and holds the transform that
        /// the compositor has applied to the buffer contents.
        case transform(transform: UInt32)
        
        /// Buffer Damaged Region
        /// 
        /// This event is sent before the ready event. It may be generated multiple
        /// times to describe a region.
        /// The first captured frame in a session will always carry full damage.
        /// Subsequent frames' damaged regions describe which parts of the buffer
        /// have changed since the last ready event.
        /// These coordinates originate in the upper left corner of the buffer.
        /// 
        /// - Parameters:
        ///   - X: damage x coordinate
        ///   - Y: damage y coordinate
        ///   - Width: damage width
        ///   - Height: damage height
        case damage(x: Int32, y: Int32, width: Int32, height: Int32)
        
        /// Presentation Time Of The Frame
        /// 
        /// This event indicates the time at which the frame is presented to the
        /// output in system monotonic time. This event is sent before the ready
        /// event.
        /// The timestamp is expressed as tv_sec_hi, tv_sec_lo, tv_nsec triples,
        /// each component being an unsigned 32-bit value. Whole seconds are in
        /// tv_sec which is a 64-bit value combined from tv_sec_hi and tv_sec_lo,
        /// and the additional fractional part in tv_nsec as nanoseconds. Hence,
        /// for valid timestamps tv_nsec must be in [0, 999999999].
        /// 
        /// - Parameters:
        ///   - TvSecHi: high 32 bits of the seconds part of the timestamp
        ///   - TvSecLo: low 32 bits of the seconds part of the timestamp
        ///   - TvNsec: nanoseconds part of the timestamp
        case presentationTime(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32)
        
        /// Frame Is Available For Reading
        /// 
        /// Called as soon as the frame is copied, indicating it is available
        /// for reading.
        /// The buffer may be re-used by the client after this event.
        /// After receiving this event, the client must destroy the object.
        case ready
        
        /// Capture Failed
        /// 
        /// This event indicates that the attempted frame copy has failed.
        /// After receiving this event, the client must destroy the object.
        case failed(reason: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.transform(transform: r.readUInt())
            case 1:
                return Self.damage(x: r.readInt(), y: r.readInt(), width: r.readInt(), height: r.readInt())
            case 2:
                return Self.presentationTime(tvSecHi: r.readUInt(), tvSecLo: r.readUInt(), tvNsec: r.readUInt())
            case 3:
                return Self.ready
            case 4:
                return Self.failed(reason: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
