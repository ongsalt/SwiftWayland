import Foundation

#if KDE
/// Appmenu Dbus Address Interface
/// 
/// This interface allows a client to link a window (or wl_surface) to an com.canonical.dbusmenu
/// interface registered on DBus.
public final class OrgKdeKwinAppmenuManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_appmenu_manager",
            version: 2,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_appmenu",
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
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 2
                )
                ,
            ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinAppmenu {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinAppmenu.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// Destroy The Org_Kde_Kwin_Appmenu_Manager Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = AppmenuProtocol
    
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

    public typealias Event = NoEvent
}

/// Appmenu Dbus Address Interface
/// 
/// The DBus service name and object path where the appmenu interface is present
/// The object should be registered on the session bus before sending this request.
/// If not applicable, clients should remove this object.
public final class OrgKdeKwinAppmenu: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_appmenu",
            version: 2,
            requests: [
                Message(
                    name: "set_address",
                    arguments: [
                        Argument(
                            name: "service_name",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "object_path",
                            type: .string,
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
                )
                ,
            ],
        )
    /// Initialise Or Update The Location Of The Appmenu Interface
    /// 
    /// Set or update the service name and object path.
    /// Strings should be formatted in Latin-1 matching the relevant DBus specifications.
    /// 
    /// - Parameters:
    public func setAddress(serviceName: String, objectPath: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(serviceName),
            .string(objectPath),
        ])
    }

    /// Release The Appmenu Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = AppmenuProtocol
    
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

    public typealias Event = NoEvent
}


public let AppmenuProtocol = Protocol(
        name: "appmenu",
        interfaces: [
            OrgKdeKwinAppmenuManager.interface,
OrgKdeKwinAppmenu.interface
        ]
    )

public final class OrgKdeKwinBlurManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_blur_manager",
            version: 1,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_blur",
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
                    name: "unset",
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
            ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinBlur {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinBlur.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// 
    /// - Parameters:
    public func unset(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface.id),
        ])
    }

    
    public static let `protocol`: Protocol = BlurProtocol
    
    public typealias Event = NoEvent
}

public final class OrgKdeKwinBlur: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_blur",
            version: 1,
            requests: [
                Message(
                    name: "commit",
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
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// 
    /// - Parameters:
    public func setRegion(_ region: WlRegion? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(region?.id ?? 0),
        ])
    }

    /// Release The Blur Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = BlurProtocol
    
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

    public typealias Event = NoEvent
}


public let BlurProtocol = Protocol(
        name: "blur",
        interfaces: [
            OrgKdeKwinBlurManager.interface,
OrgKdeKwinBlur.interface
        ]
    )

public final class OrgKdeKwinContrastManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_contrast_manager",
            version: 2,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_contrast",
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
                    name: "unset",
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
            ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinContrast {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinContrast.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// 
    /// - Parameters:
    public func unset(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface.id),
        ])
    }

    
    public static let `protocol`: Protocol = ContrastProtocol
    
    public typealias Event = NoEvent
}

public final class OrgKdeKwinContrast: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_contrast",
            version: 2,
            requests: [
                Message(
                    name: "commit",
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
                Message(
                    name: "set_contrast",
                    arguments: [
                        Argument(
                            name: "contrast",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_intensity",
                    arguments: [
                        Argument(
                            name: "intensity",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_saturation",
                    arguments: [
                        Argument(
                            name: "saturation",
                            type: .fixed,
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
                )
                ,
                Message(
                    name: "set_frost",
                    arguments: [
                        Argument(
                            name: "red",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "green",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "blue",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "alpha",
                            type: .int,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "unset_frost",
                    arguments: [
                    ],
                    since: 2
                )
                ,
            ],
        )
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// 
    /// - Parameters:
    public func setRegion(_ region: WlRegion? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(region?.id ?? 0),
        ])
    }

    /// 
    /// - Parameters:
    public func setContrast(_ contrast: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .fixed(contrast),
        ])
    }

    /// 
    /// - Parameters:
    public func setIntensity(_ intensity: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .fixed(intensity),
        ])
    }

    /// 
    /// - Parameters:
    public func setSaturation(_ saturation: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .fixed(saturation),
        ])
    }

    /// Release The Contrast Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 5, [
        ])
    }

    /// Opt Into Frost Effect W/ Given Colour
    /// 
    /// enables 'frost' variant of contrast effect.
    /// 'frost' is an enhanced version of the contrast effect that
    /// uses different colour arithmetic to get backgrounds simultaneously
    /// higher in contrast and (apparent) transparency.
    /// r, g, b, a are channels from 0-255, indicating a colour to use in contrast calculation.
    /// should be based off of the "main" background colour of the surface.
    /// 
    /// - Parameters:
    public func setFrost(red: Int32, green: Int32, blue: Int32, alpha: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 6, [
            .int(red),
            .int(green),
            .int(blue),
            .int(alpha),
        ])
    }

    /// Opts Out Of Frost Effect
    /// 
    /// 
    public func unsetFrost() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 7, [
        ])
    }

    
    public static let `protocol`: Protocol = ContrastProtocol
    
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

    public typealias Event = NoEvent
}


public let ContrastProtocol = Protocol(
        name: "contrast",
        interfaces: [
            OrgKdeKwinContrastManager.interface,
OrgKdeKwinContrast.interface
        ]
    )

/// Output Dpms Manager
/// 
/// The Dpms manager allows to get a org_kde_kwin_dpms for a given wl_output.
/// The org_kde_kwin_dpms provides the currently used VESA Display Power Management
/// Signaling state (see https://en.wikipedia.org/wiki/VESA_Display_Power_Management_Signaling ).
/// In addition it allows to request a state change. A compositor is not obliged to honor it
/// and will normally automatically switch back to on state.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class OrgKdeKwinDpmsManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_dpms_manager",
            version: 1,
            requests: [
                Message(
                    name: "get",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_dpms",
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
            ],
        )
    /// Get Org_Kde_Kwin_Dpms For Wl_Output
    /// 
    /// Factory request to get the org_kde_kwin_dpms for a given wl_output.
    /// 
    /// - Parameters:
    public func `get`(output: WlOutput, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinDpms {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinDpms.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(output.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = DpmsProtocol
    
    public typealias Event = NoEvent
}

/// Dpms For A Wl_Output
/// 
/// This interface provides information about the VESA DPMS state for a wl_output.
/// It gets created through the request get on the org_kde_kwin_dpms_manager interface.
/// On creating the resource the server will push whether DPSM is supported for the output,
/// the currently used DPMS state and notifies the client through the done event once all
/// states are pushed. Whenever a state changes the set of changes is committed with the
/// done event.
public final class OrgKdeKwinDpms: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_dpms",
            version: 1,
            requests: [
                Message(
                    name: "set",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .uint,
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
                )
                ,
            ],
            events: [
                Message(
                    name: "supported",
                    arguments: [
                        Argument(
                            name: "supported",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "mode",
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
    /// Request Dpms State Change For The Wl_Output
    /// 
    /// Requests that the compositor puts the wl_output into the passed mode. The compositor
    /// is not obliged to change the state. In addition the compositor might leave the mode
    /// whenever it seems suitable. E.g. the compositor might return to On state on user input.
    /// The client should not assume that the mode changed after requesting a new mode.
    /// Instead the client should listen for the mode event.
    /// 
    /// - Parameters:
    ///   - mode: Requested mode
    public func `set`(mode: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(mode),
        ])
    }

    /// Release The Dpms Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = DpmsProtocol
    
    public enum Mode: UInt32 {
        case on = 0

        case standby = 1

        case suspend = 2

        case off = 3
    }

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

    public enum Event: MessageProtocol {
        /// Event Indicating Whether Dpms Is Supported On The Wl_Output
        /// 
        /// This event gets pushed on binding the resource and indicates whether the wl_output
        /// supports DPMS. There are operation modes of a Wayland server where DPMS might not
        /// make sense (e.g. nested compositors).
        case supported(supported: UInt32)

        /// Event Indicating Used Dpms Mode
        /// 
        /// This mode gets pushed on binding the resource and provides the currently used
        /// DPMS mode. It also gets pushed if DPMS is not supported for the wl_output, in that
        /// case the value will be On.
        /// The event is also pushed whenever the state changes.
        case mode(mode: UInt32)

        /// All Changes Are Pushed
        /// 
        /// This event gets pushed on binding the resource once all other states are pushed.
        /// In addition it gets pushed whenever a state changes to tell the client that all
        /// state changes have been pushed.
        case done

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.supported(supported: r.uint())
            case 1:
                self = Self.mode(mode: r.uint())
            case 2:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let DpmsProtocol = Protocol(
        name: "dpms",
        interfaces: [
            OrgKdeKwinDpmsManager.interface,
OrgKdeKwinDpms.interface
        ]
    )

/// Fake Input Manager
/// 
/// This interface allows other processes to provide fake input events.
/// Purpose is on the one hand side to provide testing facilities like XTest on X11.
/// But also to support use case like kdeconnect's mouse pad interface.
/// A compositor should not trust the input received from this interface.
/// Clients should not expect that the compositor honors the requests from this
/// interface.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class OrgKdeKwinFakeInput: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_fake_input",
            version: 6,
            requests: [
                Message(
                    name: "authenticate",
                    arguments: [
                        Argument(
                            name: "application",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "reason",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "pointer_motion",
                    arguments: [
                        Argument(
                            name: "delta_x",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "delta_y",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "button",
                    arguments: [
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
                    name: "axis",
                    arguments: [
                        Argument(
                            name: "axis",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "value",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "touch_down",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
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
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "touch_motion",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
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
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "touch_up",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "touch_cancel",
                    arguments: [
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "touch_frame",
                    arguments: [
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "pointer_motion_absolute",
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
                    since: 3
                )
                ,
                Message(
                    name: "keyboard_key",
                    arguments: [
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
                    since: 4
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 5
                )
                ,
                Message(
                    name: "keyboard_keysym",
                    arguments: [
                        Argument(
                            name: "keysym",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 6
                )
                ,
            ],
        )
    /// Information Why The Client Wants To Use The Interface
    /// 
    /// A client should use this request to tell the compositor why it wants to
    /// use this interface. The compositor might use the information to decide
    /// whether it wants to grant the request. The data might also be passed to
    /// the user to decide whether the application should get granted access to
    /// this very privileged interface.
    /// 
    /// - Parameters:
    ///   - application: user visible name of the application
    ///   - reason: reason why the application wants to use this interface
    public func authenticate(application: String, reason: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(application),
            .string(reason),
        ])
    }

    /// 
    /// - Parameters:
    public func pointerMotion(deltaX: Double, deltaY: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .fixed(deltaX),
            .fixed(deltaY),
        ])
    }

    /// 
    /// - Parameters:
    public func button(button: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .uint(button),
            .uint(state),
        ])
    }

    /// 
    /// - Parameters:
    public func axis(axis: UInt32, value: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(axis),
            .fixed(value),
        ])
    }

    /// Touch Down Event
    /// 
    /// A client should use this request to send touch down event at specific
    /// coordinates.
    /// 
    /// - Parameters:
    ///   - id: unique id for touch down event
    ///   - x: x coordinate for touch down event
    ///   - y: y coordinate for touch down event
    public func touchDown(id: UInt32, x: Double, y: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 4, [
            .uint(id),
            .fixed(x),
            .fixed(y),
        ])
    }

    /// Touch Motion Event
    /// 
    /// A client should use this request to send touch motion to specific position.
    /// 
    /// - Parameters:
    ///   - id: unique id for touch motion event
    ///   - x: x coordinate for touch motion event
    ///   - y: y coordinate for touch motion event
    public func touchMotion(id: UInt32, x: Double, y: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 5, [
            .uint(id),
            .fixed(x),
            .fixed(y),
        ])
    }

    /// Touch Up Event
    /// 
    /// A client should use this request to send touch up event.
    /// 
    /// - Parameters:
    ///   - id: unique id for touch up event
    public func touchUp(id: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 6, [
            .uint(id),
        ])
    }

    /// Touch Cancel Event
    /// 
    /// A client should use this request to cancel the current
    /// touch event.
    public func touchCancel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 7, [
        ])
    }

    /// Touch Frame Event
    /// 
    /// A client should use this request to send touch frame event.
    public func touchFrame() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 8, [
        ])
    }

    /// 
    /// - Parameters:
    public func pointerMotionAbsolute(x: Double, y: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 9, [
            .fixed(x),
            .fixed(y),
        ])
    }

    /// 
    /// - Parameters:
    public func keyboardKey(button: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 10, [
            .uint(button),
            .uint(state),
        ])
    }

    /// Destroy The Fake Input Device
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        self.markDead()
        connection.send(self, 11, [
        ])
    }

    /// 
    /// - Parameters:
    public func keyboardKeysym(keysym: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 6 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 6) }
        connection.send(self, 12, [
            .uint(keysym),
            .uint(state),
        ])
    }

    
    public static let `protocol`: Protocol = FakeInputProtocol
    
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


