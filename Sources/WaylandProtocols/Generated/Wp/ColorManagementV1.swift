import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
/// Color Manager Singleton
/// 
/// A singleton global interface used for getting color management extensions
/// for wl_surface and wl_output objects, and for creating client defined
/// image description objects. The extension interfaces allow
/// getting the image description of outputs and setting the image
/// description of surfaces.
/// Compositors should never remove this global.
public final class WpColorManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_color_manager_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_output",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_color_management_output_v1"
                    ),
                    Argument(
                        name: "output",
                        type: .object,
                        interface: "wl_output"
                    ),
                    ],
                ),
                Message(
                    name: "get_surface",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_color_management_surface_v1"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "get_surface_feedback",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "wp_color_management_surface_feedback_v1"
                    ),
                    Argument(
                        name: "surface",
                        type: .object,
                        interface: "wl_surface"
                    ),
                    ],
                ),
                Message(
                    name: "create_icc_creator",
                    arguments: [
                    Argument(
                        name: "obj",
                        type: .newId,
                        interface: "wp_image_description_creator_icc_v1"
                    ),
                    ],
                ),
                Message(
                    name: "create_parametric_creator",
                    arguments: [
                    Argument(
                        name: "obj",
                        type: .newId,
                        interface: "wp_image_description_creator_params_v1"
                    ),
                    ],
                ),
                Message(
                    name: "create_windows_scrgb",
                    arguments: [
                    Argument(
                        name: "image_description",
                        type: .newId,
                        interface: "wp_image_description_v1"
                    ),
                    ],
                ),
                Message(
                    name: "get_image_description",
                    arguments: [
                    Argument(
                        name: "image_description",
                        type: .newId,
                        interface: "wp_image_description_v1"
                    ),
                    Argument(
                        name: "reference",
                        type: .object,
                        interface: "wp_image_description_reference_v1"
                    ),
                    ],
                    since: 2
                ),
                Message(
                    name: "create_windows_bt2100",
                    arguments: [
                    Argument(
                        name: "image_description",
                        type: .newId,
                        interface: "wp_image_description_v1"
                    ),
                    ],
                    since: 3
                ),
                ],
            events: [
                Message(
                    name: "supported_intent",
                    arguments: [
                    Argument(
                        name: "render_intent",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "supported_feature",
                    arguments: [
                    Argument(
                        name: "feature",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "supported_tf_named",
                    arguments: [
                    Argument(
                        name: "tf",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "supported_primaries_named",
                    arguments: [
                    Argument(
                        name: "primaries",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                    ],
                ),
                ],
        )
    /// Destroy The Color Manager
    /// 
    /// Destroy the wp_color_manager_v1 object. This does not affect any other
    /// objects in any way.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A Color Management Interface For A Wl_Output
    /// 
    /// This creates a new wp_color_management_output_v1 object for the
    /// given wl_output.
    /// See the wp_color_management_output_v1 interface for more details.
    /// 
    /// - Parameters:
    public func getOutput(output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpColorManagementOutputV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorManagementOutputV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(output.id),
        ])
        return id
    }

    /// Create A Color Management Interface For A Wl_Surface
    /// 
    /// If a wp_color_management_surface_v1 object already exists for the given
    /// wl_surface, the protocol error surface_exists is raised.
    /// This creates a new color wp_color_management_surface_v1 object for the
    /// given wl_surface.
    /// See the wp_color_management_surface_v1 interface for more details.
    /// 
    /// - Parameters:
    public func getSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpColorManagementSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorManagementSurfaceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// Create A Color Management Feedback Interface
    /// 
    /// This creates a new color wp_color_management_surface_feedback_v1 object
    /// for the given wl_surface.
    /// See the wp_color_management_surface_feedback_v1 interface for more
    /// details.
    /// 
    /// - Parameters:
    public func getSurfaceFeedback(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpColorManagementSurfaceFeedbackV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WpColorManagementSurfaceFeedbackV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 3, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// Make A New Icc-Based Image Description Creator Object
    /// 
    /// Makes a new ICC-based image description creator object with all
    /// properties initially unset. The client can then use the object's
    /// interface to define all the required properties for an image description
    /// and finally create a wp_image_description_v1 object.
    /// This request can be used when the compositor advertises
    /// wp_color_manager_v1.feature.icc_v2_v4.
    /// Otherwise this request raises the protocol error unsupported_feature.
    /// 
    /// - Returns: the new creator object
    public func createIccCreator(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionCreatorIccV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let obj = connection.createProxy(type: WpImageDescriptionCreatorIccV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 4, [
            .object(obj.id),
        ])
        return obj
    }

    /// Make A New Parametric Image Description Creator Object
    /// 
    /// Makes a new parametric image description creator object with all
    /// properties initially unset. The client can then use the object's
    /// interface to define all the required properties for an image description
    /// and finally create a wp_image_description_v1 object.
    /// This request can be used when the compositor advertises
    /// wp_color_manager_v1.feature.parametric.
    /// Otherwise this request raises the protocol error unsupported_feature.
    /// 
    /// - Returns: the new creator object
    public func createParametricCreator(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionCreatorParamsV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let obj = connection.createProxy(type: WpImageDescriptionCreatorParamsV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 5, [
            .object(obj.id),
        ])
        return obj
    }

    /// Create Windows-Scrgb Image Description Object
    /// 
    /// This creates a pre-defined image description for the so-called
    /// Windows-scRGB stimulus encoding. This comes from the Windows 10 handling
    /// of its own definition of an scRGB color space for an HDR screen
    /// driven in BT.2100/PQ signalling mode.
    /// Windows-scRGB uses sRGB (BT.709) color primaries and white point.
    /// The transfer characteristic is extended linear.
    /// The nominal color channel value range is extended, meaning it includes
    /// negative and greater than 1.0 values. Negative values are used to
    /// escape the sRGB color gamut boundaries. To make use of the extended
    /// range, the client needs to use a pixel format that can represent those
    /// values, e.g. floating-point 16 bits per channel.
    /// Nominal color value R=G=B=0.0 corresponds to BT.2100/PQ system
    /// 0 cd/m², and R=G=B=1.0 corresponds to BT.2100/PQ system 80 cd/m².
    /// The maximum is R=G=B=125.0 corresponding to 10k cd/m².
    /// Windows-scRGB is displayed by Windows 10 by converting it to
    /// BT.2100/PQ, maintaining the CIE 1931 chromaticity and mapping the
    /// luminance as above. No adjustment is made to the signal to account
    /// for the viewing conditions.
    /// The reference white level of Windows-scRGB is unknown. If a
    /// reference white level must be assumed for compositor processing, it
    /// should be R=G=B=2.5375 corresponding to 203 cd/m² of Report ITU-R
    /// BT.2408-7.
    /// The target color volume of Windows-scRGB is unknown. The color gamut
    /// may be anything between sRGB and BT.2100.
    /// Note: EGL_EXT_gl_colorspace_scrgb_linear definition differs from
    /// Windows-scRGB by using R=G=B=1.0 as the reference white level, while
    /// Windows-scRGB reference white level is unknown or varies. However,
    /// it seems probable that Windows implements both
    /// EGL_EXT_gl_colorspace_scrgb_linear and Vulkan
    /// VK_COLOR_SPACE_EXTENDED_SRGB_LINEAR_EXT as Windows-scRGB.
    /// This request can be used when the compositor advertises
    /// wp_color_manager_v1.feature.windows_scrgb.
    /// Otherwise this request raises the protocol error unsupported_feature.
    /// The resulting image description object does not allow get_information
    /// request. The wp_image_description_v1.ready event shall be sent.
    public func createWindowsScrgb(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 6, [
            .object(imageDescription.id),
        ])
        return imageDescription
    }

    /// Create An Image Description From A Reference
    /// 
    /// This request retrieves the image description backing a reference.
    /// The get_information request can be used if and only if the request that
    /// creates the reference allows it.
    /// 
    /// - Parameters:
    public func getImageDescription(reference: WpImageDescriptionReferenceV1, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 7, [
            .object(imageDescription.id),
            .object(reference.id),
        ])
        return imageDescription
    }

    /// Create Windows-Bt.2100 Image Description Object
    /// 
    /// This creates a pre-defined image description for the so-called
    /// Windows-BT.2100 stimulus encoding. This comes from the Windows 10
    /// handling of its own definition of a BT.2100 color space for an HDR
    /// screen driven in BT.2100/PQ signalling mode.
    /// Windows-BT.2100 uses BT.2020 color primaries and white point.
    /// The transfer characteristic is st2084_pq.
    /// Windows-BT.2100 is generally displayed by Windows 10 without any
    /// adjustments to the signal to account for viewing conditions.
    /// The reference white level of Windows-BT.2100 is unknown. If a
    /// reference white level must be assumed for compositor processing, it
    /// should be 203 cd/m² of Report ITU-R BT.2408-7.
    /// The target color volume of Windows-BT.2100 is unknown. The color gamut
    /// may be anything up to BT.2100.
    /// This request can be used when the compositor advertises
    /// wp_color_manager_v1.feature.windows_bt2100.
    /// Otherwise this request raises the protocol error unsupported_feature.
    /// The resulting image description object does not allow get_information
    /// request. The wp_image_description_v1.ready event shall be sent.
    public func createWindowsBt2100(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 8, [
            .object(imageDescription.id),
        ])
        return imageDescription
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorManagementV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// request not supported
        case unsupportedFeature = 0

        /// color management surface exists already
        case surfaceExists = 1
    }

    public enum RenderIntent: UInt32 {
        /// perceptual
        case perceptual = 0

        /// media-relative colorimetric
        case relative = 1

        /// saturation
        case saturation = 2

        /// ICC-absolute colorimetric
        case absolute = 3

        /// media-relative colorimetric + black point compensation
        case relativeBpc = 4

        case absoluteNoAdaptation = 5
    }

    public enum Feature: UInt32 {
        /// create_icc_creator request
        case iccV2V4 = 0

        /// create_parametric_creator request
        case parametric = 1

        /// parametric set_primaries request
        case setPrimaries = 2

        /// parametric set_tf_power request
        case setTfPower = 3

        /// parametric set_luminances request
        case setLuminances = 4

        case setMasteringDisplayPrimaries = 5

        case extendedTargetVolume = 6

        /// create_windows_scrgb request
        case windowsScrgb = 7

        /// create_windows_bt2100 request
        case windowsBt2100 = 8
    }

    public enum Primaries: UInt32 {
        case srgb = 1

        case palM = 2

        case pal = 3

        case ntsc = 4

        case genericFilm = 5

        case bt2020 = 6

        case cie1931Xyz = 7

        case dciP3 = 8

        case displayP3 = 9

        case adobeRgb = 10
    }

    public enum TransferFunction: UInt32 {
        case bt1886 = 1

        case gamma22 = 2

        case gamma28 = 3

        case st240 = 4

        case extLinear = 5

        case log100 = 6

        case log316 = 7

        case xvycc = 8

        case srgb = 9

        case extSrgb = 10

        case st2084Pq = 11

        case st428 = 12

        case hlg = 13

        case compoundPower24 = 14
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
        /// Supported Rendering Intent
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each rendering intent the compositor supports.
        /// A compositor must not advertise intents that are deprecated in the
        /// bound version of the interface.
        case supportedIntent(renderIntent: RenderIntent)

        /// Supported Features
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each compositor supported feature listed in the enumeration.
        /// A compositor must not advertise features that are deprecated in the
        /// bound version of the interface.
        case supportedFeature(feature: Feature)

        /// Supported Named Transfer Characteristic
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each named transfer function the compositor supports with the
        /// parametric image description creator.
        /// A compositor must not advertise transfer functions that are deprecated
        /// in the bound version of the interface.
        case supportedTfNamed(tf: TransferFunction)

        /// Supported Named Primaries
        /// 
        /// When this object is created, it shall immediately send this event once
        /// for each named set of primaries the compositor supports with the
        /// parametric image description creator.
        /// A compositor must not advertise names that are deprecated in the
        /// bound version of the interface.
        case supportedPrimariesNamed(primaries: Primaries)

        /// All Features Have Been Sent
        /// 
        /// This event is sent when all supported rendering intents, features,
        /// transfer functions and named primaries have been sent.
        case done

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.supportedIntent(renderIntent: try _parseEnum(into: RenderIntent.self, r.uint()))
            case 1:
                self = Self.supportedFeature(feature: try _parseEnum(into: Feature.self, r.uint()))
            case 2:
                self = Self.supportedTfNamed(tf: try _parseEnum(into: TransferFunction.self, r.uint()))
            case 3:
                self = Self.supportedPrimariesNamed(primaries: try _parseEnum(into: Primaries.self, r.uint()))
            case 4:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Output Color Properties
/// 
/// A wp_color_management_output_v1 describes the color properties of an
/// output.
/// The wp_color_management_output_v1 is associated with the wl_output global
/// underlying the wl_output object. Therefore the client destroying the
/// wl_output object has no impact, but the compositor removing the output
/// global makes the wp_color_management_output_v1 object inert.
public final class WpColorManagementOutputV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_color_management_output_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_image_description",
                    arguments: [
                    Argument(
                        name: "image_description",
                        type: .newId,
                        interface: "wp_image_description_v1"
                    ),
                    ],
                ),
                ],
            events: [
                Message(
                    name: "image_description_changed",
                    arguments: [
                    ],
                ),
                ],
        )
    /// Destroy The Color Management Output
    /// 
    /// Destroy the color wp_color_management_output_v1 object. This does not
    /// affect any remaining protocol objects.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Get The Image Description Of The Output
    /// 
    /// This creates a new wp_image_description_v1 object for the current image
    /// description of the output. There always is exactly one image description
    /// active for an output so the client should destroy the image description
    /// created by earlier invocations of this request. This request is usually
    /// sent as a reaction to the image_description_changed event or when
    /// creating a wp_color_management_output_v1 object.
    /// The image description of an output represents the color encoding the
    /// output expects. There might be performance and power advantages, as well
    /// as improved color reproduction, if a content update matches the image
    /// description of the output it is being shown on. If a content update is
    /// shown on any other output than the one it matches the image description
    /// of, then the color reproduction on those outputs might be considerably
    /// worse.
    /// The created wp_image_description_v1 object preserves the image
    /// description of the output from the time the object was created.
    /// The resulting image description object allows get_information request.
    /// If this protocol object is inert, the resulting image description object
    /// shall immediately deliver the wp_image_description_v1.failed event with
    /// the no_output cause.
    /// If the interface version is inadequate for the output's image
    /// description, meaning that the client does not support all the events
    /// needed to deliver the crucial information, the resulting image
    /// description object shall immediately deliver the
    /// wp_image_description_v1.failed event with the low_version cause.
    /// Otherwise the object shall immediately deliver the ready event.
    public func getImageDescription(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(imageDescription.id),
        ])
        return imageDescription
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorManagementV1Protocol)
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
        /// Image Description Changed
        /// 
        /// This event is sent whenever the image description of the output changed,
        /// followed by one wl_output.done event common to output events across all
        /// extensions.
        /// If the client wants to use the updated image description, it needs to do
        /// get_image_description again, because image description objects are
        /// immutable.
        case imageDescriptionChanged

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.imageDescriptionChanged
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Color Management Extension To A Surface
/// 
/// A wp_color_management_surface_v1 allows the client to set the color
/// space and HDR properties of a surface.
/// If the wl_surface associated with the wp_color_management_surface_v1 is
/// destroyed, the wp_color_management_surface_v1 object becomes inert.
public final class WpColorManagementSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_color_management_surface_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_image_description",
                    arguments: [
                    Argument(
                        name: "image_description",
                        type: .object,
                        interface: "wp_image_description_v1"
                    ),
                    Argument(
                        name: "render_intent",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "unset_image_description",
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Color Management Interface For A Surface
    /// 
    /// Destroy the wp_color_management_surface_v1 object and do the same as
    /// unset_image_description.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set The Surface Image Description
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// Set the image description of the underlying surface. The image
    /// description and rendering intent are double-buffered state, see
    /// wl_surface.commit.
    /// It is the client's responsibility to understand the image description
    /// it sets on a surface, and to provide content that matches that image
    /// description. Compositors might convert images to match their own or any
    /// other image descriptions.
    /// Image descriptions which are not ready (see wp_image_description_v1)
    /// are forbidden in this request, and in such case the protocol error
    /// image_description is raised.
    /// All image descriptions which are ready (see wp_image_description_v1)
    /// are allowed and must always be accepted by the compositor.
    /// When an image description is set on a surface, it establishes an
    /// explicit link between surface pixel values and surface colorimetry.
    /// This link may be undefined for some pixel values, see the image
    /// description creator interfaces for the conditions. Non-finite
    /// floating-point values (NaN, Inf) always have an undefined colorimetry.
    /// A rendering intent provides the client's preference on how surface
    /// colorimetry should be mapped to each output. The render_intent value
    /// must be one advertised by the compositor with
    /// wp_color_manager_v1.render_intent event, otherwise the protocol error
    /// render_intent is raised.
    /// By default, a surface does not have an associated image description
    /// nor a rendering intent. The handling of color on such surfaces is
    /// compositor implementation defined. Compositors should handle such
    /// surfaces as sRGB, but may handle them differently if they have specific
    /// requirements.
    /// Setting the image description has copy semantics; after this request,
    /// the image description can be immediately destroyed without affecting
    /// the pending state of the surface.
    /// 
    /// - Parameters:
    ///   - renderIntent: rendering intent
    public func setImageDescription(_ imageDescription: WpImageDescriptionV1, renderIntent: WpColorManagerV1.RenderIntent) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(imageDescription.id),
            .uint(renderIntent.rawValue),
        ])
    }

    /// Remove The Surface Image Description
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// This request removes any image description from the surface. See
    /// set_image_description for how a compositor handles a surface without
    /// an image description. This is double-buffered state, see
    /// wl_surface.commit.
    public func unsetImageDescription() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorManagementV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// unsupported rendering intent
        case renderIntent = 0

        /// invalid image description
        case imageDescription = 1

        /// forbidden request on inert object
        case inert = 2
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
/// Color Management Extension To A Surface
/// 
/// A wp_color_management_surface_feedback_v1 allows the client to get the
/// preferred image description of a surface.
/// If the wl_surface associated with this object is destroyed, the
/// wp_color_management_surface_feedback_v1 object becomes inert.
public final class WpColorManagementSurfaceFeedbackV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_color_management_surface_feedback_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_preferred",
                    arguments: [
                    Argument(
                        name: "image_description",
                        type: .newId,
                        interface: "wp_image_description_v1"
                    ),
                    ],
                ),
                Message(
                    name: "get_preferred_parametric",
                    arguments: [
                    Argument(
                        name: "image_description",
                        type: .newId,
                        interface: "wp_image_description_v1"
                    ),
                    ],
                ),
                ],
            events: [
                Message(
                    name: "preferred_changed",
                    arguments: [
                    Argument(
                        name: "identity",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "preferred_changed2",
                    arguments: [
                    Argument(
                        name: "identity_hi",
                        type: .uint,
                    ),
                    Argument(
                        name: "identity_lo",
                        type: .uint,
                    ),
                    ],
                    since: 2
                ),
                ],
        )
    /// Destroy The Color Management Interface For A Surface
    /// 
    /// Destroy the wp_color_management_surface_feedback_v1 object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Get The Preferred Image Description
    /// 
    /// If this protocol object is inert, the protocol error inert is raised.
    /// The preferred image description represents the compositor's preferred
    /// color encoding for this wl_surface at the current time. There might be
    /// performance and power advantages, as well as improved color
    /// reproduction, if the image description of a content update matches the
    /// preferred image description.
    /// This creates a new wp_image_description_v1 object for the currently
    /// preferred image description for the wl_surface. The client should
    /// stop using and destroy the image descriptions created by earlier
    /// invocations of this request for the associated wl_surface.
    /// This request is usually sent as a reaction to the preferred_changed
    /// event or when creating a wp_color_management_surface_feedback_v1 object
    /// if the client is capable of adapting to image descriptions.
    /// The created wp_image_description_v1 object preserves the preferred image
    /// description of the wl_surface from the time the object was created.
    /// The resulting image description object allows get_information request.
    /// If the image description is parametric, the client should set it on its
    /// wl_surface only if the image description is an exact match with the
    /// client content. Particularly if everything else matches, but the target
    /// color volume is greater than what the client needs, the client should
    /// create its own parameric image description with its exact parameters.
    /// If the interface version is inadequate for the preferred image
    /// description, meaning that the client does not support all the
    /// events needed to deliver the crucial information, the resulting image
    /// description object shall immediately deliver the
    /// wp_image_description_v1.failed event with the low_version cause,
    /// otherwise the object shall immediately deliver the ready event.
    public func getPreferred(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(imageDescription.id),
        ])
        return imageDescription
    }

    /// Get The Preferred Image Description
    /// 
    /// The same description as for get_preferred applies, except the returned
    /// image description is guaranteed to be parametric. This is meant for
    /// clients that can only deal with parametric image descriptions.
    /// If the compositor doesn't support parametric image descriptions, the
    /// unsupported_feature error is emitted.
    public func getPreferredParametric(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(imageDescription.id),
        ])
        return imageDescription
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorManagementV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// forbidden request on inert object
        case inert = 0

        /// attempted to use an unsupported feature
        case unsupportedFeature = 1
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
        /// The Preferred Image Description Changed (32-Bit)
        /// 
        /// Starting from interface version 2, 'preferred_changed2' is sent instead
        /// of this event. See the 'preferred_changed2' event for the definition.
        case preferredChanged(identity: UInt32)

        /// The Preferred Image Description Changed
        /// 
        /// The preferred image description is the one which likely has the most
        /// performance and/or quality benefits for the compositor if used by the
        /// client for its wl_surface contents. This event is sent whenever the
        /// compositor changes the wl_surface's preferred image description.
        /// This event sends the identity of the new preferred state as the argument,
        /// so clients who are aware of the image description already can reuse it.
        /// Otherwise, if the client client wants to know what the preferred image
        /// description is, it shall use the get_preferred request.
        /// The preferred image description is not automatically used for anything.
        /// It is only a hint, and clients may set any valid image description with
        /// set_image_description, but there might be performance and color accuracy
        /// improvements by providing the wl_surface contents in the preferred
        /// image description. Therefore clients that can, should render according
        /// to the preferred image description
        case preferredChanged2(identityHi: UInt32, identityLo: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.preferredChanged(identity: r.uint())
            case 1:
                self = Self.preferredChanged2(identityHi: r.uint(), identityLo: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Holder Of Image Description Icc Information
/// 
/// This type of object is used for collecting all the information required
/// to create a wp_image_description_v1 object from an ICC file. A complete
/// set of required parameters consists of these properties:
/// - ICC file
/// Each required property must be set exactly once if the client is to create
/// an image description. The set requests verify that a property was not
/// already set. The create request verifies that all required properties are
/// set. There may be several alternative requests for setting each property,
/// and in that case the client must choose one of them.
/// Once all properties have been set, the create request must be used to
/// create the image description object, destroying the creator in the
/// process.
/// The link between a pixel value (a device value in ICC) and its respective
/// colorimetry is defined by the details of the particular ICC profile.
/// Those details also determine when colorimetry becomes undefined.
public final class WpImageDescriptionCreatorIccV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_image_description_creator_icc_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "create",
                    type: .destructor,
                    arguments: [
                    Argument(
                        name: "image_description",
                        type: .newId,
                        interface: "wp_image_description_v1"
                    ),
                    ],
                ),
                Message(
                    name: "set_icc_file",
                    arguments: [
                    Argument(
                        name: "icc_profile",
                        type: .fd,
                    ),
                    Argument(
                        name: "offset",
                        type: .uint,
                    ),
                    Argument(
                        name: "length",
                        type: .uint,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Create The Image Description Object From Icc Data
    /// 
    /// Create an image description object based on the ICC information
    /// previously set on this object. A compositor must parse the ICC data in
    /// some undefined but finite amount of time.
    /// The completeness of the parameter set is verified. If the set is not
    /// complete, the protocol error incomplete_set is raised. For the
    /// definition of a complete set, see the description of this interface.
    /// If the particular combination of the information is not supported
    /// by the compositor, the resulting image description object shall
    /// immediately deliver the wp_image_description_v1.failed event with the
    /// 'unsupported' cause. If a valid image description was created from the
    /// information, the wp_image_description_v1.ready event will eventually
    /// be sent instead.
    /// This request destroys the wp_image_description_creator_icc_v1 object.
    /// The resulting image description object does not allow get_information
    /// request.
    public func create(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(imageDescription.id),
        ])
        return imageDescription
    }

    /// Set The Icc Profile File
    /// 
    /// Sets the ICC profile file to be used as the basis of the image
    /// description.
    /// The data shall be found through the given fd at the given offset, having
    /// the given length. The fd must be seekable and readable. Violating these
    /// requirements raises the bad_fd protocol error.
    /// If reading the data fails due to an error independent of the client, the
    /// compositor shall send the wp_image_description_v1.failed event on the
    /// created wp_image_description_v1 with the 'operating_system' cause.
    /// The maximum size of the ICC profile is 32 MB. If length is greater than
    /// that or zero, the protocol error bad_size is raised. If offset + length
    /// exceeds the file size, the protocol error out_of_file is raised.
    /// A compositor may read the file at any time starting from this request
    /// and only until whichever happens first:
    /// - If create request was issued, the wp_image_description_v1 object
    /// delivers either failed or ready event; or
    /// - if create request was not issued, this
    /// wp_image_description_creator_icc_v1 object is destroyed.
    /// A compositor shall not modify the contents of the file, and the fd may
    /// be sealed for writes and size changes. The client must ensure to its
    /// best ability that the data does not change while the compositor is
    /// reading it.
    /// The data must represent a valid ICC profile. The ICC profile version
    /// must be 2 or 4, it must be a 3 channel profile and the class must be
    /// Display or ColorSpace. Violating these requirements will not result in a
    /// protocol error, but will eventually send the
    /// wp_image_description_v1.failed event on the created
    /// wp_image_description_v1 with the 'unsupported' cause.
    /// See the International Color Consortium specification ICC.1:2022 for more
    /// details about ICC profiles.
    /// If ICC file has already been set on this object, the protocol error
    /// already_set is raised.
    /// 
    /// - Parameters:
    ///   - iccProfile: ICC profile
    ///   - offset: byte offset in fd to start of ICC data
    ///   - length: length of ICC data in bytes
    public func setIccFile(iccProfile: FileHandle, offset: UInt32, length: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .fd(iccProfile),
            .uint(offset),
            .uint(length),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorManagementV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// incomplete parameter set
        case incompleteSet = 0

        /// property already set
        case alreadySet = 1

        /// fd not seekable and readable
        case badFd = 2

        /// no or too much data
        case badSize = 3

        /// offset + length exceeds file size
        case outOfFile = 4
    }

    public typealias Event = NoEvent
}
/// Holder Of Image Description Parameters
/// 
/// This type of object is used for collecting all the parameters required
/// to create a wp_image_description_v1 object. A complete set of required
/// parameters consists of these properties:
/// - transfer characteristic function (tf)
/// - chromaticities of primaries and white point (primary color volume)
/// The following properties are optional and have a well-defined default
/// if not explicitly set:
/// - primary color volume luminance range
/// - reference white luminance level
/// - mastering display primaries and white point (target color volume)
/// - mastering luminance range
/// The following properties are optional and will be ignored
/// if not explicitly set:
/// - maximum content light level
/// - maximum frame-average light level
/// Each required property must be set exactly once if the client is to create
/// an image description. The set requests verify that a property was not
/// already set. The create request verifies that all required properties are
/// set. There may be several alternative requests for setting each property,
/// and in that case the client must choose one of them.
/// Once all properties have been set, the create request must be used to
/// create the image description object, destroying the creator in the
/// process.
/// A viewer, who is viewing the display defined by the resulting image
/// description (the viewing environment included), is assumed to be fully
/// adapted to the primary color volume's white point.
/// Any of the following conditions will cause the colorimetry of a pixel
/// to become undefined:
/// - Values outside of the defined range of the transfer characteristic.
/// - Tristimulus that exceeds the target color volume.
/// - If extended_target_volume is not supported: tristimulus that exceeds
/// the primary color volume.
/// The closest correspondence to an image description created through this
/// interface is the Display class of profiles in ICC.
public final class WpImageDescriptionCreatorParamsV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_image_description_creator_params_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "create",
                    type: .destructor,
                    arguments: [
                    Argument(
                        name: "image_description",
                        type: .newId,
                        interface: "wp_image_description_v1"
                    ),
                    ],
                ),
                Message(
                    name: "set_tf_named",
                    arguments: [
                    Argument(
                        name: "tf",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_tf_power",
                    arguments: [
                    Argument(
                        name: "eexp",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_primaries_named",
                    arguments: [
                    Argument(
                        name: "primaries",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_primaries",
                    arguments: [
                    Argument(
                        name: "r_x",
                        type: .int,
                    ),
                    Argument(
                        name: "r_y",
                        type: .int,
                    ),
                    Argument(
                        name: "g_x",
                        type: .int,
                    ),
                    Argument(
                        name: "g_y",
                        type: .int,
                    ),
                    Argument(
                        name: "b_x",
                        type: .int,
                    ),
                    Argument(
                        name: "b_y",
                        type: .int,
                    ),
                    Argument(
                        name: "w_x",
                        type: .int,
                    ),
                    Argument(
                        name: "w_y",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "set_luminances",
                    arguments: [
                    Argument(
                        name: "min_lum",
                        type: .uint,
                    ),
                    Argument(
                        name: "max_lum",
                        type: .uint,
                    ),
                    Argument(
                        name: "reference_lum",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_mastering_display_primaries",
                    arguments: [
                    Argument(
                        name: "r_x",
                        type: .int,
                    ),
                    Argument(
                        name: "r_y",
                        type: .int,
                    ),
                    Argument(
                        name: "g_x",
                        type: .int,
                    ),
                    Argument(
                        name: "g_y",
                        type: .int,
                    ),
                    Argument(
                        name: "b_x",
                        type: .int,
                    ),
                    Argument(
                        name: "b_y",
                        type: .int,
                    ),
                    Argument(
                        name: "w_x",
                        type: .int,
                    ),
                    Argument(
                        name: "w_y",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "set_mastering_luminance",
                    arguments: [
                    Argument(
                        name: "min_lum",
                        type: .uint,
                    ),
                    Argument(
                        name: "max_lum",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_max_cll",
                    arguments: [
                    Argument(
                        name: "max_cll",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "set_max_fall",
                    arguments: [
                    Argument(
                        name: "max_fall",
                        type: .uint,
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Create The Image Description Object Using Params
    /// 
    /// Create an image description object based on the parameters previously
    /// set on this object.
    /// The completeness of the parameter set is verified. If the set is not
    /// complete, the protocol error incomplete_set is raised. For the
    /// definition of a complete set, see the description of this interface.
    /// When both max_cll and max_fall are set, max_fall must be less or equal
    /// to max_cll otherwise the invalid_luminance protocol error is raised.
    /// In version 1, these following conditions also result in the
    /// invalid_luminance protocol error. Version 2 and later do not have this
    /// requirement.
    /// - When max_cll is set, it must be greater than min L and less or equal
    /// to max L of the mastering luminance range.
    /// - When max_fall is set, it must be greater than min L and less or equal
    /// to max L of the mastering luminance range.
    /// If the particular combination of the parameter set is not supported
    /// by the compositor, the resulting image description object shall
    /// immediately deliver the wp_image_description_v1.failed event with the
    /// 'unsupported' cause. If a valid image description was created from the
    /// parameter set, the wp_image_description_v1.ready event will eventually
    /// be sent instead.
    /// This request destroys the wp_image_description_creator_params_v1
    /// object.
    /// The resulting image description object does not allow get_information
    /// request.
    public func create(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        let imageDescription = connection.createProxy(type: WpImageDescriptionV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(imageDescription.id),
        ])
        return imageDescription
    }

    /// Named Transfer Characteristic
    /// 
    /// Sets the transfer characteristic using explicitly enumerated named
    /// functions.
    /// When the resulting image description is attached to an image, the
    /// content should be decoded according to the industry standard
    /// practices for the transfer characteristic.
    /// Only names advertised with wp_color_manager_v1 event supported_tf_named
    /// are allowed. Other values shall raise the protocol error invalid_tf.
    /// If transfer characteristic has already been set on this object, the
    /// protocol error already_set is raised.
    /// 
    /// - Parameters:
    ///   - tf: named transfer function
    public func setTfNamed(tf: WpColorManagerV1.TransferFunction) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(tf.rawValue),
        ])
    }

    /// Transfer Characteristic As A Power Curve
    /// 
    /// Sets the color component transfer characteristic to a power curve with
    /// the given exponent. Negative values are handled by mirroring the
    /// positive half of the curve through the origin. The valid domain and
    /// range of the curve are all finite real numbers. This curve represents
    /// the conversion from electrical to optical color channel values.
    /// The curve exponent shall be multiplied by 10000 to get the argument eexp
    /// value to carry the precision of 4 decimals.
    /// The curve exponent must be at least 1.0 and at most 10.0. Otherwise the
    /// protocol error invalid_tf is raised.
    /// If transfer characteristic has already been set on this object, the
    /// protocol error already_set is raised.
    /// This request can be used when the compositor advertises
    /// wp_color_manager_v1.feature.set_tf_power. Otherwise this request raises
    /// the protocol error unsupported_feature.
    /// 
    /// - Parameters:
    ///   - eexp: the exponent * 10000
    public func setTfPower(eexp: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .uint(eexp),
        ])
    }

    /// Named Primaries
    /// 
    /// Sets the color primaries and white point using explicitly named sets.
    /// This describes the primary color volume which is the basis for color
    /// value encoding.
    /// Only names advertised with wp_color_manager_v1 event
    /// supported_primaries_named are allowed. Other values shall raise the
    /// protocol error invalid_primaries_named.
    /// If primaries have already been set on this object, the protocol error
    /// already_set is raised.
    /// 
    /// - Parameters:
    ///   - primaries: named primaries
    public func setPrimariesNamed(primaries: WpColorManagerV1.Primaries) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(primaries.rawValue),
        ])
    }

    /// Primaries As Chromaticity Coordinates
    /// 
    /// Sets the color primaries and white point using CIE 1931 xy chromaticity
    /// coordinates. This describes the primary color volume which is the basis
    /// for color value encoding.
    /// Each coordinate value is multiplied by 1 million to get the argument
    /// value to carry precision of 6 decimals.
    /// If primaries have already been set on this object, the protocol error
    /// already_set is raised.
    /// This request can be used if the compositor advertises
    /// wp_color_manager_v1.feature.set_primaries. Otherwise this request raises
    /// the protocol error unsupported_feature.
    /// 
    /// - Parameters:
    ///   - rX: Red x * 1M
    ///   - rY: Red y * 1M
    ///   - gX: Green x * 1M
    ///   - gY: Green y * 1M
    ///   - bX: Blue x * 1M
    ///   - bY: Blue y * 1M
    ///   - wX: White x * 1M
    ///   - wY: White y * 1M
    public func setPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .int(rX),
            .int(rY),
            .int(gX),
            .int(gY),
            .int(bX),
            .int(bY),
            .int(wX),
            .int(wY),
        ])
    }

    /// Primary Color Volume Luminance Range And Reference White
    /// 
    /// Sets the primary color volume luminance range and the reference white
    /// luminance level. These values include the minimum display emission, but
    /// not external flare. The minimum display emission is assumed to have
    /// the chromaticity of the primary color volume white point.
    /// The default luminances from
    /// https://www.color.org/chardata/rgb/srgb.xalter are
    /// - primary color volume minimum: 0.2 cd/m²
    /// - primary color volume maximum: 80 cd/m²
    /// - reference white: 80 cd/m²
    /// Setting a named transfer characteristic can imply other default
    /// luminances.
    /// The default luminances get overwritten when this request is used.
    /// With transfer_function.st2084_pq the given 'max_lum' value is ignored,
    /// and 'max_lum' is taken as 'min_lum' + 10000 cd/m².
    /// 'min_lum' and 'max_lum' specify the minimum and maximum luminances of
    /// the primary color volume as reproduced by the targeted display.
    /// 'reference_lum' specifies the luminance of the reference white as
    /// reproduced by the targeted display, and reflects the targeted viewing
    /// environment.
    /// Compositors should make sure that all content is anchored, meaning that
    /// an input signal level of 'reference_lum' on one image description and
    /// another input signal level of 'reference_lum' on another image
    /// description should produce the same output level, even though the
    /// 'reference_lum' on both image representations can be different.
    /// 'reference_lum' may be higher than 'max_lum'. In that case reaching
    /// the reference white output level in image content requires the
    /// 'extended_target_volume' feature support.
    /// If 'max_lum' or 'reference_lum' are less than or equal to 'min_lum',
    /// the protocol error invalid_luminance is raised.
    /// The minimum luminance is multiplied by 10000 to get the argument
    /// 'min_lum' value and carries precision of 4 decimals. The maximum
    /// luminance and reference white luminance values are unscaled.
    /// If the primary color volume luminance range and the reference white
    /// luminance level have already been set on this object, the protocol error
    /// already_set is raised.
    /// This request can be used if the compositor advertises
    /// wp_color_manager_v1.feature.set_luminances. Otherwise this request
    /// raises the protocol error unsupported_feature.
    /// 
    /// - Parameters:
    ///   - minLum: minimum luminance (cd/m²) * 10000
    ///   - maxLum: maximum luminance (cd/m²)
    ///   - referenceLum: reference white luminance (cd/m²)
    public func setLuminances(minLum: UInt32, maxLum: UInt32, referenceLum: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .uint(minLum),
            .uint(maxLum),
            .uint(referenceLum),
        ])
    }

    /// Mastering Display Primaries As Chromaticity Coordinates
    /// 
    /// Provides the color primaries and white point of the mastering display
    /// using CIE 1931 xy chromaticity coordinates. This is compatible with the
    /// SMPTE ST 2086 definition of HDR static metadata.
    /// The mastering display primaries and mastering display luminances define
    /// the target color volume.
    /// If mastering display primaries are not explicitly set, the target color
    /// volume is assumed to have the same primaries as the primary color volume.
    /// The target color volume is defined by all tristimulus values between 0.0
    /// and 1.0 (inclusive) of the color space defined by the given mastering
    /// display primaries and white point. The colorimetry is identical between
    /// the container color space and the mastering display color space,
    /// including that no chromatic adaptation is applied even if the white
    /// points differ.
    /// The target color volume can exceed the primary color volume to allow for
    /// a greater color volume with an existing color space definition (for
    /// example scRGB). It can be smaller than the primary color volume to
    /// minimize gamut and tone mapping distances for big color spaces (HDR
    /// metadata).
    /// To make use of the entire target color volume a suitable pixel format
    /// has to be chosen (e.g. floating point to exceed the primary color
    /// volume, or abusing limited quantization range as with xvYCC).
    /// Each coordinate value is multiplied by 1 million to get the argument
    /// value to carry precision of 6 decimals.
    /// If mastering display primaries have already been set on this object, the
    /// protocol error already_set is raised.
    /// This request can be used if the compositor advertises
    /// wp_color_manager_v1.feature.set_mastering_display_primaries. Otherwise
    /// this request raises the protocol error unsupported_feature. The
    /// advertisement implies support only for target color volumes fully
    /// contained within the primary color volume.
    /// If a compositor additionally supports target color volume exceeding the
    /// primary color volume, it must advertise
    /// wp_color_manager_v1.feature.extended_target_volume. If a client uses
    /// target color volume exceeding the primary color volume and the
    /// compositor does not support it, the result is implementation defined.
    /// Compositors are recommended to detect this case and fail the image
    /// description gracefully, but it may as well result in color artifacts.
    /// 
    /// - Parameters:
    ///   - rX: Red x * 1M
    ///   - rY: Red y * 1M
    ///   - gX: Green x * 1M
    ///   - gY: Green y * 1M
    ///   - bX: Blue x * 1M
    ///   - bY: Blue y * 1M
    ///   - wX: White x * 1M
    ///   - wY: White y * 1M
    public func setMasteringDisplayPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .int(rX),
            .int(rY),
            .int(gX),
            .int(gY),
            .int(bX),
            .int(bY),
            .int(wX),
            .int(wY),
        ])
    }

    /// Display Mastering Luminance Range
    /// 
    /// Sets the luminance range that was used during the content mastering
    /// process as the minimum and maximum absolute luminance L. These values
    /// include the minimum display emission and ambient flare luminances,
    /// assumed to be optically additive and have the chromaticity of the
    /// primary color volume white point. This should be
    /// compatible with the SMPTE ST 2086 definition of HDR static metadata.
    /// The mastering display primaries and mastering display luminances define
    /// the target color volume.
    /// If mastering luminances are not explicitly set, the target color volume
    /// is assumed to have the same min and max luminances as the primary color
    /// volume.
    /// If max L is less than or equal to min L, the protocol error
    /// invalid_luminance is raised.
    /// Min L value is multiplied by 10000 to get the argument min_lum value
    /// and carry precision of 4 decimals. Max L value is unscaled for max_lum.
    /// This request can be used if the compositor advertises
    /// wp_color_manager_v1.feature.set_mastering_display_primaries. Otherwise
    /// this request raises the protocol error unsupported_feature. The
    /// advertisement implies support only for target color volumes fully
    /// contained within the primary color volume.
    /// If a compositor additionally supports target color volume exceeding the
    /// primary color volume, it must advertise
    /// wp_color_manager_v1.feature.extended_target_volume. If a client uses
    /// target color volume exceeding the primary color volume and the
    /// compositor does not support it, the result is implementation defined.
    /// Compositors are recommended to detect this case and fail the image
    /// description gracefully, but it may as well result in color artifacts.
    /// 
    /// - Parameters:
    ///   - minLum: min L (cd/m²) * 10000
    ///   - maxLum: max L (cd/m²)
    public func setMasteringLuminance(minLum: UInt32, maxLum: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .uint(minLum),
            .uint(maxLum),
        ])
    }

    /// Maximum Content Light Level
    /// 
    /// Sets the maximum content light level (max_cll) as defined by CTA-861-H.
    /// max_cll is undefined by default.
    /// 
    /// - Parameters:
    ///   - _: Maximum content light level (cd/m²)
    public func setMaxCll(_ maxCll: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .uint(maxCll),
        ])
    }

    /// Maximum Frame-Average Light Level
    /// 
    /// Sets the maximum frame-average light level (max_fall) as defined by
    /// CTA-861-H.
    /// max_fall is undefined by default.
    /// 
    /// - Parameters:
    ///   - _: Maximum frame-average light level (cd/m²)
    public func setMaxFall(_ maxFall: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
            .uint(maxFall),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorManagementV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// incomplete parameter set
        case incompleteSet = 0

        /// property already set
        case alreadySet = 1

        /// request not supported
        case unsupportedFeature = 2

        /// invalid transfer characteristic
        case invalidTf = 3

        /// invalid primaries named
        case invalidPrimariesNamed = 4

        /// invalid luminance value or range
        case invalidLuminance = 5
    }

    public typealias Event = NoEvent
}
/// Colorimetric Image Description
/// 
/// An image description carries information about the pixel color encoding
/// and its intended display and viewing environment. The image description is
/// attached to a wl_surface via
/// wp_color_management_surface_v1.set_image_description. A compositor can use
/// this information to decode pixel values into colorimetrically meaningful
/// quantities, which allows the compositor to transform the surface contents
/// to become suitable for various displays and viewing environments.
/// Note, that the wp_image_description_v1 object is not ready to be used
/// immediately after creation. The object eventually delivers either the
/// 'ready' or the 'failed' event, specified in all requests creating it. The
/// object is deemed "ready" after receiving the 'ready' event.
/// An object which is not ready is illegal to use, it can only be destroyed.
/// Any other request in this interface shall result in the 'not_ready'
/// protocol error. Attempts to use an object which is not ready through other
/// interfaces shall raise protocol errors defined there.
/// Once created and regardless of how it was created, a
/// wp_image_description_v1 object always refers to one fixed image
/// description. It cannot change after creation.
public final class WpImageDescriptionV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_image_description_v1",
            version: 3,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_information",
                    arguments: [
                    Argument(
                        name: "information",
                        type: .newId,
                        interface: "wp_image_description_info_v1"
                    ),
                    ],
                ),
                ],
            events: [
                Message(
                    name: "failed",
                    arguments: [
                    Argument(
                        name: "cause",
                        type: .uint,
                    ),
                    Argument(
                        name: "msg",
                        type: .string,
                    ),
                    ],
                ),
                Message(
                    name: "ready",
                    arguments: [
                    Argument(
                        name: "identity",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "ready2",
                    arguments: [
                    Argument(
                        name: "identity_hi",
                        type: .uint,
                    ),
                    Argument(
                        name: "identity_lo",
                        type: .uint,
                    ),
                    ],
                    since: 2
                ),
                ],
        )
    /// Destroy The Image Description
    /// 
    /// Destroy this object. It is safe to destroy an object which is not ready.
    /// Destroying a wp_image_description_v1 object has no side-effects, not
    /// even if a wp_color_management_surface_v1.set_image_description has not
    /// yet been followed by a wl_surface.commit.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Get Information About The Image Description
    /// 
    /// Creates a wp_image_description_info_v1 object which delivers the
    /// information that makes up the image description.
    /// Not all image description protocol objects allow get_information
    /// request. Whether it is allowed or not is defined by the request that
    /// created the object. If get_information is not allowed, the protocol
    /// error no_information is raised.
    public func getInformation(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpImageDescriptionInfoV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let information = connection.createProxy(type: WpImageDescriptionInfoV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(information.id),
        ])
        return information
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorManagementV1Protocol)
    }
    
    public enum Error: UInt32 {
        /// attempted to use an object which is not ready
        case notReady = 0

        /// get_information not allowed
        case noInformation = 1
    }

    public enum Cause: UInt32 {
        /// interface version too low
        case lowVersion = 0

        /// unsupported image description data
        case unsupported = 1

        /// error independent of the client
        case operatingSystem = 2

        /// the relevant output no longer exists
        case noOutput = 3
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
        /// Graceful Error On Creating The Image Description
        /// 
        /// If creating a wp_image_description_v1 object fails for a reason that is
        /// not defined as a protocol error, this event is sent.
        /// The requests that create image description objects define whether and
        /// when this can occur. Only such creation requests can trigger this event.
        /// This event cannot be triggered after the image description was
        /// successfully formed.
        /// Once this event has been sent, the wp_image_description_v1 object will
        /// never become ready and it can only be destroyed.
        case failed(cause: Cause, msg: String)

        /// The Object Is Ready To Be Used (32-Bit)
        /// 
        /// Starting from interface version 2, the 'ready2' event is sent instead
        /// of this event.
        /// For the definition of this event, see the 'ready2' event. The
        /// difference to this event is as follows.
        /// The id number is valid only as long as the protocol object is alive. If
        /// all protocol objects referring to the same image description record are
        /// destroyed, the id number may be recycled for a different image
        /// description record.
        case ready(identity: UInt32)

        /// The Object Is Ready To Be Used
        /// 
        /// Once this event has been sent, the wp_image_description_v1 object is
        /// deemed "ready". Ready objects can be used to send requests and can be
        /// used through other interfaces.
        /// Every ready wp_image_description_v1 protocol object refers to an
        /// underlying image description record in the compositor. Multiple protocol
        /// objects may end up referring to the same record. Clients may identify
        /// these "copies" by comparing their id numbers: if the numbers from two
        /// protocol objects are identical, the protocol objects refer to the same
        /// image description record. Two different image description records
        /// cannot have the same id number simultaneously. The id number does not
        /// change during the lifetime of the image description record.
        /// Image description id number is not a protocol object id. Zero is
        /// reserved as an invalid id number. It shall not be possible for a client
        /// to refer to an image description by its id number in protocol. The id
        /// numbers might not be portable between Wayland connections. A compositor
        /// shall not send an invalid id number.
        /// Compositors must not recycle image description id numbers.
        /// This identity allows clients to de-duplicate image description records
        /// and avoid get_information request if they already have the image
        /// description information.
        case ready2(identityHi: UInt32, identityLo: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.failed(cause: try _parseEnum(into: Cause.self, r.uint()), msg: r.string())
            case 1:
                self = Self.ready(identity: r.uint())
            case 2:
                self = Self.ready2(identityHi: r.uint(), identityLo: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Colorimetric Image Description Information
/// 
/// Sends all matching events describing an image description object exactly
/// once and finally sends the 'done' event.
/// This means
/// - if the image description is parametric, it must send
/// - primaries
/// - named_primaries, if applicable
/// - at least one of tf_power and tf_named, as applicable
/// - luminances
/// - target_primaries
/// - target_luminance
/// - if the image description is parametric, it may send, if applicable,
/// - target_max_cll
/// - target_max_fall
/// - if the image description contains an ICC profile, it must send the
/// icc_file event
/// Once a wp_image_description_info_v1 object has delivered a 'done' event it
/// is automatically destroyed.
/// Every wp_image_description_info_v1 created from the same
/// wp_image_description_v1 shall always return the exact same data.
public final class WpImageDescriptionInfoV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_image_description_info_v1",
            version: 3,
            enums: [],
            requests: [
                ],
            events: [
                Message(
                    name: "done",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "icc_file",
                    arguments: [
                    Argument(
                        name: "icc",
                        type: .fd,
                    ),
                    Argument(
                        name: "icc_size",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "primaries",
                    arguments: [
                    Argument(
                        name: "r_x",
                        type: .int,
                    ),
                    Argument(
                        name: "r_y",
                        type: .int,
                    ),
                    Argument(
                        name: "g_x",
                        type: .int,
                    ),
                    Argument(
                        name: "g_y",
                        type: .int,
                    ),
                    Argument(
                        name: "b_x",
                        type: .int,
                    ),
                    Argument(
                        name: "b_y",
                        type: .int,
                    ),
                    Argument(
                        name: "w_x",
                        type: .int,
                    ),
                    Argument(
                        name: "w_y",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "primaries_named",
                    arguments: [
                    Argument(
                        name: "primaries",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "tf_power",
                    arguments: [
                    Argument(
                        name: "eexp",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "tf_named",
                    arguments: [
                    Argument(
                        name: "tf",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "luminances",
                    arguments: [
                    Argument(
                        name: "min_lum",
                        type: .uint,
                    ),
                    Argument(
                        name: "max_lum",
                        type: .uint,
                    ),
                    Argument(
                        name: "reference_lum",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "target_primaries",
                    arguments: [
                    Argument(
                        name: "r_x",
                        type: .int,
                    ),
                    Argument(
                        name: "r_y",
                        type: .int,
                    ),
                    Argument(
                        name: "g_x",
                        type: .int,
                    ),
                    Argument(
                        name: "g_y",
                        type: .int,
                    ),
                    Argument(
                        name: "b_x",
                        type: .int,
                    ),
                    Argument(
                        name: "b_y",
                        type: .int,
                    ),
                    Argument(
                        name: "w_x",
                        type: .int,
                    ),
                    Argument(
                        name: "w_y",
                        type: .int,
                    ),
                    ],
                ),
                Message(
                    name: "target_luminance",
                    arguments: [
                    Argument(
                        name: "min_lum",
                        type: .uint,
                    ),
                    Argument(
                        name: "max_lum",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "target_max_cll",
                    arguments: [
                    Argument(
                        name: "max_cll",
                        type: .uint,
                    ),
                    ],
                ),
                Message(
                    name: "target_max_fall",
                    arguments: [
                    Argument(
                        name: "max_fall",
                        type: .uint,
                    ),
                    ],
                ),
                ],
        )
    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorManagementV1Protocol)
    }
    
    public enum Event: Decodable {
        /// End Of Information
        /// 
        /// Signals the end of information events and destroys the object.
        case done

        /// Icc Profile Matching The Image Description
        /// 
        /// The icc argument provides a file descriptor to the client which may be
        /// memory-mapped to provide the ICC profile matching the image description.
        /// The fd is read-only, and if mapped then it must be mapped with
        /// MAP_PRIVATE by the client.
        /// The ICC profile version and other details are determined by the
        /// compositor. There is no provision for a client to ask for a specific
        /// kind of a profile.
        case iccFile(icc: FileHandle, iccSize: UInt32)

        /// Primaries As Chromaticity Coordinates
        /// 
        /// Delivers the primary color volume primaries and white point using CIE
        /// 1931 xy chromaticity coordinates.
        /// Each coordinate value is multiplied by 1 million to get the argument
        /// value to carry precision of 6 decimals.
        case primaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32)

        /// Named Primaries
        /// 
        /// Delivers the primary color volume primaries and white point using an
        /// explicitly enumerated named set.
        case primariesNamed(primaries: WpColorManagerV1.Primaries)

        /// Transfer Characteristic As A Power Curve
        /// 
        /// The color component transfer characteristic of this image description is
        /// a pure power curve. This event provides the exponent of the power
        /// function. This curve represents the conversion from electrical to
        /// optical pixel or color values.
        /// The curve exponent has been multiplied by 10000 to get the argument eexp
        /// value to carry the precision of 4 decimals.
        case tfPower(eexp: UInt32)

        /// Named Transfer Characteristic
        /// 
        /// Delivers the transfer characteristic using an explicitly enumerated
        /// named function.
        case tfNamed(tf: WpColorManagerV1.TransferFunction)

        /// Primary Color Volume Luminance Range And Reference White
        /// 
        /// Delivers the primary color volume luminance range and the reference
        /// white luminance level. These values include the minimum display emission
        /// and ambient flare luminances, assumed to be optically additive and have
        /// the chromaticity of the primary color volume white point.
        /// The minimum luminance is multiplied by 10000 to get the argument
        /// 'min_lum' value and carries precision of 4 decimals. The maximum
        /// luminance and reference white luminance values are unscaled.
        case luminances(minLum: UInt32, maxLum: UInt32, referenceLum: UInt32)

        /// Target Primaries As Chromaticity Coordinates
        /// 
        /// Provides the color primaries and white point of the target color volume
        /// using CIE 1931 xy chromaticity coordinates. This is compatible with the
        /// SMPTE ST 2086 definition of HDR static metadata for mastering displays.
        /// While primary color volume is about how color is encoded, the target
        /// color volume is the actually displayable color volume.
        /// Each coordinate value is multiplied by 1 million to get the argument
        /// value to carry precision of 6 decimals.
        case targetPrimaries(rX: Int32, rY: Int32, gX: Int32, gY: Int32, bX: Int32, bY: Int32, wX: Int32, wY: Int32)

        /// Target Luminance Range
        /// 
        /// Provides the luminance range that the image description is targeting as
        /// the minimum and maximum absolute luminance L. These values include the
        /// minimum display emission and ambient flare luminances, assumed to be
        /// optically additive and have the chromaticity of the primary color
        /// volume white point. This should be compatible with the SMPTE ST 2086
        /// definition of HDR static metadata.
        /// This luminance range is only theoretical and may not correspond to the
        /// luminance of light emitted on an actual display.
        /// Min L value is multiplied by 10000 to get the argument min_lum value and
        /// carry precision of 4 decimals. Max L value is unscaled for max_lum.
        case targetLuminance(minLum: UInt32, maxLum: UInt32)

        /// Target Maximum Content Light Level
        /// 
        /// Provides the targeted max_cll of the image description. max_cll is
        /// defined by CTA-861-H.
        /// This luminance is only theoretical and may not correspond to the
        /// luminance of light emitted on an actual display.
        case targetMaxCll(maxCll: UInt32)

        /// Target Maximum Frame-Average Light Level
        /// 
        /// Provides the targeted max_fall of the image description. max_fall is
        /// defined by CTA-861-H.
        /// This luminance is only theoretical and may not correspond to the
        /// luminance of light emitted on an actual display.
        case targetMaxFall(maxFall: UInt32)

        public init(from r: any ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.done
            case 1:
                self = Self.iccFile(icc: r.fd(), iccSize: r.uint())
            case 2:
                self = Self.primaries(rX: r.int(), rY: r.int(), gX: r.int(), gY: r.int(), bX: r.int(), bY: r.int(), wX: r.int(), wY: r.int())
            case 3:
                self = Self.primariesNamed(primaries: try _parseEnum(into: WpColorManagerV1.Primaries.self, r.uint()))
            case 4:
                self = Self.tfPower(eexp: r.uint())
            case 5:
                self = Self.tfNamed(tf: try _parseEnum(into: WpColorManagerV1.TransferFunction.self, r.uint()))
            case 6:
                self = Self.luminances(minLum: r.uint(), maxLum: r.uint(), referenceLum: r.uint())
            case 7:
                self = Self.targetPrimaries(rX: r.int(), rY: r.int(), gX: r.int(), gY: r.int(), bX: r.int(), bY: r.int(), wX: r.int(), wY: r.int())
            case 8:
                self = Self.targetLuminance(minLum: r.uint(), maxLum: r.uint())
            case 9:
                self = Self.targetMaxCll(maxCll: r.uint())
            case 10:
                self = Self.targetMaxFall(maxFall: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}
/// Reference To An Image Description
/// 
/// This object is a reference to an image description. This interface is
/// frozen at version 1 to allow other protocols to create
/// wp_image_description_v1 objects.
/// The wp_color_manager_v1.get_image_description request can be used to
/// retrieve the underlying image description.
public final class WpImageDescriptionReferenceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_image_description_reference_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Reference
    /// 
    /// Destroy this object. This has no effect on the referenced image
    /// description.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: ColorManagementV1Protocol)
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

public let ColorManagementV1Protocol = Protocol(
        name: "color_management_v1",
        interfaces: [
            WpColorManagerV1.interface,
WpColorManagementOutputV1.interface,
WpColorManagementSurfaceV1.interface,
WpColorManagementSurfaceFeedbackV1.interface,
WpImageDescriptionCreatorIccV1.interface,
WpImageDescriptionCreatorParamsV1.interface,
WpImageDescriptionV1.interface,
WpImageDescriptionInfoV1.interface,
WpImageDescriptionReferenceV1.interface
        ]
    )

#endif