import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

/// Surface Cropping And Scaling
/// 
/// The global interface exposing surface cropping and scaling
/// capabilities is used to instantiate an interface extension for a
/// wl_surface object. This extended interface will then allow
/// cropping and scaling the surface contents, effectively
/// disconnecting the direct relationship between the buffer and the
/// surface size.
public final class WpViewporter: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_viewporter",
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
                    name: "get_viewport",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_viewport"
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
    /// Unbind From The Cropping And Scaling Interface
    /// 
    /// Informs the server that the client will not be using this
    /// protocol object anymore. This does not affect any other objects,
    /// wp_viewport objects included.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Extend Surface Interface For Crop And Scale
    /// 
    /// Instantiate an interface extension for the given wl_surface to
    /// crop and scale its content. If the given wl_surface already has
    /// a wp_viewport object associated, the viewport_exists
    /// protocol error is raised.
    /// 
    /// - Parameters:
    ///   - surface: the surface
    /// 
    /// - Returns: the new viewport interface id
    public func getViewport(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpViewport {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpViewport.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: Viewporter)
    }
    
    public enum Error: UInt32 {
        /// the surface already has a viewport object associated
        case viewportExists = 0
    }

    public typealias Event = NoEvent
}
/// Crop And Scale Interface To A Wl_Surface
/// 
/// An additional interface to a wl_surface object, which allows the
/// client to specify the cropping and scaling of the surface
/// contents.
/// This interface works with two concepts: the source rectangle (src_x,
/// src_y, src_width, src_height), and the destination size (dst_width,
/// dst_height). The contents of the source rectangle are scaled to the
/// destination size, and content outside the source rectangle is ignored.
/// This state is double-buffered, see wl_surface.commit.
/// The two parts of crop and scale state are independent: the source
/// rectangle, and the destination size. Initially both are unset, that
/// is, no scaling is applied. The whole of the current wl_buffer is
/// used as the source, and the surface size is as defined in
/// wl_surface.attach.
/// If the destination size is set, it causes the surface size to become
/// dst_width, dst_height. The source (rectangle) is scaled to exactly
/// this size. This overrides whatever the attached wl_buffer size is,
/// unless the wl_buffer is NULL. If the wl_buffer is NULL, the surface
/// has no content and therefore no size. Otherwise, the size is always
/// at least 1x1 in surface local coordinates.
/// If the source rectangle is set, it defines what area of the wl_buffer is
/// taken as the source. If the source rectangle is set and the destination
/// size is not set, then src_width and src_height must be integers, and the
/// surface size becomes the source rectangle size. This results in cropping
/// without scaling. If src_width or src_height are not integers and
/// destination size is not set, the bad_size protocol error is raised when
/// the surface state is applied.
/// The coordinate transformations from buffer pixel coordinates up to
/// the surface-local coordinates happen in the following order:
/// 1. buffer_transform (wl_surface.set_buffer_transform)
/// 2. buffer_scale (wl_surface.set_buffer_scale)
/// 3. crop and scale (wp_viewport.set*)
/// This means, that the source rectangle coordinates of crop and scale
/// are given in the coordinates after the buffer transform and scale,
/// i.e. in the coordinates that would be the surface-local coordinates
/// if the crop and scale was not applied.
/// If src_x or src_y are negative, the bad_value protocol error is raised.
/// Otherwise, if the source rectangle is partially or completely outside of
/// the non-NULL wl_buffer, then the out_of_buffer protocol error is raised
/// when the surface state is applied. A NULL wl_buffer does not raise the
/// out_of_buffer error.
/// If the wl_surface associated with the wp_viewport is destroyed,
/// all wp_viewport requests except 'destroy' raise the protocol error
/// no_surface.
/// If the wp_viewport object is destroyed, the crop and scale
/// state is removed from the wl_surface. The change will be applied
/// on the next wl_surface.commit.
public final class WpViewport: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_viewport",
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
                    name: "set_source",
                    arguments: [
                    Argument(
                        name: "x",
                        type: .fixed,
                    ),
                    Argument(
                        name: "y",
                        type: .fixed,
                    ),
                    Argument(
                        name: "width",
                        type: .fixed,
                    ),
                    Argument(
                        name: "height",
                        type: .fixed,
                    ),
                    ],
                ),
                Message(
                    name: "set_destination",
                    arguments: [
                    Argument(
                        name: "width",
                        type: .int,
                    ),
                    Argument(
                        name: "height",
                        type: .int,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Remove Scaling And Cropping From The Surface
    /// 
    /// The associated wl_surface's crop and scale state is removed.
    /// The change is applied on the next wl_surface.commit.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Source Rectangle For Cropping
    /// 
    /// Set the source rectangle of the associated wl_surface. See
    /// wp_viewport for the description, and relation to the wl_buffer
    /// size.
    /// If all of x, y, width and height are -1.0, the source rectangle is
    /// unset instead. Any other set of values where width or height are zero
    /// or negative, or x or y are negative, raise the bad_value protocol
    /// error.
    /// The crop and scale state is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - x: source rectangle x
    ///   - y: source rectangle y
    ///   - width: source rectangle width
    ///   - height: source rectangle height
    public func setSource(x: Double, y: Double, width: Double, height: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .fixed(x),
            .fixed(y),
            .fixed(width),
            .fixed(height),
        ])
    }

    /// Set The Surface Size For Scaling
    /// 
    /// Set the destination size of the associated wl_surface. See
    /// wp_viewport for the description, and relation to the wl_buffer
    /// size.
    /// If width is -1 and height is -1, the destination size is unset
    /// instead. Any other pair of values for width and height that
    /// contains zero or negative values raises the bad_value protocol
    /// error.
    /// The crop and scale state is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - width: surface width
    ///   - height: surface height
    public func setDestination(width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(width),
            .int(height),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: Viewporter)
    }
    
    public enum Error: UInt32 {
        /// negative or zero values in width or height
        case badValue = 0

        /// destination size is not integer
        case badSize = 1

        /// source rectangle extends outside of the content area
        case outOfBuffer = 2

        /// the wl_surface was destroyed
        case noSurface = 3
    }

    public typealias Event = NoEvent
}

public let Viewporter = Protocol(
        name: "viewporter",
        interfaces: [
            WpViewporter.interface,
WpViewport.interface
        ]
    )