public let FakeInputProtocol = Protocol(
        name: "fake_input",
        interfaces: [
            OrgKdeKwinFakeInput.interface
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
/// Requesting a surface be presented on an output that already has a
/// surface replaces the previously presented surface.  Presenting a null
/// surface removes its content and effectively disables the output.
/// Exactly what happens when an output is "disabled" is
/// compositor-specific.  The same surface may be presented on multiple
/// outputs simultaneously.
/// Once a surface is presented on an output, it stays on that output
/// until either the client removes it or the compositor destroys the
/// output.  This way, the client can update the output's contents by
/// simply attaching a new buffer.
public final class _WlFullscreenShell: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "_wl_fullscreen_shell",
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
                            interface: "_wl_fullscreen_shell_mode_feedback",
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
    /// Release the binding from the wl_fullscreen_shell interface
    /// This destroys the server-side object and frees this binding.  If
    /// the client binds to wl_fullscreen_shell multiple times, it may wish
    /// to free some of those bindings.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
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
    /// is to be presented.  In particular, it tells the compostior how to
    /// handle a size mismatch between the presented surface and the
    /// output.  The compositor is free to ignore this parameter.
    /// The "zoom", "zoom_crop", and "stretch" methods imply a scaling
    /// operation on the surface.  This will override any kind of output
    /// scaling, so the buffer_scale property of the surface is effectively
    /// ignored.
    /// 
    /// - Parameters:
    public func presentSurface(surface: WlSurface? = nil, method: UInt32, output: WlOutput? = nil) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface?.id ?? 0),
            .uint(method),
            .object(output?.id ?? 0),
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
    /// 
    /// - Parameters:
    public func presentSurfaceForMode(surface: WlSurface, output: WlOutput, framerate: Int32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> _WlFullscreenShellModeFeedback {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let feedback = connection.createProxy(type: _WlFullscreenShellModeFeedback.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(surface.id),
            .object(output.id),
            .int(framerate),
            .object(feedback.id),
        ])
        return feedback
    }

    
    public static let `protocol`: Protocol = FullscreenShellProtocol
    
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
    }

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
        case capability(capability: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.capability(capability: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public final class _WlFullscreenShellModeFeedback: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "_wl_fullscreen_shell_mode_feedback",
            version: 1,
            events: [
                Message(
                    name: "mode_successful",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "mode_failed",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "present_cancelled",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    
    public static let `protocol`: Protocol = FullscreenShellProtocol
    
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
        /// failed. This may be because the requested output mode is not
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


public let FullscreenShellProtocol = Protocol(
        name: "fullscreen_shell",
        interfaces: [
            _WlFullscreenShell.interface,
_WlFullscreenShellModeFeedback.interface
        ]
    )

/// User Idle Time Manager
/// 
/// This interface allows to monitor user idle time on a given seat. The interface
/// allows to register timers which trigger after no user activity was registered
/// on the seat for a given interval. It notifies when user activity resumes.
/// This is useful for applications wanting to perform actions when the user is not
/// interacting with the system, e.g. chat applications setting the user as away, power
/// management features to dim screen, etc..
public final class OrgKdeKwinIdle: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_idle",
            version: 1,
            requests: [
                Message(
                    name: "get_idle_timeout",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_idle_timeout",
                        )
                        ,
                        Argument(
                            name: "seat",
                            type: .object,
                            interface: "wl_seat",
                        )
                        ,
                        Argument(
                            name: "timeout",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// 
    /// - Parameters:
    ///   - timeout: The idle timeout in msec
    public func getIdleTimeout(seat: WlSeat, timeout: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinIdleTimeout {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinIdleTimeout.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(seat.id),
            .uint(timeout),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = IdleProtocol
    
    public typealias Event = NoEvent
}

public final class OrgKdeKwinIdleTimeout: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_idle_timeout",
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
                    name: "simulate_user_activity",
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "idle",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "resumed",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Release The Timeout Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Simulates User Activity For This Timeout, Behaves Just Like Real User Activity On The Seat
    /// 
    /// 
    public func simulateUserActivity() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = IdleProtocol
    
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

    public enum Event: MessageProtocol {
        /// Triggered When There Has Not Been Any User Activity In The Requested Idle Time Interval
        /// 
        /// 
        case idle

        /// Triggered On The First User Activity After An Idle Event
        /// 
        /// 
        case resumed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.idle
            case 1:
                self = Self.resumed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let IdleProtocol = Protocol(
        name: "idle",
        interfaces: [
            OrgKdeKwinIdle.interface,
OrgKdeKwinIdleTimeout.interface
        ]
    )

/// External Brightness Control
/// 
/// Some brightness control mechanisms are somewhat unstable, or require root
/// privileges, so putting them inside of the compositor is not desired.
/// This protocol is for outsourcing the actual brightness-setting to a
/// process outside of the compositor.
public final class KdeExternalBrightnessV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_external_brightness_v1",
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
                    name: "create_brightness_control",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "kde_external_brightness_device_v1",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Object.
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Registers A Brightness Device With The Compositor
    /// 
    /// 
    public func createBrightnessControl(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeExternalBrightnessDeviceV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeExternalBrightnessDeviceV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = KdeExternalBrightnessV1Protocol
    
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

/// Brightness Control Device
/// 
/// After creating this object, the client should issue all relevant setup requests
/// (set_internal, set_edid, set_max_brightness, optionally set_observed_brightness)
/// and finish the sequence with commit.
/// Afterwards, for each change in values, the client must call commit again.
public final class KdeExternalBrightnessDeviceV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_external_brightness_device_v1",
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
                    name: "set_internal",
                    arguments: [
                        Argument(
                            name: "internal",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_edid",
                    arguments: [
                        Argument(
                            name: "string",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_max_brightness",
                    arguments: [
                        Argument(
                            name: "value",
                            type: .uint,
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
                    name: "set_observed_brightness",
                    arguments: [
                        Argument(
                            name: "value",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "set_uses_ddc_ci",
                    arguments: [
                        Argument(
                            name: "value",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
            ],
            events: [
                Message(
                    name: "requested_brightness",
                    arguments: [
                        Argument(
                            name: "value",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Object And Unregister The Brightness Control Device
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Sets Whether Or Not The Brightness Device Belongs To An Internal Display
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - _: 1 if it's an internal panel, 0 if not
    public func setInternal(_ `internal`: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(`internal`),
        ])
    }

    /// Set The Edid Data For Identification Of The Display
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - string: base-64 encoded string of the first 128 bytes of the EDID
    public func setEdid(string: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .string(string),
        ])
    }

    /// Notifies The Compositor Of The Maximum Brightness That Can Be Set On This Device
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - value: the maximum value that can be set
    public func setMaxBrightness(value: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(value),
        ])
    }

    /// Notifies The Compositor That All Relevant Identifiers And Values Have Been Sent
    /// 
    /// 
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    /// Notifies The Compositor Of The Brightness That Was Read From This Device
    /// 
    /// The client can set this to notify the compositor of the device's initial brightness.
    /// It can also set this again after the initial commit to notify the compositor that
    /// the brightness level has changed due to external factors.
    /// The compositor is free to use or ignore this value as it sees fit.
    /// 
    /// - Parameters:
    ///   - value: the observed value that was read
    public func setObservedBrightness(value: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 5, [
            .uint(value),
        ])
    }

    /// Notifies The Compositor That Ddc/Ci Is Used To Control Brightness Etc.
    /// 
    /// The compositor can use this information to ignore this object if its commands
    /// expose monitor issues. The compositor may also reduce the amount of brightness
    /// requests given potentially slow response times and concerns about monitor EEPROM
    /// longevity/wear-out.
    /// 
    /// - Parameters:
    ///   - value: 1 if it uses DDC/CI, 0 if not (assumed by default)
    public func setUsesDdcCi(value: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 6, [
            .uint(value),
        ])
    }

    
    public static let `protocol`: Protocol = KdeExternalBrightnessV1Protocol
    
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

    public enum Event: MessageProtocol {
        /// Requests The Client To Change The Brightness To This Value
        /// 
        /// The client must ensure that if the brightness level changes due to external factors,
        /// that it either overwrites those changes with what the compositor last requested,
        /// or commit again with set_observed_brightness specifying the changed brightness.
        case requestedBrightness(value: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.requestedBrightness(value: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let KdeExternalBrightnessV1Protocol = Protocol(
        name: "kde_external_brightness_v1",
        interfaces: [
            KdeExternalBrightnessV1.interface,
KdeExternalBrightnessDeviceV1.interface
        ]
    )

/// Allow Surfaces Over The Lockscreen
/// 
/// Allows a client to request a surface to be visible when the system is locked.
/// This is meant to be used for specific high urgency cases like phone calls or alarms.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeLockscreenOverlayV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_lockscreen_overlay_v1",
            version: 1,
            requests: [
                Message(
                    name: "allow",
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
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Tell About Which Surface Could Be Raised Above The Lockscreen
    /// 
    /// Informs the compositor that the surface could be shown when the screen is locked. This request should be called while the surface is unmapped.
    /// 
    /// - Parameters:
    public func allow(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(surface.id),
        ])
    }

    /// Destroy The Kde_Lockscreen_Overlay_V1
    /// 
    /// This won't affect the surface previously marked with the allow request.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = KdeLockscreenOverlayV1Protocol
    
    public enum Error: UInt32 {
        /// the client provided an invalid surface state
        case invalidSurfaceState = 0
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


public let KdeLockscreenOverlayV1Protocol = Protocol(
        name: "kde_lockscreen_overlay_v1",
        interfaces: [
            KdeLockscreenOverlayV1.interface
        ]
    )

/// Output Devices
/// 
/// This interface can be used to list output devices.
/// If this global is bound with a version less than 21, the unsupported_version
/// protocol error will be posted.
public final class KdeOutputDeviceRegistryV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_device_registry_v2",
            version: 23,
            requests: [
                Message(
                    name: "stop",
                    arguments: [
                    ],
                    since: 21
                )
                ,
            ],
            events: [
                Message(
                    name: "finished",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 21
                )
                ,
                Message(
                    name: "output",
                    arguments: [
                        Argument(
                            name: "output",
                            type: .newId,
                            interface: "kde_output_device_v2",
                        )
                        ,
                    ],
                    since: 21
                )
                ,
            ],
        )
    /// Stop Receiving Updates
    /// 
    /// This request indicates that the client no longer wants to receive new
    /// output announcements. The compositor will send the
    /// kde_output_device_registry_v2.finished event in response to this request.
    /// The compositor may still send new output announcements after calling this
    /// request until the kde_output_device_registry_v2.finished event is sent.
    public func stop() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 21 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 21) }
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = KdeOutputDeviceV2Protocol
    
    public enum Error: UInt32 {
        /// the registry was bound with an unsupported version
        case unsupportedVersion = 0
    }

    public enum Event: MessageProtocol {
        /// No New Output Announcements
        /// 
        /// This event is sent in response to the stop request. The compositor will
        /// immediately destroy the object after sending this event.
        case finished

        /// New Available Output
        /// 
        /// This event is sent when a new output is connected or after binding this
        /// global to list all available outputs.
        case output(output: KdeOutputDeviceV2)

        public var isDestructor: Bool {
            switch self {
                case .finished:
                    true
                default:
                    false
            }
        }

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.finished
            case 1:
                self = Self.output(output: r.newId(type: KdeOutputDeviceV2.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Output Configuration Representation
/// 
/// An output device describes a display device available to the compositor.
/// output_device is similar to wl_output, but focuses on output
/// configuration management.
/// A client can query all global output_device objects to enlist all
/// available display devices, even those that may currently not be
/// represented by the compositor as a wl_output.
/// The client sends configuration changes to the server through the
/// outputconfiguration interface, and the server applies the configuration
/// changes to the hardware and signals changes to the output devices
/// accordingly.
/// This object is published as global during start up for every available
/// display devices, or when one later becomes available, for example by
/// being hotplugged via a physical connector.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeOutputDeviceV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_device_v2",
            version: 23,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 21
                )
                ,
            ],
            events: [
                Message(
                    name: "geometry",
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
                            name: "physical_width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "physical_height",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "subpixel",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "make",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "model",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "transform",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "current_mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .object,
                            interface: "kde_output_device_mode_v2",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .newId,
                            interface: "kde_output_device_mode_v2",
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
                    name: "scale",
                    arguments: [
                        Argument(
                            name: "factor",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "edid",
                    arguments: [
                        Argument(
                            name: "raw",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "enabled",
                    arguments: [
                        Argument(
                            name: "enabled",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "uuid",
                    arguments: [
                        Argument(
                            name: "uuid",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "serial_number",
                    arguments: [
                        Argument(
                            name: "serialNumber",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "eisa_id",
                    arguments: [
                        Argument(
                            name: "eisaId",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "capabilities",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "overscan",
                    arguments: [
                        Argument(
                            name: "overscan",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "vrr_policy",
                    arguments: [
                        Argument(
                            name: "vrr_policy",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "rgb_range",
                    arguments: [
                        Argument(
                            name: "rgb_range",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "name",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "high_dynamic_range",
                    arguments: [
                        Argument(
                            name: "hdr_enabled",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "sdr_brightness",
                    arguments: [
                        Argument(
                            name: "sdr_brightness",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "wide_color_gamut",
                    arguments: [
                        Argument(
                            name: "wcg_enabled",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "auto_rotate_policy",
                    arguments: [
                        Argument(
                            name: "policy",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "icc_profile_path",
                    arguments: [
                        Argument(
                            name: "profile_path",
                            type: .string,
                        )
                        ,
                    ],
                    since: 5
                )
                ,
                Message(
                    name: "brightness_metadata",
                    arguments: [
                        Argument(
                            name: "max_peak_brightness",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "max_frame_average_brightness",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "min_brightness",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 6
                )
                ,
                Message(
                    name: "brightness_overrides",
                    arguments: [
                        Argument(
                            name: "max_peak_brightness",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "max_average_brightness",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "min_brightness",
                            type: .int,
                        )
                        ,
                    ],
                    since: 6
                )
                ,
                Message(
                    name: "sdr_gamut_wideness",
                    arguments: [
                        Argument(
                            name: "gamut_wideness",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 6
                )
                ,
                Message(
                    name: "color_profile_source",
                    arguments: [
                        Argument(
                            name: "source",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 7
                )
                ,
                Message(
                    name: "brightness",
                    arguments: [
                        Argument(
                            name: "brightness",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 8
                )
                ,
                Message(
                    name: "color_power_tradeoff",
                    arguments: [
                        Argument(
                            name: "preference",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 10
                )
                ,
                Message(
                    name: "dimming",
                    arguments: [
                        Argument(
                            name: "multiplier",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 11
                )
                ,
                Message(
                    name: "replication_source",
                    arguments: [
                        Argument(
                            name: "source",
                            type: .string,
                        )
                        ,
                    ],
                    since: 13
                )
                ,
                Message(
                    name: "ddc_ci_allowed",
                    arguments: [
                        Argument(
                            name: "allowed",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 14
                )
                ,
                Message(
                    name: "max_bits_per_color",
                    arguments: [
                        Argument(
                            name: "max_bpc",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 15
                )
                ,
                Message(
                    name: "max_bits_per_color_range",
                    arguments: [
                        Argument(
                            name: "min_value",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "max_value",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 15
                )
                ,
                Message(
                    name: "automatic_max_bits_per_color_limit",
                    arguments: [
                        Argument(
                            name: "max_bpc_limit",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 15
                )
                ,
                Message(
                    name: "edr_policy",
                    arguments: [
                        Argument(
                            name: "policy",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 16
                )
                ,
                Message(
                    name: "sharpness",
                    arguments: [
                        Argument(
                            name: "sharpness",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 17
                )
                ,
                Message(
                    name: "priority",
                    arguments: [
                        Argument(
                            name: "priority",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 18
                )
                ,
                Message(
                    name: "auto_brightness",
                    arguments: [
                        Argument(
                            name: "enabled",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 20
                )
                ,
                Message(
                    name: "removed",
                    arguments: [
                    ],
                    since: 21
                )
                ,
                Message(
                    name: "hdr_icc_profile_path",
                    arguments: [
                        Argument(
                            name: "profile_path",
                            type: .string,
                        )
                        ,
                    ],
                    since: 22
                )
                ,
                Message(
                    name: "hdr_color_profile_source",
                    arguments: [
                        Argument(
                            name: "source",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 22
                )
                ,
                Message(
                    name: "abm_level",
                    arguments: [
                        Argument(
                            name: "level",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 23
                )
                ,
            ],
        )
    /// Destroy The Output Device
    /// 
    /// This notifies the compositor that the client no longer wishes to use
    /// the kde_output_device_v2 object.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 21 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 21) }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = KdeOutputDeviceV2Protocol
    
    public enum Subpixel: UInt32 {
        case unknown = 0

        case `none` = 1

        case horizontalRgb = 2

        case horizontalBgr = 3

        case verticalRgb = 4

        case verticalBgr = 5
    }

    public enum Transform: UInt32 {
        case normal = 0

        case `90` = 1

        case `180` = 2

        case `270` = 3

        case flipped = 4

        case flipped90 = 5

        case flipped180 = 6

        case flipped270 = 7
    }

    public struct Capability: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// if this output_device can use overscan
        public static let overscan = Capability(rawValue: 1)

        /// if this outputdevice supports variable refresh rate
        public static let vrr = Capability(rawValue: 2)

        /// if setting the rgb range is possible
        public static let rgbRange = Capability(rawValue: 4)

        /// if this outputdevice supports high dynamic range
        public static let highDynamicRange = Capability(rawValue: 8)

        /// if this outputdevice supports a wide color gamut
        public static let wideColorGamut = Capability(rawValue: 16)

        /// if this outputdevice supports autorotation
        public static let autoRotate = Capability(rawValue: 32)

        /// if this outputdevice supports icc profiles
        public static let iccProfile = Capability(rawValue: 64)

        /// if this outputdevice supports the brightness setting
        public static let brightness = Capability(rawValue: 128)

        /// if this outputdevice supports the built-in color profile
        public static let builtInColor = Capability(rawValue: 256)

        /// if this outputdevice supports DDC/CI
        public static let ddcCi = Capability(rawValue: 512)

        /// if this outputdevice supports setting max bpc
        public static let maxBitsPerColor = Capability(rawValue: 1024)

        /// if this outputdevice supports EDR
        public static let edr = Capability(rawValue: 2048)

        /// if this outputdevice supports the sharpness setting
        public static let sharpness = Capability(rawValue: 4096)

        /// if this outputdevice supports custom modes
        public static let customModes = Capability(rawValue: 8192)

        public static let autoBrightness = Capability(rawValue: 16384)

        /// if this outputdevice supports HDR ICC profiles
        public static let hdrIccProfile = Capability(rawValue: 32768)

        /// if this outputdevice supports the abm level setting
        public static let abmLevel = Capability(rawValue: 65536)
    }

    public enum VrrPolicy: UInt32 {
        case never = 0

        case always = 1

        case automatic = 2
    }

    public enum RgbRange: UInt32 {
        case automatic = 0

        case full = 1

        case limited = 2
    }

    public enum AutoRotatePolicy: UInt32 {
        case never = 0

        case inTabletMode = 1

        case always = 2
    }

    public enum ColorProfileSource: UInt32 {
        case srgb = 0

        case icc = 1

        case edid = 2
    }

    public enum ColorPowerTradeoff: UInt32 {
        /// prefer efficiency and performance
        case efficiency = 0

        /// prefer accuracy
        case accuracy = 1
    }

    public enum EdrPolicy: UInt32 {
        case never = 0

        case always = 1
    }

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

    public enum Event: MessageProtocol {
        /// Geometric Properties Of The Output
        /// 
        /// The geometry event describes geometric properties of the output.
        /// The event is sent when binding to the output object and whenever
        /// any of the properties change.
        case geometry(x: Int32, y: Int32, physicalWidth: Int32, physicalHeight: Int32, subpixel: Int32, make: String, model: String, transform: Int32)

        /// Current Mode
        /// 
        /// This event describes the mode currently in use for this head. It is only
        /// sent if the output is enabled.
        case currentMode(mode: KdeOutputDeviceModeV2)

        /// Advertise Available Output Modes And Current One
        /// 
        /// The mode event describes an available mode for the output.
        /// When the client binds to the output_device object, the server sends this
        /// event once for every available mode the output_device can be operated by.
        /// There will always be at least one event sent out on initial binding,
        /// which represents the current mode.
        /// Later if an output changes, its mode event is sent again for the
        /// eventual added modes and lastly the current mode. In other words, the
        /// current mode is always represented by the latest event sent with the current
        /// flag set.
        /// The size of a mode is given in physical hardware units of the output device.
        /// This is not necessarily the same as the output size in the global compositor
        /// space. For instance, the output may be scaled, as described in
        /// kde_output_device_v2.scale, or transformed, as described in
        /// kde_output_device_v2.transform.
        case mode(mode: KdeOutputDeviceModeV2)

        /// Sent All Information About Output
        /// 
        /// This event is sent after all other properties have been
        /// sent on binding to the output object as well as after any
        /// other output property change have been applied later on.
        /// This allows to see changes to the output properties as atomic,
        /// even if multiple events successively announce them.
        case done

        /// Output Scaling Properties
        /// 
        /// This event contains scaling geometry information
        /// that is not in the geometry event. It may be sent after
        /// binding the output object or if the output scale changes
        /// later. If it is not sent, the client should assume a
        /// scale of 1.
        /// A scale larger than 1 means that the compositor will
        /// automatically scale surface buffers by this amount
        /// when rendering. This is used for high resolution
        /// displays where applications rendering at the native
        /// resolution would be too small to be legible.
        /// It is intended that scaling aware clients track the
        /// current output of a surface, and if it is on a scaled
        /// output it should use wl_surface.set_buffer_scale with
        /// the scale of the output. That way the compositor can
        /// avoid scaling the surface, and the client can supply
        /// a higher detail image.
        case scale(factor: Double)

        /// Advertise Edid Data For The Output
        /// 
        /// The edid event encapsulates the EDID data for the outputdevice.
        /// The event is sent when binding to the output object. The EDID
        /// data may be empty, in which case this event is sent anyway.
        /// If the EDID information is empty, you can fall back to the name
        /// et al. properties of the outputdevice.
        case edid(raw: String)

        /// Output Is Enabled Or Disabled
        /// 
        /// The enabled event notifies whether this output is currently
        /// enabled and used for displaying content by the server.
        /// The event is sent when binding to the output object and
        /// whenever later on an output changes its state by becoming
        /// enabled or disabled.
        case enabled(enabled: Int32)

        /// A Unique Id For This Outputdevice
        /// 
        /// The uuid can be used to identify the output. It's controlled by
        /// the server entirely. The server should make sure the uuid is
        /// persistent across restarts. An empty uuid is considered invalid.
        case uuid(uuid: String)

        /// Serial Number
        /// 
        /// Serial ID of the monitor, sent on startup before the first done event.
        case serialNumber(serialnumber: String)

        /// Eisa Id
        /// 
        /// EISA ID of the monitor, sent on startup before the first done event.
        case eisaId(eisaid: String)

        /// Capability Flags
        /// 
        /// What capabilities this device has, sent on startup before the first
        /// done event.
        case capabilities(flags: Capability)

        /// Overscan
        /// 
        /// Overscan value of the monitor in percent, sent on startup before the
        /// first done event.
        case overscan(overscan: UInt32)

        /// Variable Refresh Rate Policy
        /// 
        /// What policy the compositor will employ regarding its use of variable
        /// refresh rate.
        case vrrPolicy(vrrPolicy: VrrPolicy)

        /// Rgb Range
        /// 
        /// What rgb range the compositor is using for this output
        case rgbRange(rgbRange: RgbRange)

        /// Output's Name
        /// 
        /// Name of the output, it's useful to cross-reference to an zxdg_output_v1 and ultimately QScreen
        case name(name: String)

        /// If Hdr Is Enabled
        /// 
        /// Whether or not high dynamic range is enabled for this output
        case highDynamicRange(hdrEnabled: UInt32)

        /// The Brightness Of Sdr If Hdr Is Enabled
        /// 
        /// If high dynamic range is used, this value defines the brightness in nits for content
        /// that's in standard dynamic range format. Note that while the value is in nits, that
        /// doesn't necessarily translate to the same brightness on the screen.
        case sdrBrightness(sdrBrightness: UInt32)

        /// If Wcg Is Enabled
        /// 
        /// Whether or not the use of a wide color gamut is enabled for this output
        case wideColorGamut(wcgEnabled: UInt32)

        /// Describes When Auto Rotate Is Used
        /// 
        /// 
        case autoRotatePolicy(policy: AutoRotatePolicy)

        /// Describes The Path To The Icc Profile Used In Sdr Mode
        /// 
        /// 
        case iccProfilePath(profilePath: String)

        /// Metadata About The Screen's Brightness Limits
        /// 
        /// 
        case brightnessMetadata(maxPeakBrightness: UInt32, maxFrameAverageBrightness: UInt32, minBrightness: UInt32)

        /// Overrides For The Screen's Brightness Limits
        /// 
        /// 
        case brightnessOverrides(maxPeakBrightness: Int32, maxAverageBrightness: Int32, minBrightness: Int32)

        /// Describes Which Gamut Is Assumed For Srgb Applications
        /// 
        /// This can be used to provide the colors users assume sRGB applications should have based on the
        /// default experience on many modern sRGB screens.
        case sdrGamutWideness(gamutWideness: UInt32)

        /// Describes Which Source The Compositor Uses For The Color Profile On An Output In Sdr Mode
        /// 
        /// 
        case colorProfileSource(source: ColorProfileSource)

        /// Brightness Multiplier
        /// 
        /// This is the brightness modifier of the output. It doesn't specify
        /// any absolute values, but is merely a multiplier on top of other
        /// brightness values, like sdr_brightness and brightness_metadata.
        /// 0 is the minimum brightness (not completely dark) and 10000 is
        /// the maximum brightness.
        /// This is currently only supported / meaningful while HDR is active.
        case brightness(brightness: UInt32)

        /// The Preferred Color/Power Tradeoff
        /// 
        /// 
        case colorPowerTradeoff(preference: ColorPowerTradeoff)

        /// Dimming Multiplier
        /// 
        /// This is the dimming multiplier of the output. This is similar to
        /// the brightness setting, except it's meant to be a temporary setting
        /// only, not persistent and may be implemented differently depending
        /// on the display.
        /// 0 is the minimum dimming factor (not completely dark) and 10000
        /// means the output is not dimmed.
        case dimming(multiplier: UInt32)

        /// Source Output For Mirroring
        /// 
        /// 
        case replicationSource(source: String)

        /// If Ddc/Ci Should Be Used To Control Brightness Etc.
        /// 
        /// If the ddc_ci capability is present, this determines if settings
        /// such as brightness, contrast or others should be set using DDC/CI.
        case ddcCiAllowed(allowed: UInt32)

        /// Override Max Bpc
        /// 
        /// This limits the amount of bits per color that are sent to the display.
        case maxBitsPerColor(maxBpc: UInt32)

        /// Range Of Max Bits Per Color Value
        /// 
        /// 
        case maxBitsPerColorRange(minValue: UInt32, maxValue: UInt32)

        /// If And To What Value Automatic Max Bpc Is Limited
        /// 
        /// 
        case automaticMaxBitsPerColorLimit(maxBpcLimit: UInt32)

        /// When The Compositor May Apply Edr
        /// 
        /// When EDR is enabled, the compositor may increase the backlight beyond
        /// the user-specified setting, in order to present HDR content on displays
        /// without native HDR support.
        /// This will usually result in better visuals, but also increases battery
        /// usage.
        case edrPolicy(policy: EdrPolicy)

        /// Sharpness Strength
        /// 
        /// This is the sharpness modifier of the output.
        /// 0 is sharpness disabled and 10000 is the maximum sharpness
        case sharpness(sharpness: UInt32)

        /// Output Priority
        /// 
        /// Describes the position of the output in the output order list,
        /// with lower values being earlier in the list. There's no specific
        /// value the list has to start at, this value is only used in sorting
        /// outputs.
        /// Note that the output order protocol is not sufficient for this,
        /// as an output may not be in the output order if it's disabled or
        /// mirroring another screen.
        case priority(priority: UInt32)

        /// Whether Or Not Automatic Brightness Is Enabled
        /// 
        /// 
        case autoBrightness(enabled: UInt32)

        /// The Output Has Been Removed
        /// 
        /// This event is sent when the output device is disconnected and no new
        /// updates will be sent. The client should call the kde_output_device_v2.release
        /// request after receiving this event.
        case removed

        /// Describes The Path To The Icc Profile Used In Hdr Mode
        /// 
        /// 
        case hdrIccProfilePath(profilePath: String)

        /// Describes Which Source The Compositor Uses For The Color Profile On An Output In Hdr Mode
        /// 
        /// 
        case hdrColorProfileSource(source: ColorProfileSource)

        /// Allowed Level Of Adaptive Backlight Modulation
        /// 
        /// Adaptive backlight modulation is a feature that reduces the backlight
        /// and increases contrast of colors on the screen to improve power usage.
        case abmLevel(level: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.geometry(x: r.int(), y: r.int(), physicalWidth: r.int(), physicalHeight: r.int(), subpixel: r.int(), make: r.string(), model: r.string(), transform: r.int())
            case 1:
                self = Self.currentMode(mode: r.object(type: KdeOutputDeviceModeV2.self))
            case 2:
                self = Self.mode(mode: r.newId(type: KdeOutputDeviceModeV2.self))
            case 3:
                self = Self.done
            case 4:
                self = Self.scale(factor: r.fixed())
            case 5:
                self = Self.edid(raw: r.string())
            case 6:
                self = Self.enabled(enabled: r.int())
            case 7:
                self = Self.uuid(uuid: r.string())
            case 8:
                self = Self.serialNumber(serialnumber: r.string())
            case 9:
                self = Self.eisaId(eisaid: r.string())
            case 10:
                self = Self.capabilities(flags: try _parseEnum(into: Capability.self, r.uint()))
            case 11:
                self = Self.overscan(overscan: r.uint())
            case 12:
                self = Self.vrrPolicy(vrrPolicy: try _parseEnum(into: VrrPolicy.self, r.uint()))
            case 13:
                self = Self.rgbRange(rgbRange: try _parseEnum(into: RgbRange.self, r.uint()))
            case 14:
                self = Self.name(name: r.string())
            case 15:
                self = Self.highDynamicRange(hdrEnabled: r.uint())
            case 16:
                self = Self.sdrBrightness(sdrBrightness: r.uint())
            case 17:
                self = Self.wideColorGamut(wcgEnabled: r.uint())
            case 18:
                self = Self.autoRotatePolicy(policy: try _parseEnum(into: AutoRotatePolicy.self, r.uint()))
            case 19:
                self = Self.iccProfilePath(profilePath: r.string())
            case 20:
                self = Self.brightnessMetadata(maxPeakBrightness: r.uint(), maxFrameAverageBrightness: r.uint(), minBrightness: r.uint())
            case 21:
                self = Self.brightnessOverrides(maxPeakBrightness: r.int(), maxAverageBrightness: r.int(), minBrightness: r.int())
            case 22:
                self = Self.sdrGamutWideness(gamutWideness: r.uint())
            case 23:
                self = Self.colorProfileSource(source: try _parseEnum(into: ColorProfileSource.self, r.uint()))
            case 24:
                self = Self.brightness(brightness: r.uint())
            case 25:
                self = Self.colorPowerTradeoff(preference: try _parseEnum(into: ColorPowerTradeoff.self, r.uint()))
            case 26:
                self = Self.dimming(multiplier: r.uint())
            case 27:
                self = Self.replicationSource(source: r.string())
            case 28:
                self = Self.ddcCiAllowed(allowed: r.uint())
            case 29:
                self = Self.maxBitsPerColor(maxBpc: r.uint())
            case 30:
                self = Self.maxBitsPerColorRange(minValue: r.uint(), maxValue: r.uint())
            case 31:
                self = Self.automaticMaxBitsPerColorLimit(maxBpcLimit: r.uint())
            case 32:
                self = Self.edrPolicy(policy: try _parseEnum(into: EdrPolicy.self, r.uint()))
            case 33:
                self = Self.sharpness(sharpness: r.uint())
            case 34:
                self = Self.priority(priority: r.uint())
            case 35:
                self = Self.autoBrightness(enabled: r.uint())
            case 36:
                self = Self.removed
            case 37:
                self = Self.hdrIccProfilePath(profilePath: r.string())
            case 38:
                self = Self.hdrColorProfileSource(source: try _parseEnum(into: ColorProfileSource.self, r.uint()))
            case 39:
                self = Self.abmLevel(level: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Output Mode
/// 
/// This object describes an output mode.
/// Some heads don't support output modes, in which case modes won't be
/// advertised.
/// Properties sent via this interface are applied atomically via the
/// kde_output_device.done event. No guarantees are made regarding the order
/// in which properties are sent.
public final class KdeOutputDeviceModeV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_device_mode_v2",
            version: 22,
            events: [
                Message(
                    name: "size",
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
                Message(
                    name: "refresh",
                    arguments: [
                        Argument(
                            name: "refresh",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "preferred",
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
                    name: "flags",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 19
                )
                ,
            ],
        )
    
    public static let `protocol`: Protocol = KdeOutputDeviceV2Protocol
    
    public enum Flags: UInt32 {
        case custom = 1

        case reducedBlanking = 2
    }

    public enum Event: MessageProtocol {
        /// Mode Size
        /// 
        /// This event describes the mode size. The size is given in physical
        /// hardware units of the output device. This is not necessarily the same as
        /// the output size in the global compositor space. For instance, the output
        /// may be scaled or transformed.
        case size(width: Int32, height: Int32)

        /// Mode Refresh Rate
        /// 
        /// This event describes the mode's fixed vertical refresh rate. It is only
        /// sent if the mode has a fixed refresh rate.
        case refresh(refresh: Int32)

        /// Mode Is Preferred
        /// 
        /// This event advertises this mode as preferred.
        case preferred

        /// The Mode Has Been Destroyed
        /// 
        /// The compositor will destroy the object immediately after sending this
        /// event, so it will become invalid and the client should release any
        /// resources associated with it.
        case removed

        /// Mode Flags
        /// 
        /// This event describes the mode's flags.
        case flags(flags: Flags)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.size(width: r.int(), height: r.int())
            case 1:
                self = Self.refresh(refresh: r.int())
            case 2:
                self = Self.preferred
            case 3:
                self = Self.removed
            case 4:
                self = Self.flags(flags: try _parseEnum(into: Flags.self, r.uint()))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let KdeOutputDeviceV2Protocol = Protocol(
        name: "kde_output_device_v2",
        interfaces: [
            KdeOutputDeviceRegistryV2.interface,
KdeOutputDeviceV2.interface,
KdeOutputDeviceModeV2.interface
        ]
    )

/// Configuration Of Server Outputs Through Clients
/// 
/// This interface enables clients to set properties of output devices for screen
/// configuration purposes via the server. To this end output devices are referenced
/// by global kde_output_device_v2 objects.
/// outputmanagement (wl_global)
/// --------------------------
/// request:
/// * create_configuration -> outputconfiguration (wl_resource)
/// outputconfiguration (wl_resource)
/// --------------------------
/// requests:
/// * enable(outputdevice, bool)
/// * mode(outputdevice, mode)
/// * transformation(outputdevice, flag)
/// * position(outputdevice, x, y)
/// * apply
/// events:
/// * applied
/// * failed
/// The server registers one outputmanagement object as a global object. In order
/// to configure outputs a client requests create_configuration, which provides a
/// resource referencing an outputconfiguration for one-time configuration. That
/// way the server knows which requests belong together and can group them by that.
/// On the outputconfiguration object the client calls for each output whether the
/// output should be enabled, which mode should be set (by referencing the mode from
/// the list of announced modes) and the output's global position. Once all outputs
/// are configured that way, the client calls apply.
/// At that point and not earlier the server should try to apply the configuration.
/// If this succeeds the server emits the applied signal, otherwise the failed
/// signal, such that the configuring client is noticed about the success of its
/// configuration request.
/// Through this design the interface enables atomic output configuration changes if
/// internally supported by the server.
/// Warning! The protocol described in this file is a desktop environment implementation
/// detail. Regular clients must not use this protocol. Backward incompatible
/// changes may be added without bumping the major version of the extension.
public final class KdeOutputManagementV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_management_v2",
            version: 21,
            requests: [
                Message(
                    name: "create_configuration",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "kde_output_configuration_v2",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "create_mode_list",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "kde_mode_list_v2",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Provide Outputconfiguration Object For Configuring Outputs
    /// 
    /// Request an outputconfiguration object through which the client can configure
    /// output devices.
    public func createConfiguration(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeOutputConfigurationV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeOutputConfigurationV2.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
        ])
        return id
    }

    /// Create A List Of Custom Modes
    /// 
    /// For details, see the description of kde_mode_list_v2 and
    /// kde_output_configuration_v2.set_custom_modes.
    public func createModeList(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeModeListV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeModeListV2.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = KdeOutputManagementV2Protocol
    
    public typealias Event = NoEvent
}

/// Configure Single Output Devices
/// 
/// outputconfiguration is a client-specific resource that can be used to ask
/// the server to apply changes to available output devices.
/// The client receives a list of output devices from the registry. When it wants
/// to apply new settings, it creates a configuration object from the
/// outputmanagement global, writes changes through this object's enable, scale,
/// transform and mode calls. It then asks the server to apply these settings in
/// an atomic fashion, for example through Linux' DRM interface.
/// The server signals back whether the new settings have applied successfully
/// or failed to apply. outputdevice objects are updated after the changes have been
/// applied to the hardware and before the server side sends the applied event.
public final class KdeOutputConfigurationV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_configuration_v2",
            version: 21,
            requests: [
                Message(
                    name: "enable",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "enable",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "mode",
                            type: .object,
                            interface: "kde_output_device_mode_v2",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "transform",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "transform",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "position",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
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
                    ],
                )
                ,
                Message(
                    name: "scale",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "scale",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "apply",
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
                Message(
                    name: "overscan",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "overscan",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_vrr_policy",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "policy",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_rgb_range",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "rgb_range",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_primary_output",
                    arguments: [
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "set_priority",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "priority",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "set_high_dynamic_range",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "enable_hdr",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "set_sdr_brightness",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "sdr_brightness",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "set_wide_color_gamut",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "enable_wcg",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "set_auto_rotate_policy",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "policy",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 5
                )
                ,
                Message(
                    name: "set_icc_profile_path",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "profile_path",
                            type: .string,
                        )
                        ,
                    ],
                    since: 6
                )
                ,
                Message(
                    name: "set_brightness_overrides",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "max_peak_brightness",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "max_frame_average_brightness",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "min_brightness",
                            type: .int,
                        )
                        ,
                    ],
                    since: 7
                )
                ,
                Message(
                    name: "set_sdr_gamut_wideness",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "gamut_wideness",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 7
                )
                ,
                Message(
                    name: "set_color_profile_source",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "color_profile_source",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 8
                )
                ,
                Message(
                    name: "set_brightness",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "brightness",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 9
                )
                ,
                Message(
                    name: "set_color_power_tradeoff",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "preference",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 10
                )
                ,
                Message(
                    name: "set_dimming",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "multiplier",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 11
                )
                ,
                Message(
                    name: "set_replication_source",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "source",
                            type: .string,
                        )
                        ,
                    ],
                    since: 13
                )
                ,
                Message(
                    name: "set_ddc_ci_allowed",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "allowed",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 14
                )
                ,
                Message(
                    name: "set_max_bits_per_color",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "max_bpc",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 15
                )
                ,
                Message(
                    name: "set_edr_policy",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "policy",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 16
                )
                ,
                Message(
                    name: "set_sharpness",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "sharpness",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 17
                )
                ,
                Message(
                    name: "set_custom_modes",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "modes",
                            type: .object,
                            interface: "kde_mode_list_v2",
                        )
                        ,
                    ],
                    since: 18
                )
                ,
                Message(
                    name: "set_auto_brightness",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "enabled",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 19
                )
                ,
                Message(
                    name: "set_hdr_icc_profile_path",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "profile_path",
                            type: .string,
                        )
                        ,
                    ],
                    since: 20
                )
                ,
                Message(
                    name: "set_hdr_color_profile_source",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "color_profile_source",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 20
                )
                ,
                Message(
                    name: "set_abm_level",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "kde_output_device_v2",
                        )
                        ,
                        Argument(
                            name: "level",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 21
                )
                ,
            ],
            events: [
                Message(
                    name: "applied",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "failed",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "failure_reason",
                    arguments: [
                        Argument(
                            name: "reason",
                            type: .string,
                        )
                        ,
                    ],
                    since: 12
                )
                ,
            ],
        )
    /// Enable Or Disable An Output
    /// 
    /// Mark the output as enabled or disabled.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice to be en- or disabled
    ///   - enable: 1 to enable or 0 to disable this output
    public func enable(outputdevice: KdeOutputDeviceV2, enable: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(outputdevice.id),
            .int(enable),
        ])
    }

    /// Switch Output-Device To Mode
    /// 
    /// Sets the mode for a given output.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this mode change applies to
    ///   - mode: the mode to apply
    public func mode(outputdevice: KdeOutputDeviceV2, mode: KdeOutputDeviceModeV2) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(outputdevice.id),
            .object(mode.id),
        ])
    }

    /// Transform Output-Device
    /// 
    /// Sets the transformation for a given output.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this transformation change applies to
    ///   - transform: transform enum
    public func transform(outputdevice: KdeOutputDeviceV2, transform: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(outputdevice.id),
            .int(transform),
        ])
    }

    /// Position Output In Global Space
    /// 
    /// Sets the position for this output device. (x,y) describe the top-left corner
    /// of the output in global space, whereby the origin (0,0) of the global space
    /// has to be aligned with the top-left corner of the most left and in case this
    /// does not define a single one the top output.
    /// There may be no gaps or overlaps between outputs, i.e. the outputs are
    /// stacked horizontally, vertically, or both on each other.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this position applies to
    ///   - x: position on the x-axis
    ///   - y: position on the y-axis
    public func position(outputdevice: KdeOutputDeviceV2, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .object(outputdevice.id),
            .int(x),
            .int(y),
        ])
    }

    /// Set Scaling Factor Of This Output
    /// 
    /// Sets the scaling factor for this output device.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this scale change applies to
    ///   - scale: scaling factor
    public func scale(outputdevice: KdeOutputDeviceV2, scale: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(outputdevice.id),
            .fixed(scale),
        ])
    }

    /// Apply Configuration Changes To All Output Devices
    /// 
    /// Asks the server to apply property changes requested through this outputconfiguration
    /// object to all outputs on the server side.
    /// The output configuration can be applied only once. The already_applied protocol error
    /// will be posted if the apply request is called the second time.
    public func apply() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
        ])
    }

    /// Release The Outputconfiguration Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 6, [
        ])
    }

    /// Set Overscan Value
    /// 
    /// Set the overscan value of this output device with a value in percent.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice overscan applies to
    ///   - overscan: overscan value
    public func overscan(outputdevice: KdeOutputDeviceV2, overscan: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .object(outputdevice.id),
            .uint(overscan),
        ])
    }

    /// Set The Vrr Policy
    /// 
    /// Set what policy the compositor should employ regarding its use of
    /// variable refresh rate.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this VRR policy applies to
    ///   - policy: the vrr policy to apply
    public func setVrrPolicy(outputdevice: KdeOutputDeviceV2, policy: VrrPolicy) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .object(outputdevice.id),
            .uint(policy.rawValue),
        ])
    }

    /// Rgb Range
    /// 
    /// Whether full or limited color range should be used
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice the rgb range applies to
    public func setRgbRange(outputdevice: KdeOutputDeviceV2, rgbRange: RgbRange) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
            .object(outputdevice.id),
            .uint(rgbRange.rawValue),
        ])
    }

    /// Select Which Primary Output To Use
    /// 
    /// 
    /// 
    /// - Parameters:
    public func setPrimaryOutput(output: KdeOutputDeviceV2) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 10, [
            .object(output.id),
        ])
    }

    /// Set The Order Of Outputs
    /// 
    /// Set the position of the output in the output order list, with lower values
    /// being earlier in the list. There's no specific value the list has to start
    /// at, this value is only used in sorting outputs.
    /// The order of outputs can be used to assign desktop environment components
    /// to a specific screen, see kde_output_order_v1 and kde-output-device-v2 for
    /// details. Note that for consistent behavior, the priority value needs to be
    /// unique among all enabled outputs.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice the index applies to
    ///   - priority: the priority of the output
    public func setPriority(outputdevice: KdeOutputDeviceV2, priority: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 11, [
            .object(outputdevice.id),
            .uint(priority),
        ])
    }

    /// Change If Hdr Should Be Enabled
    /// 
    /// Sets whether or not the output should be set to HDR mode.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - enableHdr: 1 to enable, 0 to disable hdr
    public func setHighDynamicRange(outputdevice: KdeOutputDeviceV2, enableHdr: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 12, [
            .object(outputdevice.id),
            .uint(enableHdr),
        ])
    }

    /// Set The Brightness For Sdr Content
    /// 
    /// Sets the brightness of standard dynamic range content in nits. Only has an effect while the output is in HDR mode.
    /// Note that while the value is in nits, that doesn't necessarily translate to the same brightness on the screen.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setSdrBrightness(outputdevice: KdeOutputDeviceV2, sdrBrightness: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 13, [
            .object(outputdevice.id),
            .uint(sdrBrightness),
        ])
    }

    /// Change If A Wide Color Gamut Should Be Used
    /// 
    /// Whether or not the output should use a wide color gamut
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - enableWcg: 1 to enable, 0 to disable wcg
    public func setWideColorGamut(outputdevice: KdeOutputDeviceV2, enableWcg: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 14, [
            .object(outputdevice.id),
            .uint(enableWcg),
        ])
    }

    /// Change When Auto Rotate Should Be Used
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setAutoRotatePolicy(outputdevice: KdeOutputDeviceV2, policy: AutoRotatePolicy) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        connection.send(self, 15, [
            .object(outputdevice.id),
            .uint(policy.rawValue),
        ])
    }

    /// Change The Used Icc Profile For Sdr Mode
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setIccProfilePath(outputdevice: KdeOutputDeviceV2, profilePath: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 6 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 6) }
        connection.send(self, 16, [
            .object(outputdevice.id),
            .string(profilePath),
        ])
    }

    /// Override Metadata About The Screen's Brightness Limits
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - maxPeakBrightness: -1 for not overriding, or positive values in nits
    ///   - maxFrameAverageBrightness: -1 for not overriding, or positive values in nits
    ///   - minBrightness: -1 for not overriding, or positive values in 0.0001 nits
    public func setBrightnessOverrides(outputdevice: KdeOutputDeviceV2, maxPeakBrightness: Int32, maxFrameAverageBrightness: Int32, minBrightness: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 7 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 7) }
        connection.send(self, 17, [
            .object(outputdevice.id),
            .int(maxPeakBrightness),
            .int(maxFrameAverageBrightness),
            .int(minBrightness),
        ])
    }

    /// Describes Which Gamut Is Assumed For Srgb Applications
    /// 
    /// This can be used to provide the colors users assume sRGB applications should have based on the
    /// default experience on many modern sRGB screens.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - gamutWideness: 0 means rec.709 primaries, 10000 means native primaries
    public func setSdrGamutWideness(outputdevice: KdeOutputDeviceV2, gamutWideness: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 7 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 7) }
        connection.send(self, 18, [
            .object(outputdevice.id),
            .uint(gamutWideness),
        ])
    }

    /// Which Source The Compositor Should Use For The Color Profile On An Output In Sdr Mode
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - colorProfileSource: the color profile source
    public func setColorProfileSource(outputdevice: KdeOutputDeviceV2, colorProfileSource: ColorProfileSource) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 8 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 8) }
        connection.send(self, 19, [
            .object(outputdevice.id),
            .uint(colorProfileSource.rawValue),
        ])
    }

    /// Brightness Multiplier
    /// 
    /// Set the brightness modifier of the output. It doesn't specify
    /// any absolute values, but is merely a multiplier on top of other
    /// brightness values, like sdr_brightness and brightness_metadata.
    /// 0 is the minimum brightness (not completely dark) and 10000 is
    /// the maximum brightness.
    /// This is supported while HDR is active in versions 8 and below,
    /// or when the device supports the "brightness" capability in
    /// versions 9 and above.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - brightness: brightness in 0-10000
    public func setBrightness(outputdevice: KdeOutputDeviceV2, brightness: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 9 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 9) }
        connection.send(self, 20, [
            .object(outputdevice.id),
            .uint(brightness),
        ])
    }

    /// Set The Preferred Color/Power Tradeoff
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setColorPowerTradeoff(outputdevice: KdeOutputDeviceV2, preference: ColorPowerTradeoff) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 10 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 10) }
        connection.send(self, 21, [
            .object(outputdevice.id),
            .uint(preference.rawValue),
        ])
    }

    /// Dimming Multiplier
    /// 
    /// Set the dimming multiplier of the output. This is similar to the
    /// brightness setting, except it's meant to be a temporary setting
    /// only, not persistent and may be implemented differently depending
    /// on the display.
    /// 0 is the minimum dimming factor (not completely dark) and 10000
    /// means the output is not dimmed.
    /// This is supported only when the "brightness" capability is
    /// also supported.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - multiplier: multiplier in 0-10000
    public func setDimming(outputdevice: KdeOutputDeviceV2, multiplier: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 11 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 11) }
        connection.send(self, 22, [
            .object(outputdevice.id),
            .uint(multiplier),
        ])
    }

    /// Source Output For Mirroring
    /// 
    /// Set the source output that the outputdevice should mirror its
    /// viewport from.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - source: uuid of the source output
    public func setReplicationSource(outputdevice: KdeOutputDeviceV2, source: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 13 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 13) }
        connection.send(self, 23, [
            .object(outputdevice.id),
            .string(source),
        ])
    }

    /// If Ddc/Ci Should Be Used To Control Brightness Etc.
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - allowed: 1 if allowed, 0 if disabled
    public func setDdcCiAllowed(outputdevice: KdeOutputDeviceV2, allowed: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 14 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 14) }
        connection.send(self, 24, [
            .object(outputdevice.id),
            .uint(allowed),
        ])
    }

    /// Override The Max Bpc
    /// 
    /// This limits the amount of bits per color that are sent to the display.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - maxBpc: 0 for the default / automatic
    public func setMaxBitsPerColor(outputdevice: KdeOutputDeviceV2, maxBpc: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 15 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 15) }
        connection.send(self, 25, [
            .object(outputdevice.id),
            .uint(maxBpc),
        ])
    }

    /// Set When The Compositor May Apply Edr
    /// 
    /// When EDR is enabled, the compositor may increase the backlight beyond
    /// the user-specified setting, in order to present HDR content on displays
    /// without native HDR support.
    /// This will usually result in better visuals, but also increases battery
    /// usage.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setEdrPolicy(outputdevice: KdeOutputDeviceV2, policy: EdrPolicy) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 16 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 16) }
        connection.send(self, 26, [
            .object(outputdevice.id),
            .uint(policy.rawValue),
        ])
    }

    /// Sharpness Strength
    /// 
    /// This is the sharpness modifier of the output.
    /// 0 is sharpness disabled and 10000 is the maximum sharpness
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - sharpness: sharpness in 0-10000
    public func setSharpness(outputdevice: KdeOutputDeviceV2, sharpness: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 17 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 17) }
        connection.send(self, 27, [
            .object(outputdevice.id),
            .uint(sharpness),
        ])
    }

    /// Set The Custom Mode List
    /// 
    /// Set the list of custom modes for this output. The compositor
    /// will in response generate the requested modes and add them to
    /// the output (or delete ones no longer in the list).
    /// This can be useful for overclocking displays, or for working
    /// around broken EDIDs.
    /// Note that there is no guarantee for any custom mode to
    /// actually work, or even to leave the display undamaged (in the
    /// case of CRTs). It's entirely the responsibility of the user
    /// to ensure each added mode is the right one for their display.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setCustomModes(outputdevice: KdeOutputDeviceV2, modes: KdeModeListV2) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 18 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 18) }
        connection.send(self, 28, [
            .object(outputdevice.id),
            .object(modes.id),
        ])
    }

    /// Whether Or Not Automatic Brightness Is Enabled
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - enabled: 1 for enabled, 0 for disabled
    public func setAutoBrightness(outputdevice: KdeOutputDeviceV2, enabled: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 19 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 19) }
        connection.send(self, 29, [
            .object(outputdevice.id),
            .uint(enabled),
        ])
    }

    /// Change The Used Icc Profile For Hdr Mode
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    public func setHdrIccProfilePath(outputdevice: KdeOutputDeviceV2, profilePath: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 20 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 20) }
        connection.send(self, 30, [
            .object(outputdevice.id),
            .string(profilePath),
        ])
    }

    /// Which Source The Compositor Should Use For The Color Profile On An Output In Hdr Mode
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - colorProfileSource: the color profile source
    public func setHdrColorProfileSource(outputdevice: KdeOutputDeviceV2, colorProfileSource: ColorProfileSource) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 20 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 20) }
        connection.send(self, 31, [
            .object(outputdevice.id),
            .uint(colorProfileSource.rawValue),
        ])
    }

    /// Set The Allowed Level Of Adaptive Backlight Modulation
    /// 
    /// Adaptive backlight modulation is a feature that reduces the backlight
    /// and increases contrast of colors on the screen to improve power usage.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this setting applies to
    ///   - level: 0 is off, 4 is the maximum level
    public func setAbmLevel(outputdevice: KdeOutputDeviceV2, level: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 21 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 21) }
        connection.send(self, 32, [
            .object(outputdevice.id),
            .uint(level),
        ])
    }

    
    public static let `protocol`: Protocol = KdeOutputManagementV2Protocol
    
    public enum Error: UInt32 {
        /// the config is already applied
        case alreadyApplied = 0
    }

    public enum VrrPolicy: UInt32 {
        case never = 0

        case always = 1

        case automatic = 2
    }

    public enum RgbRange: UInt32 {
        case automatic = 0

        case full = 1

        case limited = 2
    }

    public enum AutoRotatePolicy: UInt32 {
        case never = 0

        case inTabletMode = 1

        case always = 2
    }

    public enum ColorProfileSource: UInt32 {
        case srgb = 0

        case icc = 1

        case edid = 2
    }

    public enum ColorPowerTradeoff: UInt32 {
        /// prefer efficiency and performance
        case efficiency = 0

        /// prefer accuracy
        case accuracy = 1
    }

    public enum EdrPolicy: UInt32 {
        case never = 0

        case always = 1
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

    public enum Event: MessageProtocol {
        /// Configuration Changes Have Been Applied
        /// 
        /// Sent after the server has successfully applied the changes.
        /// .
        case applied

        /// Configuration Changes Failed To Apply
        /// 
        /// Sent if the server rejects the changes or failed to apply them.
        case failed

        /// Reason For Failure
        /// 
        /// Describes why applying the output configuration failed. Is only
        /// sent before the failure event.
        case failureReason(reason: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.applied
            case 1:
                self = Self.failed
            case 2:
                self = Self.failureReason(reason: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// A List Of Custom Modes
/// 
/// This list is populated by first setting each relevant property,
/// and then calling add_mode to add a mode with these properties.
/// One would for example call
/// - set_resolution
/// - set_refresh_rate
/// - set_reduced_blanking
/// - add_mode
/// add_mode does not reset the properties that were previously set,
/// they are valid until the object is destroyed.
/// The compositor may additionally have sensible defaults for some
/// properties like reduced_blanking, but for consistent results,
/// it's best to always set each known property every time.
/// The parameters resolution and refresh rate are required, if they
/// are not set, the missing_parameters error will be emitted.
public final class KdeModeListV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_mode_list_v2",
            version: 20,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "add_mode",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_resolution",
                    arguments: [
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
                Message(
                    name: "set_refresh_rate",
                    arguments: [
                        Argument(
                            name: "rate",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_reduced_blanking",
                    arguments: [
                        Argument(
                            name: "reduced",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Mode List Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Add The Current Mode Configuration To The List
    /// 
    /// 
    public func addMode() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// 
    /// - Parameters:
    public func setResolution(width: UInt32, height: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .uint(width),
            .uint(height),
        ])
    }

    /// 
    /// - Parameters:
    ///   - rate: in milliHz
    public func setRefreshRate(rate: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(rate),
        ])
    }

    /// Whether Or Not The Mode Should Have Reduced Blanking
    /// 
    /// Reduced blanking is an optimization that can reduce bandwidth / timing
    /// requirements for a display mode by reducing the time vblank takes.
    /// As not all displays support it, it may be desired to still turn it off
    /// though (like with CRTs, where full blanking is required).
    /// 
    /// - Parameters:
    ///   - reduced: 1 for reduced blanking, 0 for normal vblank duration
    public func setReducedBlanking(reduced: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(reduced),
        ])
    }

    
    public static let `protocol`: Protocol = KdeOutputManagementV2Protocol
    
    public enum Error: UInt32 {
        /// a required parameter wasn't set
        case missingParameters = 0
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


public let KdeOutputManagementV2Protocol = Protocol(
        name: "kde_output_management_v2",
        interfaces: [
            KdeOutputManagementV2.interface,
KdeOutputConfigurationV2.interface,
KdeModeListV2.interface
        ]
    )

/// Announce Order Of Outputs
/// 
/// Announce the order in which desktop environment components should be placed on outputs.
/// The compositor will send the list of outputs when the global is bound and whenever there is a change.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeOutputOrderV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_output_order_v1",
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
                    name: "output",
                    arguments: [
                        Argument(
                            name: "output_name",
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
            ],
        )
    /// Destroy The Output Order Notifier.
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = KdeOutputOrderV1Protocol
    
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

    public enum Event: MessageProtocol {
        /// Output Name
        /// 
        /// Specifies the output identified by their wl_output.name.
        case output(outputName: String)

        /// Done
        /// 
        /// Specifies that the output list is complete. On the next output event, a new list begins.
        case done

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.output(outputName: r.string())
            case 1:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let KdeOutputOrderV1Protocol = Protocol(
        name: "kde_output_order_v1",
        interfaces: [
            KdeOutputOrderV1.interface
        ]
    )

/// Expose Which Is The Primary Display
/// 
/// Protocol for telling which is the primary display among the selection
/// of enabled outputs.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdePrimaryOutputV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_primary_output_v1",
            version: 2,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 2
                )
                ,
            ],
            events: [
                Message(
                    name: "primary_output",
                    arguments: [
                        Argument(
                            name: "output_name",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Primary Output Notifier.
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = KdePrimaryOutputV1Protocol
    
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

    public enum Event: MessageProtocol {
        /// Provide The Current Primary Output's Name
        /// 
        /// Specifies which output is the primary one identified by their uuid. See kde_output_device_v2 uuid event for more information about it.
        case primaryOutput(outputName: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.primaryOutput(outputName: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let KdePrimaryOutputV1Protocol = Protocol(
        name: "kde_primary_output_v1",
        interfaces: [
            KdePrimaryOutputV1.interface
        ]
    )

/// Screen Edge Manager
/// 
/// This interface allows clients to associate actions with screen edges. For
/// example, showing a surface by moving the pointer to a screen edge.
/// Potential ways to trigger the screen edge are subject to compositor
/// policies. As an example, the compositor may consider the screen edge to be
/// triggered if the pointer hits its associated screen border. Other ways may
/// include using touchscreen or touchpad gestures.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeScreenEdgeManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_screen_edge_manager_v1",
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
                    name: "get_auto_hide_screen_edge",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "kde_auto_hide_screen_edge_v1",
                        )
                        ,
                        Argument(
                            name: "border",
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
            ],
        )
    /// Destroy The Screen Edge Manager
    /// 
    /// Destroy the screen edge manager. This doesn't destroy objects created
    /// with this manager.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create An Auto Hide Edge
    /// 
    /// Create a new auto hide screen edge object associated with the specified
    /// surface and the border.
    /// Creating a kde_auto_hide_screen_edge_v1 object does not change the
    /// visibility of the surface. The kde_auto_hide_screen_edge_v1.activate
    /// request must be issued in order to hide the surface.
    /// The "border" argument must be a valid enum entry, otherwise the
    /// invalid_border protocol error is raised.
    /// The invalid_role protocol error will be raised if the specified surface
    /// does not have layer_surface role.
    /// 
    /// - Parameters:
    ///   - border: the associated screen border
    ///   - surface: the surface
    /// 
    /// - Returns: the new screen edge
    public func getAutoHideScreenEdge(border: Border, surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> KdeAutoHideScreenEdgeV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: KdeAutoHideScreenEdgeV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .uint(border.rawValue),
            .object(surface.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = KdeScreenEdgeV1Protocol
    
    public enum Error: UInt32 {
        /// the specified border value is invalid
        case invalidBorder = 0

        /// the surface has invalid role
        case invalidRole = 1

        /// the surface already has a screen edge
        case alreadyConstructed = 2
    }

    public enum Border: UInt32 {
        /// top screen edge
        case top = 1

        /// bottom screen edge
        case bottom = 2

        /// left screen edge
        case `left` = 3

        /// right screen edge
        case `right` = 4
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

/// Auto Hide Screen Edge
/// 
/// The auto hide screen edge object allows to hide the surface and make it
/// visible by triggering the screen edge. The screen edge is inactive and
/// the surface is visible by default.
/// This interface can be used to implement user interface elements such as
/// auto-hide panels or docks.
/// kde_auto_hide_screen_edge_v1.activate activates the screen edge and makes
/// the surface hidden. The surface can be made visible by triggering the
/// screen edge or calling kde_auto_hide_screen_edge_v1.deactivate.
/// If the screen edge has been triggered, it won't be re-activated again.
/// Another kde_auto_hide_screen_edge_v1.activate request must be made by the
/// client to activate the screen edge.
public final class KdeAutoHideScreenEdgeV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "kde_auto_hide_screen_edge_v1",
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
                    name: "deactivate",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "activate",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Auto Hide Screen Edge Object
    /// 
    /// Destroy the auto hide screen edge object. If the screen edge is active,
    /// it will be deactivated and the surface will be made visible.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Deactivate The Screen Edge
    /// 
    /// Deactivate the screen edge. The surface will be made visible.
    public func deactivate() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Activate The Screen Edge
    /// 
    /// Activate the screen edge. The surface will be hidden until the screen
    /// edge is triggered.
    public func activate() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = KdeScreenEdgeV1Protocol
    
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


public let KdeScreenEdgeV1Protocol = Protocol(
        name: "kde_screen_edge_v1",
        interfaces: [
            KdeScreenEdgeManagerV1.interface,
KdeAutoHideScreenEdgeV1.interface
        ]
    )

/// Key States
/// 
/// Keeps track of the states of the different keys that have a state attached to it.
public final class OrgKdeKwinKeystate: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_keystate",
            version: 5,
            requests: [
                Message(
                    name: "fetchStates",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 4
                )
                ,
            ],
            events: [
                Message(
                    name: "stateChanged",
                    arguments: [
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
            ],
        )
    public func fetchstates() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = KeystateProtocol
    
    public enum Key: UInt32 {
        case capslock = 0

        case numlock = 1

        case scrolllock = 2

        case alt = 3

        case control = 4

        case shift = 5

        case meta = 6

        case altgr = 7
    }

    public enum State: UInt32 {
        case unlocked = 0

        case latched = 1

        case locked = 2

        case pressed = 3
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

    public enum Event: MessageProtocol {
        /// Updates The State For A Said Key
        /// 
        /// 
        case statechanged(key: UInt32, state: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.statechanged(key: r.uint(), state: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let KeystateProtocol = Protocol(
        name: "keystate",
        interfaces: [
            OrgKdeKwinKeystate.interface
        ]
    )

public final class OrgKdePlasmaVirtualDesktopManagement: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_virtual_desktop_management",
            version: 4,
            requests: [
                Message(
                    name: "get_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_plasma_virtual_desktop",
                        )
                        ,
                        Argument(
                            name: "desktop_id",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "request_create_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
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
                    name: "request_remove_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "desktop_id",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "desktop_created",
                    arguments: [
                        Argument(
                            name: "desktop_id",
                            type: .string,
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
                    name: "desktop_removed",
                    arguments: [
                        Argument(
                            name: "desktop_id",
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
                    name: "rows",
                    arguments: [
                        Argument(
                            name: "rows",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
            ],
        )
    /// Get The Org_Kde_Plasma_Virtual_Desktop Interface For A Desktop
    /// 
    /// Given the id of a particular virtual desktop, get the corresponding org_kde_plasma_virtual_desktop which represents only the desktop with that id.
    /// Warning! The protocol described in this file is a desktop environment
    /// implementation detail. Regular clients must not use this protocol.
    /// Backward incompatible changes may be added without bumping the major
    /// version of the extension.
    /// 
    /// - Parameters:
    ///   - desktopId: Unique id of the desktop
    public func getVirtualDesktop(desktopId: String, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaVirtualDesktop {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdePlasmaVirtualDesktop.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .string(desktopId),
        ])
        return id
    }

    /// Ask For The Creation Of A New Desktop At A Specified Position
    /// 
    /// Ask the server to create a new virtual desktop, and position it at a specified position. If the position is zero or less, it will be positioned at the beginning, if the position is the count or more, it will be positioned at the end.
    /// 
    /// - Parameters:
    ///   - name: The user readable name we want for the desktop
    ///   - position: The position we want for the desktop
    public func requestCreateVirtualDesktop(name: String, position: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .string(name),
            .uint(position),
        ])
    }

    /// Ask For A Desktop Removal Identified By Id
    /// 
    /// Ask the server to get rid of a virtual desktop, the server may or may not acconsent to the request.
    /// 
    /// - Parameters:
    ///   - desktopId: Unique id of the desktop
    public func requestRemoveVirtualDesktop(desktopId: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .string(desktopId),
        ])
    }

    
    public static let `protocol`: Protocol = OrgKdePlasmaVirtualDesktopProtocol
    
    public enum Event: MessageProtocol {
        /// Emitted When A New Desktop Has Been Created
        /// 
        /// 
        case desktopCreated(desktopId: String, position: UInt32)

        /// Emitted When A Desktop Has Been Removed
        /// 
        /// 
        case desktopRemoved(desktopId: String)

        /// Sent All Information About Desktops
        /// 
        /// This event is sent after all other properties have been sent after
        /// binding to the desktop manager global and after all changes to
        /// org_kde_plasma_virtual_desktop_management and org_kde_plasma_virtual_desktop
        /// properties have been sent.
        /// This allows changes to org_kde_plasma_virtual_desktop_management and
        /// org_kde_plasma_virtual_desktop properties to be seen as atomic, even
        /// if they happen via multiple events.
        case done

        case rows(rows: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.desktopCreated(desktopId: r.string(), position: r.uint())
            case 1:
                self = Self.desktopRemoved(desktopId: r.string())
            case 2:
                self = Self.done
            case 3:
                self = Self.rows(rows: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public final class OrgKdePlasmaVirtualDesktop: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_virtual_desktop",
            version: 4,
            requests: [
                Message(
                    name: "request_activate",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "request_enter_output",
                    arguments: [
                        Argument(
                            name: "output_name",
                            type: .string,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
            ],
            events: [
                Message(
                    name: "desktop_id",
                    arguments: [
                        Argument(
                            name: "desktop_id",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
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
                    name: "activated",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "deactivated",
                    arguments: [
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
                    name: "position",
                    arguments: [
                        Argument(
                            name: "index",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "output_entered",
                    arguments: [
                        Argument(
                            name: "output_name",
                            type: .string,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
            ],
        )
    /// Requests This Desktop To Be Activated
    /// 
    /// Request the server to set the status of this desktop to active: The server is free to consent or deny the request. This will be the new "current" virtual desktop of the system.
    public func requestActivate() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// Requests This Desktop To Be Activated On An Output
    /// 
    /// Request the server to activate the desktop on a given output.
    /// The server may deny the request.
    /// If the request is granted, the server will deactivate the previous desktop on the output.
    /// The server may activate the desktop on other outputs as well.
    /// 
    /// - Parameters:
    ///   - outputName: name of the output
    public func requestEnterOutput(outputName: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 1, [
            .string(outputName),
        ])
    }

    
    public static let `protocol`: Protocol = OrgKdePlasmaVirtualDesktopProtocol
    
    public enum Event: MessageProtocol {
        /// The Desktop Got An Id
        /// 
        /// The format of the id is decided by the compositor implementation. A desktop id univocally identifies a virtual desktop and must be guaranteed to never exist two desktops with the same id. The format of the string id is up to the server implementation.
        case desktopId(desktopId: String)

        case name(name: String)

        /// The Desktop Has Been Activated
        /// 
        /// The desktop will be the new "current" desktop of the system. The server may support either one virtual desktop active at a time, or other combinations such as one virtual desktop active per screen.
        /// Windows associated to this virtual desktop will be shown.
        case activated

        /// This Desktop Is No Longer Active
        /// 
        /// Windows that were associated only to this desktop will be hidden.
        case deactivated

        /// Sent All Information About Desktops
        /// 
        /// This event is sent after all other properties has been
        /// sent after binding to the desktop object and after any
        /// other property changes done after that. This allows
        /// changes to the org_kde_plasma_virtual_desktop properties to be seen as
        /// atomic, even if they happen via multiple events.
        case done

        /// This Desktop Has Been Removed
        /// 
        /// This virtual desktop has just been removed by the server:
        /// All windows will lose the association to this desktop.
        case removed

        /// Virtual Desktop Position
        /// 
        /// The position of the virtual desktop in the desktop list. The virtual
        /// desktop position is in the [0, N - 1] range, where N is the number of
        /// virtual desktops.
        case position(index: UInt32)

        /// This Desktop Became Active On An Output
        /// 
        /// This event is sent when the desktop becomes active on an output. The desktop can be active on multiple
        /// outputs simultaneously. Each output has exactly one active desktop at a time (the one that entered it last).
        case outputEntered(outputName: String)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.desktopId(desktopId: r.string())
            case 1:
                self = Self.name(name: r.string())
            case 2:
                self = Self.activated
            case 3:
                self = Self.deactivated
            case 4:
                self = Self.done
            case 5:
                self = Self.removed
            case 6:
                self = Self.position(index: r.uint())
            case 7:
                self = Self.outputEntered(outputName: r.string())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let OrgKdePlasmaVirtualDesktopProtocol = Protocol(
        name: "org_kde_plasma_virtual_desktop",
        interfaces: [
            OrgKdePlasmaVirtualDesktopManagement.interface,
OrgKdePlasmaVirtualDesktop.interface
        ]
    )

/// Output Configuration Representation
/// 
/// An outputdevice describes a display device available to the compositor.
/// outputdevice is similar to wl_output, but focuses on output
/// configuration management.
/// A client can query all global outputdevice objects to enlist all
/// available display devices, even those that may currently not be
/// represented by the compositor as a wl_output.
/// The client sends configuration changes to the server through the
/// outputconfiguration interface, and the server applies the configuration
/// changes to the hardware and signals changes to the outputdevices
/// accordingly.
/// This object is published as global during start up for every available
/// display devices, or when one later becomes available, for example by
/// being hotplugged via a physical connector.
public final class OrgKdeKwinOutputdevice: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_outputdevice",
            version: 4,
            events: [
                Message(
                    name: "geometry",
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
                            name: "physical_width",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "physical_height",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "subpixel",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "make",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "model",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "transform",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .uint,
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
                            name: "refresh",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "mode_id",
                            type: .int,
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
                    name: "scale",
                    arguments: [
                        Argument(
                            name: "factor",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "edid",
                    arguments: [
                        Argument(
                            name: "raw",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "enabled",
                    arguments: [
                        Argument(
                            name: "enabled",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "uuid",
                    arguments: [
                        Argument(
                            name: "uuid",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "scalef",
                    arguments: [
                        Argument(
                            name: "factor",
                            type: .fixed,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "colorcurves",
                    arguments: [
                        Argument(
                            name: "red",
                            type: .array,
                        )
                        ,
                        Argument(
                            name: "green",
                            type: .array,
                        )
                        ,
                        Argument(
                            name: "blue",
                            type: .array,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "serial_number",
                    arguments: [
                        Argument(
                            name: "serialNumber",
                            type: .string,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "eisa_id",
                    arguments: [
                        Argument(
                            name: "eisaId",
                            type: .string,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "capabilities",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "overscan",
                    arguments: [
                        Argument(
                            name: "overscan",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "vrr_policy",
                    arguments: [
                        Argument(
                            name: "vrr_policy",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
            ],
        )
    
    public static let `protocol`: Protocol = OrgKdeKwinOutputdeviceProtocol
    
    public enum Subpixel: UInt32 {
        case unknown = 0

        case `none` = 1

        case horizontalRgb = 2

        case horizontalBgr = 3

        case verticalRgb = 4

        case verticalBgr = 5
    }

    public enum Transform: UInt32 {
        case normal = 0

        case `90` = 1

        case `180` = 2

        case `270` = 3

        case flipped = 4

        case flipped90 = 5

        case flipped180 = 6

        case flipped270 = 7
    }

    public enum Mode: UInt32 {
        /// indicates this is the current mode
        case current = 1

        /// indicates this is the preferred mode
        case preferred = 2
    }

    public enum Enablement: UInt32 {
        case disabled = 0

        case enabled = 1
    }

    public struct Capability: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// if this outputdevice can use overscan
        public static let overscan = Capability(rawValue: 1)

        /// if this outputdevice supports variable refresh rate
        public static let vrr = Capability(rawValue: 2)
    }

    public enum VrrPolicy: UInt32 {
        case never = 0

        case always = 1

        case automatic = 2
    }

    public enum Event: MessageProtocol {
        /// Geometric Properties Of The Output
        /// 
        /// The geometry event describes geometric properties of the output.
        /// The event is sent when binding to the output object and whenever
        /// any of the properties change.
        case geometry(x: Int32, y: Int32, physicalWidth: Int32, physicalHeight: Int32, subpixel: Int32, make: String, model: String, transform: Int32)

        /// Advertise Available Output Modes And Current One
        /// 
        /// The mode event describes an available mode for the output.
        /// When the client binds to the outputdevice object, the server sends this
        /// event once for every available mode the outputdevice can be operated by.
        /// There will always be at least one event sent out on initial binding,
        /// which represents the current mode.
        /// Later on if an output changes its mode the event is sent again, whereby
        /// this event represents the mode that has now become current. In other
        /// words, the current mode is always represented by the latest event sent
        /// with the current flag set.
        /// The size of a mode is given in physical hardware units of the output device.
        /// This is not necessarily the same as the output size in the global compositor
        /// space. For instance, the output may be scaled, as described in
        /// org_kde_kwin_outputdevice.scale, or transformed, as described in
        /// org_kde_kwin_outputdevice.transform.
        /// The id can be used to refer to a mode when calling set_mode on an
        /// org_kde_kwin_outputconfiguration object.
        case mode(flags: UInt32, width: Int32, height: Int32, refresh: Int32, modeId: Int32)

        /// Sent All Information About Output
        /// 
        /// This event is sent after all other properties have been
        /// sent on binding to the output object as well as after any
        /// other output property change have been applied later on.
        /// This allows to see changes to the output properties as atomic,
        /// even if multiple events successively announce them.
        case done

        /// Output Scaling Properties
        /// 
        /// This event contains scaling geometry information
        /// that is not in the geometry event. It may be sent after
        /// binding the output object or if the output scale changes
        /// later. If it is not sent, the client should assume a
        /// scale of 1.
        /// A scale larger than 1 means that the compositor will
        /// automatically scale surface buffers by this amount
        /// when rendering. This is used for high resolution
        /// displays where applications rendering at the native
        /// resolution would be too small to be legible.
        /// It is intended that scaling aware clients track the
        /// current output of a surface, and if it is on a scaled
        /// output it should use wl_surface.set_buffer_scale with
        /// the scale of the output. That way the compositor can
        /// avoid scaling the surface, and the client can supply
        /// a higher detail image.
        case scale(factor: Int32)

        /// Advertise Edid Data For The Output
        /// 
        /// The edid event encapsulates the EDID data for the outputdevice.
        /// The event is sent when binding to the output object. The EDID
        /// data may be empty, in which case this event is sent anyway.
        /// If the EDID information is empty, you can fall back to the name
        /// et al. properties of the outputdevice.
        case edid(raw: String)

        /// Output Is Enabled Or Disabled
        /// 
        /// The enabled event notifies whether this output is currently
        /// enabled and used for displaying content by the server.
        /// The event is sent when binding to the output object and
        /// whenever later on an output changes its state by becoming
        /// enabled or disabled.
        case enabled(enabled: Int32)

        /// A Unique Id For This Outputdevice
        /// 
        /// The uuid can be used to identify the output. It's controlled by
        /// the server entirely. The server should make sure the uuid is
        /// persistent across restarts. An empty uuid is considered invalid.
        case uuid(uuid: String)

        /// Output Scaling Properties
        /// 
        /// This event contains scaling geometry information
        /// that is not in the geometry event. It may be sent after
        /// binding the output object or if the output scale changes
        /// later. If it is not sent, the client should assume a
        /// scale of 1.
        /// A scale larger than 1 means that the compositor will
        /// automatically scale surface buffers by this amount
        /// when rendering. This is used for high resolution
        /// displays where applications rendering at the native
        /// resolution would be too small to be legible.
        /// It is intended that scaling aware clients track the
        /// current output of a surface, and if it is on a scaled
        /// output it should use wl_surface.set_buffer_scale with
        /// the scale of the output. That way the compositor can
        /// avoid scaling the surface, and the client can supply
        /// a higher detail image.
        /// wl_output will keep the output scale as an integer. In every situation except
        /// configuring the window manager you want to use that.
        case scalef(factor: Double)

        /// Output Color Curves
        /// 
        /// Describes the color intensity profile of the output.
        /// Commonly used for gamma/color correction.
        /// The array contains all color ramp values of the output.
        /// For example on 8bit screens there are 256 of them.
        /// The array elements are unsigned 16bit integers.
        case colorcurves(red: Data, green: Data, blue: Data)

        /// Serial Number
        /// 
        /// Serial ID of the monitor, sent on startup before the first done event.
        case serialNumber(serialnumber: String)

        /// Eisa Id
        /// 
        /// EISA ID of the monitor, sent on startup before the first done event.
        case eisaId(eisaid: String)

        /// Capability Flags
        /// 
        /// What capabilities this device has, sent on startup before the first
        /// done event.
        case capabilities(flags: Capability)

        /// Overscan
        /// 
        /// Overscan value of the monitor in percent, sent on startup before the
        /// first done event.
        case overscan(overscan: UInt32)

        /// Variable Refresh Rate Policy
        /// 
        /// What policy the compositor will employ regarding its use of variable
        /// refresh rate.
        case vrrPolicy(vrrPolicy: VrrPolicy)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.geometry(x: r.int(), y: r.int(), physicalWidth: r.int(), physicalHeight: r.int(), subpixel: r.int(), make: r.string(), model: r.string(), transform: r.int())
            case 1:
                self = Self.mode(flags: r.uint(), width: r.int(), height: r.int(), refresh: r.int(), modeId: r.int())
            case 2:
                self = Self.done
            case 3:
                self = Self.scale(factor: r.int())
            case 4:
                self = Self.edid(raw: r.string())
            case 5:
                self = Self.enabled(enabled: r.int())
            case 6:
                self = Self.uuid(uuid: r.string())
            case 7:
                self = Self.scalef(factor: r.fixed())
            case 8:
                self = Self.colorcurves(red: r.array(), green: r.array(), blue: r.array())
            case 9:
                self = Self.serialNumber(serialnumber: r.string())
            case 10:
                self = Self.eisaId(eisaid: r.string())
            case 11:
                self = Self.capabilities(flags: try _parseEnum(into: Capability.self, r.uint()))
            case 12:
                self = Self.overscan(overscan: r.uint())
            case 13:
                self = Self.vrrPolicy(vrrPolicy: try _parseEnum(into: VrrPolicy.self, r.uint()))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let OrgKdeKwinOutputdeviceProtocol = Protocol(
        name: "org_kde_kwin_outputdevice",
        interfaces: [
            OrgKdeKwinOutputdevice.interface
        ]
    )

/// Configuration Of Server Outputs Through Clients
/// 
/// This interface enables clients to set properties of output devices for screen
/// configuration purposes via the server. To this end output devices are referenced
/// by global org_kde_kwin_outputdevice objects.
/// outputmanagement (wl_global)
/// --------------------------
/// request:
/// * create_configuration -> outputconfiguration (wl_resource)
/// outputconfiguration (wl_resource)
/// --------------------------
/// requests:
/// * enable(outputdevice, bool)
/// * mode(outputdevice, mode_id)
/// * transformation(outputdevice, flag)
/// * position(outputdevice, x, y)
/// * apply
/// events:
/// * applied
/// * failed
/// The server registers one outputmanagement object as a global object. In order
/// to configure outputs a client requests create_configuration, which provides a
/// resource referencing an outputconfiguration for one-time configuration. That
/// way the server knows which requests belong together and can group them by that.
/// On the outputconfiguration object the client calls for each output whether the
/// output should be enabled, which mode should be set (by referencing the mode from
/// the list of announced modes) and the output's global position. Once all outputs
/// are configured that way, the client calls apply.
/// At that point and not earlier the server should try to apply the configuration.
/// If this succeeds the server emits the applied signal, otherwise the failed
/// signal, such that the configuring client is noticed about the success of its
/// configuration request.
/// Through this design the interface enables atomic output configuration changes if
/// internally supported by the server.
public final class OrgKdeKwinOutputmanagement: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_outputmanagement",
            version: 4,
            requests: [
                Message(
                    name: "create_configuration",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_outputconfiguration",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Provide Outputconfiguration Object For Configuring Outputs
    /// 
    /// Request an outputconfiguration object through which the client can configure
    /// output devices.
    public func createConfiguration(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinOutputconfiguration {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinOutputconfiguration.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = OutputmanagementProtocol
    
    public typealias Event = NoEvent
}

/// Configure Single Output Devices
/// 
/// outputconfiguration is a client-specific resource that can be used to ask
/// the server to apply changes to available output devices.
/// The client receives a list of output devices from the registry. When it wants
/// to apply new settings, it creates a configuration object from the
/// outputmanagement global, writes changes through this object's enable, scale,
/// transform and mode calls. It then asks the server to apply these settings in
/// an atomic fashion, for example through Linux' DRM interface.
/// The server signals back whether the new settings have applied successfully
/// or failed to apply. outputdevice objects are updated after the changes have been
/// applied to the hardware and before the server side sends the applied event.
public final class OrgKdeKwinOutputconfiguration: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_outputconfiguration",
            version: 4,
            requests: [
                Message(
                    name: "enable",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "org_kde_kwin_outputdevice",
                        )
                        ,
                        Argument(
                            name: "enable",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "org_kde_kwin_outputdevice",
                        )
                        ,
                        Argument(
                            name: "mode_id",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "transform",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "org_kde_kwin_outputdevice",
                        )
                        ,
                        Argument(
                            name: "transform",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "position",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "org_kde_kwin_outputdevice",
                        )
                        ,
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
                    ],
                )
                ,
                Message(
                    name: "scale",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "org_kde_kwin_outputdevice",
                        )
                        ,
                        Argument(
                            name: "scale",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "apply",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "scalef",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "org_kde_kwin_outputdevice",
                        )
                        ,
                        Argument(
                            name: "scale",
                            type: .fixed,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "colorcurves",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "org_kde_kwin_outputdevice",
                        )
                        ,
                        Argument(
                            name: "red",
                            type: .array,
                        )
                        ,
                        Argument(
                            name: "green",
                            type: .array,
                        )
                        ,
                        Argument(
                            name: "blue",
                            type: .array,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "overscan",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "org_kde_kwin_outputdevice",
                        )
                        ,
                        Argument(
                            name: "overscan",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "set_vrr_policy",
                    arguments: [
                        Argument(
                            name: "outputdevice",
                            type: .object,
                            interface: "org_kde_kwin_outputdevice",
                        )
                        ,
                        Argument(
                            name: "policy",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
            ],
            events: [
                Message(
                    name: "applied",
                    arguments: [
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
    /// Enable Or Disable An Output
    /// 
    /// Mark the output as enabled or disabled.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice to be en- or disabled
    ///   - enable: 1 to enable or 0 to disable this output
    public func enable(outputdevice: OrgKdeKwinOutputdevice, enable: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(outputdevice.id),
            .int(enable),
        ])
    }

    /// Switch Outputdevice To Mode
    /// 
    /// Sets the mode for a given output by its mode size (width and height) and refresh rate.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this mode change applies to
    ///   - modeId: aspired mode's id
    public func mode(outputdevice: OrgKdeKwinOutputdevice, modeId: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(outputdevice.id),
            .int(modeId),
        ])
    }

    /// Transform Outputdevice
    /// 
    /// Sets the transformation for a given output.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this transformation change applies to
    ///   - transform: transform enum
    public func transform(outputdevice: OrgKdeKwinOutputdevice, transform: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(outputdevice.id),
            .int(transform),
        ])
    }

    /// Position Output In Global Space
    /// 
    /// Sets the position for this output device. (x,y) describe the top-left corner
    /// of the output in global space, whereby the origin (0,0) of the global space
    /// has to be aligned with the top-left corner of the most left and in case this
    /// does not define a single one the top output.
    /// There may be no gaps or overlaps between outputs, i.e. the outputs are
    /// stacked horizontally, vertically, or both on each other.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this position applies to
    ///   - x: position on the x-axis
    ///   - y: position on the y-axis
    public func position(outputdevice: OrgKdeKwinOutputdevice, x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .object(outputdevice.id),
            .int(x),
            .int(y),
        ])
    }

    /// Set Scaling Factor Of This Output
    /// 
    /// Sets the scaling factor for this output device.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this mode change applies to
    ///   - scale: scaling factor
    public func scale(outputdevice: OrgKdeKwinOutputdevice, scale: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(outputdevice.id),
            .int(scale),
        ])
    }

    /// Apply Configuration Changes To All Output Devices
    /// 
    /// Asks the server to apply property changes requested through this outputconfiguration
    /// object to all outputs on the server side.
    public func apply() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
        ])
    }

    /// Set Scaling Factor Of This Output
    /// 
    /// Sets the scaling factor for this output device.
    /// Sending both scale and scalef is undefined.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this mode change applies to
    ///   - scale: scaling factor
    public func scalef(outputdevice: OrgKdeKwinOutputdevice, scale: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 6, [
            .object(outputdevice.id),
            .fixed(scale),
        ])
    }

    /// Set Output Color Curves
    /// 
    /// Set color curves of output devices through RGB color ramps. Allows color
    /// correction of output device from user space.
    /// These are the raw values. A compositor might opt to adjust these values
    /// internally, for example to shift color temperature at night.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice curves apply to
    ///   - red: red color ramp
    ///   - green: green color ramp
    ///   - blue: blue color ramp
    public func colorcurves(outputdevice: OrgKdeKwinOutputdevice, red: Data, green: Data, blue: Data) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 7, [
            .object(outputdevice.id),
            .array(red),
            .array(green),
            .array(blue),
        ])
    }

    /// Release The Outputconfiguration Object
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 8, [
        ])
    }

    /// Set Overscan Value
    /// 
    /// Set the overscan value of this output device with a value in percent.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice overscan applies to
    ///   - overscan: overscan value
    public func overscan(outputdevice: OrgKdeKwinOutputdevice, overscan: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 9, [
            .object(outputdevice.id),
            .uint(overscan),
        ])
    }

    /// Set The Vrr Policy
    /// 
    /// Set what policy the compositor should employ regarding its use of
    /// variable refresh rate.
    /// 
    /// - Parameters:
    ///   - outputdevice: outputdevice this VRR policy applies to
    ///   - policy: the vrr policy to apply
    public func setVrrPolicy(outputdevice: OrgKdeKwinOutputdevice, policy: VrrPolicy) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 10, [
            .object(outputdevice.id),
            .uint(policy.rawValue),
        ])
    }

    
    public static let `protocol`: Protocol = OutputmanagementProtocol
    
    public enum VrrPolicy: UInt32 {
        case never = 0

        case always = 1

        case automatic = 2
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

    public enum Event: MessageProtocol {
        /// Configuration Changes Have Been Applied
        /// 
        /// Sent after the server has successfully applied the changes.
        /// .
        case applied

        /// Configuration Changes Failed To Apply
        /// 
        /// Sent if the server rejects the changes or failed to apply them.
        case failed

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.applied
            case 1:
                self = Self.failed
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let OutputmanagementProtocol = Protocol(
        name: "outputmanagement",
        interfaces: [
            OrgKdeKwinOutputmanagement.interface,
OrgKdeKwinOutputconfiguration.interface
        ]
    )

/// Create Shell Windows And Helpers
/// 
/// This interface is used by KF5 powered Wayland shells to communicate with
/// the compositor and can only be bound one time.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class OrgKdePlasmaShell: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_shell",
            version: 8,
            requests: [
                Message(
                    name: "get_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_plasma_surface",
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
    /// Create A Shell Surface From A Surface
    /// 
    /// Create a shell surface for an existing surface.
    /// Only one shell surface can be associated with a given
    /// surface.
    /// 
    /// - Parameters:
    public func getSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaSurface {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdePlasmaSurface.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = PlasmaShellProtocol
    
    public typealias Event = NoEvent
}

/// Metadata Interface
/// 
/// An interface that may be implemented by a wl_surface, for
/// implementations that provide the shell user interface.
/// It provides requests to set surface roles, assign an output
/// or set the position in output coordinates.
/// On the server side the object is automatically destroyed when
/// the related wl_surface is destroyed.  On client side,
/// org_kde_plasma_surface.destroy() must be called before
/// destroying the wl_surface object.
public final class OrgKdePlasmaSurface: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_surface",
            version: 8,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_output",
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
                    name: "set_position",
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
                    ],
                )
                ,
                Message(
                    name: "set_role",
                    arguments: [
                        Argument(
                            name: "role",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_panel_behavior",
                    arguments: [
                        Argument(
                            name: "flag",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_skip_taskbar",
                    arguments: [
                        Argument(
                            name: "skip",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "panel_auto_hide_hide",
                    arguments: [
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "panel_auto_hide_show",
                    arguments: [
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "set_panel_takes_focus",
                    arguments: [
                        Argument(
                            name: "takes_focus",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "set_skip_switcher",
                    arguments: [
                        Argument(
                            name: "skip",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 5
                )
                ,
                Message(
                    name: "open_under_cursor",
                    arguments: [
                    ],
                    since: 7
                )
                ,
            ],
            events: [
                Message(
                    name: "auto_hidden_panel_hidden",
                    arguments: [
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "auto_hidden_panel_shown",
                    arguments: [
                    ],
                    since: 4
                )
                ,
            ],
        )
    /// Remove Org_Kde_Plasma_Surface Interface
    /// 
    /// The org_kde_plasma_surface interface is removed from the
    /// wl_surface object that was turned into a shell surface with the
    /// org_kde_plasma_shell.get_surface request.
    /// The shell surface role is lost and wl_surface is unmapped.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Assign An Output To This Shell Surface
    /// 
    /// Assign an output to this shell surface.
    /// The compositor will use this information to set the position
    /// when org_kde_plasma_surface.set_position request is
    /// called.
    /// 
    /// - Parameters:
    public func setOutput(_ output: WlOutput) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(output.id),
        ])
    }

    /// Change The Shell Surface Position
    /// 
    /// Move the surface to new coordinates.
    /// Coordinates are global, for example 50,50 for a 1920,0+1920x1080 output
    /// is 1970,50 in global coordinates space.
    /// Use org_kde_plasma_surface.set_output to assign an output
    /// to this surface.
    /// 
    /// - Parameters:
    ///   - x: x coordinate in global space
    ///   - y: y coordinate in global space
    public func setPosition(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(x),
            .int(y),
        ])
    }

    /// Assign A Role To This Surface
    /// 
    /// Assign a role to a shell surface.
    /// The compositor handles surfaces depending on their role.
    /// See the explanation below.
    /// This request fails if the surface already has a role, this means
    /// the surface role may be assigned only once.
    /// == Surfaces with splash role ==
    /// Splash surfaces are placed above every other surface during the
    /// shell startup phase.
    /// The surfaces are placed according to the output coordinates.
    /// No size is imposed to those surfaces, the shell has to resize
    /// them according to output size.
    /// These surfaces are meant to hide the desktop during the startup
    /// phase so that the user will always see a ready to work desktop.
    /// A shell might not create splash surfaces if the compositor reveals
    /// the desktop in an alternative fashion, for example with a fade
    /// in effect.
    /// That depends on how much time the desktop usually need to prepare
    /// the workspace or specific design decisions.
    /// This specification doesn't impose any particular design.
    /// When the startup phase is finished, the shell will send the
    /// org_kde_plasma.desktop_ready request to the compositor.
    /// == Surfaces with desktop role ==
    /// Desktop surfaces are placed below all other surfaces and are used
    /// to show the actual desktop view with icons, search results or
    /// controls the user will interact with. What to show depends on the
    /// shell implementation.
    /// The surfaces are placed according to the output coordinates.
    /// No size is imposed to those surfaces, the shell has to resize
    /// them according to output size.
    /// Only one surface per output can have the desktop role.
    /// == Surfaces with dashboard role ==
    /// Dashboard surfaces are placed above desktop surfaces and are used to
    /// show additional widgets and controls.
    /// The surfaces are placed according to the output coordinates.
    /// No size is imposed to those surfaces, the shell has to resize
    /// them according to output size.
    /// Only one surface per output can have the dashboard role.
    /// == Surfaces with config role ==
    /// A configuration surface is shown when the user wants to configure
    /// panel or desktop views.
    /// Only one surface per output can have the config role.
    /// TODO: This should grab the input like popup menus, right?
    /// == Surfaces with overlay role ==
    /// Overlays are special surfaces that shows for a limited amount
    /// of time.  Such surfaces are useful to display things like volume,
    /// brightness and status changes.
    /// Compositors may decide to show those surfaces in a layer above
    /// all surfaces, even full screen ones if so is desired.
    /// == Surfaces with notification role ==
    /// Notification surfaces display informative content for a limited
    /// amount of time.  The compositor may decide to show them in a corner
    /// depending on the configuration.
    /// These surfaces are shown in a layer above all other surfaces except
    /// for full screen ones.
    /// == Surfaces with lock role ==
    /// The lock surface is shown by the compositor when the session is
    /// locked, users interact with it to unlock the session.
    /// Compositors should move lock surfaces to 0,0 in output
    /// coordinates space and hide all other surfaces for security sake.
    /// For the same reason it is recommended that clients make the
    /// lock surface as big as the screen.
    /// Only one surface per output can have the lock role.
    /// 
    /// - Parameters:
    public func setRole(_ role: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(role),
        ])
    }

    /// Set Or Unset The Panel 
    /// 
    /// Set flags bitmask as described by the flag enum.
    /// Pass 0 to unset any flag, the surface will adjust its behavior to
    /// the default.
    /// Deprecated in Plasma 6. Setting this flag will have no effect. Applications should use layer shell where appropriate.
    /// 
    /// - Parameters:
    ///   - flag: panel_behavior enum value
    public func setPanelBehavior(flag: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .uint(flag),
        ])
    }

    /// Make The Window Skip The Taskbar
    /// 
    /// Setting this bit to the window, will make it say it prefers to not be listed in the taskbar. Taskbar implementations may or may not follow this hint.
    /// 
    /// - Parameters:
    ///   - skip: Boolean value that sets whether to skip the taskbar
    public func setSkipTaskbar(skip: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 5, [
            .uint(skip),
        ])
    }

    /// Hide The Auto-Hiding Panel
    /// 
    /// A panel surface with panel_behavior auto_hide can perform this request to hide the panel
    /// on a screen edge without unmapping it. The compositor informs the client about the panel
    /// being hidden with the event auto_hidden_panel_hidden.
    /// The compositor will restore the visibility state of the
    /// surface when the pointer touches the screen edge the panel borders. Once the compositor restores
    /// the visibility the event auto_hidden_panel_shown will be sent. This event will also be sent
    /// if the compositor is unable to hide the panel.
    /// The client can also request to show the panel again with the request panel_auto_hide_show.
    public func panelAutoHideHide() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 6, [
        ])
    }

    /// Show The Auto-Hiding Panel
    /// 
    /// A panel surface with panel_behavior auto_hide can perform this request to show the panel
    /// again which got hidden with panel_auto_hide_hide.
    public func panelAutoHideShow() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 7, [
        ])
    }

    /// Whether A Panel Takes Focus
    /// 
    /// By default various org_kde_plasma_surface roles do not take focus and cannot be
    /// activated. With this request the compositor can be instructed to pass focus also to this
    /// org_kde_plasma_surface.
    /// 
    /// - Parameters:
    ///   - takesFocus: Boolean value that sets whether the panel takes focus
    public func setPanelTakesFocus(takesFocus: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 8, [
            .uint(takesFocus),
        ])
    }

    /// Make The Window Not Appear In A Switcher
    /// 
    /// Setting this bit will indicate that the window prefers not to be listed in a switcher.
    /// 
    /// - Parameters:
    ///   - skip: Boolean value that sets whether to skip the window switcher.
    public func setSkipSwitcher(skip: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        connection.send(self, 9, [
            .uint(skip),
        ])
    }

    /// Open Under Cursor
    /// 
    /// Request the initial position of this surface to be under the current
    /// cursor position. Has to be called before attaching any buffer to this surface.
    public func openUnderCursor() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 7 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 7) }
        connection.send(self, 10, [
        ])
    }

    
    public static let `protocol`: Protocol = PlasmaShellProtocol
    
    public enum Role: UInt32 {
        case normal = 0

        case desktop = 1

        case panel = 2

        case onscreendisplay = 3

        case notification = 4

        case tooltip = 5

        case criticalnotification = 6

        case appletpopup = 7
    }

    public enum PanelBehavior: UInt32 {
        case alwaysVisible = 1

        case autoHide = 2

        case windowsCanCover = 3

        case windowsGoBelow = 4
    }

    public enum Error: UInt32 {
        /// Request panel_auto_hide performed on a surface which does not correspond to an auto-hide panel.
        case panelNotAutoHide = 0
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

    public enum Event: MessageProtocol {
        /// Auto-Hiding Panel Is Hidden
        /// 
        /// An auto-hiding panel got hidden by the compositor.
        case autoHiddenPanelHidden

        /// Auto-Hiding Panel Is Shown
        /// 
        /// An auto-hiding panel got shown by the compositor.
        case autoHiddenPanelShown

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.autoHiddenPanelHidden
            case 1:
                self = Self.autoHiddenPanelShown
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let PlasmaShellProtocol = Protocol(
        name: "plasma_shell",
        interfaces: [
            OrgKdePlasmaShell.interface,
OrgKdePlasmaSurface.interface
        ]
    )

/// Application Windows Management
/// 
/// This interface manages application windows.
/// It provides requests to show and hide the desktop and emits
/// an event every time a window is created so that the client can
/// use it to manage the window.
/// Only one client can bind this interface at a time.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class OrgKdePlasmaWindowManagement: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_window_management",
            version: 20,
            requests: [
                Message(
                    name: "show_desktop",
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
                    name: "get_window",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_plasma_window",
                        )
                        ,
                        Argument(
                            name: "internal_window_id",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "get_window_by_uuid",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_plasma_window",
                        )
                        ,
                        Argument(
                            name: "internal_window_uuid",
                            type: .string,
                        )
                        ,
                    ],
                    since: 12
                )
                ,
                Message(
                    name: "get_stacking_order",
                    arguments: [
                        Argument(
                            name: "stacking_order",
                            type: .newId,
                            interface: "org_kde_plasma_stacking_order",
                        )
                        ,
                    ],
                    since: 17
                )
                ,
            ],
            events: [
                Message(
                    name: "show_desktop_changed",
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
                    name: "window",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "stacking_order_changed",
                    arguments: [
                        Argument(
                            name: "ids",
                            type: .array,
                        )
                        ,
                    ],
                    since: 11
                )
                ,
                Message(
                    name: "stacking_order_uuid_changed",
                    arguments: [
                        Argument(
                            name: "uuids",
                            type: .string,
                        )
                        ,
                    ],
                    since: 12
                )
                ,
                Message(
                    name: "window_with_uuid",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "uuid",
                            type: .string,
                        )
                        ,
                    ],
                    since: 13
                )
                ,
                Message(
                    name: "stacking_order_changed_2",
                    arguments: [
                    ],
                    since: 17
                )
                ,
            ],
        )
    /// Show/Hide The Desktop
    /// 
    /// Tell the compositor to show/hide the desktop.
    /// 
    /// - Parameters:
    ///   - state: requested state
    public func showDesktop(state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(state),
        ])
    }

    /// Deprecated
    /// 
    /// Deprecated: use get_window_by_uuid
    /// 
    /// - Parameters:
    ///   - internalWindowId: The internal window id of the window to create
    public func getWindow(internalWindowId: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaWindow {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdePlasmaWindow.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .uint(internalWindowId),
        ])
        return id
    }

    /// 
    /// - Parameters:
    ///   - internalWindowUuid: The internal window uuiid of the window to create
    public func getWindowByUuid(internalWindowUuid: String, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaWindow {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 12 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 12) }
        let id = connection.createProxy(type: OrgKdePlasmaWindow.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(id.id),
            .string(internalWindowUuid),
        ])
        return id
    }

    /// Get The Stacking Order
    /// 
    /// 
    public func getStackingOrder(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdePlasmaStackingOrder {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 17 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 17) }
        let stackingOrder = connection.createProxy(type: OrgKdePlasmaStackingOrder.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 3, [
            .object(stackingOrder.id),
        ])
        return stackingOrder
    }

    
    public static let `protocol`: Protocol = PlasmaWindowManagementProtocol
    
    public enum State: UInt32 {
        case active = 1

        case minimized = 2

        case maximized = 4

        case fullscreen = 8

        case keepAbove = 16

        case keepBelow = 32

        case onAllDesktops = 64

        case demandsAttention = 128

        case closeable = 256

        case minimizable = 512

        case maximizable = 1024

        case fullscreenable = 2048

        case skiptaskbar = 4096

        case shadeable = 8192

        case shaded = 16384

        case movable = 32768

        case resizable = 65536

        case virtualDesktopChangeable = 131072

        case skipswitcher = 262144

        case noBorder = 524288

        case canSetNoBorder = 1048576

        case excludeFromCapture = 2097152
    }

    public enum ShowDesktop: UInt32 {
        case disabled = 0

        case enabled = 1
    }

    public enum Event: MessageProtocol {
        /// Notify The Client When The Show Desktop Mode Is Entered/Left
        /// 
        /// This event will be sent whenever the show desktop mode changes. E.g. when it is entered
        /// or left.
        /// On binding the interface the current state is sent.
        case showDesktopChanged(state: UInt32)

        /// Notify The Client That A Window Was Mapped
        /// 
        /// This event will be sent immediately after a window is mapped.
        case window(id: UInt32)

        /// Notify The Client When Stacking Order Changed
        /// 
        /// This event will be sent when stacking order changed and on bind.
        /// With version 17 this event is deprecated and will no longer be sent.
        case stackingOrderChanged(ids: Data)

        /// Notify The Client When Stacking Order Changed
        /// 
        /// This event will be sent when stacking order changed and on bind.
        /// With version 17 this event is deprecated and will no longer be sent.
        case stackingOrderUuidChanged(uuids: String)

        /// Notify The Client That A Window Was Mapped
        /// 
        /// This event will be sent immediately after a window is mapped.
        case windowWithUuid(id: UInt32, uuid: String)

        /// Notify The Client When Stacking Order Changed
        /// 
        /// This event will be sent when stacking order changed.
        case stackingOrderChanged2

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.showDesktopChanged(state: r.uint())
            case 1:
                self = Self.window(id: r.uint())
            case 2:
                self = Self.stackingOrderChanged(ids: r.array())
            case 3:
                self = Self.stackingOrderUuidChanged(uuids: r.string())
            case 4:
                self = Self.windowWithUuid(id: r.uint(), uuid: r.string())
            case 5:
                self = Self.stackingOrderChanged2
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Interface To Control Application Windows
/// 
/// Manages and control an application window.
/// Only one client can bind this interface at a time.
public final class OrgKdePlasmaWindow: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_window",
            version: 20,
            requests: [
                Message(
                    name: "set_state",
                    arguments: [
                        Argument(
                            name: "flags",
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
                    name: "set_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "number",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_minimized_geometry",
                    arguments: [
                        Argument(
                            name: "panel",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "x",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "y",
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
                Message(
                    name: "unset_minimized_geometry",
                    arguments: [
                        Argument(
                            name: "panel",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "close",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "request_move",
                    arguments: [
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "request_resize",
                    arguments: [
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "get_icon",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
                        )
                        ,
                    ],
                    since: 7
                )
                ,
                Message(
                    name: "request_enter_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        )
                        ,
                    ],
                    since: 8
                )
                ,
                Message(
                    name: "request_enter_new_virtual_desktop",
                    arguments: [
                    ],
                    since: 8
                )
                ,
                Message(
                    name: "request_leave_virtual_desktop",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        )
                        ,
                    ],
                    since: 8
                )
                ,
                Message(
                    name: "request_enter_activity",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        )
                        ,
                    ],
                    since: 14
                )
                ,
                Message(
                    name: "request_leave_activity",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        )
                        ,
                    ],
                    since: 14
                )
                ,
                Message(
                    name: "send_to_output",
                    arguments: [
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                    since: 15
                )
                ,
            ],
            events: [
                Message(
                    name: "title_changed",
                    arguments: [
                        Argument(
                            name: "title",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "app_id_changed",
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
                    name: "state_changed",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "virtual_desktop_changed",
                    arguments: [
                        Argument(
                            name: "number",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "themed_icon_name_changed",
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
                    name: "unmapped",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "initial_state",
                    arguments: [
                    ],
                    since: 4
                )
                ,
                Message(
                    name: "parent_window",
                    arguments: [
                        Argument(
                            name: "parent",
                            type: .object,
                            interface: "org_kde_plasma_window",
                            nullable: true,
                        )
                        ,
                    ],
                    since: 5
                )
                ,
                Message(
                    name: "geometry",
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
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 6
                )
                ,
                Message(
                    name: "icon_changed",
                    arguments: [
                    ],
                    since: 7
                )
                ,
                Message(
                    name: "pid_changed",
                    arguments: [
                        Argument(
                            name: "pid",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "virtual_desktop_entered",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        )
                        ,
                    ],
                    since: 8
                )
                ,
                Message(
                    name: "virtual_desktop_left",
                    arguments: [
                        Argument(
                            name: "is",
                            type: .string,
                        )
                        ,
                    ],
                    since: 8
                )
                ,
                Message(
                    name: "application_menu",
                    arguments: [
                        Argument(
                            name: "service_name",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "object_path",
                            type: .string,
                        )
                        ,
                    ],
                    since: 10
                )
                ,
                Message(
                    name: "activity_entered",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        )
                        ,
                    ],
                    since: 14
                )
                ,
                Message(
                    name: "activity_left",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .string,
                        )
                        ,
                    ],
                    since: 14
                )
                ,
                Message(
                    name: "resource_name_changed",
                    arguments: [
                        Argument(
                            name: "resource_name",
                            type: .string,
                        )
                        ,
                    ],
                    since: 16
                )
                ,
                Message(
                    name: "client_geometry",
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
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 18
                )
                ,
            ],
        )
    /// Set Window State
    /// 
    /// Set window state.
    /// Values for state argument are described by org_kde_plasma_window_management.state
    /// and can be used together in a bitfield. The flags bitfield describes which flags are
    /// supposed to be set, the state bitfield the value for the set flags
    /// 
    /// - Parameters:
    ///   - flags: bitfield of set state flags
    ///   - state: bitfield of state flags
    public func setState(flags: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .uint(flags),
            .uint(state),
        ])
    }

    /// Map Window On A Virtual Desktop
    /// 
    /// Deprecated: use enter_virtual_desktop
    /// Maps the window to a different virtual desktop.
    /// To show the window on all virtual desktops, call the
    /// org_kde_plasma_window.set_state request and specify a on_all_desktops
    /// state in the bitfield.
    /// 
    /// - Parameters:
    ///   - number: zero based virtual desktop number
    public func setVirtualDesktop(number: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(number),
        ])
    }

    /// Set The Geometry For A Taskbar Entry
    /// 
    /// Sets the geometry of the taskbar entry for this window.
    /// The geometry is relative to a panel in particular.
    /// 
    /// - Parameters:
    public func setMinimizedGeometry(panel: WlSurface, x: UInt32, y: UInt32, width: UInt32, height: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(panel.id),
            .uint(x),
            .uint(y),
            .uint(width),
            .uint(height),
        ])
    }

    /// Set The Geometry For A Taskbar Entry
    /// 
    /// Remove the task geometry information for a particular panel.
    /// 
    /// - Parameters:
    public func unsetMinimizedGeometry(panel: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .object(panel.id),
        ])
    }

    /// Close Window
    /// 
    /// Close this window.
    public func close() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    /// Request Move
    /// 
    /// Request an interactive move for this window.
    public func requestMove() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 5, [
        ])
    }

    /// Request Resize
    /// 
    /// Request an interactive resize for this window.
    public func requestResize() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 6, [
        ])
    }

    /// Remove Resource For The Org_Kde_Plasma_Window
    /// 
    /// Removes the resource bound for this org_kde_plasma_window.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        self.markDead()
        connection.send(self, 7, [
        ])
    }

    /// Requests To Get The Window Icon
    /// 
    /// The compositor will write the window icon into the provided file descriptor.
    /// The data is a serialized QIcon with QDataStream.
    /// 
    /// - Parameters:
    ///   - fd: file descriptor for the icon
    public func getIcon(fd: FileHandle) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 7 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 7) }
        connection.send(self, 8, [
            .fd(fd),
        ])
    }

    /// Map Window On A Virtual Desktop
    /// 
    /// Make the window enter a virtual desktop. A window can enter more
    /// than one virtual desktop. if the id is empty or invalid, no action will be performed.
    /// 
    /// - Parameters:
    ///   - id: desktop id
    public func requestEnterVirtualDesktop(id: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 8 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 8) }
        connection.send(self, 9, [
            .string(id),
        ])
    }

    /// Map Window On A Virtual Desktop
    /// 
    /// RFC: do this with an empty id to request_enter_virtual_desktop?
    /// Make the window enter a new virtual desktop. If the server consents the request,
    /// it will create a new virtual desktop and assign the window to it.
    public func requestEnterNewVirtualDesktop() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 8 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 8) }
        connection.send(self, 10, [
        ])
    }

    /// Remove A Window From A Virtual Desktop
    /// 
    /// Make the window exit a virtual desktop. If it exits all desktops it will be considered on all of them.
    /// 
    /// - Parameters:
    ///   - id: desktop id
    public func requestLeaveVirtualDesktop(id: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 8 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 8) }
        connection.send(self, 11, [
            .string(id),
        ])
    }

    /// Map Window On An Activity
    /// 
    /// Make the window enter an activity. A window can enter more activity. If the id is empty or invalid, no action will be performed.
    /// 
    /// - Parameters:
    ///   - id: activity id
    public func requestEnterActivity(id: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 14 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 14) }
        connection.send(self, 12, [
            .string(id),
        ])
    }

    /// Remove A Window From An Activity
    /// 
    /// Make the window exit a an activity. If it exits all activities it will be considered on all of them.
    /// 
    /// - Parameters:
    ///   - id: activity id
    public func requestLeaveActivity(id: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 14 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 14) }
        connection.send(self, 13, [
            .string(id),
        ])
    }

    /// Send Window To Specified Output
    /// 
    /// Requests this window to be displayed in a specific output.
    /// 
    /// - Parameters:
    public func sendToOutput(output: WlOutput) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 15 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 15) }
        connection.send(self, 14, [
            .object(output.id),
        ])
    }

    
    public static let `protocol`: Protocol = PlasmaWindowManagementProtocol
    
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

    public enum Event: MessageProtocol {
        /// Window Title Has Been Changed
        /// 
        /// This event will be sent as soon as the window title is changed.
        case titleChanged(title: String)

        /// Application Identifier Has Been Changed
        /// 
        /// This event will be sent as soon as the application
        /// identifier is changed.
        case appIdChanged(appId: String)

        /// Window State Has Been Changed
        /// 
        /// This event will be sent as soon as the window state changes.
        /// Values for state argument are described by org_kde_plasma_window_management.state.
        case stateChanged(flags: UInt32)

        /// Window Was Moved To Another Workspace
        /// 
        /// DEPRECATED: use virtual_desktop_entered and virtual_desktop_left instead
        /// This event will be sent when a window is moved to another
        /// virtual desktop.
        /// It is not sent if it becomes visible on all virtual desktops though.
        case virtualDesktopChanged(number: Int32)

        /// Window's Icon Name Changed
        /// 
        /// This event will be sent whenever the themed icon name changes. May be null.
        case themedIconNameChanged(name: String)

        /// Window's Surface Was Unmapped
        /// 
        /// This event will be sent immediately after the window is closed
        /// and its surface is unmapped.
        case unmapped

        /// All Initial Known State Is Submitted
        /// 
        /// This event will be sent immediately after all initial state been sent to the client.
        /// If the Plasma window is already unmapped, the unmapped event will be sent before the
        /// initial_state event.
        case initialState

        /// The Parent Window Changed
        /// 
        /// This event will be sent whenever the parent window of this org_kde_plasma_window changes.
        /// The passed parent is another org_kde_plasma_window and this org_kde_plasma_window is a
        /// transient window to the parent window. If the parent argument is null, this
        /// org_kde_plasma_window does not have a parent window.
        case parentWindow(parent: OrgKdePlasmaWindow)

        /// The Geometry Of This Window In Absolute Coordinates
        /// 
        /// This event will be sent whenever the window geometry of this org_kde_plasma_window changes.
        /// The coordinates are in absolute coordinates of the windowing system.
        case geometry(x: Int32, y: Int32, width: UInt32, height: UInt32)

        /// The Icon Of The Window Changed
        /// 
        /// This event will be sent whenever the icon of the window changes, but there is no themed
        /// icon name. Common examples are Xwayland windows which have a pixmap based icon.
        /// The client can request the icon using get_icon.
        case iconChanged

        /// Process Id Of Application Owning The Window Has Changed
        /// 
        /// This event will be sent when the compositor has set the process id this window belongs to.
        /// This should be set once before the initial_state is sent.
        case pidChanged(pid: UInt32)

        /// The Window Entered A New Virtual Desktop
        /// 
        /// This event will be sent when the window has entered a new virtual desktop. The window can be on more than one desktop, or none: then is considered on all of them.
        case virtualDesktopEntered(id: String)

        /// The Window Left A Virtual Desktop
        /// 
        /// This event will be sent when the window left a virtual desktop. If the window leaves all desktops, it can be considered on all.
        /// If the window gets manually added on all desktops, the server has to send virtual_desktop_left for every previous desktop it was in for the window to be really considered on all desktops.
        case virtualDesktopLeft(`is`: String)

        /// Notify The Client That The Current Appmenu Changed
        /// 
        /// This event will be sent after the application menu
        /// for the window has changed.
        case applicationMenu(serviceName: String, objectPath: String)

        /// The Window Entered An Activity
        /// 
        /// This event will be sent when the window has entered an activity. The window can be on more than one activity, or none: then is considered on all of them.
        case activityEntered(id: String)

        /// The Window Left An Activity
        /// 
        /// This event will be sent when the window left an activity. If the window leaves all activities, it will be considered on all.
        /// If the window gets manually added on all activities, the server has to send activity_left for every previous activity it was in for the window to be really considered on all activities.
        case activityLeft(id: String)

        /// X11 Resource Name Has Changed
        /// 
        /// This event will be sent when the X11 resource name of the window has changed.
        /// This is only set for XWayland windows.
        case resourceNameChanged(resourceName: String)

        /// The Client Geometry (I.E. Without Decorations Etc) Of This Window In Absolute Coordinates
        /// 
        /// This event will be sent whenever the window geometry of this org_kde_plasma_window changes.
        /// The coordinates are in absolute coordinates of the windowing system.
        case clientGeometry(x: Int32, y: Int32, width: UInt32, height: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.titleChanged(title: r.string())
            case 1:
                self = Self.appIdChanged(appId: r.string())
            case 2:
                self = Self.stateChanged(flags: r.uint())
            case 3:
                self = Self.virtualDesktopChanged(number: r.int())
            case 4:
                self = Self.themedIconNameChanged(name: r.string())
            case 5:
                self = Self.unmapped
            case 6:
                self = Self.initialState
            case 7:
                self = Self.parentWindow(parent: r.object(type: OrgKdePlasmaWindow.self))
            case 8:
                self = Self.geometry(x: r.int(), y: r.int(), width: r.uint(), height: r.uint())
            case 9:
                self = Self.iconChanged
            case 10:
                self = Self.pidChanged(pid: r.uint())
            case 11:
                self = Self.virtualDesktopEntered(id: r.string())
            case 12:
                self = Self.virtualDesktopLeft(is: r.string())
            case 13:
                self = Self.applicationMenu(serviceName: r.string(), objectPath: r.string())
            case 14:
                self = Self.activityEntered(id: r.string())
            case 15:
                self = Self.activityLeft(id: r.string())
            case 16:
                self = Self.resourceNameChanged(resourceName: r.string())
            case 17:
                self = Self.clientGeometry(x: r.int(), y: r.int(), width: r.uint(), height: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Activation Feedback
/// 
/// The activation manager interface provides a way to get notified
/// when an application is about to be activated.
public final class OrgKdePlasmaActivationFeedback: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_activation_feedback",
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
                    name: "activation",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_plasma_activation",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Destroy The Activation Manager Object
    /// 
    /// Destroy the activation manager object. The activation objects introduced
    /// by this manager object will be unaffected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = PlasmaWindowManagementProtocol
    
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

    public enum Event: MessageProtocol {
        /// Notify That An App Is Starting
        /// 
        /// Will be issued when an app is set to be activated. It offers
        /// an instance of org_kde_plasma_activation that will tell us the app_id
        /// and the extent of the activation.
        case activation(id: OrgKdePlasmaActivation)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.activation(id: r.newId(type: OrgKdePlasmaActivation.self))
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public final class OrgKdePlasmaActivation: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_activation",
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
                    name: "app_id",
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
                    name: "finished",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// Destroy The Org_Kde_Plasma_Activation Object
    /// 
    /// Notify the compositor that the org_kde_plasma_activation object will no
    /// longer be used.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = PlasmaWindowManagementProtocol
    
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

    public enum Event: MessageProtocol {
        /// Offers The App_Id
        /// 
        /// 
        case appId(appId: String)

        /// Notifies About Activation Finished, Either By Activation Or Because It Got Invalidated
        /// 
        /// 
        case finished

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.appId(appId: r.string())
            case 1:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Helper Object For Sending The Stacking Order
/// 
/// When this object is created, the compositor sends a window event for
/// each window in the stacking order, and afterwards sends the done event
/// and destroys this object.
public final class OrgKdePlasmaStackingOrder: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_plasma_stacking_order",
            version: 17,
            events: [
                Message(
                    name: "window",
                    arguments: [
                        Argument(
                            name: "uuid",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "done",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
        )
    
    public static let `protocol`: Protocol = PlasmaWindowManagementProtocol
    
    public enum Event: MessageProtocol {
        /// A Window In The Stacking Order List
        /// 
        /// 
        case window(uuid: String)

        /// Marks The End Of The List
        /// 
        /// 
        case done

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
                self = Self.window(uuid: r.string())
            case 1:
                self = Self.done
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let PlasmaWindowManagementProtocol = Protocol(
        name: "plasma_window_management",
        interfaces: [
            OrgKdePlasmaWindowManagement.interface,
OrgKdePlasmaWindow.interface,
OrgKdePlasmaActivationFeedback.interface,
OrgKdePlasmaActivation.interface,
OrgKdePlasmaStackingOrder.interface
        ]
    )

/// Protocol For Managing Rendered Gbm Buffers Passing
/// 
/// 
public final class OrgKdeKwinRemoteAccessManager: BaseProxy, Proxy {
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
                        )
                        ,
                        Argument(
                            name: "internal_buffer_id",
                            type: .int,
                        )
                        ,
                    ],
                    since: 1
                )
                ,
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "buffer_ready",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                    ],
                    since: 1
                )
                ,
            ],
        )
    /// Answer On Buffer_Ready Event, Retrieves New Buffer From Server
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - internalBufferId: The internal buffer id of the buffer to create
    public func getBuffer(internalBufferId: Int32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinRemoteBuffer {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 1 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 1) }
        let buffer = connection.createProxy(type: OrgKdeKwinRemoteBuffer.self, version: self.version, queue: _queue ?? self.queue)
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

    public enum Event: MessageProtocol {
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
public final class OrgKdeKwinRemoteBuffer: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_remote_buffer",
            version: 1,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 1
                )
                ,
            ],
            events: [
                Message(
                    name: "gbm_handle",
                    arguments: [
                        Argument(
                            name: "fd",
                            type: .fd,
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
                        Argument(
                            name: "stride",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "format",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 1
                )
                ,
            ],
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

    public enum Event: MessageProtocol {
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
            OrgKdeKwinRemoteAccessManager.interface,
OrgKdeKwinRemoteBuffer.interface
        ]
    )

/// Server Side Decoration Palette Manager Interface
/// 
/// This interface allows a client to alter the palette of a server side decoration.
public final class OrgKdeKwinServerDecorationPaletteManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_server_decoration_palette_manager",
            version: 1,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_server_decoration_palette",
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
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinServerDecorationPalette {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinServerDecorationPalette.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = ServerDecorationPaletteProtocol
    
    public typealias Event = NoEvent
}

/// Server Side Decoration Palette Interface
/// 
/// This interface allows a client to alter the palette of a server side decoration.
public final class OrgKdeKwinServerDecorationPalette: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_server_decoration_palette",
            version: 1,
            requests: [
                Message(
                    name: "set_palette",
                    arguments: [
                        Argument(
                            name: "palette",
                            type: .string,
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
                )
                ,
            ],
        )
    /// Set A On The Server Side Window Decoration
    /// 
    /// Color scheme that should be applied to the window decoration.
    /// Absolute file path, or name of palette in the user's config directory.
    /// The server may choose not to follow the requested style.
    /// 
    /// - Parameters:
    ///   - _: Absolute file path, or name of palette in the user's config directory
    public func setPalette(_ palette: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(palette),
        ])
    }

    /// Release The Palette Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = ServerDecorationPaletteProtocol
    
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

    public typealias Event = NoEvent
}


public let ServerDecorationPaletteProtocol = Protocol(
        name: "server_decoration_palette",
        interfaces: [
            OrgKdeKwinServerDecorationPaletteManager.interface,
OrgKdeKwinServerDecorationPalette.interface
        ]
    )

/// Server Side Window Decoration Manager
/// 
/// This interface allows to coordinate whether the server should create
/// a server-side window decoration around a wl_surface representing a
/// shell surface (wl_shell_surface or similar). By announcing support
/// for this interface the server indicates that it supports server
/// side decorations.
/// Use in conjunction with zxdg_decoration_manager_v1 is undefined.
public final class OrgKdeKwinServerDecorationManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_server_decoration_manager",
            version: 1,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_server_decoration",
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
                    name: "default_mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Create A Server-Side Decoration Object For A Given Surface
    /// 
    /// When a client creates a server-side decoration object it indicates
    /// that it supports the protocol. The client is supposed to tell the
    /// server whether it wants server-side decorations or will provide
    /// client-side decorations.
    /// If the client does not create a server-side decoration object for
    /// a surface the server interprets this as lack of support for this
    /// protocol and considers it as client-side decorated. Nevertheless a
    /// client-side decorated surface should use this protocol to indicate
    /// to the server that it does not want a server-side deco.
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinServerDecoration {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinServerDecoration.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = ServerDecorationProtocol
    
    public enum Mode: UInt32 {
        /// Undecorated: The surface is not decorated at all, neither server nor client-side. An example is a popup surface which should not be decorated.
        case `none` = 0

        /// Client-side decoration: The decoration is part of the surface and the client.
        case client = 1

        /// Server-side decoration: The server embeds the surface into a decoration frame.
        case server = 2
    }

    public enum Event: MessageProtocol {
        /// The Default Mode Used On The Server
        /// 
        /// This event is emitted directly after binding the interface. It contains
        /// the default mode for the decoration. When a new server decoration object
        /// is created this new object will be in the default mode until the first
        /// request_mode is requested.
        /// The server may change the default mode at any time.
        case defaultMode(mode: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.defaultMode(mode: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

public final class OrgKdeKwinServerDecoration: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_server_decoration",
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
                    name: "request_mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Release The Server Decoration Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// The Decoration Mode The Surface Wants To Use.
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - mode: The mode this surface wants to use.
    public func requestMode(mode: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(mode),
        ])
    }

    
    public static let `protocol`: Protocol = ServerDecorationProtocol
    
    public enum Mode: UInt32 {
        /// Undecorated: The surface is not decorated at all, neither server nor client-side. An example is a popup surface which should not be decorated.
        case `none` = 0

        /// Client-side decoration: The decoration is part of the surface and the client.
        case client = 1

        /// Server-side decoration: The server embeds the surface into a decoration frame.
        case server = 2
    }

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

    public enum Event: MessageProtocol {
        /// The New Decoration Mode Applied By The Server
        /// 
        /// This event is emitted directly after the decoration is created and
        /// represents the base decoration policy by the server. E.g. a server
        /// which wants all surfaces to be client-side decorated will send Client,
        /// a server which wants server-side decoration will send Server.
        /// The client can request a different mode through the decoration request.
        /// The server will acknowledge this by another event with the same mode. So
        /// even if a server prefers server-side decoration it's possible to force a
        /// client-side decoration.
        /// The server may emit this event at any time. In this case the client can
        /// again request a different mode. It's the responsibility of the server to
        /// prevent a feedback loop.
        case mode(mode: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.mode(mode: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let ServerDecorationProtocol = Protocol(
        name: "server_decoration",
        interfaces: [
            OrgKdeKwinServerDecorationManager.interface,
OrgKdeKwinServerDecoration.interface
        ]
    )

public final class OrgKdeKwinShadowManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_shadow_manager",
            version: 2,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_shadow",
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
                    name: "unset",
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
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                    since: 2
                )
                ,
            ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinShadow {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinShadow.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// 
    /// - Parameters:
    public func unset(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface.id),
        ])
    }

    /// Destroy The Org_Kde_Kwin_Shadow_Manager
    /// 
    /// Destroy the org_kde_kwin_shadow_manager object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    
    public static let `protocol`: Protocol = ShadowProtocol
    
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

public final class OrgKdeKwinShadow: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_shadow",
            version: 2,
            requests: [
                Message(
                    name: "commit",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "attach_left",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "attach_top_left",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "attach_top",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "attach_top_right",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "attach_right",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "attach_bottom_right",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "attach_bottom",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "attach_bottom_left",
                    arguments: [
                        Argument(
                            name: "buffer",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_left_offset",
                    arguments: [
                        Argument(
                            name: "offset",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_top_offset",
                    arguments: [
                        Argument(
                            name: "offset",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_right_offset",
                    arguments: [
                        Argument(
                            name: "offset",
                            type: .fixed,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_bottom_offset",
                    arguments: [
                        Argument(
                            name: "offset",
                            type: .fixed,
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
                    since: 2
                )
                ,
            ],
        )
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// 
    /// - Parameters:
    public func attachLeft(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachTopLeft(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachTop(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachTopRight(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachRight(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachBottomRight(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachBottom(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 7, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func attachBottomLeft(buffer: WlBuffer) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .object(buffer.id),
        ])
    }

    /// 
    /// - Parameters:
    public func setLeftOffset(offset: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
            .fixed(offset),
        ])
    }

    /// 
    /// - Parameters:
    public func setTopOffset(offset: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 10, [
            .fixed(offset),
        ])
    }

    /// 
    /// - Parameters:
    public func setRightOffset(offset: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 11, [
            .fixed(offset),
        ])
    }

    /// 
    /// - Parameters:
    public func setBottomOffset(offset: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 12, [
            .fixed(offset),
        ])
    }

    /// Destroy The Org_Kde_Kwin_Shadow
    /// 
    /// Destroy the org_kde_kwin_shadow object. If the org_kde_kwin_shadow is
    /// still set on a wl_surface the shadow will be immediately removed.
    /// Prefer to first call the request unset on the org_kde_kwin_shadow_manager and
    /// commit the wl_surface to apply the change.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        self.markDead()
        connection.send(self, 13, [
        ])
    }

    
    public static let `protocol`: Protocol = ShadowProtocol
    
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


public let ShadowProtocol = Protocol(
        name: "shadow",
        interfaces: [
            OrgKdeKwinShadowManager.interface,
OrgKdeKwinShadow.interface
        ]
    )

public final class OrgKdeKwinSlideManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_slide_manager",
            version: 1,
            requests: [
                Message(
                    name: "create",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "org_kde_kwin_slide",
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
                    name: "unset",
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
            ],
        )
    /// 
    /// - Parameters:
    public func create(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> OrgKdeKwinSlide {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: OrgKdeKwinSlide.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    /// 
    /// - Parameters:
    public func unset(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface.id),
        ])
    }

    
    public static let `protocol`: Protocol = SlideProtocol
    
    public typealias Event = NoEvent
}

/// Slide A Surface From A Location To Another
/// 
/// Ask the compositor to move the surface from a location to another
/// with a slide animation.
/// The from argument provides a clue about where the slide animation
/// begins, offset is the distance from screen edge to begin the animation.
public final class OrgKdeKwinSlide: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_slide",
            version: 1,
            requests: [
                Message(
                    name: "commit",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "set_location",
                    arguments: [
                        Argument(
                            name: "location",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_offset",
                    arguments: [
                        Argument(
                            name: "offset",
                            type: .int,
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
                )
                ,
            ],
        )
    public func commit() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
        ])
    }

    /// 
    /// - Parameters:
    public func setLocation(_ location: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .uint(location),
        ])
    }

    /// 
    /// - Parameters:
    public func setOffset(_ offset: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(offset),
        ])
    }

    /// Release The Slide Object
    /// 
    /// 
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 3, [
        ])
    }

    
    public static let `protocol`: Protocol = SlideProtocol
    
    public enum Location: UInt32 {
        case `left` = 0

        case top = 1

        case `right` = 2

        case bottom = 3
    }

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

    public typealias Event = NoEvent
}


public let SlideProtocol = Protocol(
        name: "slide",
        interfaces: [
            OrgKdeKwinSlideManager.interface,
OrgKdeKwinSlide.interface
        ]
    )

public final class QtSurfaceExtension: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "qt_surface_extension",
            version: 1,
            requests: [
                Message(
                    name: "get_extended_surface",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "qt_extended_surface",
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
    public func getExtendedSurface(surface: WlSurface, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> QtExtendedSurface {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: QtExtendedSurface.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(surface.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = SurfaceExtensionProtocol
    
    public typealias Event = NoEvent
}

public final class QtExtendedSurface: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "qt_extended_surface",
            version: 1,
            requests: [
                Message(
                    name: "update_generic_property",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "value",
                            type: .array,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_content_orientation_mask",
                    arguments: [
                        Argument(
                            name: "orientation",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_window_flags",
                    arguments: [
                        Argument(
                            name: "flags",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "raise",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "lower",
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "onscreen_visibility",
                    arguments: [
                        Argument(
                            name: "visible",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "set_generic_property",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "value",
                            type: .array,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "close",
                    arguments: [
                    ],
                )
                ,
            ],
        )
    /// 
    /// - Parameters:
    public func updateGenericProperty(name: String, value: Data) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(name),
            .array(value),
        ])
    }

    /// 
    /// - Parameters:
    public func setContentOrientationMask(orientation: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .int(orientation),
        ])
    }

    /// 
    /// - Parameters:
    public func setWindowFlags(flags: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(flags),
        ])
    }

    public func raise() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    public func lower() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    
    public static let `protocol`: Protocol = SurfaceExtensionProtocol
    
    public enum Orientation: UInt32 {
        case primaryorientation = 0

        case portraitorientation = 1

        case landscapeorientation = 2

        case invertedportraitorientation = 4

        case invertedlandscapeorientation = 8
    }

    public enum Windowflag: UInt32 {
        case overridessystemgestures = 1

        case staysontop = 2

        case bypasswindowmanager = 4
    }

    public enum Event: MessageProtocol {
        case onscreenVisibility(visible: Int32)

        case setGenericProperty(name: String, value: Data)

        case close

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.onscreenVisibility(visible: r.int())
            case 1:
                self = Self.setGenericProperty(name: r.string(), value: r.array())
            case 2:
                self = Self.close
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let SurfaceExtensionProtocol = Protocol(
        name: "surface_extension",
        interfaces: [
            QtSurfaceExtension.interface,
QtExtendedSurface.interface
        ]
    )

/// Text Input
/// 
/// The zwp_text_input_v2 interface represents text input and input methods
/// associated with a seat. It provides enter/leave events to follow the
/// text input focus for a seat.
/// Requests are used to enable/disable the text-input object and set
/// state information like surrounding and selected text or the content type.
/// The information about the entered text is sent to the text-input object
/// via the pre-edit and commit events. Using this interface removes the need
/// for applications to directly process hardware key events and compose text
/// out of them.
/// Text is valid UTF-8 encoded, indices and lengths are in bytes. Indices
/// have to always point to the first byte of an UTF-8 encoded code point.
/// Lengths are not allowed to contain just a part of an UTF-8 encoded code
/// point.
/// State is sent by the state requests (set_surrounding_text,
/// set_content_type, set_cursor_rectangle and set_preferred_language) and
/// an update_state request. After an enter or an input_method_change event
/// all state information is invalidated and needs to be resent from the
/// client. A reset or entering a new widget on client side also
/// invalidates all current state information.
public final class ZwpTextInputV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_v2",
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
                    name: "enable",
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
                    name: "disable",
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
                    name: "update_state",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "reason",
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
                    name: "input_panel_state",
                    arguments: [
                        Argument(
                            name: "state",
                            type: .uint,
                        )
                        ,
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
                    name: "preedit_string",
                    arguments: [
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
                            name: "direction",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "configure_surrounding_text",
                    arguments: [
                        Argument(
                            name: "before_cursor",
                            type: .int,
                        )
                        ,
                        Argument(
                            name: "after_cursor",
                            type: .int,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "input_method_changed",
                    arguments: [
                        Argument(
                            name: "serial",
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
            ],
        )
    /// Destroy The Wp_Text_Input
    /// 
    /// Destroy the wp_text_input object. Also disables all surfaces enabled
    /// through this wp_text_input object
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Enable Text Input For Surface
    /// 
    /// Enable text input in a surface (usually when a text entry inside of it
    /// has focus).
    /// This can be called before or after a surface gets text (or keyboard)
    /// focus via the enter event. Text input to a surface is only active
    /// when it has the current text (or keyboard) focus and is enabled.
    /// 
    /// - Parameters:
    public func enable(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(surface.id),
        ])
    }

    /// Disable Text Input For Surface
    /// 
    /// Disable text input in a surface (typically when there is no focus on any
    /// text entry inside the surface).
    /// 
    /// - Parameters:
    public func disable(surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(surface.id),
        ])
    }

    /// Show Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to show.
    /// This should be used for example to show a virtual keyboard again
    /// (with a tap) after it was closed by pressing on a close button on the
    /// keyboard.
    public func showInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    /// Hide Input Panels
    /// 
    /// Requests input panels (virtual keyboard) to hide.
    public func hideInputPanel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
        ])
    }

    /// Sets The Surrounding Text
    /// 
    /// Sets the plain surrounding text around the input position. Text is
    /// UTF-8 encoded. Cursor is the byte offset within the surrounding text.
    /// Anchor is the byte offset of the selection anchor within the
    /// surrounding text. If there is no selected text, anchor is the same as
    /// cursor.
    /// Make sure to always send some text before and after the cursor
    /// except when the cursor is at the beginning or end of text.
    /// When there was a configure_surrounding_text event take the
    /// before_cursor and after_cursor arguments into account for picking how
    /// much surrounding text to send.
    /// There is a maximum length of wayland messages so text can not be
    /// longer than 4000 bytes.
    /// 
    /// - Parameters:
    public func setSurroundingText(text: String, cursor: Int32, anchor: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 5, [
            .string(text),
            .int(cursor),
            .int(anchor),
        ])
    }

    /// Set Content Purpose And Hint
    /// 
    /// Sets the content purpose and content hint. While the purpose is the
    /// basic purpose of an input field, the hint flags allow to modify some
    /// of the behavior.
    /// When no content type is explicitly set, a normal content purpose with
    /// none hint should be assumed.
    /// 
    /// - Parameters:
    public func setContentType(hint: ContentHint, purpose: ContentPurpose) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .uint(hint.rawValue),
            .uint(purpose.rawValue),
        ])
    }

    /// Set Cursor Position
    /// 
    /// Sets the cursor outline as a x, y, width, height rectangle in surface
    /// local coordinates.
    /// Allows the compositor to put a window with word suggestions near the
    /// cursor.
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
    /// show a language specific layout. The "language" argument is a RFC-3066
    /// format language tag.
    /// It could be used for example in a word processor to indicate language of
    /// currently edited document or in an instant message application which
    /// tracks languages of contacts.
    /// 
    /// - Parameters:
    public func setPreferredLanguage(language: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 8, [
            .string(language),
        ])
    }

    /// Update State
    /// 
    /// Allows to atomically send state updates from client.
    /// This request should follow after a batch of state updating requests
    /// like set_surrounding_text, set_content_type, set_cursor_rectangle and
    /// set_preferred_language.
    /// The flags field indicates why an updated state is sent to the input
    /// method.
    /// Reset should be used by an editor widget after the text was changed
    /// outside of the normal input method flow.
    /// For "change" it is enough to send the changed state, else the full
    /// state should be send.
    /// Serial should be set to the serial from the last enter or
    /// input_method_changed event.
    /// To make sure to not receive outdated input method events after a
    /// reset or switching to a new widget wl_display_sync() should be used
    /// after update_state in these cases.
    /// 
    /// - Parameters:
    ///   - serial: serial of the enter or input_method_changed event
    public func updateState(serial: UInt32, reason: UpdateState) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 9, [
            .uint(serial),
            .uint(reason.rawValue),
        ])
    }

    
    public static let `protocol`: Protocol = TextInputUnstableV2Protocol
    
    public struct ContentHint: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        /// no special behaviour
        public static let `none`: ContentHint = []

        /// suggest word completions
        public static let autoCompletion = ContentHint(rawValue: 1)

        /// suggest word corrections
        public static let autoCorrection = ContentHint(rawValue: 2)

        /// switch to uppercase letters at the start of a sentence
        public static let autoCapitalization = ContentHint(rawValue: 4)

        /// prefer lowercase letters
        public static let lowercase = ContentHint(rawValue: 8)

        /// prefer uppercase letters
        public static let uppercase = ContentHint(rawValue: 16)

        /// prefer casing for titles and headings (can be language dependent)
        public static let titlecase = ContentHint(rawValue: 32)

        /// characters should be hidden
        public static let hiddenText = ContentHint(rawValue: 64)

        /// typed text should not be stored
        public static let sensitiveData = ContentHint(rawValue: 128)

        /// just latin characters should be entered
        public static let latin = ContentHint(rawValue: 256)

        /// the text input is multiline
        public static let multiline = ContentHint(rawValue: 512)
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

    public enum UpdateState: UInt32 {
        /// updated state because it changed
        case change = 0

        /// full state after enter or input_method_changed event
        case full = 1

        /// full state after reset
        case reset = 2

        /// full state after switching focus to a different widget on client side
        case enter = 3
    }

    public enum InputPanelVisibility: UInt32 {
        /// the input panel (virtual keyboard) is hidden
        case hidden = 0

        /// the input panel (virtual keyboard) is visible
        case visible = 1
    }

    public enum PreeditStyle: UInt32 {
        /// default style for composing text
        case `default` = 0

        /// composing text should be shown the same as non-composing text
        case `none` = 1

        /// composing text might be bold
        case active = 2

        /// composing text might be cursive
        case inactive = 3

        /// composing text might have a different background color
        case highlight = 4

        /// composing text might be underlined
        case underline = 5

        /// composing text should be shown the same as selected text
        case selection = 6

        /// composing text might be underlined with a red wavy line
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

    public enum Event: MessageProtocol {
        /// Enter Event
        /// 
        /// Notification that this seat's text-input focus is on a certain surface.
        /// When the seat has the keyboard capability the text-input focus follows
        /// the keyboard focus.
        case enter(serial: UInt32, surface: WlSurface)

        /// Leave Event
        /// 
        /// Notification that this seat's text-input focus is no longer on
        /// a certain surface.
        /// The leave notification is sent before the enter notification
        /// for the new focus.
        /// When the seat has the keyboard capability the text-input focus follows
        /// the keyboard focus.
        case leave(serial: UInt32, surface: WlSurface)

        /// State Of The Input Panel
        /// 
        /// Notification that the visibility of the input panel (virtual keyboard)
        /// changed.
        /// The rectangle x, y, width, height defines the area overlapped by the
        /// input panel (virtual keyboard) on the surface having the text
        /// focus in surface local coordinates.
        /// That can be used to make sure widgets are visible and not covered by
        /// a virtual keyboard.
        case inputPanelState(state: InputPanelVisibility, x: Int32, y: Int32, width: Int32, height: Int32)

        /// Pre-Edit
        /// 
        /// Notify when a new composing text (pre-edit) should be set around the
        /// current cursor position. Any previously set composing text should
        /// be removed.
        /// The commit text can be used to replace the composing text in some cases
        /// (for example when losing focus).
        /// The text input should also handle all preedit_style and preedit_cursor
        /// events occurring directly before preedit_string.
        case preeditString(text: String, commit: String)

        /// Pre-Edit Styling
        /// 
        /// Sets styling information on composing text. The style is applied for
        /// length bytes from index relative to the beginning of the composing
        /// text (as byte offset). Multiple styles can be applied to a composing
        /// text by sending multiple preedit_styling events.
        /// This event is handled as part of a following preedit_string event.
        case preeditStyling(index: UInt32, length: UInt32, style: PreeditStyle)

        /// Pre-Edit Cursor
        /// 
        /// Sets the cursor position inside the composing text (as byte
        /// offset) relative to the start of the composing text. When index is a
        /// negative number no cursor is shown.
        /// When no preedit_cursor event is sent the cursor will be at the end of
        /// the composing text by default.
        /// This event is handled as part of a following preedit_string event.
        case preeditCursor(index: Int32)

        /// Commit
        /// 
        /// Notify when text should be inserted into the editor widget. The text to
        /// commit could be either just a single character after a key press or the
        /// result of some composing (pre-edit). It could be also an empty text
        /// when some text should be removed (see delete_surrounding_text) or when
        /// the input cursor should be moved (see cursor_position).
        /// Any previously set composing text should be removed.
        case commitString(text: String)

        /// Set Cursor To New Position
        /// 
        /// Notify when the cursor or anchor position should be modified.
        /// This event should be handled as part of a following commit_string
        /// event.
        /// The text between anchor and index should be selected.
        case cursorPosition(index: Int32, anchor: Int32)

        /// Delete Surrounding Text
        /// 
        /// Notify when the text around the current cursor position should be
        /// deleted. BeforeLength and afterLength is the length (in bytes) of text
        /// before and after the current cursor position (excluding the selection)
        /// to delete.
        /// This event should be handled as part of a following commit_string
        /// or preedit_string event.
        case deleteSurroundingText(beforeLength: UInt32, afterLength: UInt32)

        /// Modifiers Map
        /// 
        /// Transfer an array of 0-terminated modifiers names. The position in
        /// the array is the index of the modifier as used in the modifiers
        /// bitmask in the keysym event.
        case modifiersMap(map: Data)

        /// Keysym
        /// 
        /// Notify when a key event was sent. Key events should not be used
        /// for normal text input operations, which should be done with
        /// commit_string, delete_surrounding_text, etc. The key event follows
        /// the wl_keyboard key event convention. Sym is a XKB keysym, state a
        /// wl_keyboard key_state. Modifiers are a mask for effective modifiers
        /// (where the modifier indices are set by the modifiers_map event)
        case keysym(time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32)

        /// Language
        /// 
        /// Sets the language of the input text. The "language" argument is a RFC-3066
        /// format language tag.
        case language(language: String)

        /// Text Direction
        /// 
        /// Sets the text direction of input text.
        /// It is mainly needed for showing input cursor on correct side of the
        /// editor when there is no input yet done and making sure neutral
        /// direction text is laid out properly.
        case textDirection(direction: TextDirection)

        /// Configure Amount Of Surrounding Text To Be Sent
        /// 
        /// Configure what amount of surrounding text is expected by the
        /// input method. The surrounding text will be sent in the
        /// set_surrounding_text request on the following state information updates.
        case configureSurroundingText(beforeCursor: Int32, afterCursor: Int32)

        /// Notifies About A Changed Input Method
        /// 
        /// The input method changed on compositor side, which invalidates all
        /// current state information. New state information should be sent from
        /// the client via state requests (set_surrounding_text,
        /// set_content_hint, ...) and update_state.
        case inputMethodChanged(serial: UInt32, flags: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.enter(serial: r.uint(), surface: r.object(type: WlSurface.self))
            case 1:
                self = Self.leave(serial: r.uint(), surface: r.object(type: WlSurface.self))
            case 2:
                self = Self.inputPanelState(state: try _parseEnum(into: InputPanelVisibility.self, r.uint()), x: r.int(), y: r.int(), width: r.int(), height: r.int())
            case 3:
                self = Self.preeditString(text: r.string(), commit: r.string())
            case 4:
                self = Self.preeditStyling(index: r.uint(), length: r.uint(), style: try _parseEnum(into: PreeditStyle.self, r.uint()))
            case 5:
                self = Self.preeditCursor(index: r.int())
            case 6:
                self = Self.commitString(text: r.string())
            case 7:
                self = Self.cursorPosition(index: r.int(), anchor: r.int())
            case 8:
                self = Self.deleteSurroundingText(beforeLength: r.uint(), afterLength: r.uint())
            case 9:
                self = Self.modifiersMap(map: r.array())
            case 10:
                self = Self.keysym(time: r.uint(), sym: r.uint(), state: r.uint(), modifiers: r.uint())
            case 11:
                self = Self.language(language: r.string())
            case 12:
                self = Self.textDirection(direction: try _parseEnum(into: TextDirection.self, r.uint()))
            case 13:
                self = Self.configureSurroundingText(beforeCursor: r.int(), afterCursor: r.int())
            case 14:
                self = Self.inputMethodChanged(serial: r.uint(), flags: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Text Input Manager
/// 
/// A factory for text-input objects. This object is a global singleton.
public final class ZwpTextInputManagerV2: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwp_text_input_manager_v2",
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
                    name: "get_text_input",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwp_text_input_v2",
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
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A New Text Input Object
    /// 
    /// Creates a new text-input object for a given seat.
    /// 
    /// - Parameters:
    public func getTextInput(seat: WlSeat, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwpTextInputV2 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwpTextInputV2.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(seat.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = TextInputUnstableV2Protocol
    
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


public let TextInputUnstableV2Protocol = Protocol(
        name: "text_input_unstable_v2",
        interfaces: [
            ZwpTextInputV2.interface,
ZwpTextInputManagerV2.interface
        ]
    )

/// Text Input
/// 
/// An object used for text input. Adds support for text input and input
/// methods to applications. A text-input object is created from a
/// wl_text_input_manager and corresponds typically to a text entry in an
/// application.
/// Requests are used to activate/deactivate the text-input object and set
/// state information like surrounding and selected text or the content type.
/// The information about entered text is sent to the text-input object via
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
public final class WlTextInput: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wl_text_input",
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
    /// Requests the text-input object to be activated (typically when the
    /// text entry gets focus).
    /// The seat argument is a wl_seat which maintains the focus for this
    /// activation. The surface argument is a wl_surface assigned to the
    /// text-input object and tracked for focus lost. The enter event
    /// is emitted on successful activation.
    /// 
    /// - Parameters:
    public func activate(seat: WlSeat, surface: WlSurface) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(seat.id),
            .object(surface.id),
        ])
    }

    /// Request Deactivation
    /// 
    /// Requests the text-input object to be deactivated (typically when the
    /// text entry lost focus). The seat argument is a wl_seat which was used
    /// for activation.
    /// 
    /// - Parameters:
    public func deactivate(seat: WlSeat) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(seat.id),
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
    /// text anchor is the same as cursor.
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
    public func setContentType(hint: UInt32, purpose: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 6, [
            .uint(hint),
            .uint(purpose),
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
    /// show a language specific layout. The "language" argument is a RFC-3066
    /// format language tag.
    /// It could be used for example in a word processor to indicate language of
    /// currently edited document or in an instant message application which tracks
    /// languages of contacts.
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

    
    public static let `protocol`: Protocol = TextProtocol
    
    public enum ContentHint: UInt32 {
        /// no special behaviour
        case `none` = 0

        /// auto completion, correction and capitalization
        case `default` = 7

        /// hidden and sensitive text
        case password = 192

        /// suggest word completions
        case autoCompletion = 1

        /// suggest word corrections
        case autoCorrection = 2

        /// switch to uppercase letters at the start of a sentence
        case autoCapitalization = 4

        /// prefer lowercase letters
        case lowercase = 8

        /// prefer uppercase letters
        case uppercase = 16

        /// prefer casing for titles and headings (can be language dependent)
        case titlecase = 32

        /// characters should be hidden
        case hiddenText = 64

        /// typed text should not be stored
        case sensitiveData = 128

        /// just latin characters should be entered
        case latin = 256

        /// the text input is multiline
        case multiline = 512
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

    public enum Event: MessageProtocol {
        /// Enter Event
        /// 
        /// Notify the text-input object when it received focus. Typically in
        /// response to an activate request.
        case enter(surface: WlSurface)

        /// Leave Event
        /// 
        /// Notify the text-input object when it lost focus. Either in response
        /// to a deactivate request or when the assigned surface lost focus or was
        /// destroyed.
        case leave

        /// Modifiers Map
        /// 
        /// Transfer an array of 0-terminated modifiers names. The position in
        /// the array is the index of the modifier as used in the modifiers
        /// bitmask in the keysym event.
        case modifiersMap(map: Data)

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
        case preeditStyling(index: UInt32, length: UInt32, style: UInt32)

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
        /// result of some composing (pre-edit). It could be also an empty text
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
        /// the wl_keyboard key event convention. Sym is a XKB keysym, state a
        /// wl_keyboard key_state. Modifiers are a mask for effective modifiers
        /// (where the modifier indices are set by the modifiers_map event)
        case keysym(serial: UInt32, time: UInt32, sym: UInt32, state: UInt32, modifiers: UInt32)

        /// Language
        /// 
        /// Sets the language of the input text. The "language" argument is a RFC-3066
        /// format language tag.
        case language(serial: UInt32, language: String)

        /// Text Direction
        /// 
        /// Sets the text direction of input text.
        /// It is mainly needed for showing input cursor on correct side of the
        /// editor when there is no input yet done and making sure neutral
        /// direction text is laid out properly.
        case textDirection(serial: UInt32, direction: UInt32)

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
                self = Self.preeditStyling(index: r.uint(), length: r.uint(), style: r.uint())
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
                self = Self.textDirection(serial: r.uint(), direction: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Text Input Manager
/// 
/// A factory for text-input objects. This object is a global singleton.
public final class WlTextInputManager: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "wl_text_input_manager",
            version: 1,
            requests: [
                Message(
                    name: "create_text_input",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "wl_text_input",
                        )
                        ,
                    ],
                )
                ,
            ],
        )
    /// Create Text Input
    /// 
    /// Creates a new text-input object.
    public func createTextInput(queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WlTextInput {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlTextInput.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
        ])
        return id
    }

    
    public static let `protocol`: Protocol = TextProtocol
    
    public typealias Event = NoEvent
}


public let TextProtocol = Protocol(
        name: "text",
        interfaces: [
            WlTextInput.interface,
WlTextInputManager.interface
        ]
    )

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
                        )
                        ,
                        Argument(
                            name: "wl_resource",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                    ],
                    since: 1
                )
                ,
                Message(
                    name: "attach_eglstream_consumer_attribs",
                    arguments: [
                        Argument(
                            name: "wl_surface",
                            type: .object,
                            interface: "wl_surface",
                        )
                        ,
                        Argument(
                            name: "wl_resource",
                            type: .object,
                            interface: "wl_buffer",
                        )
                        ,
                        Argument(
                            name: "attribs",
                            type: .array,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
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

/// Protocol For Managing Pipewire Feeds Of The Different Displays And Windows
/// 
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class ZkdeScreencastUnstableV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zkde_screencast_unstable_v1",
            version: 6,
            requests: [
                Message(
                    name: "stream_output",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        )
                        ,
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "stream_window",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        )
                        ,
                        Argument(
                            name: "window_uuid",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "pointer",
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
                Message(
                    name: "stream_virtual_output",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        )
                        ,
                        Argument(
                            name: "name",
                            type: .string,
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
                            name: "scale",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 2
                )
                ,
                Message(
                    name: "stream_region",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        )
                        ,
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
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "height",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "scale",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 3
                )
                ,
                Message(
                    name: "stream_virtual_output_with_description",
                    arguments: [
                        Argument(
                            name: "stream",
                            type: .newId,
                            interface: "zkde_screencast_stream_unstable_v1",
                        )
                        ,
                        Argument(
                            name: "name",
                            type: .string,
                        )
                        ,
                        Argument(
                            name: "description",
                            type: .string,
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
                            name: "scale",
                            type: .fixed,
                        )
                        ,
                        Argument(
                            name: "pointer",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 4
                )
                ,
            ],
        )
    /// Requests A Feed From A Given Source
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - pointer: Requested pointer mode
    public func streamOutput(output: WlOutput, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(stream.id),
            .object(output.id),
            .uint(pointer),
        ])
        return stream
    }

    /// Requests A Feed From A Given Source
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - windowUuid: window Identifier
    ///   - pointer: Requested pointer mode
    public func streamWindow(windowUuid: String, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(stream.id),
            .string(windowUuid),
            .uint(pointer),
        ])
        return stream
    }

    /// Destroy The Zkde_Screencast_Unstable_V1
    /// 
    /// Destroy the zkde_screencast_unstable_v1 object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 2, [
        ])
    }

    /// Requests A Feed From A New Virtual Output
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - name: name of the created output
    ///   - width: Logical width resolution
    ///   - height: Logical height resolution
    ///   - scale: Scaling factor of the display where it's to be displayed
    ///   - pointer: Requested pointer mode
    public func streamVirtualOutput(name: String, width: Int32, height: Int32, scale: Double, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 3, [
            .object(stream.id),
            .string(name),
            .int(width),
            .int(height),
            .fixed(scale),
            .uint(pointer),
        ])
        return stream
    }

    /// Requests A Feed From Region In The Workspace
    /// 
    /// Since version 5, the compositor will choose the highest scale
    /// factor for the region if the given scale is 0.0.
    /// 
    /// - Parameters:
    ///   - x: Logical left position
    ///   - y: Logical top position
    ///   - width: Logical width resolution
    ///   - height: Logical height resolution
    ///   - scale: Scaling factor of the output recording
    ///   - pointer: Requested pointer mode
    public func streamRegion(x: Int32, y: Int32, width: UInt32, height: UInt32, scale: Double, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 4, [
            .object(stream.id),
            .int(x),
            .int(y),
            .uint(width),
            .uint(height),
            .fixed(scale),
            .uint(pointer),
        ])
        return stream
    }

    /// Requests A Feed From A New Virtual Output
    /// 
    /// 
    /// 
    /// - Parameters:
    ///   - name: name of the created output
    ///   - description: user visible description of the created output
    ///   - width: Logical width resolution
    ///   - height: Logical height resolution
    ///   - scale: Scaling factor of the display where it's to be displayed
    ///   - pointer: Requested pointer mode
    public func streamVirtualOutputWithDescription(name: String, description: String, width: Int32, height: Int32, scale: Double, pointer: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZkdeScreencastStreamUnstableV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let stream = connection.createProxy(type: ZkdeScreencastStreamUnstableV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 5, [
            .object(stream.id),
            .string(name),
            .string(description),
            .int(width),
            .int(height),
            .fixed(scale),
            .uint(pointer),
        ])
        return stream
    }

    
    public static let `protocol`: Protocol = ZkdeScreencastUnstableV1Protocol
    
    public enum Pointer: UInt32 {
        /// No cursor
        case hidden = 1

        /// Render the cursor on the stream
        case embedded = 2

        /// Send metadata about where the cursor is through PipeWire
        case `metadata` = 4
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

public final class ZkdeScreencastStreamUnstableV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zkde_screencast_stream_unstable_v1",
            version: 6,
            requests: [
                Message(
                    name: "close",
                    type: .destructor,
                    arguments: [
                    ],
                )
                ,
            ],
            events: [
                Message(
                    name: "closed",
                    arguments: [
                    ],
                )
                ,
                Message(
                    name: "created",
                    arguments: [
                        Argument(
                            name: "node",
                            type: .uint,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "failed",
                    arguments: [
                        Argument(
                            name: "error",
                            type: .string,
                        )
                        ,
                    ],
                )
                ,
                Message(
                    name: "serial",
                    arguments: [
                        Argument(
                            name: "object_serial_hi",
                            type: .uint,
                        )
                        ,
                        Argument(
                            name: "object_serial_low",
                            type: .uint,
                        )
                        ,
                    ],
                    since: 6
                )
                ,
            ],
        )
    /// Indicates We Are Done With The Stream And The Communication Is Over.
    /// 
    /// 
    public func close() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = ZkdeScreencastUnstableV1Protocol
    
    var destructor: Destructor? = .close

    enum Destructor {
        case close
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .close: try? self.close()
                case nil: break
            }
        }
    }

    public enum Event: MessageProtocol {
        /// Notifies That The Server Has Stopped The Stream. Clients Should Now Call Close.
        /// 
        /// 
        case closed

        /// Notifies About A Pipewire Feed Being Created
        /// 
        /// Deprecated since version 6, use the object serial from the serial event instead
        case created(node: UInt32)

        /// Offers An Error Message So The Client Knows The Created Event Will Not Arrive, And The Client Should Close The Resource.
        /// 
        /// 
        case failed(error: String)

        /// The Pipewire Object Serial
        /// 
        /// The pipewire object serial of the stream. Should be preferred over the node id which is prone to id reuse.
        /// Will be sent before the created event.
        case serial(objectSerialHi: UInt32, objectSerialLow: UInt32)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.closed
            case 1:
                self = Self.created(node: r.uint())
            case 2:
                self = Self.failed(error: r.string())
            case 3:
                self = Self.serial(objectSerialHi: r.uint(), objectSerialLow: r.uint())
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}


public let ZkdeScreencastUnstableV1Protocol = Protocol(
        name: "zkde_screencast_unstable_v1",
        interfaces: [
            ZkdeScreencastUnstableV1.interface,
ZkdeScreencastStreamUnstableV1.interface
        ]
    )

#endif
