import Foundation
import WaylandClient

#if WP
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_surface_content_type",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_content_type_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Content Type Manager Object
    /// 
    /// Destroy the content type manager. This doesn't destroy objects created
    /// with the manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
        let id = connection.sendConstructor(self, 1, WpContentTypeV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = ContentTypeV1Protocol
    
    public enum Error: UInt32 {
        /// wl_surface already has a content type object
        case alreadyConstructed = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_content_type",
                    arguments: [
                        Argument(
                            name: "content_type",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Content Type Object
    /// 
    /// Switch back to not specifying the content type of this surface. This is
    /// equivalent to setting the content type to none, including double
    /// buffering semantics. See set_content_type for details.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
    ///   - _: the content type
    public func setContentType(_ contentType: Type) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(contentType.rawValue),
        ])
    }

    
    public static let `protocol`: Protocol = ContentTypeV1Protocol
    
    public enum `Type`: UInt32 {
        case `none` = 0

        case photo = 1

        case video = 2

        case game = 3
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let ContentTypeV1Protocol = Protocol(
        name: "content_type_v1",
        interfaces: [
            WpContentTypeManagerV1.interface,
WpContentTypeV1.interface
        ]
    )

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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_output",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_color_management_output_v1",
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_color_management_surface_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_surface_feedback",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_color_management_surface_feedback_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "create_icc_creator",
                    arguments: [
                        Argument(
                            name: "obj",
                            type: .newId,
                            interface: "wp_image_description_creator_icc_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "create_parametric_creator",
                    arguments: [
                        Argument(
                            name: "obj",
                            type: .newId,
                            interface: "wp_image_description_creator_params_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "create_windows_scrgb",
                    arguments: [
                        Argument(
                            name: "image_description",
                            type: .newId,
                            interface: "wp_image_description_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_image_description",
                    arguments: [
                        Argument(
                            name: "image_description",
                            type: .newId,
                            interface: "wp_image_description_v1",
                        )
                        ,
                        Argument(
                            name: "reference",
                            type: .object,
                            interface: "wp_image_description_reference_v1",
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "create_windows_bt2100",
                    arguments: [
                        Argument(
                            name: "image_description",
                            type: .newId,
                            interface: "wp_image_description_v1",
                        )
                        ,
                    ],
                    since: 3
                )
                ,
            ],
            events: [
                Message(
                    name: "supported_intent",
                    arguments: [
                        Argument(
                            name: "render_intent",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "supported_feature",
                    arguments: [
                        Argument(
                            name: "feature",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "supported_tf_named",
                    arguments: [
                        Argument(
                            name: "tf",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "supported_primaries_named",
                    arguments: [
                        Argument(
                            name: "primaries",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Color Manager
    /// 
    /// Destroy the wp_color_manager_v1 object. This does not affect any other
    /// objects in any way.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
        let id = connection.sendConstructor(self, 1, WpColorManagementOutputV1.self, version, _queue, [
            .newId,
            .object(output),
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
        let id = connection.sendConstructor(self, 2, WpColorManagementSurfaceV1.self, version, _queue, [
            .newId,
            .object(surface),
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
        let id = connection.sendConstructor(self, 3, WpColorManagementSurfaceFeedbackV1.self, version, _queue, [
            .newId,
            .object(surface),
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
        let obj = connection.sendConstructor(self, 4, WpImageDescriptionCreatorIccV1.self, version, _queue, [
            .newId,
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
        let obj = connection.sendConstructor(self, 5, WpImageDescriptionCreatorParamsV1.self, version, _queue, [
            .newId,
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
        let imageDescription = connection.sendConstructor(self, 6, WpImageDescriptionV1.self, version, _queue, [
            .newId,
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
        let imageDescription = connection.sendConstructor(self, 7, WpImageDescriptionV1.self, version, _queue, [
            .newId,
            .object(reference),
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
        let imageDescription = connection.sendConstructor(self, 8, WpImageDescriptionV1.self, version, _queue, [
            .newId,
        ])
        return imageDescription
    }

    
    public static let `protocol`: Protocol = ColorManagementV1Protocol
    
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

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
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

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.supportedIntent(renderIntent: try r.`enum`(RenderIntent.self))
            case 1:
                self = Self.supportedFeature(feature: try r.`enum`(Feature.self))
            case 2:
                self = Self.supportedTfNamed(tf: try r.`enum`(TransferFunction.self))
            case 3:
                self = Self.supportedPrimariesNamed(primaries: try r.`enum`(Primaries.self))
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_image_description",
                    arguments: [
                        Argument(
                            name: "image_description",
                            type: .newId,
                            interface: "wp_image_description_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "image_description_changed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Color Management Output
    /// 
    /// Destroy the color wp_color_management_output_v1 object. This does not
    /// affect any remaining protocol objects.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
        let imageDescription = connection.sendConstructor(self, 1, WpImageDescriptionV1.self, version, _queue, [
            .newId,
        ])
        return imageDescription
    }

    
    public static let `protocol`: Protocol = ColorManagementV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Image Description Changed
        /// 
        /// This event is sent whenever the image description of the output changed,
        /// followed by one wl_output.done event common to output events across all
        /// extensions.
        /// If the client wants to use the updated image description, it needs to do
        /// get_image_description again, because image description objects are
        /// immutable.
        case imageDescriptionChanged

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_image_description",
                    arguments: [
                        Argument(
                            name: "image_description",
                            type: .object,
                            interface: "wp_image_description_v1",
                        )
                        ,
                        Argument(
                            name: "render_intent",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "unset_image_description",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Color Management Interface For A Surface
    /// 
    /// Destroy the wp_color_management_surface_v1 object and do the same as
    /// unset_image_description.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
            .object(imageDescription),
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

    
    public static let `protocol`: Protocol = ColorManagementV1Protocol
    
    public enum Error: UInt32 {
        /// unsupported rendering intent
        case renderIntent = 0

        /// invalid image description
        case imageDescription = 1

        /// forbidden request on inert object
        case inert = 2
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_preferred",
                    arguments: [
                        Argument(
                            name: "image_description",
                            type: .newId,
                            interface: "wp_image_description_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_preferred_parametric",
                    arguments: [
                        Argument(
                            name: "image_description",
                            type: .newId,
                            interface: "wp_image_description_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "preferred_changed",
                    arguments: [
                        Argument(
                            name: "identity",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preferred_changed2",
                    arguments: [
                        Argument(
                            name: "identity_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "identity_lo",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
            ],
        )
    /// Destroy The Color Management Interface For A Surface
    /// 
    /// Destroy the wp_color_management_surface_feedback_v1 object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
        let imageDescription = connection.sendConstructor(self, 1, WpImageDescriptionV1.self, version, _queue, [
            .newId,
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
        let imageDescription = connection.sendConstructor(self, 2, WpImageDescriptionV1.self, version, _queue, [
            .newId,
        ])
        return imageDescription
    }

    
    public static let `protocol`: Protocol = ColorManagementV1Protocol
    
    public enum Error: UInt32 {
        /// forbidden request on inert object
        case inert = 0

        /// attempted to use an unsupported feature
        case unsupportedFeature = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
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

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
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
            requests: [
                Message(
                    name: "create",
                    type: .destructor,
                    arguments: [
                        Argument(
                            name: "image_description",
                            type: .newId,
                            interface: "wp_image_description_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_icc_file",
                    arguments: [
                        Argument(
                            name: "icc_profile",
                            type: .fd,
                        )
                        ,
                        Argument(
                            name: "offset",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "length",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
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
        connection.destroy(self)
        let imageDescription = connection.sendConstructor(self, 0, WpImageDescriptionV1.self, version, _queue, [
            .newId,
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

    
    public static let `protocol`: Protocol = ColorManagementV1Protocol
    
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

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
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
            requests: [
                Message(
                    name: "create",
                    type: .destructor,
                    arguments: [
                        Argument(
                            name: "image_description",
                            type: .newId,
                            interface: "wp_image_description_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_tf_named",
                    arguments: [
                        Argument(
                            name: "tf",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_tf_power",
                    arguments: [
                        Argument(
                            name: "eexp",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_primaries_named",
                    arguments: [
                        Argument(
                            name: "primaries",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_primaries",
                    arguments: [
                        Argument(
                            name: "r_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "r_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "g_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "g_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "b_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "b_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "w_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "w_y",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_luminances",
                    arguments: [
                        Argument(
                            name: "min_lum",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "max_lum",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "reference_lum",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_mastering_display_primaries",
                    arguments: [
                        Argument(
                            name: "r_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "r_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "g_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "g_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "b_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "b_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "w_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "w_y",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_mastering_luminance",
                    arguments: [
                        Argument(
                            name: "min_lum",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "max_lum",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_max_cll",
                    arguments: [
                        Argument(
                            name: "max_cll",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_max_fall",
                    arguments: [
                        Argument(
                            name: "max_fall",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
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
        connection.destroy(self)
        let imageDescription = connection.sendConstructor(self, 0, WpImageDescriptionV1.self, version, _queue, [
            .newId,
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

    
    public static let `protocol`: Protocol = ColorManagementV1Protocol
    
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

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_information",
                    arguments: [
                        Argument(
                            name: "information",
                            type: .newId,
                            interface: "wp_image_description_info_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "failed",
                    arguments: [
                        Argument(
                            name: "cause",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "msg",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "ready",
                    arguments: [
                        Argument(
                            name: "identity",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "ready2",
                    arguments: [
                        Argument(
                            name: "identity_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "identity_lo",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
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
        connection.destroy(self)
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
        let information = connection.sendConstructor(self, 1, WpImageDescriptionInfoV1.self, version, _queue, [
            .newId,
        ])
        return information
    }

    
    public static let `protocol`: Protocol = ColorManagementV1Protocol
    
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

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
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

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.failed(cause: try r.`enum`(Cause.self), msg: r.string())
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
            events: [
                Message(
                    name: "done",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "icc_file",
                    arguments: [
                        Argument(
                            name: "icc",
                            type: .fd,
                        )
                        ,
                        Argument(
                            name: "icc_size",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "primaries",
                    arguments: [
                        Argument(
                            name: "r_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "r_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "g_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "g_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "b_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "b_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "w_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "w_y",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "primaries_named",
                    arguments: [
                        Argument(
                            name: "primaries",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "tf_power",
                    arguments: [
                        Argument(
                            name: "eexp",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "tf_named",
                    arguments: [
                        Argument(
                            name: "tf",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "luminances",
                    arguments: [
                        Argument(
                            name: "min_lum",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "max_lum",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "reference_lum",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "target_primaries",
                    arguments: [
                        Argument(
                            name: "r_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "r_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "g_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "g_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "b_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "b_y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "w_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "w_y",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "target_luminance",
                    arguments: [
                        Argument(
                            name: "min_lum",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "max_lum",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "target_max_cll",
                    arguments: [
                        Argument(
                            name: "max_cll",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "target_max_fall",
                    arguments: [
                        Argument(
                            name: "max_fall",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    
    public static let `protocol`: Protocol = ColorManagementV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
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

        public var isDestructor: Bool {
            switch self {
                case .done:
                    true
                default:
                    false
            }
        }

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.done
            case 1:
                self = Self.iccFile(icc: r.fd(), iccSize: r.uint())
            case 2:
                self = Self.primaries(rX: r.int(), rY: r.int(), gX: r.int(), gY: r.int(), bX: r.int(), bY: r.int(), wX: r.int(), wY: r.int())
            case 3:
                self = Self.primariesNamed(primaries: try r.`enum`(WpColorManagerV1.Primaries.self))
            case 4:
                self = Self.tfPower(eexp: r.uint())
            case 5:
                self = Self.tfNamed(tf: try r.`enum`(WpColorManagerV1.TransferFunction.self))
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Reference
    /// 
    /// Destroy this object. This has no effect on the referenced image
    /// description.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = ColorManagementV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
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
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_color_representation_surface_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "supported_alpha_mode",
                    arguments: [
                        Argument(
                            name: "alpha_mode",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "supported_coefficients_and_ranges",
                    arguments: [
                        Argument(
                            name: "coefficients",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "range",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Manager
    /// 
    /// Destroy the wp_color_representation_manager_v1 object. This does not
    /// affect any other objects in any way.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
        let id = connection.sendConstructor(self, 1, WpColorRepresentationSurfaceV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = ColorRepresentationV1Protocol
    
    public enum Error: UInt32 {
        /// color representation surface exists already
        case surfaceExists = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
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
                self = Self.supportedAlphaMode(alphaMode: try r.`enum`(WpColorRepresentationSurfaceV1.AlphaMode.self))
            case 1:
                self = Self.supportedCoefficientsAndRanges(coefficients: try r.`enum`(WpColorRepresentationSurfaceV1.Coefficients.self), range: try r.`enum`(WpColorRepresentationSurfaceV1.Range.self))
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
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_alpha_mode",
                    arguments: [
                        Argument(
                            name: "alpha_mode",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_coefficients_and_range",
                    arguments: [
                        Argument(
                            name: "coefficients",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "range",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_chroma_location",
                    arguments: [
                        Argument(
                            name: "chroma_location",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
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
        connection.destroy(self)
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

    
    public static let `protocol`: Protocol = ColorRepresentationV1Protocol
    
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

    deinit {
        if self.isAlive {
            connection.destroy(self)
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

/// Lease Device
/// 
/// This protocol is used by Wayland compositors which act as Direct
/// Rendering Manager (DRM) masters to lease DRM resources to Wayland
/// clients.
/// The compositor will advertise one wp_drm_lease_device_v1 global for each
/// DRM node. Some time after a client binds to the wp_drm_lease_device_v1
/// global, the compositor will send a drm_fd event followed by zero, one or
/// more connector events. After all currently available connectors have been
/// sent, the compositor will send a wp_drm_lease_device_v1.done event.
/// When the list of connectors available for lease changes the compositor
/// will send wp_drm_lease_device_v1.connector events for added connectors and
/// wp_drm_lease_connector_v1.withdrawn events for removed connectors,
/// followed by a wp_drm_lease_device_v1.done event.
/// The compositor will indicate when a device is gone by removing the global
/// via a wl_registry.global_remove event. Upon receiving this event, the
/// client should destroy any matching wp_drm_lease_device_v1 object.
/// To destroy a wp_drm_lease_device_v1 object, the client must first issue
/// a release request. Upon receiving this request, the compositor will
/// immediately send a released event and destroy the object. The client must
/// continue to process and discard drm_fd and connector events until it
/// receives the released event. Upon receiving the released event, the
/// client can safely cleanup any client-side resources.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpDrmLeaseDeviceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_drm_lease_device_v1",
            version: 1,
            requests: [
                Message(
                    name: "create_lease_request",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_drm_lease_request_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "release",
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "drm_fd",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "connector",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_drm_lease_connector_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "released",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Create A Lease Request Object
    /// 
    /// Creates a lease request object.
    /// See the documentation for wp_drm_lease_request_v1 for details.
    public func createLeaseRequest(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpDrmLeaseRequestV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, WpDrmLeaseRequestV1.self, version, _queue, [
            .newId,
        ])
        return id
    }

    /// Release This Object
    /// 
    /// Indicates the client no longer wishes to use this object. In response
    /// the compositor will immediately send the released event and destroy
    /// this object. It can however not guarantee that the client won't receive
    /// connector events before the released event. The client must not send any
    /// requests after this one, doing so will raise a wl_display error.
    /// Existing connectors, lease request and leases will not be affected.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = DrmLeaseV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Open A Non-Master Fd For This Drm Node
        /// 
        /// The compositor will send this event when the wp_drm_lease_device_v1
        /// global is bound, although there are no guarantees as to how long this
        /// takes - the compositor might need to wait until regaining DRM master.
        /// The included fd is a non-master DRM file descriptor opened for this
        /// device and the compositor must not authenticate it.
        /// The purpose of this event is to give the client the ability to
        /// query DRM and discover information which may help them pick the
        /// appropriate DRM device or select the appropriate connectors therein.
        case drmFd(fd: FileHandle)

        /// Advertise Connectors Available For Leases
        /// 
        /// The compositor will use this event to advertise connectors available for
        /// lease by clients. This object may be passed into a lease request to
        /// indicate the client would like to lease that connector, see
        /// wp_drm_lease_request_v1.request_connector for details. While the
        /// compositor will make a best effort to not send disconnected connectors,
        /// no guarantees can be made.
        /// The compositor must send the drm_fd event before sending connectors.
        /// After the drm_fd event it will send all available connectors but may
        /// send additional connectors at any time.
        case connector(id: WpDrmLeaseConnectorV1)

        /// Signals Grouping Of Connectors
        /// 
        /// The compositor will send this event to indicate that it has sent all
        /// currently available connectors after the client binds to the global or
        /// when it updates the connector list, for example on hotplug, drm master
        /// change or when a leased connector becomes available again. It will
        /// similarly send this event to group wp_drm_lease_connector_v1.withdrawn
        /// events of connectors of this device.
        case done

        /// The Compositor Has Finished Using The Device
        /// 
        /// This event is sent in response to the release request and indicates
        /// that the compositor is done sending connector events.
        /// The compositor will destroy this object immediately after sending the
        /// event and it will become invalid. The client should release any
        /// resources associated with this device after receiving this event.
        case released

        public var isDestructor: Bool {
            switch self {
                case .released:
                    true
                default:
                    false
            }
        }

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.drmFd(fd: r.fd())
            case 1:
                self = Self.connector(id: r.newId(type: WpDrmLeaseConnectorV1.self))
            case 2:
                self = Self.done
            case 3:
                self = Self.released
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Leasable Drm Connector
/// 
/// Represents a DRM connector which is available for lease. These objects are
/// created via wp_drm_lease_device_v1.connector events, and should be passed
/// to lease requests via wp_drm_lease_request_v1.request_connector.
/// Immediately after the wp_drm_lease_connector_v1 object is created the
/// compositor will send a name, a description, a connector_id and a done
/// event. When the description is updated the compositor will send a
/// description event followed by a done event.
public final class WpDrmLeaseConnectorV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_drm_lease_connector_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "name",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "description",
                    arguments: [
                        Argument(
                            name: "description",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "connector_id",
                    arguments: [
                        Argument(
                            name: "connector_id",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "withdrawn",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy Connector
    /// 
    /// The client may send this request to indicate that it will not use this
    /// connector. Clients are encouraged to send this after receiving the
    /// "withdrawn" event so that the server can release the resources
    /// associated with this connector offer. Neither existing lease requests
    /// nor leases will be affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = DrmLeaseV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Name
        /// 
        /// The compositor sends this event once the connector is created to
        /// indicate the name of this connector. This will not change for the
        /// duration of the Wayland session, but is not guaranteed to be consistent
        /// between sessions.
        /// If the compositor supports wl_output version 4 and this connector
        /// corresponds to a wl_output, the compositor should use the same name as
        /// for the wl_output.
        case name(name: String)

        /// Description
        /// 
        /// The compositor sends this event once the connector is created to provide
        /// a human-readable description for this connector, which may be presented
        /// to the user. The compositor may send this event multiple times over the
        /// lifetime of this object to reflect changes in the description.
        case description(description: String)

        /// Connector_Id
        /// 
        /// The compositor sends this event once the connector is created to
        /// indicate the DRM object ID which represents the underlying connector
        /// that is being offered. Note that the final lease may include additional
        /// object IDs, such as CRTCs and planes.
        case connectorId(connectorId: UInt32)

        /// All Properties Have Been Sent
        /// 
        /// This event is sent after all properties of a connector have been sent.
        /// This allows changes to the properties to be seen as atomic even if they
        /// happen via multiple events.
        case done

        /// Lease Offer Withdrawn
        /// 
        /// Sent to indicate that the compositor will no longer honor requests for
        /// DRM leases which include this connector. The client may still issue a
        /// lease request including this connector, but the compositor will send
        /// wp_drm_lease_v1.finished without issuing a lease fd. Compositors are
        /// encouraged to send this event when they lose access to connector, for
        /// example when the connector is hot-unplugged, when the connector gets
        /// leased to a client or when the compositor loses DRM master.
        /// If a client holds a lease for the connector, the status of the lease
        /// remains the same. The client should destroy the object after receiving
        /// this event.
        case withdrawn

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.name(name: r.string())
            case 1:
                self = Self.description(description: r.string())
            case 2:
                self = Self.connectorId(connectorId: r.uint())
            case 3:
                self = Self.done
            case 4:
                self = Self.withdrawn
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Drm Lease Request
/// 
/// A client that wishes to lease DRM resources will attach the list of
/// connectors advertised with wp_drm_lease_device_v1.connector that they
/// wish to lease, then use wp_drm_lease_request_v1.submit to submit the
/// request.
public final class WpDrmLeaseRequestV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_drm_lease_request_v1",
            version: 1,
            requests: [
                Message(
                    name: "request_connector",
                    arguments: [
                        Argument(
                            name: "connector",
                            type: .object,
                            interface: "wp_drm_lease_connector_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "submit",
                    type: .destructor,
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_drm_lease_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Request A Connector For This Lease
    /// 
    /// Indicates that the client would like to lease the given connector.
    /// This is only used as a suggestion, the compositor may choose to
    /// include any resources in the lease it issues, or change the set of
    /// leased resources at any time. Compositors are however encouraged to
    /// include the requested connector and other resources necessary
    /// to drive the connected output in the lease.
    /// Requesting a connector that was created from a different lease device
    /// than this lease request raises the wrong_device error. Requesting a
    /// connector twice will raise the duplicate_connector error.
    /// 
    /// - Parameters:
    public func requestConnector(connector: WpDrmLeaseConnectorV1) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(connector),
        ])
    }

    /// Submit The Lease Request
    /// 
    /// Submits the lease request and creates a new wp_drm_lease_v1 object.
    /// After calling submit the compositor will immediately destroy this
    /// object, issuing any more requests will cause a wl_display error.
    /// The compositor doesn't make any guarantees about the events of the
    /// lease object, clients cannot expect an immediate response.
    /// Not requesting any connectors before submitting the lease request
    /// will raise the empty_lease error.
    public func submit(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpDrmLeaseV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        let id = connection.sendConstructor(self, 1, WpDrmLeaseV1.self, version, _queue, [
            .newId,
        ])
        return id
    }

    
    public static let `protocol`: Protocol = DrmLeaseV1Protocol
    
    public enum Error: UInt32 {
        /// requested a connector from a different lease device
        case wrongDevice = 0

        /// requested a connector twice
        case duplicateConnector = 1

        /// requested a lease without requesting a connector
        case emptyLease = 2
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// A Drm Lease
/// 
/// A DRM lease object is used to transfer the DRM file descriptor to the
/// client and manage the lifetime of the lease.
/// Some time after the wp_drm_lease_v1 object is created, the compositor
/// will reply with the lease request's result. If the lease request is
/// granted, the compositor will send a lease_fd event. If the lease request
/// is denied, the compositor will send a finished event without a lease_fd
/// event.
public final class WpDrmLeaseV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_drm_lease_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "lease_fd",
                    arguments: [
                        Argument(
                            name: "leased_fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "finished",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroys The Lease Object
    /// 
    /// The client should send this to indicate that it no longer wishes to use
    /// this lease. The compositor should use drmModeRevokeLease on the
    /// appropriate file descriptor, if necessary.
    /// Upon destruction, the compositor should advertise the connector for
    /// leasing again by sending the connector event through the
    /// wp_drm_lease_device_v1 interface.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = DrmLeaseV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Shares The Drm File Descriptor
        /// 
        /// This event returns a file descriptor suitable for use with DRM-related
        /// ioctls. The client should use drmModeGetLease to enumerate the DRM
        /// objects which have been leased to them. The compositor guarantees it
        /// will not use the leased DRM objects itself until it sends the finished
        /// event. If the compositor cannot or will not grant a lease for the
        /// requested connectors, it will not send this event, instead sending the
        /// finished event.
        /// The compositor will send this event at most once during this objects
        /// lifetime.
        case leaseFd(leasedFd: FileHandle)

        /// Sent When The Lease Has Been Revoked
        /// 
        /// The compositor uses this event to either reject a lease request, or if
        /// it previously sent a lease_fd, to notify the client that the lease has
        /// been revoked. If the client requires a new lease, they should destroy
        /// this object and submit a new lease request. The compositor will send
        /// no further events for this object after sending the finish event.
        /// Compositors should revoke the lease when any of the leased resources
        /// become unavailable, namely when a hot-unplug occurs or when the
        /// compositor loses DRM master. Compositors may advertise the connector
        /// for leasing again, if the resource is available, by sending the
        /// connector event through the wp_drm_lease_device_v1 interface.
        case finished

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.leaseFd(leasedFd: r.fd())
            case 1:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let DrmLeaseV1Protocol = Protocol(
        name: "drm_lease_v1",
        interfaces: [
            WpDrmLeaseDeviceV1.interface,
WpDrmLeaseConnectorV1.interface,
WpDrmLeaseRequestV1.interface,
WpDrmLeaseV1.interface
        ]
    )

/// Protocol For Tearing Control
/// 
/// For some use cases like games or drawing tablets it can make sense to
/// reduce latency by accepting tearing with the use of asynchronous page
/// flips. This global is a factory interface, allowing clients to inform
/// which type of presentation the content of their surfaces is suitable for.
/// Graphics APIs like EGL or Vulkan, that manage the buffer queue and commits
/// of a wl_surface themselves, are likely to be using this extension
/// internally. If a client is using such an API for a wl_surface, it should
/// not directly use this extension on that surface, to avoid raising a
/// tearing_control_exists protocol error.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpTearingControlManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_tearing_control_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_tearing_control",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_tearing_control_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy Tearing Control Factory Object
    /// 
    /// Destroy this tearing control factory object. Other objects, including
    /// wp_tearing_control_v1 objects created by this factory, are not affected
    /// by this request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Extend Surface Interface For Tearing Control
    /// 
    /// Instantiate an interface extension for the given wl_surface to request
    /// asynchronous page flips for presentation.
    /// If the given wl_surface already has a wp_tearing_control_v1 object
    /// associated, the tearing_control_exists protocol error is raised.
    /// 
    /// - Parameters:
    public func getTearingControl(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpTearingControlV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, WpTearingControlV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = TearingControlV1Protocol
    
    public enum Error: UInt32 {
        /// the surface already has a tearing object associated
        case tearingControlExists = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Per-Surface Tearing Control Interface
/// 
/// An additional interface to a wl_surface object, which allows the client
/// to hint to the compositor if the content on the surface is suitable for
/// presentation with tearing.
/// The default presentation hint is vsync. See presentation_hint for more
/// details.
/// If the associated wl_surface is destroyed, this object becomes inert and
/// should be destroyed.
public final class WpTearingControlV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_tearing_control_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_presentation_hint",
                    arguments: [
                        Argument(
                            name: "hint",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Set Presentation Hint
    /// 
    /// Set the presentation hint for the associated wl_surface. This state is
    /// double-buffered, see wl_surface.commit.
    /// The compositor is free to dynamically respect or ignore this hint based
    /// on various conditions like hardware capabilities, surface state and
    /// user preferences.
    /// 
    /// - Parameters:
    public func setPresentationHint(hint: PresentationHint) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(hint.rawValue),
        ])
    }

    /// Destroy Tearing Control Object
    /// 
    /// Destroy this surface tearing object and revert the presentation hint to
    /// vsync. The change will be applied on the next wl_surface.commit.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = TearingControlV1Protocol
    
    public enum PresentationHint: UInt32 {
        case vsync = 0

        case `async` = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let TearingControlV1Protocol = Protocol(
        name: "tearing_control_v1",
        interfaces: [
            WpTearingControlManagerV1.interface,
WpTearingControlV1.interface
        ]
    )

/// Fractional Surface Scale Information
/// 
/// A global interface for requesting surfaces to use fractional scales.
public final class WpFractionalScaleManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_fractional_scale_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_fractional_scale",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_fractional_scale_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Unbind The Fractional Surface Scale Interface
    /// 
    /// Informs the server that the client will not be using this protocol
    /// object anymore. This does not affect any other objects,
    /// wp_fractional_scale_v1 objects included.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Extend Surface Interface For Scale Information
    /// 
    /// Create an add-on object for the the wl_surface to let the compositor
    /// request fractional scales. If the given wl_surface already has a
    /// wp_fractional_scale_v1 object associated, the fractional_scale_exists
    /// protocol error is raised.
    /// 
    /// - Parameters:
    ///   - surface: the surface
    /// 
    /// - Returns: the new surface scale info interface id
    public func getFractionalScale(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpFractionalScaleV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, WpFractionalScaleV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = FractionalScaleV1Protocol
    
    public enum Error: UInt32 {
        /// the surface already has a fractional_scale object associated
        case fractionalScaleExists = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Fractional Scale Interface To A Wl_Surface
/// 
/// An additional interface to a wl_surface object which allows the compositor
/// to inform the client of the preferred scale.
public final class WpFractionalScaleV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_fractional_scale_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "preferred_scale",
                    arguments: [
                        Argument(
                            name: "scale",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Remove Surface Scale Information For Surface
    /// 
    /// Destroy the fractional scale object. When this object is destroyed,
    /// preferred_scale events will no longer be sent.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = FractionalScaleV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Notify Of New Preferred Scale
        /// 
        /// Notification of a new preferred scale for this surface that the
        /// compositor suggests that the client should use.
        /// The sent scale is the numerator of a fraction with a denominator of 120.
        case preferredScale(scale: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.preferredScale(scale: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let FractionalScaleV1Protocol = Protocol(
        name: "fractional_scale_v1",
        interfaces: [
            WpFractionalScaleManagerV1.interface,
WpFractionalScaleV1.interface
        ]
    )

/// Displays A Single Surface Per Output
/// 
/// Displays a single surface per output.
/// This interface provides a mechanism for a single client to display
/// simple full-screen surfaces.  While there technically may be multiple
/// clients bound to this interface, only one of those clients should be
/// shown at a time.
/// To present a surface, the client uses either the present_surface or
/// present_surface_for_mode requests.  Presenting a surface takes effect
/// on the next wl_surface.commit.  See the individual requests for
/// details about scaling and mode switches.
/// The client can have at most one surface per output at any time.
/// Requesting a surface to be presented on an output that already has a
/// surface replaces the previously presented surface.  Presenting a null
/// surface removes its content and effectively disables the output.
/// Exactly what happens when an output is "disabled" is
/// compositor-specific.  The same surface may be presented on multiple
/// outputs simultaneously.
/// Once a surface is presented on an output, it stays on that output
/// until either the client removes it or the compositor destroys the
/// output.  This way, the client can update the output's contents by
/// simply attaching a new buffer.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpFullscreenShellV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_fullscreen_shell_v1",
            version: 1,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "present_surface",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "method",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "present_surface_for_mode",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                        Argument(
                            name: "framerate",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "feedback",
                            type: .newId,
                            interface: "zwp_fullscreen_shell_mode_feedback_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "capability",
                    arguments: [
                        Argument(
                            name: "capability",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Release The Wl_Fullscreen_Shell Interface
    /// 
    /// Release the binding from the wl_fullscreen_shell interface.
    /// This destroys the server-side object and frees this binding.  If
    /// the client binds to wl_fullscreen_shell multiple times, it may wish
    /// to free some of those bindings.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Present Surface For Display
    /// 
    /// Present a surface on the given output.
    /// If the output is null, the compositor will present the surface on
    /// whatever display (or displays) it thinks best.  In particular, this
    /// may replace any or all surfaces currently presented so it should
    /// not be used in combination with placing surfaces on specific
    /// outputs.
    /// The method parameter is a hint to the compositor for how the surface
    /// is to be presented.  In particular, it tells the compositor how to
    /// handle a size mismatch between the presented surface and the
    /// output.  The compositor is free to ignore this parameter.
    /// The "zoom", "zoom_crop", and "stretch" methods imply a scaling
    /// operation on the surface.  This will override any kind of output
    /// scaling, so the buffer_scale property of the surface is effectively
    /// ignored.
    /// This request gives the surface the role of a fullscreen shell surface.
    /// If the surface already has another role, it raises a role protocol
    /// error.
    /// 
    /// - Parameters:
    public func presentSurface(surface: WlSurface? = nil, method: PresentMethod, output: WlOutput? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface),
            .uint(method.rawValue),
            .object(output),
        ])
    }

    /// Present Surface For Display At A Particular Mode
    /// 
    /// Presents a surface on the given output for a particular mode.
    /// If the current size of the output differs from that of the surface,
    /// the compositor will attempt to change the size of the output to
    /// match the surface.  The result of the mode-switch operation will be
    /// returned via the provided wl_fullscreen_shell_mode_feedback object.
    /// If the current output mode matches the one requested or if the
    /// compositor successfully switches the mode to match the surface,
    /// then the mode_successful event will be sent and the output will
    /// contain the contents of the given surface.  If the compositor
    /// cannot match the output size to the surface size, the mode_failed
    /// will be sent and the output will contain the contents of the
    /// previously presented surface (if any).  If another surface is
    /// presented on the given output before either of these has a chance
    /// to happen, the present_cancelled event will be sent.
    /// Due to race conditions and other issues unknown to the client, no
    /// mode-switch operation is guaranteed to succeed.  However, if the
    /// mode is one advertised by wl_output.mode or if the compositor
    /// advertises the ARBITRARY_MODES capability, then the client should
    /// expect that the mode-switch operation will usually succeed.
    /// If the size of the presented surface changes, the resulting output
    /// is undefined.  The compositor may attempt to change the output mode
    /// to compensate.  However, there is no guarantee that a suitable mode
    /// will be found and the client has no way to be notified of success
    /// or failure.
    /// The framerate parameter specifies the desired framerate for the
    /// output in mHz.  The compositor is free to ignore this parameter.  A
    /// value of 0 indicates that the client has no preference.
    /// If the value of wl_output.scale differs from wl_surface.buffer_scale,
    /// then the compositor may choose a mode that matches either the buffer
    /// size or the surface size.  In either case, the surface will fill the
    /// output.
    /// This request gives the surface the role of a fullscreen shell surface.
    /// If the surface already has another role, it raises a role protocol
    /// error.
    /// 
    /// - Parameters:
    public func presentSurfaceForMode(surface: WlSurface, output: WlOutput, framerate: Int32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpFullscreenShellModeFeedbackV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let feedback = connection.sendConstructor(self, 2, ZwpFullscreenShellModeFeedbackV1.self, version, _queue, [
            .object(surface),
            .object(output),
            .int(framerate),
            .newId,
        ])
        return feedback
    }

    
    public static let `protocol`: Protocol = FullscreenShellUnstableV1Protocol
    
    public enum Capability: UInt32 {
        /// compositor is capable of almost any output mode
        case arbitraryModes = 1

        /// compositor has a separate cursor plane
        case cursorPlane = 2
    }

    public enum PresentMethod: UInt32 {
        /// no preference, apply default policy
        case `default` = 0

        /// center the surface on the output
        case center = 1

        /// scale the surface, preserving aspect ratio, to the largest size that will fit on the output
        case zoom = 2

        /// scale the surface, preserving aspect ratio, to fully fill the output cropping if needed
        case zoomCrop = 3

        /// scale the surface to the size of the output ignoring aspect ratio
        case stretch = 4
    }

    public enum Error: UInt32 {
        /// present_method is not known
        case invalidMethod = 0

        /// given wl_surface has another role
        case role = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Advertises A Capability Of The Compositor
        /// 
        /// Advertises a single capability of the compositor.
        /// When the wl_fullscreen_shell interface is bound, this event is emitted
        /// once for each capability advertised.  Valid capabilities are given by
        /// the wl_fullscreen_shell.capability enum.  If clients want to take
        /// advantage of any of these capabilities, they should use a
        /// wl_display.sync request immediately after binding to ensure that they
        /// receive all the capability events.
        case capability(capability: Capability)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.capability(capability: try r.`enum`(Capability.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public final class ZwpFullscreenShellModeFeedbackV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_fullscreen_shell_mode_feedback_v1",
            version: 1,
            events: [
                Message(
                    name: "mode_successful",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "mode_failed",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "present_cancelled",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    
    public static let `protocol`: Protocol = FullscreenShellUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Mode Switch Succeeded
        /// 
        /// This event indicates that the attempted mode switch operation was
        /// successful.  A surface of the size requested in the mode switch
        /// will fill the output without scaling.
        /// Upon receiving this event, the client should destroy the
        /// wl_fullscreen_shell_mode_feedback object.
        case modeSuccessful

        /// Mode Switch Failed
        /// 
        /// This event indicates that the attempted mode switch operation
        /// failed.  This may be because the requested output mode is not
        /// possible or it may mean that the compositor does not want to allow it.
        /// Upon receiving this event, the client should destroy the
        /// wl_fullscreen_shell_mode_feedback object.
        case modeFailed

        /// Mode Switch Cancelled
        /// 
        /// This event indicates that the attempted mode switch operation was
        /// cancelled.  Most likely this is because the client requested a
        /// second mode switch before the first one completed.
        /// Upon receiving this event, the client should destroy the
        /// wl_fullscreen_shell_mode_feedback object.
        case presentCancelled

        public var isDestructor: Bool {
            true
        }

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.modeSuccessful
            case 1:
                self = Self.modeFailed
            case 2:
                self = Self.presentCancelled
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let FullscreenShellUnstableV1Protocol = Protocol(
        name: "fullscreen_shell_unstable_v1",
        interfaces: [
            ZwpFullscreenShellV1.interface,
ZwpFullscreenShellModeFeedbackV1.interface
        ]
    )

/// Control Behavior When Display Idles
/// 
/// This interface permits inhibiting the idle behavior such as screen
/// blanking, locking, and screensaving.  The client binds the idle manager
/// globally, then creates idle-inhibitor objects for each surface.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpIdleInhibitManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_idle_inhibit_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "create_inhibitor",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_idle_inhibitor_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Idle Inhibitor Object
    /// 
    /// Destroy the inhibit manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Create A New Inhibitor Object
    /// 
    /// Create a new inhibitor object associated with the given surface.
    /// 
    /// - Parameters:
    ///   - surface: the surface that inhibits the idle behavior
    public func createInhibitor(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpIdleInhibitorV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpIdleInhibitorV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = IdleInhibitUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Context Object For Inhibiting Idle Behavior
/// 
/// An idle inhibitor prevents the output that the associated surface is
/// visible on from being set to a state where it is not visually usable due
/// to lack of user interaction (e.g. blanked, dimmed, locked, set to power
/// save, etc.)  Any screensaver processes are also blocked from displaying.
/// If the surface is destroyed, unmapped, becomes occluded, loses
/// visibility, or otherwise becomes not visually relevant for the user, the
/// idle inhibitor will not be honored by the compositor; if the surface
/// subsequently regains visibility the inhibitor takes effect once again.
/// Likewise, the inhibitor isn't honored if the system was already idled at
/// the time the inhibitor was established, although if the system later
/// de-idles and re-idles the inhibitor will take effect.
public final class ZwpIdleInhibitorV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_idle_inhibitor_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Idle Inhibitor Object
    /// 
    /// Remove the inhibitor effect from the associated wl_surface.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = IdleInhibitUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let IdleInhibitUnstableV1Protocol = Protocol(
        name: "idle_inhibit_unstable_v1",
        interfaces: [
            ZwpIdleInhibitManagerV1.interface,
ZwpIdleInhibitorV1.interface
        ]
    )

/// Input Method Context
/// 
/// Corresponds to a text input on the input method side. An input method context
/// is created on text input activation on the input method side. It allows
/// receiving information about the text input from the application via events.
/// Input method contexts do not keep state after deactivation and should be
/// destroyed after deactivation is handled.
/// Text is generally UTF-8 encoded, indices and lengths are in bytes.
/// Serials are used to synchronize the state between the text input and
/// an input method. New serials are sent by the text input in the
/// commit_state request and are used by the input method to indicate
/// the known text input state in events like preedit_string, commit_string,
/// and keysym. The text input can then ignore events from the input method
/// which are based on an outdated state (for example after a reset).
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpInputMethodContextV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_method_context_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "commit_string",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "text",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preedit_string",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "text",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "commit",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preedit_styling",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "length",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "style",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preedit_cursor",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "delete_surrounding_text",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "length",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "cursor_position",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "anchor",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "modifiers_map",
                    arguments: [
                        Argument(
                            name: "map",
                            type: .array,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "keysym",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "sym",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "modifiers",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "grab_keyboard",
                    arguments: [
                        Argument(
                            name: "keyboard",
                            type: .newId,
                            interface: "wl_keyboard",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "key",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "key",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "modifiers",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "mods_depressed",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "mods_latched",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "mods_locked",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "group",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "language",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "language",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "text_direction",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "direction",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "surrounding_text",
                    arguments: [
                        Argument(
                            name: "text",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "cursor",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "anchor",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "reset",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "content_type",
                    arguments: [
                        Argument(
                            name: "hint",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "purpose",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "invoke_action",
                    arguments: [
                        Argument(
                            name: "button",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "index",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "commit_state",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preferred_language",
                    arguments: [
                        Argument(
                            name: "language",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Commit String
    /// 
    /// Send the commit string text for insertion to the application.
    /// The text to commit could be either just a single character after a key
    /// press or the result of some composing (pre-edit). It could be also an
    /// empty text when some text should be removed (see
    /// delete_surrounding_text) or when the input cursor should be moved (see
    /// cursor_position).
    /// Any previously set composing text will be removed.
    /// 
    /// - Parameters:
    ///   - serial: serial of the latest known text input state
    public func commitString(serial: UInt32, text: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(serial),
            .string(text),
        ])
    }

    /// Pre-Edit String
    /// 
    /// Send the pre-edit string text to the application text input.
    /// The commit text can be used to replace the pre-edit text on reset (for
    /// example on unfocus).
    /// Previously sent preedit_style and preedit_cursor requests are also
    /// processed by the text_input.
    /// 
    /// - Parameters:
    ///   - serial: serial of the latest known text input state
    public func preeditString(serial: UInt32, text: String, commit: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .uint(serial),
            .string(text),
            .string(commit),
        ])
    }

    /// Pre-Edit Styling
    /// 
    /// Set the styling information on composing text. The style is applied for
    /// length in bytes from index relative to the beginning of
    /// the composing text (as byte offset). Multiple styles can
    /// be applied to a composing text.
    /// This request should be sent before sending a preedit_string request.
    /// 
    /// - Parameters:
    public func preeditStyling(index: UInt32, length: UInt32, style: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(index),
            .uint(length),
            .uint(style),
        ])
    }

    /// Pre-Edit Cursor
    /// 
    /// Set the cursor position inside the composing text (as byte offset)
    /// relative to the start of the composing text.
    /// When index is negative no cursor should be displayed.
    /// This request should be sent before sending a preedit_string request.
    /// 
    /// - Parameters:
    public func preeditCursor(index: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .int(index),
        ])
    }

    /// Delete Text
    /// 
    /// Remove the surrounding text.
    /// This request will be handled on the text_input side directly following
    /// a commit_string request.
    /// 
    /// - Parameters:
    public func deleteSurroundingText(index: Int32, length: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .int(index),
            .uint(length),
        ])
    }

    /// Set Cursor To A New Position
    /// 
    /// Set the cursor and anchor to a new position. Index is the new cursor
    /// position in bytes (when >= 0 this is relative to the end of the inserted text,
    /// otherwise it is relative to the beginning of the inserted text). Anchor is
    /// the new anchor position in bytes (when >= 0 this is relative to the end of the
    /// inserted text, otherwise it is relative to the beginning of the inserted
    /// text). When there should be no selected text, anchor should be the same
    /// as index.
    /// This request will be handled on the text_input side directly following
    /// a commit_string request.
    /// 
    /// - Parameters:
    public func cursorPosition(index: Int32, anchor: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .int(index),
            .int(anchor),
        ])
    }

    /// 
    /// - Parameters:
    public func modifiersMap(map: UnsafeRawBufferPointer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .array(map),
        ])
    }

    /// Keysym
    /// 
    /// Notify when a key event was sent. Key events should not be used for
    /// normal text input operations, which should be done with commit_string,
    /// delete_surrounding_text, etc. The key event follows the wl_keyboard key
    /// event convention. Sym is an XKB keysym, state is a wl_keyboard key_state.
    /// 
    /// - Parameters:
    ///   - serial: serial of the latest known text input state
    public func keysym(serial: UInt32, time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .uint(serial),
            .uint(time),
            .uint(sym),
            .uint(state),
            .uint(modifiers),
        ])
    }

    /// Grab Hardware Keyboard
    /// 
    /// Allow an input method to receive hardware keyboard input and process
    /// key events to generate text events (with pre-edit) over the wire. This
    /// allows input methods which compose multiple key events for inputting
    /// text like it is done for CJK languages.
    public func grabKeyboard(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WlKeyboard {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let keyboard = connection.sendConstructor(self, 9, WlKeyboard.self, version, _queue, [
            .newId,
        ])
        return keyboard
    }

    /// Forward Key Event
    /// 
    /// Forward a wl_keyboard::key event to the client that was not processed
    /// by the input method itself. Should be used when filtering key events
    /// with grab_keyboard.  The arguments should be the ones from the
    /// wl_keyboard::key event.
    /// For generating custom key events use the keysym request instead.
    /// 
    /// - Parameters:
    ///   - serial: serial from wl_keyboard::key
    ///   - time: time from wl_keyboard::key
    ///   - key: key from wl_keyboard::key
    ///   - state: state from wl_keyboard::key
    public func key(serial: UInt32, time: UInt32, key: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 10, [
            .uint(serial),
            .uint(time),
            .uint(key),
            .uint(state),
        ])
    }

    /// Forward Modifiers Event
    /// 
    /// Forward a wl_keyboard::modifiers event to the client that was not
    /// processed by the input method itself.  Should be used when filtering
    /// key events with grab_keyboard. The arguments should be the ones
    /// from the wl_keyboard::modifiers event.
    /// 
    /// - Parameters:
    ///   - serial: serial from wl_keyboard::modifiers
    ///   - modsDepressed: mods_depressed from wl_keyboard::modifiers
    ///   - modsLatched: mods_latched from wl_keyboard::modifiers
    ///   - modsLocked: mods_locked from wl_keyboard::modifiers
    ///   - group: group from wl_keyboard::modifiers
    public func modifiers(serial: UInt32, modsDepressed: UInt32, modsLatched: UInt32, modsLocked: UInt32, group: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 11, [
            .uint(serial),
            .uint(modsDepressed),
            .uint(modsLatched),
            .uint(modsLocked),
            .uint(group),
        ])
    }

    /// 
    /// - Parameters:
    ///   - serial: serial of the latest known text input state
    public func language(serial: UInt32, language: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 12, [
            .uint(serial),
            .string(language),
        ])
    }

    /// 
    /// - Parameters:
    ///   - serial: serial of the latest known text input state
    public func textDirection(serial: UInt32, direction: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 13, [
            .uint(serial),
            .uint(direction),
        ])
    }

    
    public static let `protocol`: Protocol = InputMethodUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Surrounding Text Event
        /// 
        /// The plain surrounding text around the input position. Cursor is the
        /// position in bytes within the surrounding text relative to the beginning
        /// of the text. Anchor is the position in bytes of the selection anchor
        /// within the surrounding text relative to the beginning of the text. If
        /// there is no selected text then anchor is the same as cursor.
        case surroundingText(text: String, cursor: UInt32, anchor: UInt32)

        case reset

        case contentType(hint: UInt32, purpose: UInt32)

        case invokeAction(button: UInt32, index: UInt32)

        case commitState(serial: UInt32)

        case preferredLanguage(language: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.surroundingText(text: r.string(), cursor: r.uint(), anchor: r.uint())
            case 1:
                self = Self.reset
            case 2:
                self = Self.contentType(hint: r.uint(), purpose: r.uint())
            case 3:
                self = Self.invokeAction(button: r.uint(), index: r.uint())
            case 4:
                self = Self.commitState(serial: r.uint())
            case 5:
                self = Self.preferredLanguage(language: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Input Method
/// 
/// An input method object is responsible for composing text in response to
/// input from hardware or virtual keyboards. There is one input method
/// object per seat. On activate there is a new input method context object
/// created which allows the input method to communicate with the text input.
public final class ZwpInputMethodV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_method_v1",
            version: 1,
            events: [
                Message(
                    name: "activate",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_input_method_context_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "deactivate",
                    arguments: [
                        Argument(
                            name: "context",
                            type: .object,
                            interface: "zwp_input_method_context_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    
    public static let `protocol`: Protocol = InputMethodUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Activate Event
        /// 
        /// A text input was activated. Creates an input method context object
        /// which allows communication with the text input.
        case activate(id: ZwpInputMethodContextV1)

        /// Deactivate Event
        /// 
        /// The text input corresponding to the context argument was deactivated.
        /// The input method context should be destroyed after deactivation is
        /// handled.
        case deactivate(context: ZwpInputMethodContextV1)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.activate(id: r.newId(type: ZwpInputMethodContextV1.self))
            case 1:
                self = Self.deactivate(context: r.object(type: ZwpInputMethodContextV1.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Interface For Implementing Keyboards
/// 
/// Only one client can bind this interface at a time.
public final class ZwpInputPanelV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_panel_v1",
            version: 1,
            requests: [
                Message(
                    name: "get_input_panel_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_input_panel_surface_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// 
    /// - Parameters:
    public func getInputPanelSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpInputPanelSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwpInputPanelSurfaceV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = InputMethodUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

public final class ZwpInputPanelSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_panel_surface_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_toplevel",
                    arguments: [
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                        Argument(
                            name: "position",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_overlay_panel",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Set The Surface Type As A Keyboard
    /// 
    /// Set the input_panel_surface type to keyboard.
    /// A keyboard surface is only shown when a text input is active.
    /// 
    /// - Parameters:
    public func setToplevel(output: WlOutput, position: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(output),
            .uint(position),
        ])
    }

    /// Set The Surface Type As An Overlay Panel
    /// 
    /// Set the input_panel_surface to be an overlay panel.
    /// This is shown near the input cursor above the application window when
    /// a text input is active.
    public func setOverlayPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = InputMethodUnstableV1Protocol
    
    public enum Position: UInt32 {
        case centerBottom = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let InputMethodUnstableV1Protocol = Protocol(
        name: "input_method_unstable_v1",
        interfaces: [
            ZwpInputMethodContextV1.interface,
ZwpInputMethodV1.interface,
ZwpInputPanelV1.interface,
ZwpInputPanelSurfaceV1.interface
        ]
    )

/// Context Object For High-Resolution Input Timestamps
/// 
/// A global interface used for requesting high-resolution timestamps
/// for input events.
public final class ZwpInputTimestampsManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_timestamps_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_keyboard_timestamps",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_input_timestamps_v1",
                        )
                        ,
                        Argument(
                            name: "keyboard",
                            type: .object,
                            interface: "wl_keyboard",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_pointer_timestamps",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_input_timestamps_v1",
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_touch_timestamps",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_input_timestamps_v1",
                        )
                        ,
                        Argument(
                            name: "touch",
                            type: .object,
                            interface: "wl_touch",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Input Timestamps Manager Object
    /// 
    /// Informs the server that the client will no longer be using this
    /// protocol object. Existing objects created by this object are not
    /// affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Subscribe To High-Resolution Keyboard Timestamp Events
    /// 
    /// Creates a new input timestamps object that represents a subscription
    /// to high-resolution timestamp events for all wl_keyboard events that
    /// carry a timestamp.
    /// If the associated wl_keyboard object is invalidated, either through
    /// client action (e.g. release) or server-side changes, the input
    /// timestamps object becomes inert and the client should destroy it
    /// by calling zwp_input_timestamps_v1.destroy.
    /// 
    /// - Parameters:
    ///   - keyboard: the wl_keyboard object for which to get timestamp events
    public func getKeyboardTimestamps(keyboard: WlKeyboard, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpInputTimestampsV1.self, version, _queue, [
            .newId,
            .object(keyboard),
        ])
        return id
    }

    /// Subscribe To High-Resolution Pointer Timestamp Events
    /// 
    /// Creates a new input timestamps object that represents a subscription
    /// to high-resolution timestamp events for all wl_pointer events that
    /// carry a timestamp.
    /// If the associated wl_pointer object is invalidated, either through
    /// client action (e.g. release) or server-side changes, the input
    /// timestamps object becomes inert and the client should destroy it
    /// by calling zwp_input_timestamps_v1.destroy.
    /// 
    /// - Parameters:
    ///   - pointer: the wl_pointer object for which to get timestamp events
    public func getPointerTimestamps(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 2, ZwpInputTimestampsV1.self, version, _queue, [
            .newId,
            .object(pointer),
        ])
        return id
    }

    /// Subscribe To High-Resolution Touch Timestamp Events
    /// 
    /// Creates a new input timestamps object that represents a subscription
    /// to high-resolution timestamp events for all wl_touch events that
    /// carry a timestamp.
    /// If the associated wl_touch object becomes invalid, either through
    /// client action (e.g. release) or server-side changes, the input
    /// timestamps object becomes inert and the client should destroy it
    /// by calling zwp_input_timestamps_v1.destroy.
    /// 
    /// - Parameters:
    ///   - touch: the wl_touch object for which to get timestamp events
    public func getTouchTimestamps(touch: WlTouch, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpInputTimestampsV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 3, ZwpInputTimestampsV1.self, version, _queue, [
            .newId,
            .object(touch),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = InputTimestampsUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Context Object For Input Timestamps
/// 
/// Provides high-resolution timestamp events for a set of subscribed input
/// events. The set of subscribed input events is determined by the
/// zwp_input_timestamps_manager_v1 request used to create this object.
public final class ZwpInputTimestampsV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_input_timestamps_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "timestamp",
                    arguments: [
                        Argument(
                            name: "tv_sec_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_sec_lo",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_nsec",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Input Timestamps Object
    /// 
    /// Informs the server that the client will no longer be using this
    /// protocol object. After the server processes the request, no more
    /// timestamp events will be emitted.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = InputTimestampsUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// High-Resolution Timestamp Event
        /// 
        /// The timestamp event is associated with the first subsequent input event
        /// carrying a timestamp which belongs to the set of input events this
        /// object is subscribed to.
        /// The timestamp provided by this event is a high-resolution version of
        /// the timestamp argument of the associated input event. The provided
        /// timestamp is in the same clock domain and is at least as accurate as
        /// the associated input event timestamp.
        /// The timestamp is expressed as tv_sec_hi, tv_sec_lo, tv_nsec triples,
        /// each component being an unsigned 32-bit value. Whole seconds are in
        /// tv_sec which is a 64-bit value combined from tv_sec_hi and tv_sec_lo,
        /// and the additional fractional part in tv_nsec as nanoseconds. Hence,
        /// for valid timestamps tv_nsec must be in [0, 999999999].
        case timestamp(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.timestamp(tvSecHi: r.uint(), tvSecLo: r.uint(), tvNsec: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let InputTimestampsUnstableV1Protocol = Protocol(
        name: "input_timestamps_unstable_v1",
        interfaces: [
            ZwpInputTimestampsManagerV1.interface,
ZwpInputTimestampsV1.interface
        ]
    )

/// Context Object For Keyboard Grab_Manager
/// 
/// A global interface used for inhibiting the compositor keyboard shortcuts.
public final class ZwpKeyboardShortcutsInhibitManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_keyboard_shortcuts_inhibit_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "inhibit_shortcuts",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_keyboard_shortcuts_inhibitor_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Keyboard Shortcuts Inhibitor Object
    /// 
    /// Destroy the keyboard shortcuts inhibitor manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Create A New Keyboard Shortcuts Inhibitor Object
    /// 
    /// Create a new keyboard shortcuts inhibitor object associated with
    /// the given surface for the given seat.
    /// If shortcuts are already inhibited for the specified seat and surface,
    /// a protocol error "already_inhibited" is raised by the compositor.
    /// 
    /// - Parameters:
    ///   - surface: the surface that inhibits the keyboard shortcuts behavior
    ///   - seat: the wl_seat for which keyboard shortcuts should be disabled
    public func inhibitShortcuts(surface: WlSurface, seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpKeyboardShortcutsInhibitorV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpKeyboardShortcutsInhibitorV1.self, version, _queue, [
            .newId,
            .object(surface),
            .object(seat),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = KeyboardShortcutsInhibitUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// the shortcuts are already inhibited for this surface
        case alreadyInhibited = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Context Object For Keyboard Shortcuts Inhibitor
/// 
/// A keyboard shortcuts inhibitor instructs the compositor to ignore
/// its own keyboard shortcuts when the associated surface has keyboard
/// focus. As a result, when the surface has keyboard focus on the given
/// seat, it will receive all key events originating from the specified
/// seat, even those which would normally be caught by the compositor for
/// its own shortcuts.
/// The Wayland compositor is however under no obligation to disable
/// all of its shortcuts, and may keep some special key combo for its own
/// use, including but not limited to one allowing the user to forcibly
/// restore normal keyboard events routing in the case of an unwilling
/// client. The compositor may also use the same key combo to reactivate
/// an existing shortcut inhibitor that was previously deactivated on
/// user request.
/// When the compositor restores its own keyboard shortcuts, an
/// "inactive" event is emitted to notify the client that the keyboard
/// shortcuts inhibitor is not effectively active for the surface and
/// seat any more, and the client should not expect to receive all
/// keyboard events.
/// When the keyboard shortcuts inhibitor is inactive, the client has
/// no way to forcibly reactivate the keyboard shortcuts inhibitor.
/// The user can chose to re-enable a previously deactivated keyboard
/// shortcuts inhibitor using any mechanism the compositor may offer,
/// in which case the compositor will send an "active" event to notify
/// the client.
/// If the surface is destroyed, unmapped, or loses the seat's keyboard
/// focus, the keyboard shortcuts inhibitor becomes irrelevant and the
/// compositor will restore its own keyboard shortcuts but no "inactive"
/// event is emitted in this case.
public final class ZwpKeyboardShortcutsInhibitorV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_keyboard_shortcuts_inhibitor_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "active",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "inactive",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Keyboard Shortcuts Inhibitor Object
    /// 
    /// Remove the keyboard shortcuts inhibitor from the associated wl_surface.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = KeyboardShortcutsInhibitUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Shortcuts Are Inhibited
        /// 
        /// This event indicates that the shortcut inhibitor is active.
        /// The compositor sends this event every time compositor shortcuts
        /// are inhibited on behalf of the surface. When active, the client
        /// may receive input events normally reserved by the compositor
        /// (see zwp_keyboard_shortcuts_inhibitor_v1).
        /// This occurs typically when the initial request "inhibit_shortcuts"
        /// first becomes active or when the user instructs the compositor to
        /// re-enable and existing shortcuts inhibitor using any mechanism
        /// offered by the compositor.
        case active

        /// Shortcuts Are Restored
        /// 
        /// This event indicates that the shortcuts inhibitor is inactive,
        /// normal shortcuts processing is restored by the compositor.
        case inactive

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.active
            case 1:
                self = Self.inactive
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let KeyboardShortcutsInhibitUnstableV1Protocol = Protocol(
        name: "keyboard_shortcuts_inhibit_unstable_v1",
        interfaces: [
            ZwpKeyboardShortcutsInhibitManagerV1.interface,
ZwpKeyboardShortcutsInhibitorV1.interface
        ]
    )

/// Factory For Creating Dmabuf-Based Wl_Buffers
/// 
/// This interface offers ways to create generic dmabuf-based wl_buffers.
/// For more information about dmabuf, see:
/// https://www.kernel.org/doc/html/next/userspace-api/dma-buf-alloc-exchange.html
/// Clients can use the get_surface_feedback request to get dmabuf feedback
/// for a particular surface. If the client wants to retrieve feedback not
/// tied to a surface, they can use the get_default_feedback request.
/// The following are required from clients:
/// - Clients must ensure that either all data in the dma-buf is
/// coherent for all subsequent read access or that coherency is
/// correctly handled by the underlying kernel-side dma-buf
/// implementation.
/// - Don't make any more attachments after sending the buffer to the
/// compositor. Making more attachments later increases the risk of
/// the compositor not being able to use (re-import) an existing
/// dmabuf-based wl_buffer.
/// The underlying graphics stack must ensure the following:
/// - The dmabuf file descriptors relayed to the server will stay valid
/// for the whole lifetime of the wl_buffer. This means the server may
/// at any time use those fds to import the dmabuf into any kernel
/// sub-system that might accept it.
/// However, when the underlying graphics stack fails to deliver the
/// promise, because of e.g. a device hot-unplug which raises internal
/// errors, after the wl_buffer has been successfully created the
/// compositor must not raise protocol errors to the client when dmabuf
/// import later fails.
/// To create a wl_buffer from one or more dmabufs, a client creates a
/// zwp_linux_buffer_params_v1 object with a zwp_linux_dmabuf_v1.create_params
/// request. All planes required by the intended format are added with
/// the 'add' request. Finally, a 'create' or 'create_immed' request is
/// issued, which has the following outcome depending on the import success.
/// The 'create' request,
/// - on success, triggers a 'created' event which provides the final
/// wl_buffer to the client.
/// - on failure, triggers a 'failed' event to convey that the server
/// cannot use the dmabufs received from the client.
/// For the 'create_immed' request,
/// - on success, the server immediately imports the added dmabufs to
/// create a wl_buffer. No event is sent from the server in this case.
/// - on failure, the server can choose to either:
/// - terminate the client by raising a fatal error.
/// - mark the wl_buffer as failed, and send a 'failed' event to the
/// client. If the client uses a failed wl_buffer as an argument to any
/// request, the behaviour is compositor implementation-defined.
/// For all DRM formats and unless specified in another protocol extension,
/// pre-multiplied alpha is used for pixel values.
/// Unless specified otherwise in another protocol extension, implicit
/// synchronization is used. In other words, compositors and clients must
/// wait and signal fences implicitly passed via the DMA-BUF's reservation
/// mechanism.
public final class ZwpLinuxDmabufV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_linux_dmabuf_v1",
            version: 6,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "create_params",
                    arguments: [
                        Argument(
                            name: "params_id",
                            type: .newId,
                            interface: "zwp_linux_buffer_params_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_default_feedback",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_linux_dmabuf_feedback_v1",
                        )
                        ,
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "get_surface_feedback",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_linux_dmabuf_feedback_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                    since: 4
                )
                ,
            ],
            events: [
                Message(
                    name: "format",
                    arguments: [
                        Argument(
                            name: "format",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "modifier",
                    arguments: [
                        Argument(
                            name: "format",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "modifier_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "modifier_lo",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
            ],
        )
    /// Unbind The Factory
    /// 
    /// Objects created through this interface, especially wl_buffers, will
    /// remain valid.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Create A Temporary Object For Buffer Parameters
    /// 
    /// This temporary object is used to collect multiple dmabuf handles into
    /// a single batch to create a wl_buffer. It can only be used once and
    /// should be destroyed after a 'created' or 'failed' event has been
    /// received.
    /// 
    /// - Returns: id for the newly created zwp_linux_buffer_params_v1
    public func createParams(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpLinuxBufferParamsV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let paramsId = connection.sendConstructor(self, 1, ZwpLinuxBufferParamsV1.self, version, _queue, [
            .newId,
        ])
        return paramsId
    }

    /// Get Default Feedback
    /// 
    /// This request creates a new zwp_linux_dmabuf_feedback_v1 object not bound
    /// to a particular surface. This object will deliver feedback about dmabuf
    /// parameters to use if the client doesn't support per-surface feedback
    /// (see get_surface_feedback).
    public func getDefaultFeedback(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpLinuxDmabufFeedbackV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let id = connection.sendConstructor(self, 2, ZwpLinuxDmabufFeedbackV1.self, version, _queue, [
            .newId,
        ])
        return id
    }

    /// Get Feedback For A Surface
    /// 
    /// This request creates a new zwp_linux_dmabuf_feedback_v1 object for the
    /// specified wl_surface. This object will deliver feedback about dmabuf
    /// parameters to use for buffers attached to this surface.
    /// If the surface is destroyed before the zwp_linux_dmabuf_feedback_v1 object,
    /// the feedback object becomes inert.
    /// 
    /// - Parameters:
    public func getSurfaceFeedback(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpLinuxDmabufFeedbackV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let id = connection.sendConstructor(self, 3, ZwpLinuxDmabufFeedbackV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = LinuxDmabufV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Supported Buffer Format
        /// 
        /// This event advertises one buffer format that the server supports.
        /// All the supported formats are advertised once when the client
        /// binds to this interface. A roundtrip after binding guarantees
        /// that the client has received all supported formats.
        /// For the definition of the format codes, see the
        /// zwp_linux_buffer_params_v1::create request.
        /// Starting version 4, the format event is deprecated and must not be
        /// sent by compositors. Instead, use get_default_feedback or
        /// get_surface_feedback.
        case format(format: UInt32)

        /// Supported Buffer Format Modifier
        /// 
        /// This event advertises the formats that the server supports, along with
        /// the modifiers supported for each format. All the supported modifiers
        /// for all the supported formats are advertised once when the client
        /// binds to this interface. A roundtrip after binding guarantees that
        /// the client has received all supported format-modifier pairs.
        /// For legacy support, DRM_FORMAT_MOD_INVALID (that is, modifier_hi ==
        /// 0x00ffffff and modifier_lo == 0xffffffff) is allowed in this event.
        /// It indicates that the server can support the format with an implicit
        /// modifier. When a plane has DRM_FORMAT_MOD_INVALID as its modifier, it
        /// is as if no explicit modifier is specified. The effective modifier
        /// will be derived from the dmabuf.
        /// A compositor that sends valid modifiers and DRM_FORMAT_MOD_INVALID for
        /// a given format supports both explicit modifiers and implicit modifiers.
        /// For the definition of the format and modifier codes, see the
        /// zwp_linux_buffer_params_v1::create and zwp_linux_buffer_params_v1::add
        /// requests.
        /// Starting version 4, the modifier event is deprecated and must not be
        /// sent by compositors. Instead, use get_default_feedback or
        /// get_surface_feedback.
        case modifier(format: UInt32, modifierHi: UInt32, modifierLo: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.format(format: r.uint())
            case 1:
                self = Self.modifier(format: r.uint(), modifierHi: r.uint(), modifierLo: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Parameters For Creating A Dmabuf-Based Wl_Buffer
/// 
/// This temporary object is a collection of dmabufs and other
/// parameters that together form a single logical buffer. The temporary
/// object may eventually create one wl_buffer unless cancelled by
/// destroying it before requesting 'create'.
/// Single-planar formats only require one dmabuf, however
/// multi-planar formats may require more than one dmabuf. For all
/// formats, an 'add' request must be called once per plane (even if the
/// underlying dmabuf fd is identical).
/// You must use consecutive plane indices ('plane_idx' argument for 'add')
/// from zero to the number of planes used by the drm_fourcc format code.
/// All planes required by the format must be given exactly once, but can
/// be given in any order. Each plane index can only be set once; subsequent
/// calls with a plane index which has already been set will result in a
/// plane_set error being generated.
public final class ZwpLinuxBufferParamsV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_linux_buffer_params_v1",
            version: 6,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "add",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                        Argument(
                            name: "plane_idx",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "offset",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "stride",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "modifier_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "modifier_lo",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "format",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "create_immed",
                    arguments: [
                        Argument(
                            name: "buffer_id",
                            type: .newId,
                            interface: "wl_buffer",
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "format",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "set_sampling_device",
                    arguments: [
                        Argument(
                            name: "device",
                            type: .array,
                        )
                        ,
                    ],
                    since: 6
                )
                ,
            ],
            events: [
                Message(
                    name: "created",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .newId,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "failed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Delete This Object, Used Or Not
    /// 
    /// Cleans up the temporary data sent to the server for dmabuf-based
    /// wl_buffer creation.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Add A Dmabuf To The Temporary Set
    /// 
    /// This request adds one dmabuf to the set in this
    /// zwp_linux_buffer_params_v1.
    /// The 64-bit unsigned value combined from modifier_hi and modifier_lo
    /// is the dmabuf layout modifier. DRM AddFB2 ioctl calls this the
    /// fb modifier, which is defined in drm_mode.h of Linux UAPI.
    /// This is an opaque token. Drivers use this token to express tiling,
    /// compression, etc. driver-specific modifications to the base format
    /// defined by the DRM fourcc code.
    /// Starting from version 4, the invalid_format protocol error is sent if
    /// the format + modifier pair was not advertised as supported.
    /// Starting from version 5, the invalid_format protocol error is sent if
    /// all planes don't use the same modifier.
    /// This request raises the PLANE_IDX error if plane_idx is too large.
    /// The error PLANE_SET is raised if attempting to set a plane that
    /// was already set.
    /// 
    /// - Parameters:
    ///   - fd: dmabuf fd
    ///   - planeIdx: plane index
    ///   - offset: offset in bytes
    ///   - stride: stride in bytes
    ///   - modifierHi: high 32 bits of layout modifier
    ///   - modifierLo: low 32 bits of layout modifier
    public func add(fd: FileHandle, planeIdx: UInt32, offset: UInt32, stride: UInt32, modifierHi: UInt32, modifierLo: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .fd(fd),
            .uint(planeIdx),
            .uint(offset),
            .uint(stride),
            .uint(modifierHi),
            .uint(modifierLo),
        ])
    }

    /// Create A Wl_Buffer From The Given Dmabufs
    /// 
    /// This asks for creation of a wl_buffer from the added dmabuf
    /// buffers. The wl_buffer is not created immediately but returned via
    /// the 'created' event if the dmabuf sharing succeeds. The sharing
    /// may fail at runtime for reasons a client cannot predict, in
    /// which case the 'failed' event is triggered.
    /// The 'format' argument is a DRM_FORMAT code, as defined by the
    /// libdrm's drm_fourcc.h. The Linux kernel's DRM sub-system is the
    /// authoritative source on how the format codes should work.
    /// The 'flags' is a bitfield of the flags defined in enum "flags".
    /// 'y_invert' means that the image needs to be y-flipped.
    /// Flag 'interlaced' means that the frame in the buffer is not
    /// progressive as usual, but interlaced. An interlaced buffer as
    /// supported here must always contain both top and bottom fields.
    /// The top field always begins on the first pixel row. The temporal
    /// ordering between the two fields is top field first, unless
    /// 'bottom_first' is specified. It is undefined whether 'bottom_first'
    /// is ignored if 'interlaced' is not set.
    /// This protocol does not convey any information about field rate,
    /// duration, or timing, other than the relative ordering between the
    /// two fields in one buffer. A compositor may have to estimate the
    /// intended field rate from the incoming buffer rate. It is undefined
    /// whether the time of receiving wl_surface.commit with a new buffer
    /// attached, applying the wl_surface state, wl_surface.frame callback
    /// trigger, presentation, or any other point in the compositor cycle
    /// is used to measure the frame or field times. There is no support
    /// for detecting missed or late frames/fields/buffers either, and
    /// there is no support whatsoever for cooperating with interlaced
    /// compositor output.
    /// The composited image quality resulting from the use of interlaced
    /// buffers is explicitly undefined. A compositor may use elaborate
    /// hardware features or software to deinterlace and create progressive
    /// output frames from a sequence of interlaced input buffers, or it
    /// may produce substandard image quality. However, compositors that
    /// cannot guarantee reasonable image quality in all cases are recommended
    /// to just reject all interlaced buffers.
    /// Any argument errors, including non-positive width or height,
    /// mismatch between the number of planes and the format, bad
    /// format, bad offset or stride, may be indicated by fatal protocol
    /// errors: INCOMPLETE, INVALID_FORMAT, INVALID_DIMENSIONS,
    /// OUT_OF_BOUNDS.
    /// Dmabuf import errors in the server that are not obvious client
    /// bugs are returned via the 'failed' event as non-fatal. This
    /// allows attempting dmabuf sharing and falling back in the client
    /// if it fails.
    /// This request can be sent only once in the object's lifetime, after
    /// which the only legal request is destroy. This object should be
    /// destroyed after issuing a 'create' request. Attempting to use this
    /// object after issuing 'create' raises the ALREADY_USED protocol error.
    /// It is not mandatory to issue 'create'. If a client wants to
    /// cancel the buffer creation, it can just destroy this object.
    /// 
    /// - Parameters:
    ///   - width: base plane width in pixels
    ///   - height: base plane height in pixels
    ///   - format: DRM_FORMAT code
    ///   - flags: see enum flags
    public func create(width: Int32, height: Int32, format: UInt32, flags: Flags) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(width),
            .int(height),
            .uint(format),
            .uint(flags.rawValue),
        ])
    }

    /// Immediately Create A Wl_Buffer From The Given                      Dmabufs
    /// 
    /// This asks for immediate creation of a wl_buffer by importing the
    /// added dmabufs.
    /// In case of import success, no event is sent from the server, and the
    /// wl_buffer is ready to be used by the client.
    /// Upon import failure, either of the following may happen, as seen fit
    /// by the implementation:
    /// - the client is terminated with one of the following fatal protocol
    /// errors:
    /// - INCOMPLETE, INVALID_FORMAT, INVALID_DIMENSIONS, OUT_OF_BOUNDS,
    /// in case of argument errors such as mismatch between the number
    /// of planes and the format, bad format, non-positive width or
    /// height, or bad offset or stride.
    /// - INVALID_WL_BUFFER, in case the cause for failure is unknown or
    /// platform specific.
    /// - the server creates an invalid wl_buffer, marks it as failed and
    /// sends a 'failed' event to the client. The result of using this
    /// invalid wl_buffer as an argument in any request by the client is
    /// defined by the compositor implementation.
    /// This takes the same arguments as a 'create' request, and obeys the
    /// same restrictions.
    /// 
    /// - Parameters:
    ///   - width: base plane width in pixels
    ///   - height: base plane height in pixels
    ///   - format: DRM_FORMAT code
    ///   - flags: see enum flags
    /// 
    /// - Returns: id for the newly created wl_buffer
    public func createImmed(width: Int32, height: Int32, format: UInt32, flags: Flags, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WlBuffer {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let bufferId = connection.sendConstructor(self, 3, WlBuffer.self, version, _queue, [
            .newId,
            .int(width),
            .int(height),
            .uint(format),
            .uint(flags.rawValue),
        ])
        return bufferId
    }

    /// Set The Target Device Of The Wl_Buffer
    /// 
    /// Set the device the compositor should import the dmabufs to for sampling
    /// in the next create or create_immed request.
    /// To avoid race conditions when the compositor removes a device from the
    /// tranches, it is not a protocol error if the device hasn't been advertised
    /// by the compositor in a tranche with the sampling flag, but the import is
    /// likely to fail in that case.
    /// If the client doesn't know a suitable target device, it shouldn't set one,
    /// and the compositor should attempt import on all devices it supports.
    /// If the array is too small to contain a dev_t or larger than required, the
    /// invalid_dev_t_size error will be emitted.
    /// 
    /// - Parameters:
    ///   - device: device dev_t value
    public func setSamplingDevice(device: UnsafeRawBufferPointer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 6 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 6) }
        connection.send(self, 4, [
            .array(device),
        ])
    }

    
    public static let `protocol`: Protocol = LinuxDmabufV1Protocol
    
    public enum Error: UInt32 {
        /// the zwp_linux_buffer_params_v1 object has already been used to create a wl_buffer
        case alreadyUsed = 0

        /// plane index out of bounds
        case planeIdx = 1

        /// the plane index was already set
        case planeSet = 2

        /// missing or too many planes to create a buffer
        case incomplete = 3

        /// format not supported
        case invalidFormat = 4

        /// invalid width or height
        case invalidDimensions = 5

        /// offset + stride * height goes out of dmabuf bounds
        case outOfBounds = 6

        /// invalid wl_buffer resulted from importing dmabufs via                the create_immed request on given buffer_params
        case invalidWlBuffer = 7

        /// an array with mismatching size for a dev_t was used
        case invalidDevTSize = 8
    }

    public struct Flags: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// contents are y-inverted
        public static let yInvert = Flags(rawValue: 1)

        /// content is interlaced
        public static let interlaced = Flags(rawValue: 2)

        /// bottom field first
        public static let bottomFirst = Flags(rawValue: 4)
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Buffer Creation Succeeded
        /// 
        /// This event indicates that the attempted buffer creation was
        /// successful. It provides the new wl_buffer referencing the dmabuf(s).
        /// Upon receiving this event, the client should destroy the
        /// zwp_linux_buffer_params_v1 object.
        case created(buffer: WlBuffer)

        /// Buffer Creation Failed
        /// 
        /// This event indicates that the attempted buffer creation has
        /// failed. It usually means that one of the dmabuf constraints
        /// has not been fulfilled.
        /// Upon receiving this event, the client should destroy the
        /// zwp_linux_buffer_params_v1 object.
        case failed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.created(buffer: r.newId(type: WlBuffer.self))
            case 1:
                self = Self.failed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Dmabuf Feedback
/// 
/// This object advertises dmabuf parameters feedback. This includes the
/// preferred devices and the supported formats/modifiers.
/// The parameters are sent once when this object is created and whenever they
/// change. The done event is always sent once after all parameters have been
/// sent. When a single parameter changes, all parameters are re-sent by the
/// compositor.
/// Compositors can re-send the parameters when the current client buffer
/// allocations are sub-optimal. Compositors should not re-send the
/// parameters if re-allocating the buffers would not result in a more optimal
/// configuration. In particular, compositors should avoid sending the exact
/// same parameters multiple times in a row.
/// The tranche_target_device and tranche_formats events are grouped by
/// tranches of preference. For each tranche, a tranche_target_device, one
/// tranche_flags and one or more tranche_formats events are sent, followed
/// by a tranche_done event finishing the list. The tranches are sent in
/// descending order of preference. All formats and modifiers in the same
/// tranche have the same preference.
/// To send parameters, the compositor sends one main_device event (unless
/// the client bound version 6 or above), tranches (each consisting of one
/// tranche_target_device event, one tranche_flags event, tranche_formats
/// events and then a tranche_done event), then one done event.
/// With version 6 and above, the compositor must always advertise at least
/// one tranche with the sampling flag set.
public final class ZwpLinuxDmabufFeedbackV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_linux_dmabuf_feedback_v1",
            version: 6,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "format_table",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                        Argument(
                            name: "size",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "main_device",
                    arguments: [
                        Argument(
                            name: "device",
                            type: .array,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "tranche_done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "tranche_target_device",
                    arguments: [
                        Argument(
                            name: "device",
                            type: .array,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "tranche_formats",
                    arguments: [
                        Argument(
                            name: "indices",
                            type: .array,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "tranche_flags",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Feedback Object
    /// 
    /// Using this request a client can tell the server that it is not going to
    /// use the zwp_linux_dmabuf_feedback_v1 object anymore.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = LinuxDmabufV1Protocol
    
    public struct TrancheFlags: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public static let scanout = TrancheFlags(rawValue: 1)

        public static let sampling = TrancheFlags(rawValue: 2)
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// All Feedback Has Been Sent
        /// 
        /// This event is sent after all parameters of a zwp_linux_dmabuf_feedback_v1
        /// object have been sent.
        /// This allows changes to the zwp_linux_dmabuf_feedback_v1 parameters to be
        /// seen as atomic, even if they happen via multiple events.
        case done

        /// Format And Modifier Table
        /// 
        /// This event provides a file descriptor which can be memory-mapped to
        /// access the format and modifier table.
        /// The table contains a tightly packed array of consecutive format +
        /// modifier pairs. Each pair is 16 bytes wide. It contains a format as a
        /// 32-bit unsigned integer, followed by 4 bytes of unused padding, and a
        /// modifier as a 64-bit unsigned integer. The native endianness is used.
        /// The client must map the file descriptor in read-only private mode.
        /// Compositors are not allowed to mutate the table file contents once this
        /// event has been sent. Instead, compositors must create a new, separate
        /// table file and re-send feedback parameters. Compositors are allowed to
        /// store duplicate format + modifier pairs in the table.
        case formatTable(fd: FileHandle, size: UInt32)

        /// Preferred Main Device
        /// 
        /// This event advertises the main device that the server prefers to use
        /// when direct scan-out to the target device isn't possible. The
        /// advertised main device may be different for each
        /// zwp_linux_dmabuf_feedback_v1 object, and may change over time.
        /// There is exactly one main device. The compositor must send at least
        /// one preference tranche with tranche_target_device equal to main_device.
        /// Clients need to create buffers that the main device can import and
        /// read from, otherwise creating the dmabuf wl_buffer will fail (see the
        /// zwp_linux_buffer_params_v1.create and create_immed requests for details).
        /// The main device will also likely be kept active by the compositor,
        /// so clients can use it instead of waking up another device for power
        /// savings.
        /// In general the device is a DRM node. The DRM node type (primary vs.
        /// render) is unspecified. Clients must not rely on the compositor sending
        /// a particular node type. Clients cannot check two devices for equality
        /// by comparing the dev_t value.
        /// If explicit modifiers are not supported and the client performs buffer
        /// allocations on a different device than the main device, then the client
        /// must force the buffer to have a linear layout.
        /// With version 6 and above, this event is no longer sent. Clients should
        /// use a device with the sampling flag in the tranches instead.
        case mainDevice(device: UnsafeRawBufferPointer)

        /// A Preference Tranche Has Been Sent
        /// 
        /// This event splits tranche_target_device and tranche_formats events into
        /// preference tranches. It is sent after a set of tranche_target_device
        /// and tranche_formats events; it represents the end of a tranche. The
        /// next tranche will have a lower preference.
        case trancheDone

        /// Target Device
        /// 
        /// This event advertises the target device that the server prefers to use
        /// for a buffer created given this tranche. The advertised target device
        /// may be different for each preference tranche, and may change over time.
        /// There is exactly one target device per tranche.
        /// The target device may be a scan-out device, for example if the
        /// compositor prefers to directly scan-out a buffer created given this
        /// tranche. The target device may be a rendering device, for example if
        /// the compositor prefers to texture from said buffer.
        /// The client can use this hint to allocate the buffer in a way that makes
        /// it accessible from the target device, ideally directly. The buffer must
        /// still be accessible from a device with the sampling flag, either through
        /// direct import or a potentially more expensive fallback path. If the
        /// buffer can't be directly imported for sampling, then clients must be
        /// prepared for the compositor changing the tranche priority or making
        /// wl_buffer creation fail (see the zwp_linux_buffer_params_v1.create and
        /// create_immed requests for details).
        /// If the device is a DRM node, the DRM node type (primary vs. render) is
        /// unspecified. Clients must not rely on the compositor sending a
        /// particular node type. Clients cannot check two devices for equality by
        /// comparing the dev_t value.
        /// This event is tied to a preference tranche, see the tranche_done event.
        case trancheTargetDevice(device: UnsafeRawBufferPointer)

        /// Supported Buffer Format Modifiers
        /// 
        /// This event advertises the format + modifier combinations that the
        /// compositor supports.
        /// It carries an array of indices, each referring to a format + modifier
        /// pair in the last received format table (see the format_table event).
        /// Each index is a 16-bit unsigned integer in native endianness.
        /// For legacy support, DRM_FORMAT_MOD_INVALID is an allowed modifier.
        /// It indicates that the server can support the format with an implicit
        /// modifier. When a buffer has DRM_FORMAT_MOD_INVALID as its modifier, it
        /// is as if no explicit modifier is specified. The effective modifier
        /// will be derived from the dmabuf.
        /// A compositor that sends valid modifiers and DRM_FORMAT_MOD_INVALID for
        /// a given format supports both explicit modifiers and implicit modifiers.
        /// Compositors must not send duplicate format + modifier pairs within the
        /// same tranche or across two different tranches with the same target
        /// device and flags.
        /// This event is tied to a preference tranche, see the tranche_done event.
        /// For the definition of the format and modifier codes, see the
        /// zwp_linux_buffer_params_v1.create request.
        case trancheFormats(indices: UnsafeRawBufferPointer)

        /// Tranche Flags
        /// 
        /// This event sets tranche-specific flags. This event is tied to a
        /// preference tranche, see the tranche_done event.
        /// With version 6 and above, the compositor must set at least one flag
        /// in each tranche.
        case trancheFlags(flags: TrancheFlags)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.done
            case 1:
                self = Self.formatTable(fd: r.fd(), size: r.uint())
            case 2:
                self = Self.mainDevice(device: r.array())
            case 3:
                self = Self.trancheDone
            case 4:
                self = Self.trancheTargetDevice(device: r.array())
            case 5:
                self = Self.trancheFormats(indices: r.array())
            case 6:
                self = Self.trancheFlags(flags: try r.`enum`(TrancheFlags.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let LinuxDmabufV1Protocol = Protocol(
        name: "linux_dmabuf_v1",
        interfaces: [
            ZwpLinuxDmabufV1.interface,
ZwpLinuxBufferParamsV1.interface,
ZwpLinuxDmabufFeedbackV1.interface
        ]
    )

/// Protocol For Providing Explicit Synchronization
/// 
/// This global is a factory interface, allowing clients to request
/// explicit synchronization for buffers on a per-surface basis.
/// See zwp_linux_surface_synchronization_v1 for more information.
/// This interface is derived from Chromium's
/// zcr_linux_explicit_synchronization_v1.
/// Note: this protocol is superseded by linux-drm-syncobj.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpLinuxExplicitSynchronizationV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_linux_explicit_synchronization_v1",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_synchronization",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_linux_surface_synchronization_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy Explicit Synchronization Factory Object
    /// 
    /// Destroy this explicit synchronization factory object. Other objects,
    /// including zwp_linux_surface_synchronization_v1 objects created by this
    /// factory, shall not be affected by this request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Extend Surface Interface For Explicit Synchronization
    /// 
    /// Instantiate an interface extension for the given wl_surface to provide
    /// explicit synchronization.
    /// If the given wl_surface already has an explicit synchronization object
    /// associated, the synchronization_exists protocol error is raised.
    /// Graphics APIs, like EGL or Vulkan, that manage the buffer queue and
    /// commits of a wl_surface themselves, are likely to be using this
    /// extension internally. If a client is using such an API for a
    /// wl_surface, it should not directly use this extension on that surface,
    /// to avoid raising a synchronization_exists protocol error.
    /// 
    /// - Parameters:
    ///   - surface: the surface
    /// 
    /// - Returns: the new synchronization interface id
    public func getSynchronization(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpLinuxSurfaceSynchronizationV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpLinuxSurfaceSynchronizationV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = ZwpLinuxExplicitSynchronizationUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// the surface already has a synchronization object associated
        case synchronizationExists = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Per-Surface Explicit Synchronization Support
/// 
/// This object implements per-surface explicit synchronization.
/// Synchronization refers to co-ordination of pipelined operations performed
/// on buffers. Most GPU clients will schedule an asynchronous operation to
/// render to the buffer, then immediately send the buffer to the compositor
/// to be attached to a surface.
/// In implicit synchronization, ensuring that the rendering operation is
/// complete before the compositor displays the buffer is an implementation
/// detail handled by either the kernel or userspace graphics driver.
/// By contrast, in explicit synchronization, dma_fence objects mark when the
/// asynchronous operations are complete. When submitting a buffer, the
/// client provides an acquire fence which will be waited on before the
/// compositor accesses the buffer. The Wayland server, through a
/// zwp_linux_buffer_release_v1 object, will inform the client with an event
/// which may be accompanied by a release fence, when the compositor will no
/// longer access the buffer contents due to the specific commit that
/// requested the release event.
/// Each surface can be associated with only one object of this interface at
/// any time.
/// In version 1 of this interface, explicit synchronization is only
/// guaranteed to be supported for buffers created with any version of the
/// wp_linux_dmabuf buffer factory. Version 2 additionally guarantees
/// explicit synchronization support for opaque EGL buffers, which is a type
/// of platform specific buffers described in the EGL_WL_bind_wayland_display
/// extension. Compositors are free to support explicit synchronization for
/// additional buffer types.
public final class ZwpLinuxSurfaceSynchronizationV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_linux_surface_synchronization_v1",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_acquire_fence",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_release",
                    arguments: [
                        Argument(
                            name: "release",
                            type: .newId,
                            interface: "zwp_linux_buffer_release_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy Synchronization Object
    /// 
    /// Destroy this explicit synchronization object.
    /// Any fence set by this object with set_acquire_fence since the last
    /// commit will be discarded by the server. Any fences set by this object
    /// before the last commit are not affected.
    /// zwp_linux_buffer_release_v1 objects created by this object are not
    /// affected by this request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Set The Acquire Fence
    /// 
    /// Set the acquire fence that must be signaled before the compositor
    /// may sample from the buffer attached with wl_surface.attach. The fence
    /// is a dma_fence kernel object.
    /// The acquire fence is double-buffered state, and will be applied on the
    /// next wl_surface.commit request for the associated surface. Thus, it
    /// applies only to the buffer that is attached to the surface at commit
    /// time.
    /// If the provided fd is not a valid dma_fence fd, then an INVALID_FENCE
    /// error is raised.
    /// If a fence has already been attached during the same commit cycle, a
    /// DUPLICATE_FENCE error is raised.
    /// If the associated wl_surface was destroyed, a NO_SURFACE error is
    /// raised.
    /// If at surface commit time the attached buffer does not support explicit
    /// synchronization, an UNSUPPORTED_BUFFER error is raised.
    /// If at surface commit time there is no buffer attached, a NO_BUFFER
    /// error is raised.
    /// 
    /// - Parameters:
    ///   - fd: acquire fence fd
    public func setAcquireFence(fd: FileHandle) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .fd(fd),
        ])
    }

    /// Release Fence For Last-Attached Buffer
    /// 
    /// Create a listener for the release of the buffer attached by the
    /// client with wl_surface.attach. See zwp_linux_buffer_release_v1
    /// documentation for more information.
    /// The release object is double-buffered state, and will be associated
    /// with the buffer that is attached to the surface at wl_surface.commit
    /// time.
    /// If a zwp_linux_buffer_release_v1 object has already been requested for
    /// the surface in the same commit cycle, a DUPLICATE_RELEASE error is
    /// raised.
    /// If the associated wl_surface was destroyed, a NO_SURFACE error
    /// is raised.
    /// If at surface commit time there is no buffer attached, a NO_BUFFER
    /// error is raised.
    /// 
    /// - Returns: new zwp_linux_buffer_release_v1 object
    public func getRelease(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpLinuxBufferReleaseV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let release = connection.sendConstructor(self, 2, ZwpLinuxBufferReleaseV1.self, version, _queue, [
            .newId,
        ])
        return release
    }

    
    public static let `protocol`: Protocol = ZwpLinuxExplicitSynchronizationUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// the fence specified by the client could not be imported
        case invalidFence = 0

        /// multiple fences added for a single surface commit
        case duplicateFence = 1

        /// multiple releases added for a single surface commit
        case duplicateRelease = 2

        /// the associated wl_surface was destroyed
        case noSurface = 3

        /// the buffer does not support explicit synchronization
        case unsupportedBuffer = 4

        /// no buffer was attached
        case noBuffer = 5
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Buffer Release Explicit Synchronization
/// 
/// This object is instantiated in response to a
/// zwp_linux_surface_synchronization_v1.get_release request.
/// It provides an alternative to wl_buffer.release events, providing a
/// unique release from a single wl_surface.commit request. The release event
/// also supports explicit synchronization, providing a fence FD for the
/// client to synchronize against.
/// Exactly one event, either a fenced_release or an immediate_release, will
/// be emitted for the wl_surface.commit request. The compositor can choose
/// release by release which event it uses.
/// This event does not replace wl_buffer.release events; servers are still
/// required to send those events.
/// Once a buffer release object has delivered a 'fenced_release' or an
/// 'immediate_release' event it is automatically destroyed.
public final class ZwpLinuxBufferReleaseV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_linux_buffer_release_v1",
            version: 1,
            events: [
                Message(
                    name: "fenced_release",
                    type: .destructor,
                    arguments: [
                        Argument(
                            name: "fence",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "immediate_release",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    
    public static let `protocol`: Protocol = ZwpLinuxExplicitSynchronizationUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Release Buffer With Fence
        /// 
        /// Sent when the compositor has finalised its usage of the associated
        /// buffer for the relevant commit, providing a dma_fence which will be
        /// signaled when all operations by the compositor on that buffer for that
        /// commit have finished.
        /// Once the fence has signaled, and assuming the associated buffer is not
        /// pending release from other wl_surface.commit requests, no additional
        /// explicit or implicit synchronization is required to safely reuse or
        /// destroy the buffer.
        /// This event destroys the zwp_linux_buffer_release_v1 object.
        case fencedRelease(fence: FileHandle)

        /// Release Buffer Immediately
        /// 
        /// Sent when the compositor has finalised its usage of the associated
        /// buffer for the relevant commit, and either performed no operations
        /// using it, or has a guarantee that all its operations on that buffer for
        /// that commit have finished.
        /// Once this event is received, and assuming the associated buffer is not
        /// pending release from other wl_surface.commit requests, no additional
        /// explicit or implicit synchronization is required to safely reuse or
        /// destroy the buffer.
        /// This event destroys the zwp_linux_buffer_release_v1 object.
        case immediateRelease

        public var isDestructor: Bool {
            true
        }

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.fencedRelease(fence: r.fd())
            case 1:
                self = Self.immediateRelease
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let ZwpLinuxExplicitSynchronizationUnstableV1Protocol = Protocol(
        name: "zwp_linux_explicit_synchronization_unstable_v1",
        interfaces: [
            ZwpLinuxExplicitSynchronizationV1.interface,
ZwpLinuxSurfaceSynchronizationV1.interface,
ZwpLinuxBufferReleaseV1.interface
        ]
    )

/// Global For Providing Explicit Synchronization
/// 
/// This global is a factory interface, allowing clients to request
/// explicit synchronization for buffers on a per-surface basis.
/// See wp_linux_drm_syncobj_surface_v1 for more information.
public final class WpLinuxDrmSyncobjManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_linux_drm_syncobj_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_linux_drm_syncobj_surface_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "import_timeline",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_linux_drm_syncobj_timeline_v1",
                        )
                        ,
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy Explicit Synchronization Factory Object
    /// 
    /// Destroy this explicit synchronization factory object. Other objects
    /// shall not be affected by this request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Extend Surface Interface For Explicit Synchronization
    /// 
    /// Instantiate an interface extension for the given wl_surface to provide
    /// explicit synchronization.
    /// If the given wl_surface already has an explicit synchronization object
    /// associated, the surface_exists protocol error is raised.
    /// Graphics APIs, like EGL or Vulkan, that manage the buffer queue and
    /// commits of a wl_surface themselves, are likely to be using this
    /// extension internally. If a client is using such an API for a
    /// wl_surface, it should not directly use this extension on that surface,
    /// to avoid raising a surface_exists protocol error.
    /// 
    /// - Parameters:
    ///   - surface: the surface
    /// 
    /// - Returns: the new synchronization surface object id
    public func getSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpLinuxDrmSyncobjSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, WpLinuxDrmSyncobjSurfaceV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    /// Import A Drm Syncobj Timeline
    /// 
    /// Import a DRM synchronization object timeline.
    /// If the FD cannot be imported, the invalid_timeline error is raised.
    /// 
    /// - Parameters:
    ///   - fd: drm_syncobj file descriptor
    public func importTimeline(fd: FileHandle, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpLinuxDrmSyncobjTimelineV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 2, WpLinuxDrmSyncobjTimelineV1.self, version, _queue, [
            .newId,
            .fd(fd),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = LinuxDrmSyncobjV1Protocol
    
    public enum Error: UInt32 {
        /// the surface already has a synchronization object associated
        case surfaceExists = 0

        /// the timeline object could not be imported
        case invalidTimeline = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Synchronization Object Timeline
/// 
/// This object represents an explicit synchronization object timeline
/// imported by the client to the compositor.
public final class WpLinuxDrmSyncobjTimelineV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_linux_drm_syncobj_timeline_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Timeline
    /// 
    /// Destroy the synchronization object timeline. Other objects are not
    /// affected by this request, in particular timeline points set by
    /// set_acquire_point and set_release_point are not unset.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = LinuxDrmSyncobjV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Per-Surface Explicit Synchronization
/// 
/// This object is an add-on interface for wl_surface to enable explicit
/// synchronization.
/// Each surface can be associated with only one object of this interface at
/// any time.
/// Explicit synchronization is guaranteed to be supported for buffers
/// created with any version of the linux-dmabuf protocol. Compositors are
/// free to support explicit synchronization for additional buffer types.
/// If at surface commit time the attached buffer does not support explicit
/// synchronization, an unsupported_buffer error is raised.
/// As long as the wp_linux_drm_syncobj_surface_v1 object is alive, the
/// compositor may ignore implicit synchronization for buffers attached and
/// committed to the wl_surface. The delivery of wl_buffer.release events
/// for buffers attached to the surface becomes undefined.
/// Clients must set both acquire and release points if and only if a
/// non-null buffer is attached in the same surface commit. See the
/// no_buffer, no_acquire_point and no_release_point protocol errors.
/// If at surface commit time the acquire and release DRM syncobj timelines
/// are identical, the acquire point value must be strictly less than the
/// release point value, or else the conflicting_points protocol error is
/// raised.
public final class WpLinuxDrmSyncobjSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_linux_drm_syncobj_surface_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_acquire_point",
                    arguments: [
                        Argument(
                            name: "timeline",
                            type: .object,
                            interface: "wp_linux_drm_syncobj_timeline_v1",
                        )
                        ,
                        Argument(
                            name: "point_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "point_lo",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_release_point",
                    arguments: [
                        Argument(
                            name: "timeline",
                            type: .object,
                            interface: "wp_linux_drm_syncobj_timeline_v1",
                        )
                        ,
                        Argument(
                            name: "point_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "point_lo",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Surface Synchronization Object
    /// 
    /// Destroy this surface synchronization object.
    /// Any timeline point set by this object with set_acquire_point or
    /// set_release_point since the last commit may be discarded by the
    /// compositor. Any timeline point set by this object before the last
    /// commit will not be affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Set The Acquire Timeline Point
    /// 
    /// Set the timeline point that must be signalled before the compositor may
    /// sample from the buffer attached with wl_surface.attach.
    /// The 64-bit unsigned value combined from point_hi and point_lo is the
    /// point value.
    /// The acquire point is double-buffered state, and will be applied on the
    /// next wl_surface.commit request for the associated surface. Thus, it
    /// applies only to the buffer that is attached to the surface at commit
    /// time.
    /// If an acquire point has already been attached during the same commit
    /// cycle, the new point replaces the old one.
    /// If the associated wl_surface was destroyed, a no_surface error is
    /// raised.
    /// If at surface commit time there is a pending acquire timeline point set
    /// but no pending buffer attached, a no_buffer error is raised. If at
    /// surface commit time there is a pending buffer attached but no pending
    /// acquire timeline point set, the no_acquire_point protocol error is
    /// raised.
    /// 
    /// - Parameters:
    ///   - pointHi: high 32 bits of the point value
    ///   - pointLo: low 32 bits of the point value
    public func setAcquirePoint(timeline: WpLinuxDrmSyncobjTimelineV1, pointHi: UInt32, pointLo: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(timeline),
            .uint(pointHi),
            .uint(pointLo),
        ])
    }

    /// Set The Release Timeline Point
    /// 
    /// Set the timeline point that must be signalled by the compositor when it
    /// has finished its usage of the buffer attached with wl_surface.attach
    /// for the relevant commit.
    /// Once the timeline point is signaled, and assuming the associated buffer
    /// is not pending release from other wl_surface.commit requests, no
    /// additional explicit or implicit synchronization with the compositor is
    /// required to safely re-use the buffer.
    /// Note that clients cannot rely on the release point being always
    /// signaled after the acquire point: compositors may release buffers
    /// without ever reading from them. In addition, the compositor may use
    /// different presentation paths for different commits, which may have
    /// different release behavior. As a result, the compositor may signal the
    /// release points in a different order than the client committed them.
    /// Because signaling a timeline point also signals every previous point,
    /// it is generally not safe to use the same timeline object for the
    /// release points of multiple buffers. The out-of-order signaling
    /// described above may lead to a release point being signaled before the
    /// compositor has finished reading. To avoid this, it is strongly
    /// recommended that each buffer should use a separate timeline for its
    /// release points.
    /// The 64-bit unsigned value combined from point_hi and point_lo is the
    /// point value.
    /// The release point is double-buffered state, and will be applied on the
    /// next wl_surface.commit request for the associated surface. Thus, it
    /// applies only to the buffer that is attached to the surface at commit
    /// time.
    /// If a release point has already been attached during the same commit
    /// cycle, the new point replaces the old one.
    /// If the associated wl_surface was destroyed, a no_surface error is
    /// raised.
    /// If at surface commit time there is a pending release timeline point set
    /// but no pending buffer attached, a no_buffer error is raised. If at
    /// surface commit time there is a pending buffer attached but no pending
    /// release timeline point set, the no_release_point protocol error is
    /// raised.
    /// 
    /// - Parameters:
    ///   - pointHi: high 32 bits of the point value
    ///   - pointLo: low 32 bits of the point value
    public func setReleasePoint(timeline: WpLinuxDrmSyncobjTimelineV1, pointHi: UInt32, pointLo: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(timeline),
            .uint(pointHi),
            .uint(pointLo),
        ])
    }

    
    public static let `protocol`: Protocol = LinuxDrmSyncobjV1Protocol
    
    public enum Error: UInt32 {
        /// the associated wl_surface was destroyed
        case noSurface = 1

        /// the buffer does not support explicit synchronization
        case unsupportedBuffer = 2

        /// no buffer was attached
        case noBuffer = 3

        /// no acquire timeline point was set
        case noAcquirePoint = 4

        /// no release timeline point was set
        case noReleasePoint = 5

        /// acquire and release timeline points are in conflict
        case conflictingPoints = 6
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let LinuxDrmSyncobjV1Protocol = Protocol(
        name: "linux_drm_syncobj_v1",
        interfaces: [
            WpLinuxDrmSyncobjManagerV1.interface,
WpLinuxDrmSyncobjTimelineV1.interface,
WpLinuxDrmSyncobjSurfaceV1.interface
        ]
    )

/// Constrain The Movement Of A Pointer
/// 
/// The global interface exposing pointer constraining functionality. It
/// exposes two requests: lock_pointer for locking the pointer to its
/// position, and confine_pointer for locking the pointer to a region.
/// The lock_pointer and confine_pointer requests create the objects
/// wp_locked_pointer and wp_confined_pointer respectively, and the client can
/// use these objects to interact with the lock.
/// For any surface, only one lock or confinement may be active across all
/// wl_pointer objects of the same seat. If a lock or confinement is requested
/// when another lock or confinement is active or requested on the same surface
/// and with any of the wl_pointer objects of the same seat, an
/// 'already_constrained' error will be raised.
public final class ZwpPointerConstraintsV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_constraints_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "lock_pointer",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_locked_pointer_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        )
                        ,
                        Argument(
                            name: "region",
                            type: .object,
                            interface: "wl_region",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "lifetime",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "confine_pointer",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_confined_pointer_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        )
                        ,
                        Argument(
                            name: "region",
                            type: .object,
                            interface: "wl_region",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "lifetime",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Pointer Constraints Manager Object
    /// 
    /// Used by the client to notify the server that it will no longer use this
    /// pointer constraints object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Lock Pointer To A Position
    /// 
    /// The lock_pointer request lets the client request to disable movements of
    /// the virtual pointer (i.e. the cursor), effectively locking the pointer
    /// to a position. This request may not take effect immediately; in the
    /// future, when the compositor deems implementation-specific constraints
    /// are satisfied, the pointer lock will be activated and the compositor
    /// sends a locked event.
    /// The protocol provides no guarantee that the constraints are ever
    /// satisfied, and does not require the compositor to send an error if the
    /// constraints cannot ever be satisfied. It is thus possible to request a
    /// lock that will never activate.
    /// There may not be another pointer constraint of any kind requested or
    /// active on the surface for any of the wl_pointer objects of the seat of
    /// the passed pointer when requesting a lock. If there is, an error will be
    /// raised. See general pointer lock documentation for more details.
    /// The intersection of the region passed with this request and the input
    /// region of the surface is used to determine where the pointer must be
    /// in order for the lock to activate. It is up to the compositor whether to
    /// warp the pointer or require some kind of user interaction for the lock
    /// to activate. If the region is null the surface input region is used.
    /// A surface may receive pointer focus without the lock being activated.
    /// The request creates a new object wp_locked_pointer which is used to
    /// interact with the lock as well as receive updates about its state. See
    /// the the description of wp_locked_pointer for further information.
    /// Note that while a pointer is locked, the wl_pointer objects of the
    /// corresponding seat will not emit any wl_pointer.motion events, but
    /// relative motion events will still be emitted via wp_relative_pointer
    /// objects of the same seat. wl_pointer.axis and wl_pointer.button events
    /// are unaffected.
    /// 
    /// - Parameters:
    ///   - surface: surface to lock pointer to
    ///   - pointer: the pointer that should be locked
    ///   - region: region of surface
    ///   - lifetime: lock lifetime
    public func lockPointer(surface: WlSurface, pointer: WlPointer, region: WlRegion? = nil, lifetime: Lifetime, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpLockedPointerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpLockedPointerV1.self, version, _queue, [
            .newId,
            .object(surface),
            .object(pointer),
            .object(region),
            .uint(lifetime.rawValue),
        ])
        return id
    }

    /// Confine Pointer To A Region
    /// 
    /// The confine_pointer request lets the client request to confine the
    /// pointer cursor to a given region. This request may not take effect
    /// immediately; in the future, when the compositor deems implementation-
    /// specific constraints are satisfied, the pointer confinement will be
    /// activated and the compositor sends a confined event.
    /// The intersection of the region passed with this request and the input
    /// region of the surface is used to determine where the pointer must be
    /// in order for the confinement to activate. It is up to the compositor
    /// whether to warp the pointer or require some kind of user interaction for
    /// the confinement to activate. If the region is null the surface input
    /// region is used.
    /// The request will create a new object wp_confined_pointer which is used
    /// to interact with the confinement as well as receive updates about its
    /// state. See the the description of wp_confined_pointer for further
    /// information.
    /// 
    /// - Parameters:
    ///   - surface: surface to lock pointer to
    ///   - pointer: the pointer that should be confined
    ///   - region: region of surface
    ///   - lifetime: confinement lifetime
    public func confinePointer(surface: WlSurface, pointer: WlPointer, region: WlRegion? = nil, lifetime: Lifetime, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpConfinedPointerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 2, ZwpConfinedPointerV1.self, version, _queue, [
            .newId,
            .object(surface),
            .object(pointer),
            .object(region),
            .uint(lifetime.rawValue),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = PointerConstraintsUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// pointer constraint already requested on that surface
        case alreadyConstrained = 1
    }

    public enum Lifetime: UInt32 {
        case oneshot = 1

        case persistent = 2
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Receive Relative Pointer Motion Events
/// 
/// The wp_locked_pointer interface represents a locked pointer state.
/// While the lock of this object is active, the wl_pointer objects of the
/// associated seat will not emit any wl_pointer.motion events.
/// This object will send the event 'locked' when the lock is activated.
/// Whenever the lock is activated, it is guaranteed that the locked surface
/// will already have received pointer focus and that the pointer will be
/// within the region passed to the request creating this object.
/// To unlock the pointer, send the destroy request. This will also destroy
/// the wp_locked_pointer object.
/// If the compositor decides to unlock the pointer the unlocked event is
/// sent. See wp_locked_pointer.unlock for details.
/// When unlocking, the compositor may warp the cursor position to the set
/// cursor position hint. If it does, it will not result in any relative
/// motion events emitted via wp_relative_pointer.
/// If the surface the lock was requested on is destroyed and the lock is not
/// yet activated, the wp_locked_pointer object is now defunct and must be
/// destroyed.
public final class ZwpLockedPointerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_locked_pointer_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_cursor_position_hint",
                    arguments: [
                        Argument(
                            name: "surface_x",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "surface_y",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_region",
                    arguments: [
                        Argument(
                            name: "region",
                            type: .object,
                            interface: "wl_region",
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "locked",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "unlocked",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Locked Pointer Object
    /// 
    /// Destroy the locked pointer object. If applicable, the compositor will
    /// unlock the pointer.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Set The Pointer Cursor Position Hint
    /// 
    /// Set the cursor position hint relative to the top left corner of the
    /// surface.
    /// If the client is drawing its own cursor, it should update the position
    /// hint to the position of its own cursor. A compositor may use this
    /// information to warp the pointer upon unlock in order to avoid pointer
    /// jumps.
    /// The cursor position hint is double-buffered state, see
    /// wl_surface.commit.
    /// 
    /// - Parameters:
    ///   - surfaceX: surface-local x coordinate
    ///   - surfaceY: surface-local y coordinate
    public func setCursorPositionHint(surfaceX: Double, surfaceY: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .fixed(surfaceX),
            .fixed(surfaceY),
        ])
    }

    /// Set A New Lock Region
    /// 
    /// Set a new region used to lock the pointer.
    /// The new lock region is double-buffered, see wl_surface.commit.
    /// For details about the lock region, see wp_locked_pointer.
    /// 
    /// - Parameters:
    ///   - _: region of surface
    public func setRegion(_ region: WlRegion? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(region),
        ])
    }

    
    public static let `protocol`: Protocol = PointerConstraintsUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Lock Activation Event
        /// 
        /// Notification that the pointer lock of the seat's pointer is activated.
        case locked

        /// Lock Deactivation Event
        /// 
        /// Notification that the pointer lock of the seat's pointer is no longer
        /// active. If this is a oneshot pointer lock (see
        /// wp_pointer_constraints.lifetime) this object is now defunct and should
        /// be destroyed. If this is a persistent pointer lock (see
        /// wp_pointer_constraints.lifetime) this pointer lock may again
        /// reactivate in the future.
        case unlocked

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.locked
            case 1:
                self = Self.unlocked
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Confined Pointer Object
/// 
/// The wp_confined_pointer interface represents a confined pointer state.
/// This object will send the event 'confined' when the confinement is
/// activated. Whenever the confinement is activated, it is guaranteed that
/// the surface the pointer is confined to will already have received pointer
/// focus and that the pointer will be within the region passed to the request
/// creating this object. It is up to the compositor to decide whether this
/// requires some user interaction and if the pointer will warp to within the
/// passed region if outside.
/// To unconfine the pointer, send the destroy request. This will also destroy
/// the wp_confined_pointer object.
/// If the compositor decides to unconfine the pointer the unconfined event is
/// sent. The wp_confined_pointer object is at this point defunct and should
/// be destroyed.
public final class ZwpConfinedPointerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_confined_pointer_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_region",
                    arguments: [
                        Argument(
                            name: "region",
                            type: .object,
                            interface: "wl_region",
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "confined",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "unconfined",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Confined Pointer Object
    /// 
    /// Destroy the confined pointer object. If applicable, the compositor will
    /// unconfine the pointer.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Set A New Confine Region
    /// 
    /// Set a new region used to confine the pointer.
    /// The new confine region is double-buffered, see wl_surface.commit.
    /// If the confinement is active when the new confinement region is applied
    /// and the pointer ends up outside of newly applied region, the pointer may
    /// warped to a position within the new confinement region. If warped, a
    /// wl_pointer.motion event will be emitted, but no
    /// wp_relative_pointer.relative_motion event.
    /// The compositor may also, instead of using the new region, unconfine the
    /// pointer.
    /// For details about the confine region, see wp_confined_pointer.
    /// 
    /// - Parameters:
    ///   - _: region of surface
    public func setRegion(_ region: WlRegion? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(region),
        ])
    }

    
    public static let `protocol`: Protocol = PointerConstraintsUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Pointer Confined
        /// 
        /// Notification that the pointer confinement of the seat's pointer is
        /// activated.
        case confined

        /// Pointer Unconfined
        /// 
        /// Notification that the pointer confinement of the seat's pointer is no
        /// longer active. If this is a oneshot pointer confinement (see
        /// wp_pointer_constraints.lifetime) this object is now defunct and should
        /// be destroyed. If this is a persistent pointer confinement (see
        /// wp_pointer_constraints.lifetime) this pointer confinement may again
        /// reactivate in the future.
        case unconfined

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.confined
            case 1:
                self = Self.unconfined
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let PointerConstraintsUnstableV1Protocol = Protocol(
        name: "pointer_constraints_unstable_v1",
        interfaces: [
            ZwpPointerConstraintsV1.interface,
ZwpLockedPointerV1.interface,
ZwpConfinedPointerV1.interface
        ]
    )

/// Touchpad Gestures
/// 
/// A global interface to provide semantic touchpad gestures for a given
/// pointer.
/// Three gestures are currently supported: swipe, pinch, and hold.
/// Pinch and swipe gestures follow a three-stage cycle: begin, update,
/// end. Hold gestures follow a two-stage cycle: begin and end. All
/// gestures are identified by a unique id.
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpPointerGesturesV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_gestures_v1",
            version: 3,
            requests: [
                Message(
                    name: "get_swipe_gesture",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_pointer_gesture_swipe_v1",
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_pinch_gesture",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_pointer_gesture_pinch_v1",
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "get_hold_gesture",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_pointer_gesture_hold_v1",
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        )
                        ,
                    ],
                    since: 3
                )
                ,
            ],
        )
    /// Get Swipe Gesture
    /// 
    /// Create a swipe gesture object. See the
    /// wl_pointer_gesture_swipe interface for details.
    /// 
    /// - Parameters:
    public func getSwipeGesture(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPointerGestureSwipeV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwpPointerGestureSwipeV1.self, version, _queue, [
            .newId,
            .object(pointer),
        ])
        return id
    }

    /// Get Pinch Gesture
    /// 
    /// Create a pinch gesture object. See the
    /// wl_pointer_gesture_pinch interface for details.
    /// 
    /// - Parameters:
    public func getPinchGesture(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPointerGesturePinchV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpPointerGesturePinchV1.self, version, _queue, [
            .newId,
            .object(pointer),
        ])
        return id
    }

    /// Destroy The Pointer Gesture Object
    /// 
    /// Destroy the pointer gesture object. Swipe, pinch and hold objects
    /// created via this gesture object remain valid.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.destroy(self)
        connection.send(self, 2, [
        ])
    }

    /// Get Hold Gesture
    /// 
    /// Create a hold gesture object. See the
    /// wl_pointer_gesture_hold interface for details.
    /// 
    /// - Parameters:
    public func getHoldGesture(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPointerGestureHoldV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let id = connection.sendConstructor(self, 3, ZwpPointerGestureHoldV1.self, version, _queue, [
            .newId,
            .object(pointer),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = PointerGesturesUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// A Swipe Gesture Object
/// 
/// A swipe gesture object notifies a client about a multi-finger swipe
/// gesture detected on an indirect input device such as a touchpad.
/// The gesture is usually initiated by multiple fingers moving in the
/// same direction but once initiated the direction may change.
/// The precise conditions of when such a gesture is detected are
/// implementation-dependent.
/// A gesture consists of three stages: begin, update (optional) and end.
/// There cannot be multiple simultaneous hold, pinch or swipe gestures on a
/// same pointer/seat, how compositors prevent these situations is
/// implementation-dependent.
/// A gesture may be cancelled by the compositor or the hardware.
/// Clients should not consider performing permanent or irreversible
/// actions until the end of a gesture has been received.
public final class ZwpPointerGestureSwipeV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_gesture_swipe_v1",
            version: 3,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "begin",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "fingers",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "update",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "dx",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "dy",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "end",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "cancelled",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Pointer Swipe Gesture Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = PointerGesturesUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Multi-Finger Swipe Begin
        /// 
        /// This event is sent when a multi-finger swipe gesture is detected
        /// on the device.
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)

        /// Multi-Finger Swipe Motion
        /// 
        /// This event is sent when a multi-finger swipe gesture changes the
        /// position of the logical center.
        /// The dx and dy coordinates are relative coordinates of the logical
        /// center of the gesture compared to the previous event.
        case update(time: UInt32, dx: Double, dy: Double)

        /// Multi-Finger Swipe End
        /// 
        /// This event is sent when a multi-finger swipe gesture ceases to
        /// be valid. This may happen when one or more fingers are lifted or
        /// the gesture is cancelled.
        /// When a gesture is cancelled, the client should undo state changes
        /// caused by this gesture. What causes a gesture to be cancelled is
        /// implementation-dependent.
        case end(serial: UInt32, time: UInt32, cancelled: Int32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.begin(serial: r.uint(), time: r.uint(), surface: r.object(type: WlSurface.self), fingers: r.uint())
            case 1:
                self = Self.update(time: r.uint(), dx: r.fixed(), dy: r.fixed())
            case 2:
                self = Self.end(serial: r.uint(), time: r.uint(), cancelled: r.int())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Pinch Gesture Object
/// 
/// A pinch gesture object notifies a client about a multi-finger pinch
/// gesture detected on an indirect input device such as a touchpad.
/// The gesture is usually initiated by multiple fingers moving towards
/// each other or away from each other, or by two or more fingers rotating
/// around a logical center of gravity. The precise conditions of when
/// such a gesture is detected are implementation-dependent.
/// A gesture consists of three stages: begin, update (optional) and end.
/// There cannot be multiple simultaneous hold, pinch or swipe gestures on a
/// same pointer/seat, how compositors prevent these situations is
/// implementation-dependent.
/// A gesture may be cancelled by the compositor or the hardware.
/// Clients should not consider performing permanent or irreversible
/// actions until the end of a gesture has been received.
public final class ZwpPointerGesturePinchV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_gesture_pinch_v1",
            version: 3,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "begin",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "fingers",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "update",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "dx",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "dy",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "scale",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "rotation",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "end",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "cancelled",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Pinch Gesture Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = PointerGesturesUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Multi-Finger Pinch Begin
        /// 
        /// This event is sent when a multi-finger pinch gesture is detected
        /// on the device.
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)

        /// Multi-Finger Pinch Motion
        /// 
        /// This event is sent when a multi-finger pinch gesture changes the
        /// position of the logical center, the rotation or the relative scale.
        /// The dx and dy coordinates are relative coordinates in the
        /// surface coordinate space of the logical center of the gesture.
        /// The scale factor is an absolute scale compared to the
        /// pointer_gesture_pinch.begin event, e.g. a scale of 2 means the fingers
        /// are now twice as far apart as on pointer_gesture_pinch.begin.
        /// The rotation is the relative angle in degrees clockwise compared to the previous
        /// pointer_gesture_pinch.begin or pointer_gesture_pinch.update event.
        case update(time: UInt32, dx: Double, dy: Double, scale: Double, rotation: Double)

        /// Multi-Finger Pinch End
        /// 
        /// This event is sent when a multi-finger pinch gesture ceases to
        /// be valid. This may happen when one or more fingers are lifted or
        /// the gesture is cancelled.
        /// When a gesture is cancelled, the client should undo state changes
        /// caused by this gesture. What causes a gesture to be cancelled is
        /// implementation-dependent.
        case end(serial: UInt32, time: UInt32, cancelled: Int32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.begin(serial: r.uint(), time: r.uint(), surface: r.object(type: WlSurface.self), fingers: r.uint())
            case 1:
                self = Self.update(time: r.uint(), dx: r.fixed(), dy: r.fixed(), scale: r.fixed(), rotation: r.fixed())
            case 2:
                self = Self.end(serial: r.uint(), time: r.uint(), cancelled: r.int())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Hold Gesture Object
/// 
/// A hold gesture object notifies a client about a single- or
/// multi-finger hold gesture detected on an indirect input device such as
/// a touchpad. The gesture is usually initiated by one or more fingers
/// being held down without significant movement. The precise conditions
/// of when such a gesture is detected are implementation-dependent.
/// In particular, this gesture may be used to cancel kinetic scrolling.
/// A hold gesture consists of two stages: begin and end. Unlike pinch and
/// swipe there is no update stage.
/// There cannot be multiple simultaneous hold, pinch or swipe gestures on a
/// same pointer/seat, how compositors prevent these situations is
/// implementation-dependent.
/// A gesture may be cancelled by the compositor or the hardware.
/// Clients should not consider performing permanent or irreversible
/// actions until the end of a gesture has been received.
public final class ZwpPointerGestureHoldV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_pointer_gesture_hold_v1",
            version: 3,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 3
                )
                ,
            ],
            events: [
                Message(
                    name: "begin",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "fingers",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "end",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "cancelled",
                            type: .int,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
            ],
        )
    /// Destroy The Hold Gesture Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = PointerGesturesUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Multi-Finger Hold Begin
        /// 
        /// This event is sent when a hold gesture is detected on the device.
        case begin(serial: UInt32, time: UInt32, surface: WlSurface, fingers: UInt32)

        /// Multi-Finger Hold End
        /// 
        /// This event is sent when a hold gesture ceases to
        /// be valid. This may happen when the holding fingers are lifted or
        /// the gesture is cancelled, for example if the fingers move past an
        /// implementation-defined threshold, the finger count changes or the hold
        /// gesture changes into a different type of gesture.
        /// When a gesture is cancelled, the client may need to undo state changes
        /// caused by this gesture. What causes a gesture to be cancelled is
        /// implementation-dependent.
        case end(serial: UInt32, time: UInt32, cancelled: Int32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.begin(serial: r.uint(), time: r.uint(), surface: r.object(type: WlSurface.self), fingers: r.uint())
            case 1:
                self = Self.end(serial: r.uint(), time: r.uint(), cancelled: r.int())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let PointerGesturesUnstableV1Protocol = Protocol(
        name: "pointer_gestures_unstable_v1",
        interfaces: [
            ZwpPointerGesturesV1.interface,
ZwpPointerGestureSwipeV1.interface,
ZwpPointerGesturePinchV1.interface,
ZwpPointerGestureHoldV1.interface
        ]
    )

/// Timed Presentation Related Wl_Surface Requests
/// 
/// The main feature of this interface is accurate presentation
/// timing feedback to ensure smooth video playback while maintaining
/// audio/video synchronization. Some features use the concept of a
/// presentation clock, which is defined in the
/// presentation.clock_id event.
/// A content update for a wl_surface is submitted by a
/// wl_surface.commit request. Request 'feedback' associates with
/// the wl_surface.commit and provides feedback on the content
/// update, particularly the final realized presentation time.
/// When the final realized presentation time is available, e.g.
/// after a framebuffer flip completes, the requested
/// presentation_feedback.presented events are sent. The final
/// presentation time can differ from the compositor's predicted
/// display update time and the update's target time, especially
/// when the compositor misses its target vertical blanking period.
public final class WpPresentation: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_presentation",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "feedback",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "callback",
                            type: .newId,
                            interface: "wp_presentation_feedback",
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "clock_id",
                    arguments: [
                        Argument(
                            name: "clk_id",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Unbind From The Presentation Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object. Existing objects created by this object
    /// are not affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Request Presentation Feedback Information
    /// 
    /// Request presentation feedback for the current content submission
    /// on the given surface. This creates a new presentation_feedback
    /// object, which will deliver the feedback information once. If
    /// multiple presentation_feedback objects are created for the same
    /// submission, they will all deliver the same information.
    /// For details on what information is returned, see the
    /// presentation_feedback interface.
    /// 
    /// - Parameters:
    ///   - surface: target surface
    /// 
    /// - Returns: new feedback object
    public func feedback(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpPresentationFeedback {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let callback = connection.sendConstructor(self, 1, WpPresentationFeedback.self, version, _queue, [
            .object(surface),
            .newId,
        ])
        return callback
    }

    
    public static let `protocol`: Protocol = PresentationTimeProtocol
    
    public enum Error: UInt32 {
        /// invalid value in tv_nsec
        case invalidTimestamp = 0

        /// invalid flag
        case invalidFlag = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Clock Id For Timestamps
        /// 
        /// This event tells the client in which clock domain the
        /// compositor interprets the timestamps used by the presentation
        /// extension. This clock is called the presentation clock.
        /// The compositor sends this event when the client binds to the
        /// presentation interface. The presentation clock does not change
        /// during the lifetime of the client connection.
        /// The clock identifier is platform dependent. On POSIX platforms, the
        /// identifier value is one of the clockid_t values accepted by
        /// clock_gettime(). clock_gettime() is defined by POSIX.1-2001.
        /// Timestamps in this clock domain are expressed as tv_sec_hi,
        /// tv_sec_lo, tv_nsec triples, each component being an unsigned
        /// 32-bit value. Whole seconds are in tv_sec which is a 64-bit
        /// value combined from tv_sec_hi and tv_sec_lo, and the
        /// additional fractional part in tv_nsec as nanoseconds. Hence,
        /// for valid timestamps tv_nsec must be in [0, 999999999].
        /// Note that clock_id applies only to the presentation clock,
        /// and implies nothing about e.g. the timestamps used in the
        /// Wayland core protocol input events.
        /// Compositors should prefer a clock which does not jump and is
        /// not slewed e.g. by NTP. The absolute value of the clock is
        /// irrelevant. Precision of one millisecond or better is
        /// recommended. Clients must be able to query the current clock
        /// value directly, not by asking the compositor.
        case clockId(clkId: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.clockId(clkId: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Presentation Time Feedback Event
/// 
/// A presentation_feedback object returns an indication that a
/// wl_surface content update has become visible to the user.
/// One object corresponds to one content update submission
/// (wl_surface.commit). There are two possible outcomes: the
/// content update is presented to the user, and a presentation
/// timestamp delivered; or, the user did not see the content
/// update because it was superseded or its surface destroyed,
/// and the content update is discarded.
/// Once a presentation_feedback object has delivered a 'presented'
/// or 'discarded' event it is automatically destroyed.
public final class WpPresentationFeedback: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_presentation_feedback",
            version: 2,
            events: [
                Message(
                    name: "sync_output",
                    arguments: [
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "presented",
                    type: .destructor,
                    arguments: [
                        Argument(
                            name: "tv_sec_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_sec_lo",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_nsec",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "refresh",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "seq_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "seq_lo",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "discarded",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    
    public static let `protocol`: Protocol = PresentationTimeProtocol
    
    public struct Kind: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public static let vsync = Kind(rawValue: 0x1)

        public static let hwClock = Kind(rawValue: 0x2)

        public static let hwCompletion = Kind(rawValue: 0x4)

        public static let zeroCopy = Kind(rawValue: 0x8)
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Presentation Synchronized To This Output
        /// 
        /// As presentation can be synchronized to only one output at a
        /// time, this event tells which output it was. This event is only
        /// sent prior to the presented event.
        /// As clients may bind to the same global wl_output multiple
        /// times, this event is sent for each bound instance that matches
        /// the synchronized output. If a client has not bound to the
        /// right wl_output global at all, this event is not sent.
        case syncOutput(output: WlOutput)

        /// The Content Update Was Displayed
        /// 
        /// The associated content update was displayed to the user at the
        /// indicated time (tv_sec_hi/lo, tv_nsec). For the interpretation of
        /// the timestamp, see presentation.clock_id event.
        /// The timestamp corresponds to the time when the content update
        /// turned into light the first time on the surface's main output.
        /// Compositors may approximate this from the framebuffer flip
        /// completion events from the system, and the latency of the
        /// physical display path if known.
        /// This event is preceded by all related sync_output events
        /// telling which output's refresh cycle the feedback corresponds
        /// to, i.e. the main output for the surface. Compositors are
        /// recommended to choose the output containing the largest part
        /// of the wl_surface, or keeping the output they previously
        /// chose. Having a stable presentation output association helps
        /// clients predict future output refreshes (vblank).
        /// The 'refresh' argument gives the compositor's prediction of how
        /// many nanoseconds after tv_sec, tv_nsec the very next output
        /// refresh may occur. This is to further aid clients in
        /// predicting future refreshes, i.e., estimating the timestamps
        /// targeting the next few vblanks. If such prediction cannot
        /// usefully be done, the argument is zero.
        /// For version 2 and later, if the output does not have a constant
        /// refresh rate, explicit video mode switches excluded, then the
        /// refresh argument must be either an appropriate rate picked by the
        /// compositor (e.g. fastest rate), or 0 if no such rate exists.
        /// For version 1, if the output does not have a constant refresh rate,
        /// the refresh argument must be zero.
        /// The 64-bit value combined from seq_hi and seq_lo is the value
        /// of the output's vertical retrace counter when the content
        /// update was first scanned out to the display. This value must
        /// be compatible with the definition of MSC in
        /// GLX_OML_sync_control specification. Note, that if the display
        /// path has a non-zero latency, the time instant specified by
        /// this counter may differ from the timestamp's.
        /// If the output does not have a concept of vertical retrace or a
        /// refresh cycle, or the output device is self-refreshing without
        /// a way to query the refresh count, then the arguments seq_hi
        /// and seq_lo must be zero.
        case presented(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32, refresh: UInt32, seqHi: UInt32, seqLo: UInt32, flags: Kind)

        /// The Content Update Was Not Displayed
        /// 
        /// The content update was never displayed to the user.
        case discarded

        public var isDestructor: Bool {
            switch self {
                case .presented, .discarded:
                    true
                default:
                    false
            }
        }

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.syncOutput(output: r.object(type: WlOutput.self))
            case 1:
                self = Self.presented(tvSecHi: r.uint(), tvSecLo: r.uint(), tvNsec: r.uint(), refresh: r.uint(), seqHi: r.uint(), seqLo: r.uint(), flags: try r.`enum`(Kind.self))
            case 2:
                self = Self.discarded
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let PresentationTimeProtocol = Protocol(
        name: "presentation_time",
        interfaces: [
            WpPresentation.interface,
WpPresentationFeedback.interface
        ]
    )

/// X Primary Selection Emulation
/// 
/// The primary selection device manager is a singleton global object that
/// provides access to the primary selection. It allows to create
/// wp_primary_selection_source objects, as well as retrieving the per-seat
/// wp_primary_selection_device objects.
public final class ZwpPrimarySelectionDeviceManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_primary_selection_device_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "create_source",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_primary_selection_source_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_device",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_primary_selection_device_v1",
                        )
                        ,
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Create A New Primary Selection Source
    /// 
    /// Create a new primary selection source.
    public func createSource(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPrimarySelectionSourceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwpPrimarySelectionSourceV1.self, version, _queue, [
            .newId,
        ])
        return id
    }

    /// Create A New Primary Selection Device
    /// 
    /// Create a new data device for a given seat.
    /// 
    /// - Parameters:
    public func getDevice(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpPrimarySelectionDeviceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpPrimarySelectionDeviceV1.self, version, _queue, [
            .newId,
            .object(seat),
        ])
        return id
    }

    /// Destroy The Primary Selection Device Manager
    /// 
    /// Destroy the primary selection device manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = WpPrimarySelectionUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

public final class ZwpPrimarySelectionDeviceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_primary_selection_device_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_selection",
                    arguments: [
                        Argument(
                            name: "source",
                            type: .object,
                            interface: "zwp_primary_selection_source_v1",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "data_offer",
                    arguments: [
                        Argument(
                            name: "offer",
                            type: .newId,
                            interface: "zwp_primary_selection_offer_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "selection",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .object,
                            interface: "zwp_primary_selection_offer_v1",
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Set The Primary Selection
    /// 
    /// Replaces the current selection. The previous owner of the primary
    /// selection will receive a wp_primary_selection_source.cancelled event.
    /// To unset the selection, set the source to NULL.
    /// 
    /// - Parameters:
    ///   - serial: serial of the event that triggered this request
    public func setSelection(source: ZwpPrimarySelectionSourceV1? = nil, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(source),
            .uint(serial),
        ])
    }

    /// Destroy The Primary Selection Device
    /// 
    /// Destroy the primary selection device.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WpPrimarySelectionUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Introduce A New Wp_Primary_Selection_Offer
        /// 
        /// Introduces a new wp_primary_selection_offer object that may be used
        /// to receive the current primary selection. Immediately following this
        /// event, the new wp_primary_selection_offer object will send
        /// wp_primary_selection_offer.offer events to describe the offered mime
        /// types.
        case dataOffer(offer: ZwpPrimarySelectionOfferV1)

        /// Advertise A New Primary Selection
        /// 
        /// The wp_primary_selection_device.selection event is sent to notify the
        /// client of a new primary selection. This event is sent after the
        /// wp_primary_selection.data_offer event introducing this object, and after
        /// the offer has announced its mimetypes through
        /// wp_primary_selection_offer.offer.
        /// The data_offer is valid until a new offer or NULL is received
        /// or until the client loses keyboard focus. The client must destroy the
        /// previous selection data_offer, if any, upon receiving this event.
        case selection(id: ZwpPrimarySelectionOfferV1)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.dataOffer(offer: r.newId(type: ZwpPrimarySelectionOfferV1.self))
            case 1:
                self = Self.selection(id: r.object(type: ZwpPrimarySelectionOfferV1.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Offer To Transfer Primary Selection Contents
/// 
/// A wp_primary_selection_offer represents an offer to transfer the contents
/// of the primary selection clipboard to the client. Similar to
/// wl_data_offer, the offer also describes the mime types that the data can
/// be converted to and provides the mechanisms for transferring the data
/// directly to the client.
public final class ZwpPrimarySelectionOfferV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_primary_selection_offer_v1",
            version: 1,
            requests: [
                Message(
                    name: "receive",
                    arguments: [
                        Argument(
                            name: "mime_type",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "offer",
                    arguments: [
                        Argument(
                            name: "mime_type",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Request That The Data Is Transferred
    /// 
    /// To transfer the contents of the primary selection clipboard, the client
    /// issues this request and indicates the mime type that it wants to
    /// receive. The transfer happens through the passed file descriptor
    /// (typically created with the pipe system call). The source client writes
    /// the data in the mime type representation requested and then closes the
    /// file descriptor.
    /// The receiving client reads from the read end of the pipe until EOF and
    /// closes its end, at which point the transfer is complete.
    /// 
    /// - Parameters:
    public func receive(mimeType: String, fd: FileHandle) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(mimeType),
            .fd(fd),
        ])
    }

    /// Destroy The Primary Selection Offer
    /// 
    /// Destroy the primary selection offer.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WpPrimarySelectionUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Advertise Offered Mime Type
        /// 
        /// Sent immediately after creating announcing the
        /// wp_primary_selection_offer through
        /// wp_primary_selection_device.data_offer. One event is sent per offered
        /// mime type.
        case offer(mimeType: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.offer(mimeType: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Offer To Replace The Contents Of The Primary Selection
/// 
/// The source side of a wp_primary_selection_offer, it provides a way to
/// describe the offered data and respond to requests to transfer the
/// requested contents of the primary selection clipboard.
public final class ZwpPrimarySelectionSourceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_primary_selection_source_v1",
            version: 1,
            requests: [
                Message(
                    name: "offer",
                    arguments: [
                        Argument(
                            name: "mime_type",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "send",
                    arguments: [
                        Argument(
                            name: "mime_type",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "cancelled",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Add An Offered Mime Type
    /// 
    /// This request adds a mime type to the set of mime types advertised to
    /// targets. Can be called several times to offer multiple types.
    /// 
    /// - Parameters:
    public func offer(mimeType: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(mimeType),
        ])
    }

    /// Destroy The Primary Selection Source
    /// 
    /// Destroy the primary selection source.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WpPrimarySelectionUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Send The Primary Selection Contents
        /// 
        /// Request for the current primary selection contents from the client.
        /// Send the specified mime type over the passed file descriptor, then
        /// close it.
        case send(mimeType: String, fd: FileHandle)

        /// Request For Primary Selection Contents Was Canceled
        /// 
        /// This primary selection source is no longer valid. The client should
        /// clean up and destroy this primary selection source.
        case cancelled

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.send(mimeType: r.string(), fd: r.fd())
            case 1:
                self = Self.cancelled
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let WpPrimarySelectionUnstableV1Protocol = Protocol(
        name: "wp_primary_selection_unstable_v1",
        interfaces: [
            ZwpPrimarySelectionDeviceManagerV1.interface,
ZwpPrimarySelectionDeviceV1.interface,
ZwpPrimarySelectionOfferV1.interface,
ZwpPrimarySelectionSourceV1.interface
        ]
    )

/// Get Relative Pointer Objects
/// 
/// A global interface used for getting the relative pointer object for a
/// given pointer.
public final class ZwpRelativePointerManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_relative_pointer_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_relative_pointer",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_relative_pointer_v1",
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Relative Pointer Manager Object
    /// 
    /// Used by the client to notify the server that it will no longer use this
    /// relative pointer manager object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Get A Relative Pointer Object
    /// 
    /// Create a relative pointer interface given a wl_pointer object. See the
    /// wp_relative_pointer interface for more details.
    /// 
    /// - Parameters:
    public func getRelativePointer(pointer: WlPointer, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpRelativePointerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpRelativePointerV1.self, version, _queue, [
            .newId,
            .object(pointer),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = RelativePointerUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Relative Pointer Object
/// 
/// A wp_relative_pointer object is an extension to the wl_pointer interface
/// used for emitting relative pointer events. It shares the same focus as
/// wl_pointer objects of the same seat and will only emit events when it has
/// focus.
public final class ZwpRelativePointerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_relative_pointer_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "relative_motion",
                    arguments: [
                        Argument(
                            name: "utime_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "utime_lo",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "dx",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "dy",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "dx_unaccel",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "dy_unaccel",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Release The Relative Pointer Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = RelativePointerUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Relative Pointer Motion
        /// 
        /// Relative x/y pointer motion from the pointer of the seat associated with
        /// this object.
        /// A relative motion is in the same dimension as regular wl_pointer motion
        /// events, except they do not represent an absolute position. For example,
        /// moving a pointer from (x, y) to (x', y') would have the equivalent
        /// relative motion (x' - x, y' - y). If a pointer motion caused the
        /// absolute pointer position to be clipped by for example the edge of the
        /// monitor, the relative motion is unaffected by the clipping and will
        /// represent the unclipped motion.
        /// This event also contains non-accelerated motion deltas. The
        /// non-accelerated delta is, when applicable, the regular pointer motion
        /// delta as it was before having applied motion acceleration and other
        /// transformations such as normalization.
        /// Note that the non-accelerated delta does not represent 'raw' events as
        /// they were read from some device. Pointer motion acceleration is device-
        /// and configuration-specific and non-accelerated deltas and accelerated
        /// deltas may have the same value on some devices.
        /// Relative motions are not coupled to wl_pointer.motion events, and can be
        /// sent in combination with such events, but also independently. There may
        /// also be scenarios where wl_pointer.motion is sent, but there is no
        /// relative motion. The order of an absolute and relative motion event
        /// originating from the same physical motion is not guaranteed.
        /// If the client needs button events or focus state, it can receive them
        /// from a wl_pointer object of the same seat that the wp_relative_pointer
        /// object is associated with.
        case relativeMotion(utimeHi: UInt32, utimeLo: UInt32, dx: Double, dy: Double, dxUnaccel: Double, dyUnaccel: Double)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.relativeMotion(utimeHi: r.uint(), utimeLo: r.uint(), dx: r.fixed(), dy: r.fixed(), dxUnaccel: r.fixed(), dyUnaccel: r.fixed())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let RelativePointerUnstableV1Protocol = Protocol(
        name: "relative_pointer_unstable_v1",
        interfaces: [
            ZwpRelativePointerManagerV1.interface,
ZwpRelativePointerV1.interface
        ]
    )

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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "create_u32_rgba_buffer",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wl_buffer",
                        )
                        ,
                        Argument(
                            name: "r",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "g",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "b",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "a",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Manager
    /// 
    /// Destroy the wp_single_pixel_buffer_manager_v1 object.
    /// The child objects created via this interface are unaffected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
        let id = connection.sendConstructor(self, 1, WlBuffer.self, version, _queue, [
            .newId,
            .uint(r),
            .uint(g),
            .uint(b),
            .uint(a),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = SinglePixelBufferV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
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

/// Controller Object For Graphic Tablet Devices
/// 
/// An object that provides access to the graphics tablets available on this
/// system. All tablets are associated with a seat, to get access to the
/// actual tablets, use wp_tablet_manager.get_tablet_seat.
public final class ZwpTabletManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "get_tablet_seat",
                    arguments: [
                        Argument(
                            name: "tablet_seat",
                            type: .newId,
                            interface: "zwp_tablet_seat_v1",
                        )
                        ,
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Get The Tablet Seat
    /// 
    /// Get the wp_tablet_seat object for the given seat. This object
    /// provides access to all graphics tablets in this seat.
    /// 
    /// - Parameters:
    ///   - seat: The wl_seat object to retrieve the tablets for
    public func getTabletSeat(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpTabletSeatV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let tabletSeat = connection.sendConstructor(self, 0, ZwpTabletSeatV1.self, version, _queue, [
            .newId,
            .object(seat),
        ])
        return tabletSeat
    }

    /// Release The Memory For The Tablet Manager Object
    /// 
    /// Destroy the wp_tablet_manager object. Objects created from this
    /// object are unaffected and should be destroyed separately.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Controller Object For Graphic Tablet Devices Of A Seat
/// 
/// An object that provides access to the graphics tablets available on this
/// seat. After binding to this interface, the compositor sends a set of
/// wp_tablet_seat.tablet_added and wp_tablet_seat.tool_added events.
public final class ZwpTabletSeatV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_seat_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "tablet_added",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_tablet_v1",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "tool_added",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_tablet_tool_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Release The Memory For The Tablet Seat Object
    /// 
    /// Destroy the wp_tablet_seat object. Objects created from this
    /// object are unaffected and should be destroyed separately.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// New Device Notification
        /// 
        /// This event is sent whenever a new tablet becomes available on this
        /// seat. This event only provides the object id of the tablet, any
        /// static information about the tablet (device name, vid/pid, etc.) is
        /// sent through the wp_tablet interface.
        case tabletAdded(id: ZwpTabletV1)

        /// A New Tool Has Been Used With A Tablet
        /// 
        /// This event is sent whenever a tool that has not previously been used
        /// with a tablet comes into use. This event only provides the object id
        /// of the tool; any static information about the tool (capabilities,
        /// type, etc.) is sent through the wp_tablet_tool interface.
        case toolAdded(id: ZwpTabletToolV1)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.tabletAdded(id: r.newId(type: ZwpTabletV1.self))
            case 1:
                self = Self.toolAdded(id: r.newId(type: ZwpTabletToolV1.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Physical Tablet Tool
/// 
/// An object that represents a physical tool that has been, or is
/// currently in use with a tablet in this seat. Each wp_tablet_tool
/// object stays valid until the client destroys it; the compositor
/// reuses the wp_tablet_tool object to indicate that the object's
/// respective physical tool has come into proximity of a tablet again.
/// A wp_tablet_tool object's relation to a physical tool depends on the
/// tablet's ability to report serial numbers. If the tablet supports
/// this capability, then the object represents a specific physical tool
/// and can be identified even when used on multiple tablets.
/// A tablet tool has a number of static characteristics, e.g. tool type,
/// hardware_serial and capabilities. These capabilities are sent in an
/// event sequence after the wp_tablet_seat.tool_added event before any
/// actual events from this tool. This initial event sequence is
/// terminated by a wp_tablet_tool.done event.
/// Tablet tool events are grouped by wp_tablet_tool.frame events.
/// Any events received before a wp_tablet_tool.frame event should be
/// considered part of the same hardware state change.
public final class ZwpTabletToolV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_tool_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_cursor",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "hotspot_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "hotspot_y",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "type",
                    arguments: [
                        Argument(
                            name: "tool_type",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "hardware_serial",
                    arguments: [
                        Argument(
                            name: "hardware_serial_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "hardware_serial_lo",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "hardware_id_wacom",
                    arguments: [
                        Argument(
                            name: "hardware_id_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "hardware_id_lo",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "capability",
                    arguments: [
                        Argument(
                            name: "capability",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "removed",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "proximity_in",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tablet",
                            type: .object,
                            interface: "zwp_tablet_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "proximity_out",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "down",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "up",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "motion",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "pressure",
                    arguments: [
                        Argument(
                            name: "pressure",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "distance",
                    arguments: [
                        Argument(
                            name: "distance",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "tilt",
                    arguments: [
                        Argument(
                            name: "tilt_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "tilt_y",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "rotation",
                    arguments: [
                        Argument(
                            name: "degrees",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "slider",
                    arguments: [
                        Argument(
                            name: "position",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "wheel",
                    arguments: [
                        Argument(
                            name: "degrees",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "clicks",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "button",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "button",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "frame",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Set The Tablet Tool's Surface
    /// 
    /// Sets the surface of the cursor used for this tool on the given
    /// tablet. This request only takes effect if the tool is in proximity
    /// of one of the requesting client's surfaces or the surface parameter
    /// is the current pointer surface. If there was a previous surface set
    /// with this request it is replaced. If surface is NULL, the cursor
    /// image is hidden.
    /// The parameters hotspot_x and hotspot_y define the position of the
    /// pointer surface relative to the pointer location. Its top-left corner
    /// is always at (x, y) - (hotspot_x, hotspot_y), where (x, y) are the
    /// coordinates of the pointer location, in surface-local coordinates.
    /// On surface.attach requests to the pointer surface, hotspot_x and
    /// hotspot_y are decremented by the x and y parameters passed to the
    /// request. Attach must be confirmed by wl_surface.commit as usual.
    /// The hotspot can also be updated by passing the currently set pointer
    /// surface to this request with new values for hotspot_x and hotspot_y.
    /// The current and pending input regions of the wl_surface are cleared,
    /// and wl_surface.set_input_region is ignored until the wl_surface is no
    /// longer used as the cursor. When the use as a cursor ends, the current
    /// and pending input regions become undefined, and the wl_surface is
    /// unmapped.
    /// This request gives the surface the role of a cursor. The role
    /// assigned by this request is the same as assigned by
    /// wl_pointer.set_cursor meaning the same surface can be
    /// used both as a wl_pointer cursor and a wp_tablet cursor. If the
    /// surface already has another role, it raises a protocol error.
    /// The surface may be used on multiple tablets and across multiple
    /// seats.
    /// 
    /// - Parameters:
    ///   - serial: serial of the enter event
    ///   - hotspotX: surface-local x coordinate
    ///   - hotspotY: surface-local y coordinate
    public func setCursor(serial: UInt32, surface: WlSurface? = nil, hotspotX: Int32, hotspotY: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(serial),
            .object(surface),
            .int(hotspotX),
            .int(hotspotY),
        ])
    }

    /// Destroy The Tool Object
    /// 
    /// This destroys the client's resource for this tool object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletUnstableV1Protocol
    
    public enum `Type`: UInt32 {
        /// Pen
        case pen = 0x140

        /// Eraser
        case eraser = 0x141

        /// Brush
        case brush = 0x142

        /// Pencil
        case pencil = 0x143

        /// Airbrush
        case airbrush = 0x144

        /// Finger
        case finger = 0x145

        /// Mouse
        case mouse = 0x146

        /// Lens
        case lens = 0x147
    }

    public enum Capability: UInt32 {
        /// Tilt axes
        case tilt = 1

        /// Pressure axis
        case pressure = 2

        /// Distance axis
        case distance = 3

        /// Z-rotation axis
        case rotation = 4

        /// Slider axis
        case slider = 5

        /// Wheel axis
        case wheel = 6
    }

    public enum ButtonState: UInt32 {
        /// button is not pressed
        case released = 0

        /// button is pressed
        case pressed = 1
    }

    public enum Error: UInt32 {
        /// given wl_surface has another role
        case role = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Tool Type
        /// 
        /// The tool type is the high-level type of the tool and usually decides
        /// the interaction expected from this tool.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        case type(toolType: Type)

        /// Unique Hardware Serial Number Of The Tool
        /// 
        /// If the physical tool can be identified by a unique 64-bit serial
        /// number, this event notifies the client of this serial number.
        /// If multiple tablets are available in the same seat and the tool is
        /// uniquely identifiable by the serial number, that tool may move
        /// between tablets.
        /// Otherwise, if the tool has no serial number and this event is
        /// missing, the tool is tied to the tablet it first comes into
        /// proximity with. Even if the physical tool is used on multiple
        /// tablets, separate wp_tablet_tool objects will be created, one per
        /// tablet.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        case hardwareSerial(hardwareSerialHi: UInt32, hardwareSerialLo: UInt32)

        /// Hardware Id Notification In Wacom's Format
        /// 
        /// This event notifies the client of a hardware id available on this tool.
        /// The hardware id is a device-specific 64-bit id that provides extra
        /// information about the tool in use, beyond the wl_tool.type
        /// enumeration. The format of the id is specific to tablets made by
        /// Wacom Inc. For example, the hardware id of a Wacom Grip
        /// Pen (a stylus) is 0x802.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        case hardwareIdWacom(hardwareIdHi: UInt32, hardwareIdLo: UInt32)

        /// Tool Capability Notification
        /// 
        /// This event notifies the client of any capabilities of this tool,
        /// beyond the main set of x/y axes and tip up/down detection.
        /// One event is sent for each extra capability available on this tool.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet_tool.done event.
        case capability(capability: Capability)

        /// Tool Description Events Sequence Complete
        /// 
        /// This event signals the end of the initial burst of descriptive
        /// events. A client may consider the static description of the tool to
        /// be complete and finalize initialization of the tool.
        case done

        /// Tool Removed
        /// 
        /// This event is sent when the tool is removed from the system and will
        /// send no further events. Should the physical tool come back into
        /// proximity later, a new wp_tablet_tool object will be created.
        /// It is compositor-dependent when a tool is removed. A compositor may
        /// remove a tool on proximity out, tablet removal or any other reason.
        /// A compositor may also keep a tool alive until shutdown.
        /// If the tool is currently in proximity, a proximity_out event will be
        /// sent before the removed event. See wp_tablet_tool.proximity_out for
        /// the handling of any buttons logically down.
        /// When this event is received, the client must wp_tablet_tool.destroy
        /// the object.
        case removed

        /// Proximity In Event
        /// 
        /// Notification that this tool is focused on a certain surface.
        /// This event can be received when the tool has moved from one surface to
        /// another, or when the tool has come back into proximity above the
        /// surface.
        /// If any button is logically down when the tool comes into proximity,
        /// the respective button event is sent after the proximity_in event but
        /// within the same frame as the proximity_in event.
        case proximityIn(serial: UInt32, tablet: ZwpTabletV1, surface: WlSurface)

        /// Proximity Out Event
        /// 
        /// Notification that this tool has either left proximity, or is no
        /// longer focused on a certain surface.
        /// When the tablet tool leaves proximity of the tablet, button release
        /// events are sent for each button that was held down at the time of
        /// leaving proximity. These events are sent before the proximity_out
        /// event but within the same wp_tablet.frame.
        /// If the tool stays within proximity of the tablet, but the focus
        /// changes from one surface to another, a button release event may not
        /// be sent until the button is actually released or the tool leaves the
        /// proximity of the tablet.
        case proximityOut

        /// Tablet Tool Is Making Contact
        /// 
        /// Sent whenever the tablet tool comes in contact with the surface of the
        /// tablet.
        /// If the tool is already in contact with the tablet when entering the
        /// input region, the client owning said region will receive a
        /// wp_tablet.proximity_in event, followed by a wp_tablet.down
        /// event and a wp_tablet.frame event.
        /// Note that this event describes logical contact, not physical
        /// contact. On some devices, a compositor may not consider a tool in
        /// logical contact until a minimum physical pressure threshold is
        /// exceeded.
        case down(serial: UInt32)

        /// Tablet Tool Is No Longer Making Contact
        /// 
        /// Sent whenever the tablet tool stops making contact with the surface of
        /// the tablet, or when the tablet tool moves out of the input region
        /// and the compositor grab (if any) is dismissed.
        /// If the tablet tool moves out of the input region while in contact
        /// with the surface of the tablet and the compositor does not have an
        /// ongoing grab on the surface, the client owning said region will
        /// receive a wp_tablet.up event, followed by a wp_tablet.proximity_out
        /// event and a wp_tablet.frame event. If the compositor has an ongoing
        /// grab on this device, this event sequence is sent whenever the grab
        /// is dismissed in the future.
        /// Note that this event describes logical contact, not physical
        /// contact. On some devices, a compositor may not consider a tool out
        /// of logical contact until physical pressure falls below a specific
        /// threshold.
        case up

        /// Motion Event
        /// 
        /// Sent whenever a tablet tool moves.
        case motion(x: Double, y: Double)

        /// Pressure Change Event
        /// 
        /// Sent whenever the pressure axis on a tool changes. The value of this
        /// event is normalized to a value between 0 and 65535.
        /// Note that pressure may be nonzero even when a tool is not in logical
        /// contact. See the down and up events for more details.
        case pressure(pressure: UInt32)

        /// Distance Change Event
        /// 
        /// Sent whenever the distance axis on a tool changes. The value of this
        /// event is normalized to a value between 0 and 65535.
        /// Note that distance may be nonzero even when a tool is not in logical
        /// contact. See the down and up events for more details.
        case distance(distance: UInt32)

        /// Tilt Change Event
        /// 
        /// Sent whenever one or both of the tilt axes on a tool change. Each tilt
        /// value is in 0.01 of a degree, relative to the z-axis of the tablet.
        /// The angle is positive when the top of a tool tilts along the
        /// positive x or y axis.
        case tilt(tiltX: Int32, tiltY: Int32)

        /// Z-Rotation Change Event
        /// 
        /// Sent whenever the z-rotation axis on the tool changes. The
        /// rotation value is in 0.01 of a degree clockwise from the tool's
        /// logical neutral position.
        case rotation(degrees: Int32)

        /// Slider Position Change Event
        /// 
        /// Sent whenever the slider position on the tool changes. The
        /// value is normalized between -65535 and 65535, with 0 as the logical
        /// neutral position of the slider.
        /// The slider is available on e.g. the Wacom Airbrush tool.
        case slider(position: Int32)

        /// Wheel Delta Event
        /// 
        /// Sent whenever the wheel on the tool emits an event. This event
        /// contains two values for the same axis change. The degrees value is
        /// in 0.01 of a degree in the same orientation as the
        /// wl_pointer.vertical_scroll axis. The clicks value is in discrete
        /// logical clicks of the mouse wheel. This value may be zero if the
        /// movement of the wheel was less than one logical click.
        /// Clients should choose either value and avoid mixing degrees and
        /// clicks. The compositor may accumulate values smaller than a logical
        /// click and emulate click events when a certain threshold is met.
        /// Thus, wl_tablet_tool.wheel events with non-zero clicks values may
        /// have different degrees values.
        case wheel(degrees: Int32, clicks: Int32)

        /// Button Event
        /// 
        /// Sent whenever a button on the tool is pressed or released.
        /// If a button is held down when the tool moves in or out of proximity,
        /// button events are generated by the compositor. See
        /// wp_tablet_tool.proximity_in and wp_tablet_tool.proximity_out for
        /// details.
        case button(serial: UInt32, button: UInt32, state: ButtonState)

        /// Frame Event
        /// 
        /// Marks the end of a series of axis and/or button updates from the
        /// tablet. The Wayland protocol requires axis updates to be sent
        /// sequentially, however all events within a frame should be considered
        /// one hardware event.
        case frame(time: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.type(toolType: try r.`enum`(Type.self))
            case 1:
                self = Self.hardwareSerial(hardwareSerialHi: r.uint(), hardwareSerialLo: r.uint())
            case 2:
                self = Self.hardwareIdWacom(hardwareIdHi: r.uint(), hardwareIdLo: r.uint())
            case 3:
                self = Self.capability(capability: try r.`enum`(Capability.self))
            case 4:
                self = Self.done
            case 5:
                self = Self.removed
            case 6:
                self = Self.proximityIn(serial: r.uint(), tablet: r.object(type: ZwpTabletV1.self), surface: r.object(type: WlSurface.self))
            case 7:
                self = Self.proximityOut
            case 8:
                self = Self.down(serial: r.uint())
            case 9:
                self = Self.up
            case 10:
                self = Self.motion(x: r.fixed(), y: r.fixed())
            case 11:
                self = Self.pressure(pressure: r.uint())
            case 12:
                self = Self.distance(distance: r.uint())
            case 13:
                self = Self.tilt(tiltX: r.int(), tiltY: r.int())
            case 14:
                self = Self.rotation(degrees: r.int())
            case 15:
                self = Self.slider(position: r.int())
            case 16:
                self = Self.wheel(degrees: r.int(), clicks: r.int())
            case 17:
                self = Self.button(serial: r.uint(), button: r.uint(), state: try r.`enum`(ButtonState.self))
            case 18:
                self = Self.frame(time: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Graphics Tablet Device
/// 
/// The wp_tablet interface represents one graphics tablet device. The
/// tablet interface itself does not generate events; all events are
/// generated by wp_tablet_tool objects when in proximity above a tablet.
/// A tablet has a number of static characteristics, e.g. device name and
/// pid/vid. These capabilities are sent in an event sequence after the
/// wp_tablet_seat.tablet_added event. This initial event sequence is
/// terminated by a wp_tablet.done event.
public final class ZwpTabletV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "name",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "id",
                    arguments: [
                        Argument(
                            name: "vid",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "pid",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "path",
                    arguments: [
                        Argument(
                            name: "path",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "removed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Tablet Object
    /// 
    /// This destroys the client's resource for this tablet object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Tablet Device Name
        /// 
        /// This event is sent in the initial burst of events before the
        /// wp_tablet.done event.
        case name(name: String)

        /// Tablet Device Usb Vendor/Product Id
        /// 
        /// This event is sent in the initial burst of events before the
        /// wp_tablet.done event.
        case id(vid: UInt32, pid: UInt32)

        /// Path To The Device
        /// 
        /// A system-specific device path that indicates which device is behind
        /// this wp_tablet. This information may be used to gather additional
        /// information about the device, e.g. through libwacom.
        /// A device may have more than one device path. If so, multiple
        /// wp_tablet.path events are sent. A device may be emulated and not
        /// have a device path, and in that case this event will not be sent.
        /// The format of the path is unspecified, it may be a device node, a
        /// sysfs path, or some other identifier. It is up to the client to
        /// identify the string provided.
        /// This event is sent in the initial burst of events before the
        /// wp_tablet.done event.
        case path(path: String)

        /// Tablet Description Events Sequence Complete
        /// 
        /// This event is sent immediately to signal the end of the initial
        /// burst of descriptive events. A client may consider the static
        /// description of the tablet to be complete and finalize initialization
        /// of the tablet.
        case done

        /// Tablet Removed Event
        /// 
        /// Sent when the tablet has been removed from the system. When a tablet
        /// is removed, some tools may be removed.
        /// When this event is received, the client must wp_tablet.destroy
        /// the object.
        case removed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.name(name: r.string())
            case 1:
                self = Self.id(vid: r.uint(), pid: r.uint())
            case 2:
                self = Self.path(path: r.string())
            case 3:
                self = Self.done
            case 4:
                self = Self.removed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let TabletUnstableV1Protocol = Protocol(
        name: "tablet_unstable_v1",
        interfaces: [
            ZwpTabletManagerV1.interface,
ZwpTabletSeatV1.interface,
ZwpTabletToolV1.interface,
ZwpTabletV1.interface
        ]
    )

/// Controller Object For Graphic Tablet Devices
/// 
/// An object that provides access to the graphics tablets available on this
/// system. All tablets are associated with a seat, to get access to the
/// actual tablets, use zwp_tablet_manager_v2.get_tablet_seat.
public final class ZwpTabletManagerV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_manager_v2",
            version: 2,
            requests: [
                Message(
                    name: "get_tablet_seat",
                    arguments: [
                        Argument(
                            name: "tablet_seat",
                            type: .newId,
                            interface: "zwp_tablet_seat_v2",
                        )
                        ,
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Get The Tablet Seat
    /// 
    /// Get the zwp_tablet_seat_v2 object for the given seat. This object
    /// provides access to all graphics tablets in this seat.
    /// 
    /// - Parameters:
    ///   - seat: The wl_seat object to retrieve the tablets for
    public func getTabletSeat(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpTabletSeatV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let tabletSeat = connection.sendConstructor(self, 0, ZwpTabletSeatV2.self, version, _queue, [
            .newId,
            .object(seat),
        ])
        return tabletSeat
    }

    /// Release The Memory For The Tablet Manager Object
    /// 
    /// Destroy the zwp_tablet_manager_v2 object. Objects created from this
    /// object are unaffected and should be destroyed separately.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletV2Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Controller Object For Graphic Tablet Devices Of A Seat
/// 
/// An object that provides access to the graphics tablets available on this
/// seat. After binding to this interface, the compositor sends a set of
/// zwp_tablet_seat_v2.tablet_added and zwp_tablet_seat_v2.tool_added events.
public final class ZwpTabletSeatV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_seat_v2",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "tablet_added",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_tablet_v2",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "tool_added",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_tablet_tool_v2",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "pad_added",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_tablet_pad_v2",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Release The Memory For The Tablet Seat Object
    /// 
    /// Destroy the zwp_tablet_seat_v2 object. Objects created from this
    /// object are unaffected and should be destroyed separately.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletV2Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// New Device Notification
        /// 
        /// This event is sent whenever a new tablet becomes available on this
        /// seat. This event only provides the object id of the tablet, any
        /// static information about the tablet (device name, vid/pid, etc.) is
        /// sent through the zwp_tablet_v2 interface.
        case tabletAdded(id: ZwpTabletV2)

        /// A New Tool Has Been Used With A Tablet
        /// 
        /// This event is sent whenever a tool that has not previously been used
        /// with a tablet comes into use. This event only provides the object id
        /// of the tool; any static information about the tool (capabilities,
        /// type, etc.) is sent through the zwp_tablet_tool_v2 interface.
        case toolAdded(id: ZwpTabletToolV2)

        /// New Pad Notification
        /// 
        /// This event is sent whenever a new pad is known to the system. Typically,
        /// pads are physically attached to tablets and a pad_added event is
        /// sent immediately after the zwp_tablet_seat_v2.tablet_added.
        /// However, some standalone pad devices logically attach to tablets at
        /// runtime, and the client must wait for zwp_tablet_pad_v2.enter to know
        /// the tablet a pad is attached to.
        /// This event only provides the object id of the pad. All further
        /// features (buttons, strips, rings) are sent through the zwp_tablet_pad_v2
        /// interface.
        case padAdded(id: ZwpTabletPadV2)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.tabletAdded(id: r.newId(type: ZwpTabletV2.self))
            case 1:
                self = Self.toolAdded(id: r.newId(type: ZwpTabletToolV2.self))
            case 2:
                self = Self.padAdded(id: r.newId(type: ZwpTabletPadV2.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Physical Tablet Tool
/// 
/// An object that represents a physical tool that has been, or is
/// currently in use with a tablet in this seat. Each zwp_tablet_tool_v2
/// object stays valid until the client destroys it; the compositor
/// reuses the zwp_tablet_tool_v2 object to indicate that the object's
/// respective physical tool has come into proximity of a tablet again.
/// A zwp_tablet_tool_v2 object's relation to a physical tool depends on the
/// tablet's ability to report serial numbers. If the tablet supports
/// this capability, then the object represents a specific physical tool
/// and can be identified even when used on multiple tablets.
/// A tablet tool has a number of static characteristics, e.g. tool type,
/// hardware_serial and capabilities. These capabilities are sent in an
/// event sequence after the zwp_tablet_seat_v2.tool_added event before any
/// actual events from this tool. This initial event sequence is
/// terminated by a zwp_tablet_tool_v2.done event.
/// Tablet tool events are grouped by zwp_tablet_tool_v2.frame events.
/// Any events received before a zwp_tablet_tool_v2.frame event should be
/// considered part of the same hardware state change.
public final class ZwpTabletToolV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_tool_v2",
            version: 2,
            requests: [
                Message(
                    name: "set_cursor",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "hotspot_x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "hotspot_y",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "type",
                    arguments: [
                        Argument(
                            name: "tool_type",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "hardware_serial",
                    arguments: [
                        Argument(
                            name: "hardware_serial_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "hardware_serial_lo",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "hardware_id_wacom",
                    arguments: [
                        Argument(
                            name: "hardware_id_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "hardware_id_lo",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "capability",
                    arguments: [
                        Argument(
                            name: "capability",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "removed",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "proximity_in",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tablet",
                            type: .object,
                            interface: "zwp_tablet_v2",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "proximity_out",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "down",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "up",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "motion",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "pressure",
                    arguments: [
                        Argument(
                            name: "pressure",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "distance",
                    arguments: [
                        Argument(
                            name: "distance",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "tilt",
                    arguments: [
                        Argument(
                            name: "tilt_x",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "tilt_y",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "rotation",
                    arguments: [
                        Argument(
                            name: "degrees",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "slider",
                    arguments: [
                        Argument(
                            name: "position",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "wheel",
                    arguments: [
                        Argument(
                            name: "degrees",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "clicks",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "button",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "button",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "frame",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Set The Tablet Tool's Surface
    /// 
    /// Sets the surface of the cursor used for this tool on the given
    /// tablet. This request only takes effect if the tool is in proximity
    /// of one of the requesting client's surfaces or the surface parameter
    /// is the current pointer surface. If there was a previous surface set
    /// with this request it is replaced. If surface is NULL, the cursor
    /// image is hidden.
    /// The parameters hotspot_x and hotspot_y define the position of the
    /// pointer surface relative to the pointer location. Its top-left corner
    /// is always at (x, y) - (hotspot_x, hotspot_y), where (x, y) are the
    /// coordinates of the pointer location, in surface-local coordinates.
    /// On surface.attach requests to the pointer surface, hotspot_x and
    /// hotspot_y are decremented by the x and y parameters passed to the
    /// request. Attach must be confirmed by wl_surface.commit as usual.
    /// The hotspot can also be updated by passing the currently set pointer
    /// surface to this request with new values for hotspot_x and hotspot_y.
    /// The current and pending input regions of the wl_surface are cleared,
    /// and wl_surface.set_input_region is ignored until the wl_surface is no
    /// longer used as the cursor. When the use as a cursor ends, the current
    /// and pending input regions become undefined, and the wl_surface is
    /// unmapped.
    /// This request gives the surface the role of a zwp_tablet_tool_v2 cursor. A
    /// surface may only ever be used as the cursor surface for one
    /// zwp_tablet_tool_v2. If the surface already has another role or has
    /// previously been used as cursor surface for a different tool, a
    /// protocol error is raised.
    /// 
    /// - Parameters:
    ///   - serial: serial of the proximity_in event
    ///   - hotspotX: surface-local x coordinate
    ///   - hotspotY: surface-local y coordinate
    public func setCursor(serial: UInt32, surface: WlSurface? = nil, hotspotX: Int32, hotspotY: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(serial),
            .object(surface),
            .int(hotspotX),
            .int(hotspotY),
        ])
    }

    /// Destroy The Tool Object
    /// 
    /// This destroys the client's resource for this tool object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletV2Protocol
    
    public enum `Type`: UInt32 {
        /// Pen
        case pen = 0x140

        /// Eraser
        case eraser = 0x141

        /// Brush
        case brush = 0x142

        /// Pencil
        case pencil = 0x143

        /// Airbrush
        case airbrush = 0x144

        /// Finger
        case finger = 0x145

        /// Mouse
        case mouse = 0x146

        /// Lens
        case lens = 0x147
    }

    public enum Capability: UInt32 {
        /// Tilt axes
        case tilt = 1

        /// Pressure axis
        case pressure = 2

        /// Distance axis
        case distance = 3

        /// Z-rotation axis
        case rotation = 4

        /// Slider axis
        case slider = 5

        /// Wheel axis
        case wheel = 6
    }

    public enum ButtonState: UInt32 {
        /// button is not pressed
        case released = 0

        /// button is pressed
        case pressed = 1
    }

    public enum Error: UInt32 {
        /// given wl_surface has another role
        case role = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Tool Type
        /// 
        /// The tool type is the high-level type of the tool and usually decides
        /// the interaction expected from this tool.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_tool_v2.done event.
        case type(toolType: Type)

        /// Unique Hardware Serial Number Of The Tool
        /// 
        /// If the physical tool can be identified by a unique 64-bit serial
        /// number, this event notifies the client of this serial number.
        /// If multiple tablets are available in the same seat and the tool is
        /// uniquely identifiable by the serial number, that tool may move
        /// between tablets.
        /// Otherwise, if the tool has no serial number and this event is
        /// missing, the tool is tied to the tablet it first comes into
        /// proximity with. Even if the physical tool is used on multiple
        /// tablets, separate zwp_tablet_tool_v2 objects will be created, one per
        /// tablet.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_tool_v2.done event.
        case hardwareSerial(hardwareSerialHi: UInt32, hardwareSerialLo: UInt32)

        /// Hardware Id Notification In Wacom's Format
        /// 
        /// This event notifies the client of a hardware id available on this tool.
        /// The hardware id is a device-specific 64-bit id that provides extra
        /// information about the tool in use, beyond the wl_tool.type
        /// enumeration. The format of the id is specific to tablets made by
        /// Wacom Inc. For example, the hardware id of a Wacom Grip
        /// Pen (a stylus) is 0x802.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_tool_v2.done event.
        case hardwareIdWacom(hardwareIdHi: UInt32, hardwareIdLo: UInt32)

        /// Tool Capability Notification
        /// 
        /// This event notifies the client of any capabilities of this tool,
        /// beyond the main set of x/y axes and tip up/down detection.
        /// One event is sent for each extra capability available on this tool.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_tool_v2.done event.
        case capability(capability: Capability)

        /// Tool Description Events Sequence Complete
        /// 
        /// This event signals the end of the initial burst of descriptive
        /// events. A client may consider the static description of the tool to
        /// be complete and finalize initialization of the tool.
        case done

        /// Tool Removed
        /// 
        /// This event is sent when the tool is removed from the system and will
        /// send no further events. Should the physical tool come back into
        /// proximity later, a new zwp_tablet_tool_v2 object will be created.
        /// It is compositor-dependent when a tool is removed. A compositor may
        /// remove a tool on proximity out, tablet removal or any other reason.
        /// A compositor may also keep a tool alive until shutdown.
        /// If the tool is currently in proximity, a proximity_out event will be
        /// sent before the removed event. See zwp_tablet_tool_v2.proximity_out for
        /// the handling of any buttons logically down.
        /// When this event is received, the client must zwp_tablet_tool_v2.destroy
        /// the object.
        case removed

        /// Proximity In Event
        /// 
        /// Notification that this tool is focused on a certain surface.
        /// This event can be received when the tool has moved from one surface to
        /// another, or when the tool has come back into proximity above the
        /// surface.
        /// If any button is logically down when the tool comes into proximity,
        /// the respective button event is sent after the proximity_in event but
        /// within the same frame as the proximity_in event.
        case proximityIn(serial: UInt32, tablet: ZwpTabletV2, surface: WlSurface)

        /// Proximity Out Event
        /// 
        /// Notification that this tool has either left proximity, or is no
        /// longer focused on a certain surface.
        /// When the tablet tool leaves proximity of the tablet, button release
        /// events are sent for each button that was held down at the time of
        /// leaving proximity. These events are sent before the proximity_out
        /// event but within the same zwp_tablet_v2.frame.
        /// If the tool stays within proximity of the tablet, but the focus
        /// changes from one surface to another, a button release event may not
        /// be sent until the button is actually released or the tool leaves the
        /// proximity of the tablet.
        case proximityOut

        /// Tablet Tool Is Making Contact
        /// 
        /// Sent whenever the tablet tool comes in contact with the surface of the
        /// tablet.
        /// If the tool is already in contact with the tablet when entering the
        /// input region, the client owning said region will receive a
        /// zwp_tablet_v2.proximity_in event, followed by a zwp_tablet_v2.down
        /// event and a zwp_tablet_v2.frame event.
        /// Note that this event describes logical contact, not physical
        /// contact. On some devices, a compositor may not consider a tool in
        /// logical contact until a minimum physical pressure threshold is
        /// exceeded.
        case down(serial: UInt32)

        /// Tablet Tool Is No Longer Making Contact
        /// 
        /// Sent whenever the tablet tool stops making contact with the surface of
        /// the tablet, or when the tablet tool moves out of the input region
        /// and the compositor grab (if any) is dismissed.
        /// If the tablet tool moves out of the input region while in contact
        /// with the surface of the tablet and the compositor does not have an
        /// ongoing grab on the surface, the client owning said region will
        /// receive a zwp_tablet_v2.up event, followed by a zwp_tablet_v2.proximity_out
        /// event and a zwp_tablet_v2.frame event. If the compositor has an ongoing
        /// grab on this device, this event sequence is sent whenever the grab
        /// is dismissed in the future.
        /// Note that this event describes logical contact, not physical
        /// contact. On some devices, a compositor may not consider a tool out
        /// of logical contact until physical pressure falls below a specific
        /// threshold.
        case up

        /// Motion Event
        /// 
        /// Sent whenever a tablet tool moves.
        case motion(x: Double, y: Double)

        /// Pressure Change Event
        /// 
        /// Sent whenever the pressure axis on a tool changes. The value of this
        /// event is normalized to a value between 0 and 65535.
        /// Note that pressure may be nonzero even when a tool is not in logical
        /// contact. See the down and up events for more details.
        case pressure(pressure: UInt32)

        /// Distance Change Event
        /// 
        /// Sent whenever the distance axis on a tool changes. The value of this
        /// event is normalized to a value between 0 and 65535.
        /// Note that distance may be nonzero even when a tool is not in logical
        /// contact. See the down and up events for more details.
        case distance(distance: UInt32)

        /// Tilt Change Event
        /// 
        /// Sent whenever one or both of the tilt axes on a tool change. Each tilt
        /// value is in degrees, relative to the z-axis of the tablet.
        /// The angle is positive when the top of a tool tilts along the
        /// positive x or y axis.
        case tilt(tiltX: Double, tiltY: Double)

        /// Z-Rotation Change Event
        /// 
        /// Sent whenever the z-rotation axis on the tool changes. The
        /// rotation value is in degrees clockwise from the tool's
        /// logical neutral position.
        case rotation(degrees: Double)

        /// Slider Position Change Event
        /// 
        /// Sent whenever the slider position on the tool changes. The
        /// value is normalized between -65535 and 65535, with 0 as the logical
        /// neutral position of the slider.
        /// The slider is available on e.g. the Wacom Airbrush tool.
        case slider(position: Int32)

        /// Wheel Delta Event
        /// 
        /// Sent whenever the wheel on the tool emits an event. This event
        /// contains two values for the same axis change. The degrees value is
        /// in the same orientation as the wl_pointer.vertical_scroll axis. The
        /// clicks value is in discrete logical clicks of the mouse wheel. This
        /// value may be zero if the movement of the wheel was less
        /// than one logical click.
        /// Clients should choose either value and avoid mixing degrees and
        /// clicks. The compositor may accumulate values smaller than a logical
        /// click and emulate click events when a certain threshold is met.
        /// Thus, zwp_tablet_tool_v2.wheel events with non-zero clicks values may
        /// have different degrees values.
        case wheel(degrees: Double, clicks: Int32)

        /// Button Event
        /// 
        /// Sent whenever a button on the tool is pressed or released.
        /// If a button is held down when the tool moves in or out of proximity,
        /// button events are generated by the compositor. See
        /// zwp_tablet_tool_v2.proximity_in and zwp_tablet_tool_v2.proximity_out for
        /// details.
        case button(serial: UInt32, button: UInt32, state: ButtonState)

        /// Frame Event
        /// 
        /// Marks the end of a series of axis and/or button updates from the
        /// tablet. The Wayland protocol requires axis updates to be sent
        /// sequentially, however all events within a frame should be considered
        /// one hardware event.
        case frame(time: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.type(toolType: try r.`enum`(Type.self))
            case 1:
                self = Self.hardwareSerial(hardwareSerialHi: r.uint(), hardwareSerialLo: r.uint())
            case 2:
                self = Self.hardwareIdWacom(hardwareIdHi: r.uint(), hardwareIdLo: r.uint())
            case 3:
                self = Self.capability(capability: try r.`enum`(Capability.self))
            case 4:
                self = Self.done
            case 5:
                self = Self.removed
            case 6:
                self = Self.proximityIn(serial: r.uint(), tablet: r.object(type: ZwpTabletV2.self), surface: r.object(type: WlSurface.self))
            case 7:
                self = Self.proximityOut
            case 8:
                self = Self.down(serial: r.uint())
            case 9:
                self = Self.up
            case 10:
                self = Self.motion(x: r.fixed(), y: r.fixed())
            case 11:
                self = Self.pressure(pressure: r.uint())
            case 12:
                self = Self.distance(distance: r.uint())
            case 13:
                self = Self.tilt(tiltX: r.fixed(), tiltY: r.fixed())
            case 14:
                self = Self.rotation(degrees: r.fixed())
            case 15:
                self = Self.slider(position: r.int())
            case 16:
                self = Self.wheel(degrees: r.fixed(), clicks: r.int())
            case 17:
                self = Self.button(serial: r.uint(), button: r.uint(), state: try r.`enum`(ButtonState.self))
            case 18:
                self = Self.frame(time: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Graphics Tablet Device
/// 
/// The zwp_tablet_v2 interface represents one graphics tablet device. The
/// tablet interface itself does not generate events; all events are
/// generated by zwp_tablet_tool_v2 objects when in proximity above a tablet.
/// A tablet has a number of static characteristics, e.g. device name and
/// pid/vid. These capabilities are sent in an event sequence after the
/// zwp_tablet_seat_v2.tablet_added event. This initial event sequence is
/// terminated by a zwp_tablet_v2.done event.
public final class ZwpTabletV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_v2",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "name",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "id",
                    arguments: [
                        Argument(
                            name: "vid",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "pid",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "path",
                    arguments: [
                        Argument(
                            name: "path",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "removed",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "bustype",
                    arguments: [
                        Argument(
                            name: "bustype",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
            ],
        )
    /// Destroy The Tablet Object
    /// 
    /// This destroys the client's resource for this tablet object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletV2Protocol
    
    public enum Bustype: UInt32 {
        /// USB
        case usb = 3

        /// Bluetooth
        case bluetooth = 5

        /// Virtual
        case virtual = 6

        /// Serial
        case serial = 17

        /// I2C
        case i2c = 24
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Tablet Device Name
        /// 
        /// A descriptive name for the tablet device.
        /// If the device has no descriptive name, this event is not sent.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_v2.done event.
        case name(name: String)

        /// Tablet Device Vendor/Product Id
        /// 
        /// The vendor and product IDs for the tablet device.
        /// The interpretation of the id depends on the zwp_tablet_v2.bustype.
        /// Prior to version v2 of this protocol, the id was implied to be a USB
        /// vendor and product ID. If no zwp_tablet_v2.bustype is sent, the ID
        /// is to be interpreted as USB vendor and product ID.
        /// If the device has no vendor/product ID, this event is not sent.
        /// This can happen for virtual devices or non-USB devices, for instance.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_v2.done event.
        case id(vid: UInt32, pid: UInt32)

        /// Path To The Device
        /// 
        /// A system-specific device path that indicates which device is behind
        /// this zwp_tablet_v2. This information may be used to gather additional
        /// information about the device, e.g. through libwacom.
        /// A device may have more than one device path. If so, multiple
        /// zwp_tablet_v2.path events are sent. A device may be emulated and not
        /// have a device path, and in that case this event will not be sent.
        /// The format of the path is unspecified, it may be a device node, a
        /// sysfs path, or some other identifier. It is up to the client to
        /// identify the string provided.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_v2.done event.
        case path(path: String)

        /// Tablet Description Events Sequence Complete
        /// 
        /// This event is sent immediately to signal the end of the initial
        /// burst of descriptive events. A client may consider the static
        /// description of the tablet to be complete and finalize initialization
        /// of the tablet.
        case done

        /// Tablet Removed Event
        /// 
        /// Sent when the tablet has been removed from the system. When a tablet
        /// is removed, some tools may be removed.
        /// When this event is received, the client must zwp_tablet_v2.destroy
        /// the object.
        case removed

        /// Tablet Device Bus Type
        /// 
        /// The bustype argument is one of the BUS_ defines in the Linux kernel's
        /// linux/input.h
        /// If the device has no known bustype or the bustype cannot be
        /// queried, this event is not sent.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_v2.done event.
        case bustype(bustype: Bustype)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.name(name: r.string())
            case 1:
                self = Self.id(vid: r.uint(), pid: r.uint())
            case 2:
                self = Self.path(path: r.string())
            case 3:
                self = Self.done
            case 4:
                self = Self.removed
            case 5:
                self = Self.bustype(bustype: try r.`enum`(Bustype.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Pad Ring
/// 
/// A circular interaction area, such as the touch ring on the Wacom Intuos
/// Pro series tablets.
/// Events on a ring are logically grouped by the zwp_tablet_pad_ring_v2.frame
/// event.
public final class ZwpTabletPadRingV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_ring_v2",
            version: 2,
            requests: [
                Message(
                    name: "set_feedback",
                    arguments: [
                        Argument(
                            name: "description",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "source",
                    arguments: [
                        Argument(
                            name: "source",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "angle",
                    arguments: [
                        Argument(
                            name: "degrees",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "stop",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "frame",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Set Compositor Feedback
    /// 
    /// Request that the compositor use the provided feedback string
    /// associated with this ring. This request should be issued immediately
    /// after a zwp_tablet_pad_group_v2.mode_switch event from the corresponding
    /// group is received, or whenever the ring is mapped to a different
    /// action. See zwp_tablet_pad_group_v2.mode_switch for more details.
    /// Clients are encouraged to provide context-aware descriptions for
    /// the actions associated with the ring; compositors may use this
    /// information to offer visual feedback about the button layout
    /// (eg. on-screen displays).
    /// The provided string 'description' is a UTF-8 encoded string to be
    /// associated with this ring, and is considered user-visible; general
    /// internationalization rules apply.
    /// The serial argument will be that of the last
    /// zwp_tablet_pad_group_v2.mode_switch event received for the group of this
    /// ring. Requests providing other serials than the most recent one will be
    /// ignored.
    /// 
    /// - Parameters:
    ///   - description: ring description
    ///   - serial: serial of the mode switch event
    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(description),
            .uint(serial),
        ])
    }

    /// Destroy The Ring Object
    /// 
    /// This destroys the client's resource for this ring object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletV2Protocol
    
    public enum Source: UInt32 {
        /// finger
        case finger = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Ring Event Source
        /// 
        /// Source information for ring events.
        /// This event does not occur on its own. It is sent before a
        /// zwp_tablet_pad_ring_v2.frame event and carries the source information
        /// for all events within that frame.
        /// The source specifies how this event was generated. If the source is
        /// zwp_tablet_pad_ring_v2.source.finger, a zwp_tablet_pad_ring_v2.stop event
        /// will be sent when the user lifts the finger off the device.
        /// This event is optional. If the source is unknown for an interaction,
        /// no event is sent.
        case source(source: Source)

        /// Angle Changed
        /// 
        /// Sent whenever the angle on a ring changes.
        /// The angle is provided in degrees clockwise from the logical
        /// north of the ring in the pad's current rotation.
        case angle(degrees: Double)

        /// Interaction Stopped
        /// 
        /// Stop notification for ring events.
        /// For some zwp_tablet_pad_ring_v2.source types, a zwp_tablet_pad_ring_v2.stop
        /// event is sent to notify a client that the interaction with the ring
        /// has terminated. This enables the client to implement kinetic scrolling.
        /// See the zwp_tablet_pad_ring_v2.source documentation for information on
        /// when this event may be generated.
        /// Any zwp_tablet_pad_ring_v2.angle events with the same source after this
        /// event should be considered as the start of a new interaction.
        case stop

        /// End Of A Ring Event Sequence
        /// 
        /// Indicates the end of a set of ring events that logically belong
        /// together. A client is expected to accumulate the data in all events
        /// within the frame before proceeding.
        /// All zwp_tablet_pad_ring_v2 events before a zwp_tablet_pad_ring_v2.frame event belong
        /// logically together. For example, on termination of a finger interaction
        /// on a ring the compositor will send a zwp_tablet_pad_ring_v2.source event,
        /// a zwp_tablet_pad_ring_v2.stop event and a zwp_tablet_pad_ring_v2.frame event.
        /// A zwp_tablet_pad_ring_v2.frame event is sent for every logical event
        /// group, even if the group only contains a single zwp_tablet_pad_ring_v2
        /// event. Specifically, a client may get a sequence: angle, frame,
        /// angle, frame, etc.
        case frame(time: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.source(source: try r.`enum`(Source.self))
            case 1:
                self = Self.angle(degrees: r.fixed())
            case 2:
                self = Self.stop
            case 3:
                self = Self.frame(time: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Pad Strip
/// 
/// A linear interaction area, such as the strips found in Wacom Cintiq
/// models.
/// Events on a strip are logically grouped by the zwp_tablet_pad_strip_v2.frame
/// event.
public final class ZwpTabletPadStripV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_strip_v2",
            version: 2,
            requests: [
                Message(
                    name: "set_feedback",
                    arguments: [
                        Argument(
                            name: "description",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "source",
                    arguments: [
                        Argument(
                            name: "source",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "position",
                    arguments: [
                        Argument(
                            name: "position",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "stop",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "frame",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Set Compositor Feedback
    /// 
    /// Requests the compositor to use the provided feedback string
    /// associated with this strip. This request should be issued immediately
    /// after a zwp_tablet_pad_group_v2.mode_switch event from the corresponding
    /// group is received, or whenever the strip is mapped to a different
    /// action. See zwp_tablet_pad_group_v2.mode_switch for more details.
    /// Clients are encouraged to provide context-aware descriptions for
    /// the actions associated with the strip, and compositors may use this
    /// information to offer visual feedback about the button layout
    /// (eg. on-screen displays).
    /// The provided string 'description' is a UTF-8 encoded string to be
    /// associated with this ring, and is considered user-visible; general
    /// internationalization rules apply.
    /// The serial argument will be that of the last
    /// zwp_tablet_pad_group_v2.mode_switch event received for the group of this
    /// strip. Requests providing other serials than the most recent one will be
    /// ignored.
    /// 
    /// - Parameters:
    ///   - description: strip description
    ///   - serial: serial of the mode switch event
    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(description),
            .uint(serial),
        ])
    }

    /// Destroy The Strip Object
    /// 
    /// This destroys the client's resource for this strip object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletV2Protocol
    
    public enum Source: UInt32 {
        /// finger
        case finger = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Strip Event Source
        /// 
        /// Source information for strip events.
        /// This event does not occur on its own. It is sent before a
        /// zwp_tablet_pad_strip_v2.frame event and carries the source information
        /// for all events within that frame.
        /// The source specifies how this event was generated. If the source is
        /// zwp_tablet_pad_strip_v2.source.finger, a zwp_tablet_pad_strip_v2.stop event
        /// will be sent when the user lifts their finger off the device.
        /// This event is optional. If the source is unknown for an interaction,
        /// no event is sent.
        case source(source: Source)

        /// Position Changed
        /// 
        /// Sent whenever the position on a strip changes.
        /// The position is normalized to a range of [0, 65535], the 0-value
        /// represents the top-most and/or left-most position of the strip in
        /// the pad's current rotation.
        case position(position: UInt32)

        /// Interaction Stopped
        /// 
        /// Stop notification for strip events.
        /// For some zwp_tablet_pad_strip_v2.source types, a zwp_tablet_pad_strip_v2.stop
        /// event is sent to notify a client that the interaction with the strip
        /// has terminated. This enables the client to implement kinetic
        /// scrolling. See the zwp_tablet_pad_strip_v2.source documentation for
        /// information on when this event may be generated.
        /// Any zwp_tablet_pad_strip_v2.position events with the same source after this
        /// event should be considered as the start of a new interaction.
        case stop

        /// End Of A Strip Event Sequence
        /// 
        /// Indicates the end of a set of events that represent one logical
        /// hardware strip event. A client is expected to accumulate the data
        /// in all events within the frame before proceeding.
        /// All zwp_tablet_pad_strip_v2 events before a zwp_tablet_pad_strip_v2.frame event belong
        /// logically together. For example, on termination of a finger interaction
        /// on a strip the compositor will send a zwp_tablet_pad_strip_v2.source event,
        /// a zwp_tablet_pad_strip_v2.stop event and a zwp_tablet_pad_strip_v2.frame
        /// event.
        /// A zwp_tablet_pad_strip_v2.frame event is sent for every logical event
        /// group, even if the group only contains a single zwp_tablet_pad_strip_v2
        /// event. Specifically, a client may get a sequence: position, frame,
        /// position, frame, etc.
        case frame(time: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.source(source: try r.`enum`(Source.self))
            case 1:
                self = Self.position(position: r.uint())
            case 2:
                self = Self.stop
            case 3:
                self = Self.frame(time: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Set Of Buttons, Rings And Strips
/// 
/// A pad group describes a distinct (sub)set of buttons, rings and strips
/// present in the tablet. The criteria of this grouping is usually positional,
/// eg. if a tablet has buttons on the left and right side, 2 groups will be
/// presented. The physical arrangement of groups is undisclosed and may
/// change on the fly.
/// Pad groups will announce their features during pad initialization. Between
/// the corresponding zwp_tablet_pad_v2.group event and zwp_tablet_pad_group_v2.done, the
/// pad group will announce the buttons, rings and strips contained in it,
/// plus the number of supported modes.
/// Modes are a mechanism to allow multiple groups of actions for every element
/// in the pad group. The number of groups and available modes in each is
/// persistent across device plugs. The current mode is user-switchable, it
/// will be announced through the zwp_tablet_pad_group_v2.mode_switch event both
/// whenever it is switched, and after zwp_tablet_pad_v2.enter.
/// The current mode logically applies to all elements in the pad group,
/// although it is at clients' discretion whether to actually perform different
/// actions, and/or issue the respective .set_feedback requests to notify the
/// compositor. See the zwp_tablet_pad_group_v2.mode_switch event for more details.
public final class ZwpTabletPadGroupV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_group_v2",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "buttons",
                    arguments: [
                        Argument(
                            name: "buttons",
                            type: .array,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "ring",
                    arguments: [
                        Argument(
                            name: "ring",
                            type: .newId,
                            interface: "zwp_tablet_pad_ring_v2",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "strip",
                    arguments: [
                        Argument(
                            name: "strip",
                            type: .newId,
                            interface: "zwp_tablet_pad_strip_v2",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "modes",
                    arguments: [
                        Argument(
                            name: "modes",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "mode_switch",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "mode",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "dial",
                    arguments: [
                        Argument(
                            name: "dial",
                            type: .newId,
                            interface: "zwp_tablet_pad_dial_v2",
                        )
                        ,
                    ],
                    since: 2
                )
                ,
            ],
        )
    /// Destroy The Pad Object
    /// 
    /// Destroy the zwp_tablet_pad_group_v2 object. Objects created from this object
    /// are unaffected and should be destroyed separately.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletV2Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Buttons Announced
        /// 
        /// Sent on zwp_tablet_pad_group_v2 initialization to announce the available
        /// buttons in the group. Button indices start at 0, a button may only be
        /// in one group at a time.
        /// This event is first sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event.
        /// Some buttons are reserved by the compositor. These buttons may not be
        /// assigned to any zwp_tablet_pad_group_v2. Compositors may broadcast this
        /// event in the case of changes to the mapping of these reserved buttons.
        /// If the compositor happens to reserve all buttons in a group, this event
        /// will be sent with an empty array.
        case buttons(buttons: UnsafeRawBufferPointer)

        /// Ring Announced
        /// 
        /// Sent on zwp_tablet_pad_group_v2 initialization to announce available rings.
        /// One event is sent for each ring available on this pad group.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event.
        case ring(ring: ZwpTabletPadRingV2)

        /// Strip Announced
        /// 
        /// Sent on zwp_tablet_pad_v2 initialization to announce available strips.
        /// One event is sent for each strip available on this pad group.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event.
        case strip(strip: ZwpTabletPadStripV2)

        /// Mode-Switch Ability Announced
        /// 
        /// Sent on zwp_tablet_pad_group_v2 initialization to announce that the pad
        /// group may switch between modes. A client may use a mode to store a
        /// specific configuration for buttons, rings and strips and use the
        /// zwp_tablet_pad_group_v2.mode_switch event to toggle between these
        /// configurations. Mode indices start at 0.
        /// Switching modes is compositor-dependent. See the
        /// zwp_tablet_pad_group_v2.mode_switch event for more details.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event. This event is only sent when
        /// more than one mode is available.
        case modes(modes: UInt32)

        /// Tablet Group Description Events Sequence Complete
        /// 
        /// This event is sent immediately to signal the end of the initial
        /// burst of descriptive events. A client may consider the static
        /// description of the tablet to be complete and finalize initialization
        /// of the tablet group.
        case done

        /// Mode Switch Event
        /// 
        /// Notification that the mode was switched.
        /// A mode applies to all buttons, rings, strips and dials in a group
        /// simultaneously, but a client is not required to assign different actions
        /// for each mode. For example, a client may have mode-specific button
        /// mappings but map the ring to vertical scrolling in all modes. Mode
        /// indices start at 0.
        /// Switching modes is compositor-dependent. The compositor may provide
        /// visual cues to the user about the mode, e.g. by toggling LEDs on
        /// the tablet device. Mode-switching may be software-controlled or
        /// controlled by one or more physical buttons. For example, on a Wacom
        /// Intuos Pro, the button inside the ring may be assigned to switch
        /// between modes.
        /// The compositor will also send this event after zwp_tablet_pad_v2.enter on
        /// each group in order to notify of the current mode. Groups that only
        /// feature one mode will use mode=0 when emitting this event.
        /// If a button action in the new mode differs from the action in the
        /// previous mode, the client should immediately issue a
        /// zwp_tablet_pad_v2.set_feedback request for each changed button.
        /// If a ring, strip or dial action in the new mode differs from the action
        /// in the previous mode, the client should immediately issue a
        /// zwp_tablet_ring_v2.set_feedback, zwp_tablet_strip_v2.set_feedback or
        /// zwp_tablet_dial_v2.set_feedback request for each changed ring, strip or dial.
        case modeSwitch(time: UInt32, serial: UInt32, mode: UInt32)

        /// Dial Announced
        /// 
        /// Sent on zwp_tablet_pad_v2 initialization to announce available dials.
        /// One event is sent for each dial available on this pad group.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_group_v2.done event.
        case dial(dial: ZwpTabletPadDialV2)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.buttons(buttons: r.array())
            case 1:
                self = Self.ring(ring: r.newId(type: ZwpTabletPadRingV2.self))
            case 2:
                self = Self.strip(strip: r.newId(type: ZwpTabletPadStripV2.self))
            case 3:
                self = Self.modes(modes: r.uint())
            case 4:
                self = Self.done
            case 5:
                self = Self.modeSwitch(time: r.uint(), serial: r.uint(), mode: r.uint())
            case 6:
                self = Self.dial(dial: r.newId(type: ZwpTabletPadDialV2.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Set Of Buttons, Rings, Strips And Dials
/// 
/// A pad device is a set of buttons, rings, strips and dials
/// usually physically present on the tablet device itself. Some
/// exceptions exist where the pad device is physically detached, e.g. the
/// Wacom ExpressKey Remote.
/// Pad devices have no axes that control the cursor and are generally
/// auxiliary devices to the tool devices used on the tablet surface.
/// A pad device has a number of static characteristics, e.g. the number
/// of rings. These capabilities are sent in an event sequence after the
/// zwp_tablet_seat_v2.pad_added event before any actual events from this pad.
/// This initial event sequence is terminated by a zwp_tablet_pad_v2.done
/// event.
/// All pad features (buttons, rings, strips and dials) are logically divided into
/// groups and all pads have at least one group. The available groups are
/// notified through the zwp_tablet_pad_v2.group event; the compositor will
/// emit one event per group before emitting zwp_tablet_pad_v2.done.
/// Groups may have multiple modes. Modes allow clients to map multiple
/// actions to a single pad feature. Only one mode can be active per group,
/// although different groups may have different active modes.
public final class ZwpTabletPadV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_v2",
            version: 2,
            requests: [
                Message(
                    name: "set_feedback",
                    arguments: [
                        Argument(
                            name: "button",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "description",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "group",
                    arguments: [
                        Argument(
                            name: "pad_group",
                            type: .newId,
                            interface: "zwp_tablet_pad_group_v2",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "path",
                    arguments: [
                        Argument(
                            name: "path",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "buttons",
                    arguments: [
                        Argument(
                            name: "buttons",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "button",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "button",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "enter",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tablet",
                            type: .object,
                            interface: "zwp_tablet_v2",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "leave",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "removed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Set Compositor Feedback
    /// 
    /// Requests the compositor to use the provided feedback string
    /// associated with this button. This request should be issued immediately
    /// after a zwp_tablet_pad_group_v2.mode_switch event from the corresponding
    /// group is received, or whenever a button is mapped to a different
    /// action. See zwp_tablet_pad_group_v2.mode_switch for more details.
    /// Clients are encouraged to provide context-aware descriptions for
    /// the actions associated with each button, and compositors may use
    /// this information to offer visual feedback on the button layout
    /// (e.g. on-screen displays).
    /// Button indices start at 0. Setting the feedback string on a button
    /// that is reserved by the compositor (i.e. not belonging to any
    /// zwp_tablet_pad_group_v2) does not generate an error but the compositor
    /// is free to ignore the request.
    /// The provided string 'description' is a UTF-8 encoded string to be
    /// associated with this ring, and is considered user-visible; general
    /// internationalization rules apply.
    /// The serial argument will be that of the last
    /// zwp_tablet_pad_group_v2.mode_switch event received for the group of this
    /// button. Requests providing other serials than the most recent one will
    /// be ignored.
    /// 
    /// - Parameters:
    ///   - button: button index
    ///   - description: button description
    ///   - serial: serial of the mode switch event
    public func setFeedback(button: UInt32, description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(button),
            .string(description),
            .uint(serial),
        ])
    }

    /// Destroy The Pad Object
    /// 
    /// Destroy the zwp_tablet_pad_v2 object. Objects created from this object
    /// are unaffected and should be destroyed separately.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletV2Protocol
    
    public enum ButtonState: UInt32 {
        /// the button is not pressed
        case released = 0

        /// the button is pressed
        case pressed = 1
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Group Announced
        /// 
        /// Sent on zwp_tablet_pad_v2 initialization to announce available groups.
        /// One event is sent for each pad group available.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_v2.done event. At least one group will be announced.
        case group(padGroup: ZwpTabletPadGroupV2)

        /// Path To The Device
        /// 
        /// A system-specific device path that indicates which device is behind
        /// this zwp_tablet_pad_v2. This information may be used to gather additional
        /// information about the device, e.g. through libwacom.
        /// The format of the path is unspecified, it may be a device node, a
        /// sysfs path, or some other identifier. It is up to the client to
        /// identify the string provided.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_v2.done event.
        case path(path: String)

        /// Buttons Announced
        /// 
        /// Sent on zwp_tablet_pad_v2 initialization to announce the available
        /// buttons.
        /// This event is sent in the initial burst of events before the
        /// zwp_tablet_pad_v2.done event. This event is only sent when at least one
        /// button is available.
        case buttons(buttons: UInt32)

        /// Pad Description Event Sequence Complete
        /// 
        /// This event signals the end of the initial burst of descriptive
        /// events. A client may consider the static description of the pad to
        /// be complete and finalize initialization of the pad.
        case done

        /// Physical Button State
        /// 
        /// Sent whenever the physical state of a button changes.
        case button(time: UInt32, button: UInt32, state: ButtonState)

        /// Enter Event
        /// 
        /// Notification that this pad is focused on the specified surface.
        case enter(serial: UInt32, tablet: ZwpTabletV2, surface: WlSurface)

        /// Leave Event
        /// 
        /// Notification that this pad is no longer focused on the specified
        /// surface.
        case leave(serial: UInt32, surface: WlSurface)

        /// Pad Removed Event
        /// 
        /// Sent when the pad has been removed from the system. When a tablet
        /// is removed its pad(s) will be removed too.
        /// When this event is received, the client must destroy all rings, strips
        /// and groups that were offered by this pad, and issue zwp_tablet_pad_v2.destroy
        /// the pad itself.
        case removed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.group(padGroup: r.newId(type: ZwpTabletPadGroupV2.self))
            case 1:
                self = Self.path(path: r.string())
            case 2:
                self = Self.buttons(buttons: r.uint())
            case 3:
                self = Self.done
            case 4:
                self = Self.button(time: r.uint(), button: r.uint(), state: try r.`enum`(ButtonState.self))
            case 5:
                self = Self.enter(serial: r.uint(), tablet: r.object(type: ZwpTabletV2.self), surface: r.object(type: WlSurface.self))
            case 6:
                self = Self.leave(serial: r.uint(), surface: r.object(type: WlSurface.self))
            case 7:
                self = Self.removed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Pad Dial
/// 
/// A rotary control, e.g. a dial or a wheel.
/// Events on a dial are logically grouped by the zwp_tablet_pad_dial_v2.frame
/// event.
public final class ZwpTabletPadDialV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_tablet_pad_dial_v2",
            version: 2,
            requests: [
                Message(
                    name: "set_feedback",
                    arguments: [
                        Argument(
                            name: "description",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "delta",
                    arguments: [
                        Argument(
                            name: "value120",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "frame",
                    arguments: [
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Set Compositor Feedback
    /// 
    /// Requests the compositor to use the provided feedback string
    /// associated with this dial. This request should be issued immediately
    /// after a zwp_tablet_pad_group_v2.mode_switch event from the corresponding
    /// group is received, or whenever the dial is mapped to a different
    /// action. See zwp_tablet_pad_group_v2.mode_switch for more details.
    /// Clients are encouraged to provide context-aware descriptions for
    /// the actions associated with the dial, and compositors may use this
    /// information to offer visual feedback about the button layout
    /// (eg. on-screen displays).
    /// The provided string 'description' is a UTF-8 encoded string to be
    /// associated with this ring, and is considered user-visible; general
    /// internationalization rules apply.
    /// The serial argument will be that of the last
    /// zwp_tablet_pad_group_v2.mode_switch event received for the group of this
    /// dial. Requests providing other serials than the most recent one will be
    /// ignored.
    /// 
    /// - Parameters:
    ///   - description: dial description
    ///   - serial: serial of the mode switch event
    public func setFeedback(description: String, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(description),
            .uint(serial),
        ])
    }

    /// Destroy The Dial Object
    /// 
    /// This destroys the client's resource for this dial object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = TabletV2Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Delta Movement
        /// 
        /// Sent whenever the position on a dial changes.
        /// This event carries the wheel delta as multiples or fractions
        /// of 120 with each multiple of 120 representing one logical wheel detent.
        /// For example, an axis_value120 of 30 is one quarter of
        /// a logical wheel step in the positive direction, a value120 of
        /// -240 are two logical wheel steps in the negative direction within the
        /// same hardware event. See the wl_pointer.axis_value120 for more details.
        /// The value120 must not be zero.
        case delta(value120: Int32)

        /// End Of A Dial Event Sequence
        /// 
        /// Indicates the end of a set of events that represent one logical
        /// hardware dial event. A client is expected to accumulate the data
        /// in all events within the frame before proceeding.
        /// All zwp_tablet_pad_dial_v2 events before a zwp_tablet_pad_dial_v2.frame event belong
        /// logically together.
        /// A zwp_tablet_pad_dial_v2.frame event is sent for every logical event
        /// group, even if the group only contains a single zwp_tablet_pad_dial_v2
        /// event. Specifically, a client may get a sequence: delta, frame,
        /// delta, frame, etc.
        case frame(time: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.delta(value120: r.int())
            case 1:
                self = Self.frame(time: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let TabletV2Protocol = Protocol(
        name: "tablet_v2",
        interfaces: [
            ZwpTabletManagerV2.interface,
ZwpTabletSeatV2.interface,
ZwpTabletToolV2.interface,
ZwpTabletV2.interface,
ZwpTabletPadRingV2.interface,
ZwpTabletPadStripV2.interface,
ZwpTabletPadGroupV2.interface,
ZwpTabletPadV2.interface,
ZwpTabletPadDialV2.interface
        ]
    )

/// Text Input
/// 
/// An object used for text input. Adds support for text input and input
/// methods to applications. A text_input object is created from a
/// wl_text_input_manager and corresponds typically to a text entry in an
/// application.
/// Requests are used to activate/deactivate the text_input object and set
/// state information like surrounding and selected text or the content type.
/// The information about entered text is sent to the text_input object via
/// the pre-edit and commit events. Using this interface removes the need
/// for applications to directly process hardware key events and compose text
/// out of them.
/// Text is generally UTF-8 encoded, indices and lengths are in bytes.
/// Serials are used to synchronize the state between the text input and
/// an input method. New serials are sent by the text input in the
/// commit_state request and are used by the input method to indicate
/// the known text input state in events like preedit_string, commit_string,
/// and keysym. The text input can then ignore events from the input method
/// which are based on an outdated state (for example after a reset).
/// Warning! The protocol described in this file is experimental and
/// backward incompatible changes may be made. Backward compatible changes
/// may be added together with the corresponding interface version bump.
/// Backward incompatible changes are done by bumping the version number in
/// the protocol and interface names and resetting the interface version.
/// Once the protocol is to be declared stable, the 'z' prefix and the
/// version number in the protocol and interface names are removed and the
/// interface version number is reset.
public final class ZwpTextInputV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_v1",
            version: 1,
            requests: [
                Message(
                    name: "activate",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "deactivate",
                    arguments: [
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "show_input_panel",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "hide_input_panel",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "reset",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_surrounding_text",
                    arguments: [
                        Argument(
                            name: "text",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "cursor",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "anchor",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_content_type",
                    arguments: [
                        Argument(
                            name: "hint",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "purpose",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_cursor_rectangle",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_preferred_language",
                    arguments: [
                        Argument(
                            name: "language",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "commit_state",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "invoke_action",
                    arguments: [
                        Argument(
                            name: "button",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "index",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "enter",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "leave",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "modifiers_map",
                    arguments: [
                        Argument(
                            name: "map",
                            type: .array,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "input_panel_state",
                    arguments: [
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preedit_string",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "text",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "commit",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preedit_styling",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "length",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "style",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preedit_cursor",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "commit_string",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "text",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "cursor_position",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "anchor",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "delete_surrounding_text",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "length",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "keysym",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "time",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "sym",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "modifiers",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "language",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "language",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "text_direction",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "direction",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Request Activation
    /// 
    /// Requests the text_input object to be activated (typically when the
    /// text entry gets focus).
    /// The seat argument is a wl_seat which maintains the focus for this
    /// activation. The surface argument is a wl_surface assigned to the
    /// text_input object and tracked for focus lost. The enter event
    /// is emitted on successful activation.
    /// 
    /// - Parameters:
    public func activate(seat: WlSeat, surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(seat),
            .object(surface),
        ])
    }

    /// Request Deactivation
    /// 
    /// Requests the text_input object to be deactivated (typically when the
    /// text entry lost focus). The seat argument is a wl_seat which was used
    /// for activation.
    /// 
    /// - Parameters:
    public func deactivate(seat: WlSeat) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(seat),
        ])
    }

    /// Show Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to show.
    public func showInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    /// Hide Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to hide.
    public func hideInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    /// Reset
    /// 
    /// Should be called by an editor widget when the input state should be
    /// reset, for example after the text was changed outside of the normal
    /// input method flow.
    public func reset() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    /// Sets The Surrounding Text
    /// 
    /// Sets the plain surrounding text around the input position. Text is
    /// UTF-8 encoded. Cursor is the byte offset within the
    /// surrounding text. Anchor is the byte offset of the
    /// selection anchor within the surrounding text. If there is no selected
    /// text anchor, then it is the same as cursor.
    /// 
    /// - Parameters:
    public func setSurroundingText(text: String, cursor: UInt32, anchor: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .string(text),
            .uint(cursor),
            .uint(anchor),
        ])
    }

    /// Set Content Purpose And Hint
    /// 
    /// Sets the content purpose and content hint. While the purpose is the
    /// basic purpose of an input field, the hint flags allow to modify some
    /// of the behavior.
    /// When no content type is explicitly set, a normal content purpose with
    /// default hints (auto completion, auto correction, auto capitalization)
    /// should be assumed.
    /// 
    /// - Parameters:
    public func setContentType(hint: ContentHint, purpose: ContentPurpose) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .uint(hint.rawValue),
            .uint(purpose.rawValue),
        ])
    }

    /// 
    /// - Parameters:
    public func setCursorRectangle(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
    }

    /// Sets Preferred Language
    /// 
    /// Sets a specific language. This allows for example a virtual keyboard to
    /// show a language specific layout. The "language" argument is an RFC-3066
    /// format language tag.
    /// It could be used for example in a word processor to indicate the
    /// language of the currently edited document or in an instant message
    /// application which tracks languages of contacts.
    /// 
    /// - Parameters:
    public func setPreferredLanguage(language: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .string(language),
        ])
    }

    /// 
    /// - Parameters:
    ///   - serial: used to identify the known state
    public func commitState(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
            .uint(serial),
        ])
    }

    /// 
    /// - Parameters:
    public func invokeAction(button: UInt32, index: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 10, [
            .uint(button),
            .uint(index),
        ])
    }

    
    public static let `protocol`: Protocol = TextInputUnstableV1Protocol
    
    public struct ContentHint: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// no special behaviour
        public static let `none` = ContentHint(rawValue: 0x0)

        /// auto completion, correction and capitalization
        public static let `default` = ContentHint(rawValue: 0x7)

        /// hidden and sensitive text
        public static let password = ContentHint(rawValue: 0xc0)

        /// suggest word completions
        public static let autoCompletion = ContentHint(rawValue: 0x1)

        /// suggest word corrections
        public static let autoCorrection = ContentHint(rawValue: 0x2)

        /// switch to uppercase letters at the start of a sentence
        public static let autoCapitalization = ContentHint(rawValue: 0x4)

        /// prefer lowercase letters
        public static let lowercase = ContentHint(rawValue: 0x8)

        /// prefer uppercase letters
        public static let uppercase = ContentHint(rawValue: 0x10)

        /// prefer casing for titles and headings (can be language dependent)
        public static let titlecase = ContentHint(rawValue: 0x20)

        /// characters should be hidden
        public static let hiddenText = ContentHint(rawValue: 0x40)

        /// typed text should not be stored
        public static let sensitiveData = ContentHint(rawValue: 0x80)

        /// just latin characters should be entered
        public static let latin = ContentHint(rawValue: 0x100)

        /// the text input is multiline
        public static let multiline = ContentHint(rawValue: 0x200)
    }

    public enum ContentPurpose: UInt32 {
        /// default input, allowing all characters
        case normal = 0

        /// allow only alphabetic characters
        case alpha = 1

        /// allow only digits
        case digits = 2

        /// input a number (including decimal separator and sign)
        case number = 3

        /// input a phone number
        case phone = 4

        /// input an URL
        case url = 5

        /// input an email address
        case email = 6

        /// input a name of a person
        case name = 7

        /// input a password (combine with password or sensitive_data hint)
        case password = 8

        /// input a date
        case date = 9

        /// input a time
        case time = 10

        /// input a date and time
        case datetime = 11

        /// input for a terminal
        case terminal = 12
    }

    public enum PreeditStyle: UInt32 {
        /// default style for composing text
        case `default` = 0

        /// style should be the same as in non-composing text
        case `none` = 1

        case active = 2

        case inactive = 3

        case highlight = 4

        case underline = 5

        case selection = 6

        case incorrect = 7
    }

    public enum TextDirection: UInt32 {
        /// automatic text direction based on text and language
        case auto = 0

        /// left-to-right
        case ltr = 1

        /// right-to-left
        case rtl = 2
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Enter Event
        /// 
        /// Notify the text_input object when it received focus. Typically in
        /// response to an activate request.
        case enter(surface: WlSurface)

        /// Leave Event
        /// 
        /// Notify the text_input object when it lost focus. Either in response
        /// to a deactivate request or when the assigned surface lost focus or was
        /// destroyed.
        case leave

        /// Modifiers Map
        /// 
        /// Transfer an array of 0-terminated modifier names. The position in
        /// the array is the index of the modifier as used in the modifiers
        /// bitmask in the keysym event.
        case modifiersMap(map: UnsafeRawBufferPointer)

        /// State Of The Input Panel
        /// 
        /// Notify when the visibility state of the input panel changed.
        case inputPanelState(state: UInt32)

        /// Pre-Edit
        /// 
        /// Notify when a new composing text (pre-edit) should be set around the
        /// current cursor position. Any previously set composing text should
        /// be removed.
        /// The commit text can be used to replace the preedit text on reset
        /// (for example on unfocus).
        /// The text input should also handle all preedit_style and preedit_cursor
        /// events occurring directly before preedit_string.
        case preeditString(serial: UInt32, text: String, commit: String)

        /// Pre-Edit Styling
        /// 
        /// Sets styling information on composing text. The style is applied for
        /// length bytes from index relative to the beginning of the composing
        /// text (as byte offset). Multiple styles can
        /// be applied to a composing text by sending multiple preedit_styling
        /// events.
        /// This event is handled as part of a following preedit_string event.
        case preeditStyling(index: UInt32, length: UInt32, style: PreeditStyle)

        /// Pre-Edit Cursor
        /// 
        /// Sets the cursor position inside the composing text (as byte
        /// offset) relative to the start of the composing text. When index is a
        /// negative number no cursor is shown.
        /// This event is handled as part of a following preedit_string event.
        case preeditCursor(index: Int32)

        /// Commit
        /// 
        /// Notify when text should be inserted into the editor widget. The text to
        /// commit could be either just a single character after a key press or the
        /// result of some composing (pre-edit). It could also be an empty text
        /// when some text should be removed (see delete_surrounding_text) or when
        /// the input cursor should be moved (see cursor_position).
        /// Any previously set composing text should be removed.
        case commitString(serial: UInt32, text: String)

        /// Set Cursor To New Position
        /// 
        /// Notify when the cursor or anchor position should be modified.
        /// This event should be handled as part of a following commit_string
        /// event.
        case cursorPosition(index: Int32, anchor: Int32)

        /// Delete Surrounding Text
        /// 
        /// Notify when the text around the current cursor position should be
        /// deleted.
        /// Index is relative to the current cursor (in bytes).
        /// Length is the length of deleted text (in bytes).
        /// This event should be handled as part of a following commit_string
        /// event.
        case deleteSurroundingText(index: Int32, length: UInt32)

        /// Keysym
        /// 
        /// Notify when a key event was sent. Key events should not be used
        /// for normal text input operations, which should be done with
        /// commit_string, delete_surrounding_text, etc. The key event follows
        /// the wl_keyboard key event convention. Sym is an XKB keysym, state a
        /// wl_keyboard key_state. Modifiers are a mask for effective modifiers
        /// (where the modifier indices are set by the modifiers_map event)
        case keysym(serial: UInt32, time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32)

        /// Language
        /// 
        /// Sets the language of the input text. The "language" argument is an
        /// RFC-3066 format language tag.
        case language(serial: UInt32, language: String)

        /// Text Direction
        /// 
        /// Sets the text direction of input text.
        /// It is mainly needed for showing an input cursor on the correct side of
        /// the editor when there is no input done yet and making sure neutral
        /// direction text is laid out properly.
        case textDirection(serial: UInt32, direction: TextDirection)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.enter(surface: r.object(type: WlSurface.self))
            case 1:
                self = Self.leave
            case 2:
                self = Self.modifiersMap(map: r.array())
            case 3:
                self = Self.inputPanelState(state: r.uint())
            case 4:
                self = Self.preeditString(serial: r.uint(), text: r.string(), commit: r.string())
            case 5:
                self = Self.preeditStyling(index: r.uint(), length: r.uint(), style: try r.`enum`(PreeditStyle.self))
            case 6:
                self = Self.preeditCursor(index: r.int())
            case 7:
                self = Self.commitString(serial: r.uint(), text: r.string())
            case 8:
                self = Self.cursorPosition(index: r.int(), anchor: r.int())
            case 9:
                self = Self.deleteSurroundingText(index: r.int(), length: r.uint())
            case 10:
                self = Self.keysym(serial: r.uint(), time: r.uint(), sym: r.uint(), state: r.uint(), modifiers: r.uint())
            case 11:
                self = Self.language(serial: r.uint(), language: r.string())
            case 12:
                self = Self.textDirection(serial: r.uint(), direction: try r.`enum`(TextDirection.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Text Input Manager
/// 
/// A factory for text_input objects. This object is a global singleton.
public final class ZwpTextInputManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "create_text_input",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_text_input_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Create Text Input
    /// 
    /// Creates a new text_input object.
    public func createTextInput(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpTextInputV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 0, ZwpTextInputV1.self, version, _queue, [
            .newId,
        ])
        return id
    }

    
    public static let `protocol`: Protocol = TextInputUnstableV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let TextInputUnstableV1Protocol = Protocol(
        name: "text_input_unstable_v1",
        interfaces: [
            ZwpTextInputV1.interface,
ZwpTextInputManagerV1.interface
        ]
    )

/// Text Input
/// 
/// The zwp_text_input_v3 interface represents text input and input methods
/// associated with a seat. It provides enter/leave events to follow the
/// text input focus for a seat.
/// Requests are used to enable/disable the text-input object and set
/// state information like surrounding and selected text or the content type.
/// The information about the entered text is sent to the text-input object
/// via the preedit_string and commit_string events.
/// Text is valid UTF-8 encoded, indices and lengths are in bytes. Indices
/// must not point to middle bytes inside a code point: they must either
/// point to the first byte of a code point or to the end of the buffer.
/// Lengths must be measured between two valid indices.
/// Focus moving throughout surfaces will result in the emission of
/// zwp_text_input_v3.enter and zwp_text_input_v3.leave events. The focused
/// surface must commit zwp_text_input_v3.enable and
/// zwp_text_input_v3.disable requests as the keyboard focus moves across
/// editable and non-editable elements of the UI. Those two requests are not
/// expected to be paired with each other, the compositor must be able to
/// handle consecutive series of the same request.
/// State is sent by the state requests (set_surrounding_text,
/// set_content_type and set_cursor_rectangle) and a commit request. After an
/// enter event or disable request all state information is invalidated and
/// needs to be resent by the client.
public final class ZwpTextInputV3: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_v3",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "enable",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "disable",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_surrounding_text",
                    arguments: [
                        Argument(
                            name: "text",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "cursor",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "anchor",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_text_change_cause",
                    arguments: [
                        Argument(
                            name: "cause",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_content_type",
                    arguments: [
                        Argument(
                            name: "hint",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "purpose",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_cursor_rectangle",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "commit",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_available_actions",
                    arguments: [
                        Argument(
                            name: "available_actions",
                            type: .array,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "show_input_panel",
                    arguments: [
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "hide_input_panel",
                    arguments: [
                    ],
                    since: 2
                )
                ,
            ],
            events: [
                Message(
                    name: "enter",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "leave",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preedit_string",
                    arguments: [
                        Argument(
                            name: "text",
                            type: .string,
                            nullable: true,
                        )
                        ,
                        Argument(
                            name: "cursor_begin",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "cursor_end",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "commit_string",
                    arguments: [
                        Argument(
                            name: "text",
                            type: .string,
                            nullable: true,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "delete_surrounding_text",
                    arguments: [
                        Argument(
                            name: "before_length",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "after_length",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "action",
                    arguments: [
                        Argument(
                            name: "action",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "language",
                    arguments: [
                        Argument(
                            name: "language",
                            type: .string,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "preedit_hint",
                    arguments: [
                        Argument(
                            name: "start",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "end",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "hint",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
            ],
        )
    /// Destroy The Wp_Text_Input
    /// 
    /// Destroy the wp_text_input object. Also disables all surfaces enabled
    /// through this wp_text_input object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Request Text Input To Be Enabled
    /// 
    /// Requests text input on the surface previously obtained from the enter
    /// event.
    /// This request must be issued every time the focused text input changes
    /// to a new one, including within the current surface. Use
    /// zwp_text_input_v3.disable when there is no longer any input focus on
    /// the current surface.
    /// Clients must not enable more than one text input on the single seat
    /// and should disable the current text input before enabling the new one.
    /// Requests to enable a text input when another text input is enabled
    /// on the same seat must be ignored by compositor.
    /// This request resets all state associated with previous enable, disable,
    /// set_surrounding_text, set_text_change_cause, set_content_type, and
    /// set_cursor_rectangle requests, as well as the state associated with
    /// preedit_string, commit_string, and delete_surrounding_text events.
    /// The set_surrounding_text, set_content_type and set_cursor_rectangle
    /// requests must follow if the text input supports the necessary
    /// functionality.
    /// State set with this request is double-buffered. It will get applied on
    /// the next zwp_text_input_v3.commit request, and stay valid until the
    /// next committed enable or disable request.
    /// The changes must be applied by the compositor after issuing a
    /// zwp_text_input_v3.commit request.
    public func enable() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Disable Text Input On A Surface
    /// 
    /// Explicitly disable text input on the current surface (typically when
    /// there is no focus on any text entry inside the surface).
    /// State set with this request is double-buffered. It will get applied on
    /// the next zwp_text_input_v3.commit request.
    public func disable() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    /// Sets The Surrounding Text
    /// 
    /// Sets the surrounding plain text around the input, excluding the preedit
    /// text.
    /// The client should notify the compositor of any changes in any of the
    /// values carried with this request, including changes caused by handling
    /// incoming text-input events as well as changes caused by other
    /// mechanisms like keyboard typing.
    /// If the client is unaware of the text around the cursor, it should not
    /// issue this request, to signify lack of support to the compositor.
    /// Text is UTF-8 encoded, and should include the cursor position, the
    /// complete selection and additional characters before and after them.
    /// There is a maximum length of wayland messages, so text can not be
    /// longer than 4000 bytes.
    /// Cursor is the byte offset of the cursor within text buffer.
    /// Anchor is the byte offset of the selection anchor within text buffer.
    /// If there is no selected text, anchor is the same as cursor.
    /// If any preedit text is present, it is replaced with a cursor for the
    /// purpose of this event.
    /// Values set with this request are double-buffered. They will get applied
    /// on the next zwp_text_input_v3.commit request, and stay valid until the
    /// next committed enable or disable request.
    /// The initial state for affected fields is empty, meaning that the text
    /// input does not support sending surrounding text. If the empty values
    /// get applied, subsequent attempts to change them may have no effect.
    /// 
    /// - Parameters:
    public func setSurroundingText(text: String, cursor: Int32, anchor: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .string(text),
            .int(cursor),
            .int(anchor),
        ])
    }

    /// Indicates The Cause Of Surrounding Text Change
    /// 
    /// Tells the compositor why the text surrounding the cursor changed.
    /// Whenever the client detects an external change in text, cursor, or
    /// anchor posision, it must issue this request to the compositor. This
    /// request is intended to give the input method a chance to update the
    /// preedit text in an appropriate way, e.g. by removing it when the user
    /// starts typing with a keyboard.
    /// cause describes the source of the change.
    /// The value set with this request is double-buffered. It must be applied
    /// and reset to initial at the next zwp_text_input_v3.commit request.
    /// The initial value of cause is input_method.
    /// 
    /// - Parameters:
    public func setTextChangeCause(cause: ChangeCause) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(cause.rawValue),
        ])
    }

    /// Set Content Purpose And Hint
    /// 
    /// Sets the content purpose and content hint. While the purpose is the
    /// basic purpose of an input field, the hint flags allow to modify some of
    /// the behavior.
    /// Values set with this request are double-buffered. They will get applied
    /// on the next zwp_text_input_v3.commit request.
    /// Subsequent attempts to update them may have no effect. The values
    /// remain valid until the next committed enable or disable request.
    /// The initial value for hint is none, and the initial value for purpose
    /// is normal.
    /// 
    /// - Parameters:
    public func setContentType(hint: ContentHint, purpose: ContentPurpose) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .uint(hint.rawValue),
            .uint(purpose.rawValue),
        ])
    }

    /// Set Cursor Position
    /// 
    /// Marks an area around the cursor as a x, y, width, height rectangle in
    /// surface local coordinates.
    /// Allows the compositor to put a window with word suggestions near the
    /// cursor, without obstructing the text being input.
    /// If the client is unaware of the position of edited text, it should not
    /// issue this request, to signify lack of support to the compositor.
    /// Values set with this request are double-buffered. They will get applied
    /// on the next zwp_text_input_v3.commit request, and stay valid until the
    /// next committed enable or disable request.
    /// The initial values describing a cursor rectangle are empty. That means
    /// the text input does not support describing the cursor area. If the
    /// empty values get applied, subsequent attempts to change them may have
    /// no effect.
    /// As of version 2, the zwp_text_input_v3.commit request does not apply
    /// values sent with this request. Instead, it stores them in a separate
    /// "committed" area. The committed values, if still valid, get applied on
    /// the next wl_surface.commit request on the surface with text-input focus.
    /// Both committed and applied values get invalidated on:
    /// - the next committed enable or disable request, or
    /// - a change of the focused surface of the text-input (leave or enter events).
    /// This double stage application allows the compositor to position
    /// the input method popup in the same frame as the contents
    /// of the text on the surface are updated.
    /// 
    /// - Parameters:
    public func setCursorRectangle(x: Int32, y: Int32, width: Int32, height: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .int(x),
            .int(y),
            .int(width),
            .int(height),
        ])
    }

    /// Commit State
    /// 
    /// Atomically applies state changes recently sent to the compositor.
    /// The commit request establishes and updates the state of the client, and
    /// must be issued after any changes to apply them.
    /// Text input state (enabled status, content purpose, content hint,
    /// surrounding text and change cause, cursor rectangle) is conceptually
    /// double-buffered within the context of a text input, i.e. between a
    /// committed enable request and the following committed enable or disable
    /// request.
    /// Protocol requests modify the pending state, as opposed to the current
    /// state in use by the input method. A commit request atomically applies
    /// all pending state, replacing the current state. After commit, the new
    /// pending state is as documented for each related request.
    /// Requests are applied in the order of arrival.
    /// Neither current nor pending state are modified unless noted otherwise.
    /// The compositor must count the number of commit requests coming from
    /// each zwp_text_input_v3 object and use the count as the serial in done
    /// events.
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
        ])
    }

    /// Set The Available Actions
    /// 
    /// Set the actions available for this text input.
    /// Values set with this request are double-buffered. They will get applied
    /// on the next zwp_text_input_v3.commit request.
    /// If the available_actions array contains the none action, or contains the
    /// same action multiple times, the compositor must raise the invalid_action
    /// protocol error.
    /// Initially, no actions are available.
    /// 
    /// - Parameters:
    ///   - _: available actions
    public func setAvailableActions(_ availableActions: UnsafeRawBufferPointer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 8, [
            .array(availableActions),
        ])
    }

    /// Show Input Panel
    /// 
    /// Requests an input panel to be shown (e.g. a on-screen keyboard).
    /// This request only hints the desired interaction pattern from the
    /// client side, and its effect may be ignored by compositors given
    /// other environmental factors. Repeated calls will be ignored.
    public func showInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 9, [
        ])
    }

    /// Hide Input Panel
    /// 
    /// Requests an input panel to be hidden.
    /// This request only hints the desired interaction pattern from the
    /// client side, and its effect may be ignored by compositors given
    /// other environmental factors. Repeated calls will be ignored.
    public func hideInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 10, [
        ])
    }

    
    public static let `protocol`: Protocol = TextInputUnstableV3Protocol
    
    public enum ChangeCause: UInt32 {
        /// input method caused the change
        case inputMethod = 0

        /// something else than the input method caused the change
        case other = 1
    }

    public struct ContentHint: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// no special behavior
        public static let `none` = ContentHint(rawValue: 0x0)

        /// suggest word completions
        public static let completion = ContentHint(rawValue: 0x1)

        /// suggest word corrections
        public static let spellcheck = ContentHint(rawValue: 0x2)

        /// switch to uppercase letters at the start of a sentence
        public static let autoCapitalization = ContentHint(rawValue: 0x4)

        /// prefer lowercase letters
        public static let lowercase = ContentHint(rawValue: 0x8)

        /// prefer uppercase letters
        public static let uppercase = ContentHint(rawValue: 0x10)

        /// prefer casing for titles and headings (can be language dependent)
        public static let titlecase = ContentHint(rawValue: 0x20)

        /// characters should be hidden
        public static let hiddenText = ContentHint(rawValue: 0x40)

        /// typed text should not be stored
        public static let sensitiveData = ContentHint(rawValue: 0x80)

        /// just Latin characters should be entered
        public static let latin = ContentHint(rawValue: 0x100)

        /// the text input is multiline
        public static let multiline = ContentHint(rawValue: 0x200)

        /// an on-screen way to fill in the input is already provided by the client
        public static let onScreenInputProvided = ContentHint(rawValue: 0x400)

        /// prefer not offering emoji support
        public static let noEmoji = ContentHint(rawValue: 0x800)

        /// the text input will display preedit text in place
        public static let preeditShown = ContentHint(rawValue: 0x1000)
    }

    public enum ContentPurpose: UInt32 {
        /// default input, allowing all characters
        case normal = 0

        /// allow only alphabetic characters
        case alpha = 1

        /// allow only digits
        case digits = 2

        /// input a number (including decimal separator and sign)
        case number = 3

        /// input a phone number
        case phone = 4

        /// input an URL
        case url = 5

        /// input an email address
        case email = 6

        /// input a name of a person
        case name = 7

        /// input a password (combine with sensitive_data hint)
        case password = 8

        /// input is a numeric password (combine with sensitive_data hint)
        case pin = 9

        /// input a date
        case date = 10

        /// input a time
        case time = 11

        /// input a date and time
        case datetime = 12

        /// input for a terminal
        case terminal = 13
    }

    public enum Error: UInt32 {
        /// an invalid or duplicate action was specified
        case invalidAction = 0
    }

    public enum Action: UInt32 {
        /// no action
        case `none` = 0

        /// the action is submitted
        case submit = 1
    }

    public enum PreeditHint: UInt32 {
        /// simple pre-edit text style, typically underlined
        case whole = 1

        /// hint for a selected piece of text, e.g. per-character navigation and composition
        case selection = 2

        /// predicted text, not typed by the user
        case prediction = 3

        /// prefixed text not being currently edited, e.g. prior to a 'selection' section
        case `prefix` = 4

        /// suffixed text not being currently edited, e.g. after a 'selection' section
        case suffix = 5

        /// spelling error
        case spellingError = 6

        /// wrong composition, e.g. user input that can not be transliterated
        case composeError = 7
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Enter Event
        /// 
        /// Notification that this seat's text-input focus is on a certain surface.
        /// If client has created multiple text input objects, compositor must send
        /// this event to all of them.
        /// When the seat has the keyboard capability the text-input focus follows
        /// the keyboard focus. This event sets the current surface for the
        /// text-input object.
        case enter(surface: WlSurface)

        /// Leave Event
        /// 
        /// Notification that this seat's text-input focus is no longer on a
        /// certain surface. The client should reset any preedit string previously
        /// set.
        /// The leave notification clears the current surface. It is sent before
        /// the enter notification for the new focus. After leave event, compositor
        /// must ignore requests from any text input instances until next enter
        /// event.
        /// When the seat has the keyboard capability the text-input focus follows
        /// the keyboard focus.
        case leave(surface: WlSurface)

        /// Pre-Edit
        /// 
        /// Notify when a new composing text (pre-edit) should be set at the
        /// current cursor position. Any previously set composing text must be
        /// removed. Any previously existing selected text must be removed.
        /// The argument text contains the pre-edit string buffer.
        /// The parameters cursor_begin and cursor_end are counted in bytes
        /// relative to the beginning of the submitted text buffer. Cursor should
        /// be hidden when both are equal to -1.
        /// They could be represented by the client as a line if both values are
        /// the same, or as a text highlight otherwise.
        /// Values set with this event are double-buffered. They must be applied
        /// and reset to initial on the next zwp_text_input_v3.done event.
        /// The initial value of text is an empty string, and cursor_begin,
        /// cursor_end and cursor_hidden are all 0.
        case preeditString(text: String, cursorBegin: Int32, cursorEnd: Int32)

        /// Text Commit
        /// 
        /// Notify when text should be inserted into the editor widget. The text to
        /// commit could be either just a single character after a key press or the
        /// result of some composing (pre-edit).
        /// Values set with this event are double-buffered. They must be applied
        /// and reset to initial on the next zwp_text_input_v3.done event.
        /// The initial value of text is an empty string.
        case commitString(text: String)

        /// Delete Surrounding Text
        /// 
        /// Notify when the text around the current cursor position should be
        /// deleted.
        /// Before_length and after_length are the number of bytes before and after
        /// the current cursor index (excluding the selection) to delete.
        /// If a preedit text is present, in effect before_length is counted from
        /// the beginning of it, and after_length from its end (see done event
        /// sequence).
        /// Values set with this event are double-buffered. They must be applied
        /// and reset to initial on the next zwp_text_input_v3.done event.
        /// The initial values of both before_length and after_length are 0.
        case deleteSurroundingText(beforeLength: UInt32, afterLength: UInt32)

        /// Apply Changes
        /// 
        /// Instruct the application to apply changes to state requested by the
        /// preedit_string, commit_string delete_surrounding_text, and action
        /// events.
        /// The state relating to these events is double-buffered, and each one
        /// modifies the pending state. This event replaces the current state with
        /// the pending state.
        /// The application must proceed by evaluating the changes in the following
        /// order:
        /// 1. Replace existing preedit string with the cursor.
        /// 2. Delete requested surrounding text.
        /// 3. Insert commit string with the cursor at its end.
        /// 4. Calculate surrounding text to send.
        /// 5. Insert new preedit text in cursor position.
        /// 6. Place cursor inside preedit text.
        /// 7. Perform the requested action.
        /// The serial number reflects the last state of the zwp_text_input_v3
        /// object known to the compositor. The value of the serial argument must
        /// be equal to the number of commit requests already issued on that object.
        /// When the client receives a done event with a serial different than the
        /// number of past commit requests, it must proceed with evaluating and
        /// applying the changes as normal, except it should not change the current
        /// state of the zwp_text_input_v3 object. All pending state requests
        /// (set_surrounding_text, set_content_type and set_cursor_rectangle) on
        /// the zwp_text_input_v3 object should be sent and committed after
        /// receiving a zwp_text_input_v3.done event with a matching serial.
        case done(serial: UInt32)

        /// Action Performed
        /// 
        /// An action was performed on this text input.
        /// Values set with this event are double-buffered. They must be applied
        /// and reset to initial on the next zwp_text_input_v3.done event.
        /// The initial value of action is none.
        case action(action: Action, serial: UInt32)

        /// Notify Of Language Selection
        /// 
        /// Notify the application of language used by the input method.
        /// This event will be sent on creation if known and for all subsequent changes.
        /// The language should be specified as an IETF BCP 47 tag.
        /// Setting an empty string will reset any known language back to the default unknown state.
        case language(language: String)

        /// Pre-Edit
        /// 
        /// Notify of contextual hints for the pre-edit string. This
        /// event is always sent together with a zwp_text_input_v3.preedit_string
        /// event.
        /// The parameters start and end are counted in bytes relative to the
        /// beginning of the text buffer submitted through
        /// zwp_text_input_v3.preedit_string, and represent the substring in the
        /// pre-edit text affected by the hint.
        /// Multiple events may be submitted if the preedit string has different
        /// sections. The extent of hints may overlap. The parts of the preedit
        /// string that are not covered by any zwp_text_input_v3.preedit_hint event,
        /// the text will be considered unhinted. This is also the case if no
        /// preedit_hint event is sent.
        /// Clients should provide recognizable visuals to these hints. if they are
        /// unable to comply with this requisition, it may be preferable for them
        /// keep the preedit_shown content hint disabled.
        /// Values set with this event are double-buffered. They must be applied
        /// and reset on the next zwp_text_input_v3.done event.
        case preeditHint(start: UInt32, end: UInt32, hint: PreeditHint)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.enter(surface: r.object(type: WlSurface.self))
            case 1:
                self = Self.leave(surface: r.object(type: WlSurface.self))
            case 2:
                self = Self.preeditString(text: r.string(), cursorBegin: r.int(), cursorEnd: r.int())
            case 3:
                self = Self.commitString(text: r.string())
            case 4:
                self = Self.deleteSurroundingText(beforeLength: r.uint(), afterLength: r.uint())
            case 5:
                self = Self.done(serial: r.uint())
            case 6:
                self = Self.action(action: try r.`enum`(Action.self), serial: r.uint())
            case 7:
                self = Self.language(language: r.string())
            case 8:
                self = Self.preeditHint(start: r.uint(), end: r.uint(), hint: try r.`enum`(PreeditHint.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Text Input Manager
/// 
/// A factory for text-input objects. This object is a global singleton.
public final class ZwpTextInputManagerV3: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_manager_v3",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_text_input",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_text_input_v3",
                        )
                        ,
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Wp_Text_Input_Manager
    /// 
    /// Destroy the wp_text_input_manager object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Create A New Text Input Object
    /// 
    /// Creates a new text-input object for a given seat.
    /// 
    /// - Parameters:
    public func getTextInput(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpTextInputV3 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ZwpTextInputV3.self, version, _queue, [
            .newId,
            .object(seat),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = TextInputUnstableV3Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let TextInputUnstableV3Protocol = Protocol(
        name: "text_input_unstable_v3",
        interfaces: [
            ZwpTextInputV3.interface,
ZwpTextInputManagerV3.interface
        ]
    )

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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_viewport",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_viewport",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Unbind From The Cropping And Scaling Interface
    /// 
    /// Informs the server that the client will not be using this
    /// protocol object anymore. This does not affect any other objects,
    /// wp_viewport objects included.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
        let id = connection.sendConstructor(self, 1, WpViewport.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = ViewporterProtocol
    
    public enum Error: UInt32 {
        /// the surface already has a viewport object associated
        case viewportExists = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_source",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_destination",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Remove Scaling And Cropping From The Surface
    /// 
    /// The associated wl_surface's crop and scale state is removed.
    /// The change is applied on the next wl_surface.commit.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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

    
    public static let `protocol`: Protocol = ViewporterProtocol
    
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

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let ViewporterProtocol = Protocol(
        name: "viewporter",
        interfaces: [
            WpViewporter.interface,
WpViewport.interface
        ]
    )

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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "create_listener",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_security_context_v1",
                        )
                        ,
                        Argument(
                            name: "listen_fd",
                            type: .fd,
                        )
                        ,
                        Argument(
                            name: "close_fd",
                            type: .fd,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Manager Object
    /// 
    /// Destroy the manager. This doesn't destroy objects created with the
    /// manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
        let id = connection.sendConstructor(self, 1, WpSecurityContextV1.self, version, _queue, [
            .newId,
            .fd(listenFd),
            .fd(closeFd),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = SecurityContextV1Protocol
    
    public enum Error: UInt32 {
        /// listening socket FD is invalid
        case invalidListenFd = 1

        /// nested security contexts are forbidden
        case nested = 2
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
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
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_sandbox_engine",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_app_id",
                    arguments: [
                        Argument(
                            name: "app_id",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_instance_id",
                    arguments: [
                        Argument(
                            name: "instance_id",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "commit",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Security Context Object
    /// 
    /// Destroy the security context object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
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
    ///   - _: the application ID
    public func setAppId(_ appId: String) throws(WaylandProxyError) {
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
    ///   - _: the instance ID
    public func setInstanceId(_ instanceId: String) throws(WaylandProxyError) {
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

    
    public static let `protocol`: Protocol = SecurityContextV1Protocol
    
    public enum Error: UInt32 {
        /// security context has already been committed
        case alreadyUsed = 1

        /// metadata has already been set
        case alreadySet = 2

        /// metadata is invalid
        case invalidMetadata = 3
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let SecurityContextV1Protocol = Protocol(
        name: "security_context_v1",
        interfaces: [
            WpSecurityContextManagerV1.interface,
WpSecurityContextV1.interface
        ]
    )

/// Surface Alpha Modifier Manager
/// 
/// This interface allows a client to set a factor for the alpha values on a
/// surface, which can be used to offload such operations to the compositor,
/// which can in turn for example offload them to KMS.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpAlphaModifierV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_alpha_modifier_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_alpha_modifier_surface_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Alpha Modifier Manager Object
    /// 
    /// Destroy the alpha modifier manager. This doesn't destroy objects
    /// created with the manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Create A New Alpha Modifier Surface Object
    /// 
    /// Create a new alpha modifier surface object associated with the
    /// given wl_surface. If there is already such an object associated with
    /// the wl_surface, the already_constructed error will be raised.
    /// 
    /// - Parameters:
    public func getSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpAlphaModifierSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, WpAlphaModifierSurfaceV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = AlphaModifierV1Protocol
    
    public enum Error: UInt32 {
        /// wl_surface already has a alpha modifier object
        case alreadyConstructed = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Alpha Modifier Object For A Surface
/// 
/// This interface allows the client to set a factor for the alpha values on
/// a surface, which can be used to offload such operations to the compositor.
/// The default factor is UINT32_MAX.
/// This object has to be destroyed before the associated wl_surface. Once the
/// wl_surface is destroyed, all request on this object will raise the
/// no_surface error.
public final class WpAlphaModifierSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_alpha_modifier_surface_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_multiplier",
                    arguments: [
                        Argument(
                            name: "factor",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Alpha Modifier Object
    /// 
    /// This destroys the object, and is equivalent to set_multiplier with
    /// a value of UINT32_MAX, with the same double-buffered semantics as
    /// set_multiplier.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Specify The Alpha Multiplier
    /// 
    /// Sets the alpha multiplier for the surface. The alpha multiplier is
    /// double-buffered state, see wl_surface.commit for details.
    /// This factor is applied in the compositor's blending space, as an
    /// additional step after the processing of per-pixel alpha values for the
    /// wl_surface. The exact meaning of the factor is thus undefined, unless
    /// the blending space is specified in a different extension.
    /// This multiplier is applied even if the buffer attached to the
    /// wl_surface doesn't have an alpha channel; in that case an alpha value
    /// of one is used instead.
    /// Zero means completely transparent, UINT32_MAX means completely opaque.
    /// 
    /// - Parameters:
    public func setMultiplier(factor: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(factor),
        ])
    }

    
    public static let `protocol`: Protocol = AlphaModifierV1Protocol
    
    public enum Error: UInt32 {
        /// wl_surface was destroyed
        case noSurface = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let AlphaModifierV1Protocol = Protocol(
        name: "alpha_modifier_v1",
        interfaces: [
            WpAlphaModifierV1.interface,
WpAlphaModifierSurfaceV1.interface
        ]
    )

/// Protocol For Fifo Constraints
/// 
/// When a Wayland compositor considers applying a content update,
/// it must ensure all the update's readiness constraints (fences, etc)
/// are met.
/// This protocol provides a way to use the completion of a display refresh
/// cycle as an additional readiness constraint.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpFifoManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_fifo_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_fifo",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_fifo_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Unbind From The Manager Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object. Existing objects created by this object
    /// are not affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Request Fifo Interface For Surface
    /// 
    /// Establish a fifo object for a surface that may be used to add
    /// display refresh constraints to content updates.
    /// Only one such object may exist for a surface and attempting
    /// to create more than one will result in an already_exists
    /// protocol error. If a surface is acted on by multiple software
    /// components, general best practice is that only the component
    /// performing wl_surface.attach operations should use this protocol.
    /// 
    /// - Parameters:
    public func getFifo(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpFifoV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, WpFifoV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = FifoV1Protocol
    
    public enum Error: UInt32 {
        /// fifo manager already exists for surface
        case alreadyExists = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Fifo Interface
/// 
/// A fifo object for a surface that may be used to add
/// display refresh constraints to content updates.
public final class WpFifoV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_fifo_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_barrier",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "wait_barrier",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Sets The Start Point For A Fifo Constraint
    /// 
    /// When the content update containing the "set_barrier" is applied,
    /// it sets a "fifo_barrier" condition on the surface associated with
    /// the fifo object. The condition is cleared immediately after the
    /// following latching deadline for non-tearing presentation.
    /// The compositor may clear the condition early if it must do so to
    /// ensure client forward progress assumptions.
    /// To wait for this condition to clear, use the "wait_barrier" request.
    /// "set_barrier" is double-buffered state, see wl_surface.commit.
    /// Requesting set_barrier after the fifo object's surface is
    /// destroyed will generate a "surface_destroyed" error.
    public func setBarrier() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Adds A Fifo Constraint To A Content Update
    /// 
    /// Indicate that this content update is not ready while a
    /// "fifo_barrier" condition is present on the surface.
    /// This means that when the content update containing "set_barrier"
    /// was made active at a latching deadline, it will be active for
    /// at least one refresh cycle. A content update which is allowed to
    /// tear might become active after a latching deadline if no content
    /// update became active at the deadline.
    /// The constraint must be ignored if the surface is a subsurface in
    /// synchronized mode. If the surface is not being updated by the
    /// compositor (off-screen, occluded) the compositor may ignore the
    /// constraint. Clients must use an additional mechanism such as
    /// frame callbacks or timestamps to ensure throttling occurs under
    /// all conditions.
    /// "wait_barrier" is double-buffered state, see wl_surface.commit.
    /// Requesting "wait_barrier" after the fifo object's surface is
    /// destroyed will generate a "surface_destroyed" error.
    public func waitBarrier() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Destroy The Fifo Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object.
    /// Surface state changes previously made by this protocol are
    /// unaffected by this object's destruction.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = FifoV1Protocol
    
    public enum Error: UInt32 {
        /// the associated surface no longer exists
        case surfaceDestroyed = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let FifoV1Protocol = Protocol(
        name: "fifo_v1",
        interfaces: [
            WpFifoManagerV1.interface,
WpFifoV1.interface
        ]
    )

/// Commit Timing
/// 
/// When a compositor latches on to new content updates it will check for
/// any number of requirements of the available content updates (such as
/// fences of all buffers being signalled) to consider the update ready.
/// This protocol provides a method for adding a time constraint to surface
/// content. This constraint indicates to the compositor that a content
/// update should be presented as closely as possible to, but not before,
/// a specified time.
/// This protocol does not change the Wayland property that content
/// updates are applied in the order they are received, even when some
/// content updates contain timestamps and others do not.
/// To provide timestamps, this global factory interface must be used to
/// acquire a wp_commit_timing_v1 object for a surface, which may then be
/// used to provide timestamp information for commits.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpCommitTimingManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_commit_timing_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_timer",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wp_commit_timer_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Unbind From The Commit Timing Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object. Existing objects created by this object
    /// are not affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Request Commit Timer Interface For Surface
    /// 
    /// Establish a timing controller for a surface.
    /// Only one commit timer can be created for a surface, or a
    /// commit_timer_exists protocol error will be generated.
    /// 
    /// - Parameters:
    public func getTimer(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WpCommitTimerV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, WpCommitTimerV1.self, version, _queue, [
            .newId,
            .object(surface),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = CommitTimingV1Protocol
    
    public enum Error: UInt32 {
        /// commit timer already exists for surface
        case commitTimerExists = 0
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Surface Commit Timer
/// 
/// An object to set a time constraint for a content update on a surface.
public final class WpCommitTimerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_commit_timer_v1",
            version: 1,
            requests: [
                Message(
                    name: "set_timestamp",
                    arguments: [
                        Argument(
                            name: "tv_sec_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_sec_lo",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "tv_nsec",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Specify Time The Following Commit Takes Effect
    /// 
    /// Provide a timing constraint for a surface content update.
    /// A set_timestamp request may be made before a wl_surface.commit to
    /// tell the compositor that the content is intended to be presented
    /// as closely as possible to, but not before, the specified time.
    /// The time is in the domain of the compositor's presentation clock.
    /// An invalid_timestamp error will be generated for invalid tv_nsec.
    /// If a timestamp already exists on the surface, a timestamp_exists
    /// error is generated.
    /// Requesting set_timestamp after the commit_timer object's surface is
    /// destroyed will generate a "surface_destroyed" error.
    /// 
    /// - Parameters:
    ///   - tvSecHi: high 32 bits of the seconds part of target time
    ///   - tvSecLo: low 32 bits of the seconds part of target time
    ///   - tvNsec: nanoseconds part of target time
    public func setTimestamp(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(tvSecHi),
            .uint(tvSecLo),
            .uint(tvNsec),
        ])
    }

    /// Destroy The Timer
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object.
    /// Existing timing constraints are not affected by the destruction.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = CommitTimingV1Protocol
    
    public enum Error: UInt32 {
        /// timestamp contains an invalid value
        case invalidTimestamp = 0

        /// timestamp exists
        case timestampExists = 1

        /// the associated surface no longer exists
        case surfaceDestroyed = 2
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let CommitTimingV1Protocol = Protocol(
        name: "commit_timing_v1",
        interfaces: [
            WpCommitTimingManagerV1.interface,
WpCommitTimerV1.interface
        ]
    )

/// Reposition The Pointer To A Location On A Surface
/// 
/// This global interface allows applications to request the pointer to be
/// moved to a position relative to a wl_surface.
/// Note that if the desired behavior is to constrain the pointer to an area
/// or lock it to a position, this protocol does not provide a reliable way
/// to do that. The pointer constraint and pointer lock protocols should be
/// used for those use cases instead.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class WpPointerWarpV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wp_pointer_warp_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "warp_pointer",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .object,
                            interface: "wl_pointer",
                        )
                        ,
                        Argument(
                            name: "x",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "y",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Warp Manager
    /// 
    /// Destroy the pointer warp manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Reposition The Pointer
    /// 
    /// Request the compositor to move the pointer to a surface-local position.
    /// Whether or not the compositor honors the request is implementation defined,
    /// but it should
    /// - honor it if the surface has pointer focus, including
    /// when it has an implicit pointer grab
    /// - reject it if the enter serial is incorrect
    /// - reject it if the requested position is outside of the surface
    /// Note that the enter serial is valid for any surface of the client,
    /// and does not have to be from the surface the pointer is warped to.
    /// 
    /// - Parameters:
    ///   - surface: surface to position the pointer on
    ///   - pointer: the pointer that should be repositioned
    ///   - serial: serial number of the enter event
    public func warpPointer(surface: WlSurface, pointer: WlPointer, x: Double, y: Double, serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface),
            .object(pointer),
            .fixed(x),
            .fixed(y),
            .uint(serial),
        ])
    }

    
    public static let `protocol`: Protocol = PointerWarpV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}


public let PointerWarpV1Protocol = Protocol(
        name: "pointer_warp_v1",
        interfaces: [
            WpPointerWarpV1.interface
        ]
    )

/// Used To Lock The Session
/// 
/// This interface is used to request that the session be locked.
public final class ExtSessionLockManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "ext_session_lock_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "lock",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "ext_session_lock_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Session Lock Manager Object
    /// 
    /// This informs the compositor that the session lock manager object will
    /// no longer be used. Existing objects created through this interface
    /// remain valid.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Attempt To Lock The Session
    /// 
    /// This request creates a session lock and asks the compositor to lock the
    /// session. The compositor will send either the ext_session_lock_v1.locked
    /// or ext_session_lock_v1.finished event on the created object in
    /// response to this request.
    public func lock(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ExtSessionLockV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ExtSessionLockV1.self, version, _queue, [
            .newId,
        ])
        return id
    }

    
    public static let `protocol`: Protocol = ExtSessionLockV1Protocol
    
    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public typealias Event = NoEvent
}

/// Manage Lock State And Create Lock Surfaces
/// 
/// In response to the creation of this object the compositor must send
/// either the locked or finished event.
/// The locked event indicates that the session is locked. This means
/// that the compositor must stop rendering and providing input to normal
/// clients. Instead the compositor must blank all outputs with an opaque
/// color such that their normal content is fully hidden.
/// The only surfaces that should be rendered while the session is locked
/// are the lock surfaces created through this interface and optionally,
/// at the compositor's discretion, special privileged surfaces such as
/// input methods or portions of desktop shell UIs.
/// The locked event must not be sent until a new "locked" frame (either
/// from a session lock surface or the compositor blanking the output) has
/// been presented on all outputs and no security sensitive normal/unlocked
/// content is possibly visible.
/// The finished event should be sent immediately on creation of this
/// object if the compositor decides that the locked event will not be sent.
/// The compositor may wait for the client to create and render session lock
/// surfaces before sending the locked event to avoid displaying intermediate
/// blank frames. However, it must impose a reasonable time limit if
/// waiting and send the locked event as soon as the hard requirements
/// described above can be met if the time limit expires. Clients should
/// immediately create lock surfaces for all outputs on creation of this
/// object to make this possible.
/// This behavior of the locked event is required in order to prevent
/// possible race conditions with clients that wish to suspend the system
/// or similar after locking the session. Without these semantics, clients
/// triggering a suspend after receiving the locked event would race with
/// the first "locked" frame being presented and normal/unlocked frames
/// might be briefly visible as the system is resumed if the suspend
/// operation wins the race.
/// If the client dies while the session is locked, the compositor must not
/// unlock the session in response. It is acceptable for the session to be
/// permanently locked if this happens. The compositor may choose to continue
/// to display the lock surfaces the client had mapped before it died or
/// alternatively fall back to a solid color, this is compositor policy.
/// Compositors may also allow a secure way to recover the session, the
/// details of this are compositor policy. Compositors may allow a new
/// client to create a ext_session_lock_v1 object and take responsibility
/// for unlocking the session, they may even start a new lock client
/// instance automatically.
public final class ExtSessionLockV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "ext_session_lock_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "get_lock_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "ext_session_lock_surface_v1",
                        )
                        ,
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "unlock_and_destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "locked",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "finished",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Session Lock
    /// 
    /// This informs the compositor that the lock object will no longer be
    /// used. Existing objects created through this interface remain valid.
    /// After this request is made, lock surfaces created through this object
    /// should be destroyed by the client as they will no longer be used by
    /// the compositor.
    /// It is a protocol error to make this request if the locked event was
    /// sent, the unlock_and_destroy request must be used instead.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Create A Lock Surface For A Given Output
    /// 
    /// The client is expected to create lock surfaces for all outputs
    /// currently present and any new outputs as they are advertised. These
    /// won't be displayed by the compositor unless the lock is successful
    /// and the locked event is sent.
    /// Providing a wl_surface which already has a role or already has a buffer
    /// attached or committed is a protocol error, as is attaching/committing
    /// a buffer before the first ext_session_lock_surface_v1.configure event.
    /// Attempting to create more than one lock surface for a given output
    /// is a duplicate_output protocol error.
    /// 
    /// - Parameters:
    public func getLockSurface(surface: WlSurface, output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ExtSessionLockSurfaceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.sendConstructor(self, 1, ExtSessionLockSurfaceV1.self, version, _queue, [
            .newId,
            .object(surface),
            .object(output),
        ])
        return id
    }

    /// Unlock The Session, Destroying The Object
    /// 
    /// This request indicates that the session should be unlocked, for
    /// example because the user has entered their password and it has been
    /// verified by the client.
    /// This request also informs the compositor that the lock object will
    /// no longer be used and should be destroyed. Existing objects created
    /// through this interface remain valid.
    /// After this request is made, lock surfaces created through this object
    /// should be destroyed by the client as they will no longer be used by
    /// the compositor.
    /// It is a protocol error to make this request if the locked event has
    /// not been sent. In that case, the lock object must be destroyed using
    /// the destroy request.
    /// Note that a correct client that wishes to exit directly after unlocking
    /// the session must use the wl_display.sync request to ensure the server
    /// receives and processes the unlock_and_destroy request. Otherwise
    /// there is no guarantee that the server has unlocked the session due
    /// to the asynchronous nature of the Wayland protocol. For example,
    /// the server might terminate the client with a protocol error before
    /// it processes the unlock_and_destroy request.
    public func unlockAndDestroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = ExtSessionLockV1Protocol
    
    public enum Error: UInt32 {
        /// attempted to destroy session lock while locked
        case invalidDestroy = 0

        /// unlock requested but locked event was never sent
        case invalidUnlock = 1

        /// given wl_surface already has a role
        case role = 2

        /// given output already has a lock surface
        case duplicateOutput = 3

        /// given wl_surface has a buffer attached or committed
        case alreadyConstructed = 4
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// Session Successfully Locked
        /// 
        /// This client is now responsible for displaying graphics while the
        /// session is locked and deciding when to unlock the session.
        /// The locked event must not be sent until a new "locked" frame has been
        /// presented on all outputs and no security sensitive normal/unlocked
        /// content is possibly visible.
        /// If this event is sent, making the destroy request is a protocol error,
        /// the lock object must be destroyed using the unlock_and_destroy request.
        case locked

        /// The Session Lock Object Should Be Destroyed
        /// 
        /// The compositor has decided that the session lock should be destroyed
        /// as it will no longer be used by the compositor. Exactly when this
        /// event is sent is compositor policy, but it must never be sent more
        /// than once for a given session lock object.
        /// This might be sent because there is already another ext_session_lock_v1
        /// object held by a client, or the compositor has decided to deny the
        /// request to lock the session for some other reason. This might also
        /// be sent because the compositor implements some alternative, secure
        /// way to authenticate and unlock the session.
        /// The finished event should be sent immediately on creation of this
        /// object if the compositor decides that the locked event will not
        /// be sent.
        /// If the locked event is sent on creation of this object the finished
        /// event may still be sent at some later time in this object's
        /// lifetime. This is compositor policy.
        /// Upon receiving this event, the client should make either the destroy
        /// request or the unlock_and_destroy request, depending on whether or
        /// not the locked event was received on this object.
        case finished

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.locked
            case 1:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A Surface Displayed While The Session Is Locked
/// 
/// The client may use lock surfaces to display a screensaver, render a
/// dialog to enter a password and unlock the session, or however else it
/// sees fit.
/// On binding this interface the compositor will immediately send the
/// first configure event. After making the ack_configure request in
/// response to this event the client should attach and commit the first
/// buffer. Committing the surface before acking the first configure is a
/// protocol error. Committing the surface with a null buffer at any time
/// is a protocol error.
/// The compositor is free to handle keyboard/pointer focus for lock
/// surfaces however it chooses. A reasonable way to do this would be to
/// give the first lock surface created keyboard focus and change keyboard
/// focus if the user clicks on other surfaces.
public final class ExtSessionLockSurfaceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "ext_session_lock_surface_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "ack_configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "configure",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "width",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Lock Surface Object
    /// 
    /// This informs the compositor that the lock surface object will no
    /// longer be used.
    /// It is recommended for a lock client to destroy lock surfaces if
    /// their corresponding wl_output global is removed.
    /// If a lock surface on an active output is destroyed before the
    /// ext_session_lock_v1.unlock_and_destroy event is sent, the compositor
    /// must fall back to rendering a solid color.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.destroy(self)
        connection.send(self, 0, [
        ])
    }

    /// Ack A Configure Event
    /// 
    /// When a configure event is received, if a client commits the surface
    /// in response to the configure event, then the client must make an
    /// ack_configure request sometime before the commit request, passing
    /// along the serial of the configure event.
    /// If the client receives multiple configure events before it can
    /// respond to one, it only has to ack the last configure event.
    /// A client is not required to commit immediately after sending an
    /// ack_configure request - it may even ack_configure several times
    /// before its next surface commit.
    /// A client may send multiple ack_configure requests before committing,
    /// but only the last request sent before a commit indicates which
    /// configure event the client really is responding to.
    /// Sending an ack_configure request consumes the configure event
    /// referenced by the given serial, as well as all older configure events
    /// sent on this object.
    /// It is a protocol error to issue multiple ack_configure requests
    /// referencing the same configure event or to issue an ack_configure
    /// request referencing a configure event older than the last configure
    /// event acked for a given lock surface.
    /// 
    /// - Parameters:
    ///   - serial: serial from the configure event
    public func ackConfigure(serial: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(serial),
        ])
    }

    
    public static let `protocol`: Protocol = ExtSessionLockV1Protocol
    
    public enum Error: UInt32 {
        /// surface committed before first ack_configure request
        case commitBeforeFirstAck = 0

        /// surface committed with a null buffer
        case nullBuffer = 1

        /// failed to match ack'd width/height
        case dimensionsMismatch = 2

        /// serial provided in ack_configure is invalid
        case invalidSerial = 3
    }

    deinit {
        if self.isAlive {
            connection.destroy(self)
        }
    }

    public enum Event: MessageProtocol {
        /// The Client Should Resize Its Surface
        /// 
        /// This event is sent once on binding the interface and may be sent again
        /// at the compositor's discretion, for example if output geometry changes.
        /// The width and height are in surface-local coordinates and are exact
        /// requirements. Failing to match these surface dimensions in the next
        /// commit after acking a configure is a protocol error.
        case configure(serial: UInt32, width: UInt32, height: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.configure(serial: r.uint(), width: r.uint(), height: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let ExtSessionLockV1Protocol = Protocol(
        name: "ext_session_lock_v1",
        interfaces: [
            ExtSessionLockManagerV1.interface,
ExtSessionLockV1.interface,
ExtSessionLockSurfaceV1.interface
        ]
    )

#endif
