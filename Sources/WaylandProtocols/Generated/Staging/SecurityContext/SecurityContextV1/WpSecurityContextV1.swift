import Foundation
import SwiftWayland

/// Client Security Context
/// 
/// The security context allows a client to register a new client and attach
/// security context metadata to the connections.
/// When both are set, the combination of the application ID and the sandbox
/// engine must uniquely identify an application. The same application ID
/// will be used across instances (e.g. if the application is restarted, or
/// if the application is started multiple times).
/// When both are set, the combination of the instance ID and the sandbox
/// engine must uniquely identify a running instance of an application.
public final class WpSecurityContextV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_security_context_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Security Context Object
    /// 
    /// Destroy the security context object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set The Sandbox Engine
    /// 
    /// Attach a unique sandbox engine name to the security context. The name
    /// should follow the reverse-DNS style (e.g. "org.flatpak").
    /// A list of well-known engines is maintained at:
    /// https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/main/staging/security-context/engines.md
    /// It is a protocol error to call this request twice. The already_set
    /// error is sent in this case.
    /// 
    /// - Parameters:
    ///   - Name: the sandbox engine name
    public func setSandboxEngine(name: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.string(name)
        ])
        connection.send(message: message)
    }
    
    /// Set The Application Id
    /// 
    /// Attach an application ID to the security context.
    /// The application ID is an opaque, sandbox-specific identifier for an
    /// application. See the well-known engines document for more details:
    /// https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/main/staging/security-context/engines.md
    /// The compositor may use the application ID to group clients belonging to
    /// the same security context application.
    /// Whether this request is optional or not depends on the sandbox engine used.
    /// It is a protocol error to call this request twice. The already_set
    /// error is sent in this case.
    /// 
    /// - Parameters:
    ///   - AppId: the application ID
    public func setAppId(appId: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.string(appId)
        ])
        connection.send(message: message)
    }
    
    /// Set The Instance Id
    /// 
    /// Attach an instance ID to the security context.
    /// The instance ID is an opaque, sandbox-specific identifier for a running
    /// instance of an application. See the well-known engines document for
    /// more details:
    /// https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/main/staging/security-context/engines.md
    /// Whether this request is optional or not depends on the sandbox engine used.
    /// It is a protocol error to call this request twice. The already_set
    /// error is sent in this case.
    /// 
    /// - Parameters:
    ///   - InstanceId: the instance ID
    public func setInstanceId(instanceId: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.string(instanceId)
        ])
        connection.send(message: message)
    }
    
    /// Register The Security Context
    /// 
    /// Atomically register the new client and attach the security context
    /// metadata.
    /// If the provided metadata is inconsistent or does not match with out of
    /// band metadata (see
    /// https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/main/staging/security-context/engines.md),
    /// the invalid_metadata error may be sent eventually.
    /// It's a protocol error to send any request other than "destroy" after
    /// this request. In this case, the already_used error is sent.
    public func commit() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Security Context Has Already Been Committed
        case alreadyUsed = 1
        
        /// Metadata Has Already Been Set
        case alreadySet = 2
        
        /// Metadata Is Invalid
        case invalidMetadata = 3
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
