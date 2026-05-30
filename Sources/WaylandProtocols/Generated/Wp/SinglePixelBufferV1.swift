import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Global Factory For Single-Pixel Buffers
/// 
/// The wp_single_pixel_buffer_manager_v1 interface is a factory for
/// single-pixel buffers.
public final class WpSinglePixelBufferManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_single_pixel_buffer_manager_v1",
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
                    name: "create_u32_rgba_buffer",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wl_buffer"
                    ),
                    Argument(
                        name: "r",
                        type: .uint,
                    ),
                    Argument(
                        name: "g",
                        type: .uint,
                    ),
                    Argument(
                        name: "b",
                        type: .uint,
                    ),
                    Argument(
                        name: "a",
                        type: .uint,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Manager
    /// 
    /// Destroy the wp_single_pixel_buffer_manager_v1 object.
    /// The child objects created via this interface are unaffected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A 1×1 Buffer From 32-Bit Rgba Values
    /// 
    /// Create a single-pixel buffer from four 32-bit RGBA values.
    /// Unless specified in another protocol extension, the RGBA values use
    /// pre-multiplied alpha.
    /// The width and height of the buffer are 1.
    /// The r, g, b and a arguments valid range is from UINT32_MIN (0)
    /// to UINT32_MAX (0xffffffff).
    /// 
    /// These arguments should be interpreted as a percentage, i.e.
    /// - UINT32_MIN = 0% of the given color component
    /// - UINT32_MAX = 100% of the given color component
    /// 
    /// - Parameters:
    ///   - r: value of the buffer's red channel
    ///   - g: value of the buffer's green channel
    ///   - b: value of the buffer's blue channel
    ///   - a: value of the buffer's alpha channel
    public func createU32RgbaBuffer(r: UInt32, g: UInt32, b: UInt32, a: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WlBuffer {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlBuffer.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .uint(r),
            .uint(g),
            .uint(b),
            .uint(a),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: SinglePixelBufferV1Protocol)
    }
    
    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}

public let SinglePixelBufferV1Protocol = Protocol(
        name: "single_pixel_buffer_v1",
        interfaces: [
            WpSinglePixelBufferManagerV1.interface
        ]
    )

#endif