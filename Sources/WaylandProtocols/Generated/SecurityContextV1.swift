import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if STAGING
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
public final class WpSecurityContextManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_security_context_manager_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "create_listener",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_security_context_v1"
                    ),
                    Argument(
                        name: "listen_fd",
                        type: .fd,
                    ),
                    Argument(
                        name: "close_fd",
                        type: .fd,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Manager Object
    /// 
    /// Destroy the manager. This doesn't destroy objects created with the
    /// manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
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
    ///   - listenFd: listening socket FD
    ///   - closeFd: FD signaling when done
    public func createListener(listenFd: FileHandle, closeFd: FileHandle, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpSecurityContextV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpSecurityContextV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .fd(listenFd),
            .fd(closeFd),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: SecurityContextV1)
    }
    
    public enum Error: UInt32 {
        /// listening socket FD is invalid
        case invalidListenFd = 1

        /// nested security contexts are forbidden
        case nested = 2
    }

    public typealias Event = NoEvent
}
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
public final class WpSecurityContextV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_security_context_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_sandbox_engine",
                    arguments: [
                    Argument(
                        name: "name",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "set_app_id",
                    arguments: [
                    Argument(
                        name: "app_id",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "set_instance_id",
                    arguments: [
                    Argument(
                        name: "instance_id",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "commit",
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Security Context Object
    /// 
    /// Destroy the security context object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
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
    ///   - name: the sandbox engine name
    public func setSandboxEngine(name: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .string(name),
        ])
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
    ///   - appId: the application ID
    public func setAppId(appId: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .string(appId),
        ])
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
    ///   - instanceId: the instance ID
    public func setInstanceId(instanceId: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .string(instanceId),
        ])
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
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: SecurityContextV1)
    }
    
    public enum Error: UInt32 {
        /// security context has already been committed
        case alreadyUsed = 1

        /// metadata has already been set
        case alreadySet = 2

        /// metadata is invalid
        case invalidMetadata = 3
    }

    public typealias Event = NoEvent
}

public let SecurityContextV1 = Protocol(
        name: "security_context_v1",
        interfaces: [
            WpSecurityContextManagerV1.interface,
WpSecurityContextV1.interface
        ]
    )

#endif