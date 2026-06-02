import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
public final class WlEglstreamController: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wl_eglstream_controller",
            version: 2,
            requests: [
                Message(
                    name: "attach_eglstream_consumer",
                    arguments: [
                        Argument(
                            name: "wl_surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "wl_resource",
                            type: .object,
                            interface: "wl_buffer",
                        ),
                    ],
                    since: 1
                ),
                Message(
                    name: "attach_eglstream_consumer_attribs",
                    arguments: [
                        Argument(
                            name: "wl_surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "wl_resource",
                            type: .object,
                            interface: "wl_buffer",
                        ),
                        Argument(
                            name: "attribs",
                            type: .array,
                        ),
                    ],
                    since: 2
                ),
            ],
        )
    /// Create Server Stream And Attach Consumer
    /// 
    /// Creates the corresponding server side EGLStream from the given wl_buffer
    /// and attaches a consumer to it.
    /// 
    /// - Parameters:
    ///   - wlSurface: wl_surface corresponds to the client surface associated with         newly created eglstream
    ///   - wlResource: wl_resource corresponding to an EGLStream
    public func attachEglstreamConsumer(wlSurface: WlSurface, wlResource: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 1 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 1) }
        connection.send(self, 0, [
            .object(wlSurface.id),
            .object(wlResource.id),
        ])
    }

    /// Create Server Stream And Attach Consumer Using Attributes
    /// 
    /// Creates the corresponding server side EGLStream from the given wl_buffer
    /// and attaches a consumer to it using the given attributes.
    /// 
    /// - Parameters:
    ///   - wlSurface: wl_surface corresponds to the client surface associated with         newly created eglstream
    ///   - wlResource: wl_resource corresponding to an EGLStream
    ///   - attribs: Stream consumer attachment attribs
    public func attachEglstreamConsumerAttribs(wlSurface: WlSurface, wlResource: WlBuffer, attribs: Data) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 1, [
            .object(wlSurface.id),
            .object(wlResource.id),
            .array(attribs),
        ])
    }

    
    public static let `protocol`: Protocol = WlEglstreamControllerProtocol
    
    public enum PresentMode: UInt32 {
        /// Let the Server decide present mode
        case dontCare = 0

        /// Use a fifo present mode
        case fifo = 1

        /// Use a mailbox mode
        case mailbox = 2
    }

    public enum Attrib: UInt32 {
        /// Tells the server the desired present mode
        case presentMode = 0

        /// Tells the server the desired fifo length when the desired presenation_mode is fifo.
        case fifoLength = 1
    }

    public typealias Event = NoEvent
}


public let WlEglstreamControllerProtocol = Protocol(
        name: "wl_eglstream_controller",
        interfaces: [
            WlEglstreamController.interface
        ]
    )

#endif