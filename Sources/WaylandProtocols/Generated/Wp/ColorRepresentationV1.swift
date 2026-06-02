import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Color Representation Manager Singleton
/// 
/// A singleton global interface used for getting color representation
/// extensions for wl_surface. The extension interfaces allow setting the
/// color representation of surfaces.
/// Compositors should never remove this global.
public final class WpColorRepresentationManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_color_representation_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "get_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_color_representation_surface_v1",
                        ),
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                    ],
                ),
            ],
            events: [
                Message(
                    name: "supported_alpha_mode",
                    arguments: [
                        Argument(
                            name: "alpha_mode",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "supported_coefficients_and_ranges",
                    arguments: [
                        Argument(
                            name: "coefficients",
                            type: .uint,
                        ),
                        Argument(
                            name: "range",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [],
                ),
            ]
        )
    /// Destroy The Manager
    /// 
    /// Destroy the wp_color_representation_manager_v1 object. This does not
    /// affect any other objects in any way.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A Color Representation Interface For A Wl_Surface
    /// 
    /// If a wp_color_representation_surface_v1 object already exists for the
    /// given wl_surface, the protocol error surface_exists is raised.
    /// This creates a new color wp_color_representation_surface_v1 object for
    /// the given wl_surface.
    /// See the wp_color_representation_surface_v1 interface for more details.
    /// 
    /// - Parameters:
    public func getSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpColorRepresentationSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorRepresentationSurfaceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorRepresentationV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// color representation surface exists already
        case surfaceExists = 1
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

    public enum Event: Decodable {
        /// Supported Alpha Modes
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each alpha mode the compositor supports.
        /// For the definition of the supported values, see the
        /// wp_color_representation_surface_v1::alpha_mode enum.
        case supportedAlphaMode(alphaMode: WpColorRepresentationSurfaceV1.AlphaMode)

        /// Supported Matrix Coefficients And Ranges
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each matrix coefficient and color range combination the compositor
        /// supports.
        /// For the definition of the supported values, see the
        /// wp_color_representation_surface_v1::coefficients and
        /// wp_color_representation_surface_v1::range enums.
        case supportedCoefficientsAndRanges(coefficients: WpColorRepresentationSurfaceV1.Coefficients, range: WpColorRepresentationSurfaceV1.Range)

        /// All Features Have Been Sent
        /// 
        /// This event is sent when all supported features have been sent.
        case done

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.supportedAlphaMode(alphaMode: try _parseEnum(into: WpColorRepresentationSurfaceV1.AlphaMode.self, r.uint()))
            case 1:
                self = Self.supportedCoefficientsAndRanges(coefficients: try _parseEnum(into: WpColorRepresentationSurfaceV1.Coefficients.self, r.uint()), range: try _parseEnum(into: WpColorRepresentationSurfaceV1.Range.self, r.uint()))
            case 2:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Color Representation Extension To A Surface
/// 
/// A wp_color_representation_surface_v1 allows the client to set the color
/// representation metadata of a surface.
/// By default, a surface does not have any color representation metadata set.
/// The reconstruction of R, G, B signals on such surfaces is compositor
/// implementation defined. The alpha mode is assumed to be
/// premultiplied_electrical when the alpha mode is unset.
/// If the wl_surface associated with the wp_color_representation_surface_v1
/// is destroyed, the wp_color_representation_surface_v1 object becomes inert.
public final class WpColorRepresentationSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_color_representation_surface_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "set_alpha_mode",
                    arguments: [
                        Argument(
                            name: "alpha_mode",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_coefficients_and_range",
                    arguments: [
                        Argument(
                            name: "coefficients",
                            type: .uint,
                        ),
                        Argument(
                            name: "range",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "set_chroma_location",
                    arguments: [
                        Argument(
                            name: "chroma_location",
                            type: .uint,
                        ),
                    ],
                ),
            ],
        )
    /// Destroy The Color Representation
    /// 
    /// Destroy the wp_color_representation_surface_v1 object.
    /// Destroying this object unsets all the color representation metadata from
    /// the surface. See the wp_color_representation_surface_v1 interface
    /// description for how a compositor handles a surface without color
    /// representation metadata. Unsetting is double-buffered state, see
    /// wl_surface.commit.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Surface Alpha Mode
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// Assuming an alpha channel exists, it is always linear. The alpha mode
    /// determines whether and how the color channels include pre-multiplied
    /// alpha. Using straight alpha might have performance benefits.
    /// Only alpha modes advertised by the compositor are allowed to be used as
    /// argument for this request. The "alpha_mode" protocol error is raised
    /// otherwise.
    /// Alpha mode is double buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - _: alpha mode
    public func setAlphaMode(_ alphaMode: AlphaMode) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(alphaMode.rawValue),
        ])
    }

    /// Set The Matrix Coefficients And Range
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// Set the matrix coefficients and video range which defines the formula
    /// and the related constants used to derive red, green and blue signals.
    /// Usually coefficients correspond to MatrixCoefficients code points in
    /// H.273.
    /// Only combinations advertised by the compositor are allowed to be used as
    /// argument for this request. The "coefficients" protocol error is raised
    /// otherwise.
    /// A call to wl_surface.commit verifies that the pixel format and the
    /// coefficients-range combination in the committed surface contents are
    /// compatible, if contents exist. The "pixel_format" protocol error is
    /// raised otherwise.
    /// A pixel format is compatible with the coefficients-range combination if
    /// the related equations and conventions as defined in H.273 can produce
    /// the color channels (RGB or YCbCr) of the pixel format.
    /// For the definition of the supported combination, see the
    /// wp_color_representation_surface_v1::coefficients and
    /// wp_color_representation_surface_v1::range enums.
    /// The coefficients-range combination is double-buffered, see
    /// wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - coefficients: matrix coefficients
    ///   - range: range
    public func setCoefficientsAndRange(coefficients: Coefficients, range: Range) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .uint(coefficients.rawValue),
            .uint(range.rawValue),
        ])
    }

    /// Set The Chroma Location
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// Set the chroma location type which defines the position of downsampled
    /// chroma samples, corresponding to Chroma420SampleLocType code points in
    /// H.273.
    /// An invalid chroma location enum value raises the "chroma_location"
    /// protocol error.
    /// A call to wl_surface.commit verifies that the pixel format and chroma
    /// location type in the committed surface contents are compatible, if
    /// contents exist. The "pixel_format" protocol error is raised otherwise.
    /// For the definition of the supported chroma location types, see the
    /// wp_color_representation_surface_v1::chroma_location enum.
    /// The chroma location type is double-buffered, see wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - _: chroma sample location
    public func setChromaLocation(_ chromaLocation: ChromaLocation) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(chromaLocation.rawValue),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorRepresentationV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// unsupported alpha mode
        case alphaMode = 1

        /// unsupported coefficients
        case coefficients = 2

        /// the pixel format and a set value are incompatible
        case pixelFormat = 3

        /// forbidden request on inert object
        case inert = 4

        /// invalid chroma location
        case chromaLocation = 5
    }

    public enum AlphaMode: UInt32 {
        case premultipliedElectrical = 0

        case premultipliedOptical = 1

        case straight = 2
    }

    public enum Coefficients: UInt32 {
        case identity = 1

        case bt709 = 2

        case fcc = 3

        case bt601 = 4

        case smpte240 = 5

        case bt2020 = 6

        case bt2020Cl = 7

        case ictcp = 8
    }

    public enum Range: UInt32 {
        /// Full color range
        case full = 1

        /// Limited color range
        case limited = 2
    }

    public enum ChromaLocation: UInt32 {
        case type0 = 1

        case type1 = 2

        case type2 = 3

        case type3 = 4

        case type4 = 5

        case type5 = 6
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


public let ColorRepresentationV1Protocol = Protocol(
        name: "color_representation_v1",
        interfaces: [
            WpColorRepresentationManagerV1.interface,
WpColorRepresentationSurfaceV1.interface
        ]
    )

#endif