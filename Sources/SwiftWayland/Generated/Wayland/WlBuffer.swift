import Foundation

/// Content For A Wl_Surface
/// 
/// A buffer provides the content for a wl_surface. Buffers are
/// created through factory interfaces such as wl_shm, wp_linux_buffer_params
/// (from the linux-dmabuf protocol extension) or similar. It has a width and
/// a height and can be attached to a wl_surface, but the mechanism by which a
/// client provides and updates the contents is defined by the buffer factory
/// interface.
/// Color channels are assumed to be electrical rather than optical (in other
/// words, encoded with a transfer function) unless otherwise specified. If
/// the buffer uses a format that has an alpha channel, the alpha channel is
/// assumed to be premultiplied into the electrical color channel values
/// (after transfer function encoding) unless otherwise specified.
/// Note, because wl_buffer objects are created from multiple independent
/// factory interfaces, the wl_buffer interface is frozen at version 1.
public final class WlBuffer: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_buffer"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy A Buffer
    /// 
    /// Destroy a buffer. If and how you need to release the backing
    /// storage is defined by the buffer factory interface.
    /// For possible side-effects to a surface, see wl_surface.attach.
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
        /// Compositor Releases Buffer
        /// 
        /// Sent when this wl_buffer is no longer used by the compositor.
        /// For more information on when release events may or may not be sent,
        /// and what consequences it has, please see the description of
        /// wl_surface.attach.
        /// If a client receives a release event before the frame callback
        /// requested in the same wl_surface.commit that attaches this
        /// wl_buffer to a surface, then the client is immediately free to
        /// reuse the buffer and its backing storage, and does not need a
        /// second buffer for the next surface content update. Typically
        /// this is possible, when the compositor maintains a copy of the
        /// wl_surface contents, e.g. as a GL texture. This is an important
        /// optimization for GL(ES) compositors with wl_shm clients.
        case release
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            case 0:
                return Self.release
            default:
                fatalError("Unknown message")
            }
        }
    }
}
