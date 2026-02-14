import Foundation
import SwiftWayland

/// Client Security Context Manager
/// 
/// This interface allows a client to register a new Wayland connection to
/// the compositor and attach a security context to it.
/// This is intended to be used by sandboxes. Sandbox engines attach a
/// security context to all connections coming from inside the sandbox. The
/// compositor can then restrict the features that the sandboxed connections
/// can use.
/// Compositors should forbid nesting multiple security contexts by not
/// exposing wp_security_context_manager_v1 global to clients with a security
/// context attached, or by sending the nested protocol error. Nested
/// security contexts are dangerous because they can potentially allow
/// privilege escalation of a sandboxed client.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpSecurityContextManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_security_context_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Manager Object
    /// 
    /// Destroy the manager. This doesn't destroy objects created with the
    /// manager.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A New Security Context
    /// 
    /// Creates a new security context with a socket listening FD.
    /// The compositor will accept new client connections on listen_fd.
    /// listen_fd must be ready to accept new connections when this request is
    /// sent by the client. In other words, the client must call bind(2) and
    /// listen(2) before sending the FD.
    /// close_fd is a FD that will signal hangup when the compositor should stop
    /// accepting new connections on listen_fd.
    /// The compositor must continue to accept connections on listen_fd when
    /// the Wayland client which created the security context disconnects.
    /// After sending this request, closing listen_fd and close_fd remains the
    /// only valid operation on them.
    /// 
    /// - Parameters:
    ///   - ListenFd: listening socket FD
    ///   - CloseFd: FD signaling when done
    public func createListener(listenFd: FileHandle, closeFd: FileHandle) throws(WaylandProxyError) -> WpSecurityContextV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpSecurityContextV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id),
            WaylandData.fd(listenFd),
            WaylandData.fd(closeFd)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Listening Socket Fd Is Invalid
        case invalidListenFd = 1
        
        /// Nested Security Contexts Are Forbidden
        case nested = 2
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
