import Foundation

/// Core Global Object
/// 
/// The core global object.  This is a special singleton object.  It
/// is used for internal Wayland protocol features.
public final class WlDisplay: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_display"
    public var onEvent: (Event) -> Void = { _ in }

    /// Asynchronous Roundtrip
    /// 
    /// The sync request asks the server to emit the 'done' event
    /// on the returned wl_callback object.  Since requests are
    /// handled in-order and events are delivered in-order, this can
    /// be used as a barrier to ensure all previous requests and the
    /// resulting events have been handled.
    /// The object returned by this request will be destroyed by the
    /// compositor after the callback is fired and as such the client must not
    /// attempt to use it after that point.
    /// The callback_data passed in the callback is undefined and should be ignored.
    public func sync(callback: @escaping (UInt32) -> Void) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let callback = connection.createCallback(fn: callback)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(callback.id)
        ])
        connection.send(message: message)
    }
    
    /// Get Global Registry Object
    /// 
    /// This request creates a registry object that allows the client
    /// to list and bind the global objects available from the
    /// compositor.
    /// It should be noted that the server side resources consumed in
    /// response to a get_registry request can only be released when the
    /// client disconnects, not when the client side proxy is destroyed.
    /// Therefore, clients should invoke get_registry as infrequently as
    /// possible to avoid wasting memory.
    public func getRegistry() throws(WaylandProxyError) -> WlRegistry {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let registry = connection.createProxy(type: WlRegistry.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(registry.id)
        ])
        connection.send(message: message)
        return registry
    }
    
    /// Global Error Values
    /// 
    /// These errors are global and can be emitted in response to any
    /// server request.
    public enum Error: UInt32, WlEnum {
        /// Server Couldn't Find Object
        case invalidObject = 0
        
        /// Method Doesn't Exist On The Specified Interface Or Malformed Request
        case invalidMethod = 1
        
        /// Server Is Out Of Memory
        case noMemory = 2
        
        /// Implementation Error In Compositor
        case implementation = 3
    }
    
    public enum Event: WlEventEnum {
        /// Fatal Error Event
        /// 
        /// The error event is sent out when a fatal (non-recoverable)
        /// error has occurred.  The object_id argument is the object
        /// where the error occurred, most often in response to a request
        /// to that object.  The code identifies the error and is defined
        /// by the object interface.  As such, each interface defines its
        /// own set of error codes.  The message is a brief description
        /// of the error, for (debugging) convenience.
        /// 
        /// - Parameters:
        ///   - ObjectId: object where the error occurred
        ///   - Code: error code
        ///   - Message: error description
        case error(objectId: any WlProxy, code: UInt32, message: String)
        
        /// Acknowledge Object Id Deletion
        /// 
        /// This event is used internally by the object ID management
        /// logic. When a client deletes an object that it had created,
        /// the server will send this event to acknowledge that it has
        /// seen the delete request. When the client receives this event,
        /// it will know that it can safely reuse the object ID.
        /// 
        /// - Parameters:
        ///   - Id: deleted object ID
        case deleteId(id: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.error(objectId: connection.get(id: r.readObjectId())!, code: r.readUInt(), message: r.readString())
            case 1:
                return Self.deleteId(id: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
