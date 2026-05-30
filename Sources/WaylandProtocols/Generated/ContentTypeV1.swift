import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if STAGING
/// Surface Content Type Manager
/// 
/// This interface allows a client to describe the kind of content a surface
/// will display, to allow the compositor to optimize its behavior for it.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpContentTypeManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_content_type_manager_v1",
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
                    name: "get_surface_content_type",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_content_type_v1"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Content Type Manager Object
    /// 
    /// Destroy the content type manager. This doesn't destroy objects created
    /// with the manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Create A New Content Type Object
    /// 
    /// Create a new content type object associated with the given surface.
    /// Creating a wp_content_type_v1 from a wl_surface which already has one
    /// attached is a client error: already_constructed.
    /// 
    /// - Parameters:
    public func getSurfaceContentType(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpContentTypeV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpContentTypeV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ContentTypeV1)
    }
    
    public enum Error: UInt32 {
        /// wl_surface already has a content type object
        case alreadyConstructed = 0
    }

    public typealias Event = NoEvent
}
/// Content Type Object For A Surface
/// 
/// The content type object allows the compositor to optimize for the kind
/// of content shown on the surface. A compositor may for example use it to
/// set relevant drm properties like "content type".
/// The client may request to switch to another content type at any time.
/// When the associated surface gets destroyed, this object becomes inert and
/// the client should destroy it.
public final class WpContentTypeV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_content_type_v1",
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
                    name: "set_content_type",
                    arguments: [
                    Argument(
                        name: "content_type",
                        type: .uint,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Content Type Object
    /// 
    /// Switch back to not specifying the content type of this surface. This is
    /// equivalent to setting the content type to none, including double
    /// buffering semantics. See set_content_type for details.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Specify The Content Type
    /// 
    /// Set the surface content type. This informs the compositor that the
    /// client believes it is displaying buffers matching this content type.
    /// This is purely a hint for the compositor, which can be used to adjust
    /// its behavior or hardware settings to fit the presented content best.
    /// The content type is double-buffered state, see wl_surface.commit for
    /// details.
    /// 
    /// - Parameters:
    ///   - contentType: the content type
    public func setContentType(contentType: Type) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(contentType.rawValue),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ContentTypeV1)
    }
    
    public enum `Type`: UInt32 {
        case `none` = 0

        case photo = 1

        case video = 2

        case game = 3
    }

    public typealias Event = NoEvent
}

public let ContentTypeV1 = Protocol(
        name: "content_type_v1",
        interfaces: [
            WpContentTypeManagerV1.interface,
WpContentTypeV1.interface
        ]
    )

#endif