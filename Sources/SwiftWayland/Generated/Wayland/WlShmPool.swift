import Foundation

/// A Shared Memory Pool
/// 
/// The wl_shm_pool object encapsulates a piece of memory shared
/// between the compositor and client.  Through the wl_shm_pool
/// object, the client can allocate shared memory wl_buffer objects.
/// All objects created through the same pool share the same
/// underlying mapped memory. Reusing the mapped memory avoids the
/// setup/teardown overhead and is useful when interactively resizing
/// a surface or for many small buffers.
public final class WlShmPool: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_shm_pool"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A Buffer From The Pool
    /// 
    /// Create a wl_buffer object from the pool.
    /// The buffer is created offset bytes into the pool and has
    /// width and height as specified.  The stride argument specifies
    /// the number of bytes from the beginning of one row to the beginning
    /// of the next.  The format is the pixel format of the buffer and
    /// must be one of those advertised through the wl_shm.format event.
    /// A buffer will keep a reference to the pool it was created from
    /// so it is valid to destroy the pool immediately after creating
    /// a buffer from it.
    /// 
    /// - Parameters:
    ///   - Offset: buffer byte offset within the pool
    ///   - Width: buffer width, in pixels
    ///   - Height: buffer height, in pixels
    ///   - Stride: number of bytes from the beginning of one row to the beginning of the next row
    ///   - Format: buffer pixel format
    public func createBuffer(offset: Int32, width: Int32, height: Int32, stride: Int32, format: UInt32) throws(WaylandProxyError) -> WlBuffer {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlBuffer.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id),
            WaylandData.int(offset),
            WaylandData.int(width),
            WaylandData.int(height),
            WaylandData.int(stride),
            WaylandData.uint(format)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Destroy The Pool
    /// 
    /// Destroy the shared memory pool.
    /// The mmapped memory will be released when all
    /// buffers that have been created from this pool
    /// are gone.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Change The Size Of The Pool Mapping
    /// 
    /// This request will cause the server to remap the backing memory
    /// for the pool from the file descriptor passed when the pool was
    /// created, but using the new size.  This request can only be
    /// used to make the pool bigger.
    /// This request only changes the amount of bytes that are mmapped
    /// by the server and does not touch the file corresponding to the
    /// file descriptor passed at creation time. It is the client's
    /// responsibility to ensure that the file is at least as big as
    /// the new pool size.
    /// 
    /// - Parameters:
    ///   - Size: new size of the pool, in bytes
    public func resize(size: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.int(size)
        ])
        connection.send(message: message)
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
