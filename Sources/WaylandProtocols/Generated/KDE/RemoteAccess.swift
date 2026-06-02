import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Protocol For Managing Rendered Gbm Buffers Passing
/// 
/// 
public final class KdeRemoteAccessManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_remote_access_manager",
            version: 1,
            requests: [
                Message(
                    name: "get_buffer",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .newId,
                            interface: "org_kde_kwin_remote_buffer",
                        ),
                        Argument(
                            name: "internal_buffer_id",
                            type: .int,
                        ),
                    ],
                    since: 1
                ),
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "buffer_ready",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .int,
                        ),
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        ),
                    ],
                    since: 1
                ),
            ]
        )
    /// Answer On Buffer_Ready Event, Retrieves New Buffer From Server
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - internalBufferId: The internal buffer id of the buffer to create
    public func getBuffer(internalBufferId: Int32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeRemoteBuffer {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 1 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 1) }
        let buffer = connection.createProxy(type: KdeRemoteBuffer.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(buffer.id),
            .int(internalBufferId),
        ])
        return buffer
    }

    /// Release Org_Kde_Kwin_Remote_Access_Manager Interface
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = RemoteAccessProtocol
    
    var destructor: Destructor? = .release

    enum Destructor {
        case release
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .release: try? self.release()
                case nil: break
            }
        }
    }

    public enum Event: Decodable {
        /// Signals About Buffer Ready To Be Consumed By Clients
        /// 
        /// 
        case bufferReady(id: Int32, output: WlOutput)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.bufferReady(id: r.int(), output: r.object(type: WlOutput.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// This Interface Allows Finer Control Of Remote Buffer Lifecycle
/// 
/// 
public final class KdeRemoteBuffer: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_remote_buffer",
            version: 1,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [],
                    since: 1
                ),
            ],
            events: [
                Message(
                    name: "gbm_handle",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
                        ),
                        Argument(
                            name: "width",
                            type: .uint,
                        ),
                        Argument(
                            name: "height",
                            type: .uint,
                        ),
                        Argument(
                            name: "stride",
                            type: .uint,
                        ),
                        Argument(
                            name: "format",
                            type: .uint,
                        ),
                    ],
                    since: 1
                ),
            ]
        )
    /// This Request Comes Once Client No Longer Needs This Buffer.
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 1 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 1) }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = RemoteAccessProtocol
    
    var destructor: Destructor? = .release

    enum Destructor {
        case release
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .release: try? self.release()
                case nil: break
            }
        }
    }

    public enum Event: Decodable {
        /// This Is Sent After Binding To Remote Access Manager
        /// 
        /// 
        case gbmHandle(fd: FileHandle, width: UInt32, height: UInt32, stride: UInt32, format: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.gbmHandle(fd: r.fd(), width: r.uint(), height: r.uint(), stride: r.uint(), format: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let RemoteAccessProtocol = Protocol(
        name: "remote_access",
        interfaces: [
            KdeRemoteAccessManager.interface,
KdeRemoteBuffer.interface
        ]
    )

#endif