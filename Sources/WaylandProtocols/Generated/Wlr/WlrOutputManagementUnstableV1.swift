import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WLR
/// Output Device Configuration Manager
/// 
/// This interface is a manager that allows reading and writing the current
/// output device configuration.
/// Output devices that display pixels (e.g. a physical monitor or a virtual
/// output in a window) are represented as heads. Heads cannot be created nor
/// destroyed by the client, but they can be enabled or disabled and their
/// properties can be changed. Each head may have one or more available modes.
/// Whenever a head appears (e.g. a monitor is plugged in), it will be
/// advertised via the head event. Immediately after the output manager is
/// bound, all current heads are advertised.
/// Whenever a head's properties change, the relevant wlr_output_head events
/// will be sent. Not all head properties will be sent: only properties that
/// have changed need to.
/// Whenever a head disappears (e.g. a monitor is unplugged), a
/// wlr_output_head.finished event will be sent.
/// After one or more heads appear, change or disappear, the done event will
/// be sent. It carries a serial which can be used in a create_configuration
/// request to update heads properties.
/// The information obtained from this protocol should only be used for output
/// configuration purposes. This protocol is not designed to be a generic
/// output property advertisement protocol for regular clients. Instead,
/// protocols such as xdg-output should be used.
public final class ZwlrOutputManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_manager_v1",
            version: 4,
            requests: [
                Message(
                    name: "create_configuration",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_output_configuration_v1",
                        ),
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "stop",
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "head",
                    arguments: [
                        Argument(
                            name: "head",
                            type: .newId,
                            interface: "zwlr_output_head_v1",
                        ),
                    ],
                ),
                Message(
                    name: "done",
                    arguments: [
                        Argument(
                            name: "serial",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "finished",
                    type: .destructor,
                    arguments: [],
                ),
            ]
        )
    /// Create A New Output Configuration Object
    /// 
    /// Create a new output configuration object. This allows to update head
    /// properties.
    /// 
    /// - Parameters:
    public func createConfiguration(serial: UInt32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrOutputConfigurationV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwlrOutputConfigurationV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .uint(serial),
        ])
        return id
    }

    /// Stop Sending Events
    /// 
    /// Indicates the client no longer wishes to receive events for output
    /// configuration changes. However the compositor may emit further events,
    /// until the finished event is emitted.
    /// The client must not send any more requests after this one.
    public func stop() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
    public enum Event: Decodable {
        /// Introduce A New Head
        /// 
        /// This event introduces a new head. This happens whenever a new head
        /// appears (e.g. a monitor is plugged in) or after the output manager is
        /// bound.
        case head(head: ZwlrOutputHeadV1)

        /// Sent All Information About Current Configuration
        /// 
        /// This event is sent after all information has been sent after binding to
        /// the output manager object and after any subsequent changes. This applies
        /// to child head and mode objects as well. In other words, this event is
        /// sent whenever a head or mode is created or destroyed and whenever one of
        /// their properties has been changed. Not all state is re-sent each time
        /// the current configuration changes: only the actual changes are sent.
        /// This allows changes to the output configuration to be seen as atomic,
        /// even if they happen via multiple events.
        /// A serial is sent to be used in a future create_configuration request.
        case done(serial: UInt32)

        /// The Compositor Has Finished With The Manager
        /// 
        /// This event indicates that the compositor is done sending manager events.
        /// The compositor will destroy the object immediately after sending this
        /// event, so it will become invalid and the client should release any
        /// resources associated with it.
        case finished

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.head(head: r.newId(type: ZwlrOutputHeadV1.self))
            case 1:
                self = Self.done(serial: r.uint())
            case 2:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Output Device
/// 
/// A head is an output device. The difference between a wl_output object and
/// a head is that heads are advertised even if they are turned off. A head
/// object only advertises properties and cannot be used directly to change
/// them.
/// A head has some read-only properties: modes, name, description and
/// physical_size. These cannot be changed by clients.
/// Other properties can be updated via a wlr_output_configuration object.
/// Properties sent via this interface are applied atomically via the
/// wlr_output_manager.done event. No guarantees are made regarding the order
/// in which properties are sent.
public final class ZwlrOutputHeadV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_head_v1",
            version: 4,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [],
                    since: 3
                ),
            ],
            events: [
                Message(
                    name: "name",
                    arguments: [
                        Argument(
                            name: "name",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "description",
                    arguments: [
                        Argument(
                            name: "description",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "physical_size",
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
                Message(
                    name: "mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .newId,
                            interface: "zwlr_output_mode_v1",
                        ),
                    ],
                ),
                Message(
                    name: "enabled",
                    arguments: [
                        Argument(
                            name: "enabled",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "current_mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .object,
                            interface: "zwlr_output_mode_v1",
                        ),
                    ],
                ),
                Message(
                    name: "position",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .int,
                        ),
                        Argument(
                            name: "y",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "transform",
                    arguments: [
                        Argument(
                            name: "transform",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "scale",
                    arguments: [
                        Argument(
                            name: "scale",
                            type: .fixed,
                        ),
                    ],
                ),
                Message(
                    name: "finished",
                    arguments: [],
                ),
                Message(
                    name: "make",
                    arguments: [
                        Argument(
                            name: "make",
                            type: .string,
                        ),
                    ],
                    since: 2
                ),
                Message(
                    name: "model",
                    arguments: [
                        Argument(
                            name: "model",
                            type: .string,
                        ),
                    ],
                    since: 2
                ),
                Message(
                    name: "serial_number",
                    arguments: [
                        Argument(
                            name: "serial_number",
                            type: .string,
                        ),
                    ],
                    since: 2
                ),
                Message(
                    name: "adaptive_sync",
                    arguments: [
                        Argument(
                            name: "state",
                            type: .uint,
                        ),
                    ],
                    since: 4
                ),
            ]
        )
    /// Destroy The Head Object
    /// 
    /// This request indicates that the client will no longer use this head
    /// object.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
    public enum AdaptiveSyncState: UInt32 {
        /// adaptive sync is disabled
        case disabled = 0

        /// adaptive sync is enabled
        case enabled = 1
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

    public enum Event: Decodable {
        /// Head Name
        /// 
        /// This event describes the head name.
        /// The naming convention is compositor defined, but limited to alphanumeric
        /// characters and dashes (-). Each name is unique among all wlr_output_head
        /// objects, but if a wlr_output_head object is destroyed the same name may
        /// be reused later. The names will also remain consistent across sessions
        /// with the same hardware and software configuration.
        /// Examples of names include 'HDMI-A-1', 'WL-1', 'X11-1', etc. However, do
        /// not assume that the name is a reflection of an underlying DRM
        /// connector, X11 connection, etc.
        /// If this head matches a wl_output, the wl_output.name event must report
        /// the same name.
        /// The name event is sent after a wlr_output_head object is created. This
        /// event is only sent once per object, and the name does not change over
        /// the lifetime of the wlr_output_head object.
        case name(name: String)

        /// Head Description
        /// 
        /// This event describes a human-readable description of the head.
        /// The description is a UTF-8 string with no convention defined for its
        /// contents. Examples might include 'Foocorp 11" Display' or 'Virtual X11
        /// output via :1'. However, do not assume that the name is a reflection of
        /// the make, model, serial of the underlying DRM connector or the display
        /// name of the underlying X11 connection, etc.
        /// If this head matches a wl_output, the wl_output.description event must
        /// report the same name.
        /// The description event is sent after a wlr_output_head object is created.
        /// This event is only sent once per object, and the description does not
        /// change over the lifetime of the wlr_output_head object.
        case description(description: String)

        /// Head Physical Size
        /// 
        /// This event describes the physical size of the head. This event is only
        /// sent if the head has a physical size (e.g. is not a projector or a
        /// virtual device).
        /// The physical size event is sent after a wlr_output_head object is created. This
        /// event is only sent once per object, and the physical size does not change over
        /// the lifetime of the wlr_output_head object.
        case physicalSize(width: Int32, height: Int32)

        /// Introduce A Mode
        /// 
        /// This event introduces a mode for this head. It is sent once per
        /// supported mode.
        case mode(mode: ZwlrOutputModeV1)

        /// Head Is Enabled Or Disabled
        /// 
        /// This event describes whether the head is enabled. A disabled head is not
        /// mapped to a region of the global compositor space.
        /// When a head is disabled, some properties (current_mode, position,
        /// transform and scale) are irrelevant.
        case enabled(enabled: Int32)

        /// Current Mode
        /// 
        /// This event describes the mode currently in use for this head. It is only
        /// sent if the output is enabled.
        case currentMode(mode: ZwlrOutputModeV1)

        /// Current Position
        /// 
        /// This events describes the position of the head in the global compositor
        /// space. It is only sent if the output is enabled.
        case position(x: Int32, y: Int32)

        /// Current Transformation
        /// 
        /// This event describes the transformation currently applied to the head.
        /// It is only sent if the output is enabled.
        case transform(transform: Int32)

        /// Current Scale
        /// 
        /// This events describes the scale of the head in the global compositor
        /// space. It is only sent if the output is enabled.
        case scale(scale: Double)

        /// The Head Has Disappeared
        /// 
        /// This event indicates that the head is no longer available. The head
        /// object becomes inert. Clients should send a destroy request and release
        /// any resources associated with it.
        case finished

        /// Head Manufacturer
        /// 
        /// This event describes the manufacturer of the head.
        /// Together with the model and serial_number events the purpose is to
        /// allow clients to recognize heads from previous sessions and for example
        /// load head-specific configurations back.
        /// It is not guaranteed this event will be ever sent. A reason for that
        /// can be that the compositor does not have information about the make of
        /// the head or the definition of a make is not sensible in the current
        /// setup, for example in a virtual session. Clients can still try to
        /// identify the head by available information from other events but should
        /// be aware that there is an increased risk of false positives.
        /// If sent, the make event is sent after a wlr_output_head object is
        /// created and only sent once per object. The make does not change over
        /// the lifetime of the wlr_output_head object.
        /// It is not recommended to display the make string in UI to users. For
        /// that the string provided by the description event should be preferred.
        case make(make: String)

        /// Head Model
        /// 
        /// This event describes the model of the head.
        /// Together with the make and serial_number events the purpose is to
        /// allow clients to recognize heads from previous sessions and for example
        /// load head-specific configurations back.
        /// It is not guaranteed this event will be ever sent. A reason for that
        /// can be that the compositor does not have information about the model of
        /// the head or the definition of a model is not sensible in the current
        /// setup, for example in a virtual session. Clients can still try to
        /// identify the head by available information from other events but should
        /// be aware that there is an increased risk of false positives.
        /// If sent, the model event is sent after a wlr_output_head object is
        /// created and only sent once per object. The model does not change over
        /// the lifetime of the wlr_output_head object.
        /// It is not recommended to display the model string in UI to users. For
        /// that the string provided by the description event should be preferred.
        case model(model: String)

        /// Head Serial Number
        /// 
        /// This event describes the serial number of the head.
        /// Together with the make and model events the purpose is to allow clients
        /// to recognize heads from previous sessions and for example load head-
        /// specific configurations back.
        /// It is not guaranteed this event will be ever sent. A reason for that
        /// can be that the compositor does not have information about the serial
        /// number of the head or the definition of a serial number is not sensible
        /// in the current setup. Clients can still try to identify the head by
        /// available information from other events but should be aware that there
        /// is an increased risk of false positives.
        /// If sent, the serial number event is sent after a wlr_output_head object
        /// is created and only sent once per object. The serial number does not
        /// change over the lifetime of the wlr_output_head object.
        /// It is not recommended to display the serial_number string in UI to
        /// users. For that the string provided by the description event should be
        /// preferred.
        case serialNumber(serialNumber: String)

        /// Current Adaptive Sync State
        /// 
        /// This event describes whether adaptive sync is currently enabled for
        /// the head or not. Adaptive sync is also known as Variable Refresh
        /// Rate or VRR.
        case adaptiveSync(state: AdaptiveSyncState)

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.name(name: r.string())
            case 1:
                self = Self.description(description: r.string())
            case 2:
                self = Self.physicalSize(width: r.int(), height: r.int())
            case 3:
                self = Self.mode(mode: r.newId(type: ZwlrOutputModeV1.self))
            case 4:
                self = Self.enabled(enabled: r.int())
            case 5:
                self = Self.currentMode(mode: r.object(type: ZwlrOutputModeV1.self))
            case 6:
                self = Self.position(x: r.int(), y: r.int())
            case 7:
                self = Self.transform(transform: r.int())
            case 8:
                self = Self.scale(scale: r.fixed())
            case 9:
                self = Self.finished
            case 10:
                self = Self.make(make: r.string())
            case 11:
                self = Self.model(model: r.string())
            case 12:
                self = Self.serialNumber(serialNumber: r.string())
            case 13:
                self = Self.adaptiveSync(state: try _parseEnum(into: AdaptiveSyncState.self, r.uint()))
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
/// wlr_output_manager.done event. No guarantees are made regarding the order
/// in which properties are sent.
public final class ZwlrOutputModeV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_mode_v1",
            version: 3,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [],
                    since: 3
                ),
            ],
            events: [
                Message(
                    name: "size",
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
                Message(
                    name: "refresh",
                    arguments: [
                        Argument(
                            name: "refresh",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "preferred",
                    arguments: [],
                ),
                Message(
                    name: "finished",
                    arguments: [],
                ),
            ]
        )
    /// Destroy The Mode Object
    /// 
    /// This request indicates that the client will no longer use this mode
    /// object.
    public func release() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
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

        /// The Mode Has Disappeared
        /// 
        /// This event indicates that the mode is no longer available. The mode
        /// object becomes inert. Clients should send a destroy request and release
        /// any resources associated with it.
        case finished

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.size(width: r.int(), height: r.int())
            case 1:
                self = Self.refresh(refresh: r.int())
            case 2:
                self = Self.preferred
            case 3:
                self = Self.finished
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Output Configuration
/// 
/// This object is used by the client to describe a full output configuration.
/// First, the client needs to setup the output configuration. Each head can
/// be either enabled (and configured) or disabled. It is a protocol error to
/// send two enable_head or disable_head requests with the same head. It is a
/// protocol error to omit a head in a configuration.
/// Then, the client can apply or test the configuration. The compositor will
/// then reply with a succeeded, failed or cancelled event. Finally the client
/// should destroy the configuration object.
public final class ZwlrOutputConfigurationV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_configuration_v1",
            version: 4,
            requests: [
                Message(
                    name: "enable_head",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .newId,
                            interface: "zwlr_output_configuration_head_v1",
                        ),
                        Argument(
                            name: "head",
                            type: .object,
                            interface: "zwlr_output_head_v1",
                        ),
                    ],
                ),
                Message(
                    name: "disable_head",
                    arguments: [
                        Argument(
                            name: "head",
                            type: .object,
                            interface: "zwlr_output_head_v1",
                        ),
                    ],
                ),
                Message(
                    name: "apply",
                    arguments: [],
                ),
                Message(
                    name: "test",
                    arguments: [],
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
            ],
            events: [
                Message(
                    name: "succeeded",
                    arguments: [],
                ),
                Message(
                    name: "failed",
                    arguments: [],
                ),
                Message(
                    name: "cancelled",
                    arguments: [],
                ),
            ]
        )
    /// Enable And Configure A Head
    /// 
    /// Enable a head. This request creates a head configuration object that can
    /// be used to change the head's properties.
    /// 
    /// - Parameters:
    ///   - head: the head to be enabled
    /// 
    /// - Returns: a new object to configure the head
    public func enableHead(head: ZwlrOutputHeadV1, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> ZwlrOutputConfigurationHeadV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: ZwlrOutputConfigurationHeadV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 0, [
            .object(id.id),
            .object(head.id),
        ])
        return id
    }

    /// Disable A Head
    /// 
    /// Disable a head.
    /// 
    /// - Parameters:
    ///   - head: the head to be disabled
    public func disableHead(head: ZwlrOutputHeadV1) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(head.id),
        ])
    }

    /// Apply The Configuration
    /// 
    /// Apply the new output configuration.
    /// In case the configuration is successfully applied, there is no guarantee
    /// that the new output state matches completely the requested
    /// configuration. For instance, a compositor might round the scale if it
    /// doesn't support fractional scaling.
    /// After this request has been sent, the compositor must respond with an
    /// succeeded, failed or cancelled event. Sending a request that isn't the
    /// destructor is a protocol error.
    public func apply() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    /// Test The Configuration
    /// 
    /// Test the new output configuration. The configuration won't be applied,
    /// but will only be validated.
    /// Even if the compositor succeeds to test a configuration, applying it may
    /// fail.
    /// After this request has been sent, the compositor must respond with an
    /// succeeded, failed or cancelled event. Sending a request that isn't the
    /// destructor is a protocol error.
    public func test() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
        ])
    }

    /// Destroy The Output Configuration
    /// 
    /// Using this request a client can tell the compositor that it is not going
    /// to use the configuration object anymore. Any changes to the outputs
    /// that have not been applied will be discarded.
    /// This request also destroys wlr_output_configuration_head objects created
    /// via this object.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 4, [
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// head has been configured twice
        case alreadyConfiguredHead = 1

        /// head has not been configured
        case unconfiguredHead = 2

        /// request sent after configuration has been applied or tested
        case alreadyUsed = 3
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
        /// Configuration Changes Succeeded
        /// 
        /// Sent after the compositor has successfully applied the changes or
        /// tested them.
        /// Upon receiving this event, the client should destroy this object.
        /// If the current configuration has changed, events to describe the changes
        /// will be sent followed by a wlr_output_manager.done event.
        case succeeded

        /// Configuration Changes Failed
        /// 
        /// Sent if the compositor rejects the changes or failed to apply them. The
        /// compositor should revert any changes made by the apply request that
        /// triggered this event.
        /// Upon receiving this event, the client should destroy this object.
        case failed

        /// Configuration Has Been Cancelled
        /// 
        /// Sent if the compositor cancels the configuration because the state of an
        /// output changed and the client has outdated information (e.g. after an
        /// output has been hotplugged).
        /// The client can create a new configuration with a newer serial and try
        /// again.
        /// Upon receiving this event, the client should destroy this object.
        case cancelled

        public init(from r: inout some ArgumentReader, opcode: UInt32) throws(DecodingError) {
            switch opcode {
            case 0:
                self = Self.succeeded
            case 1:
                self = Self.failed
            case 2:
                self = Self.cancelled
            default:
                fatalError("Unknown message: opcode=\(opcode)")
            }
        }
    }
}

/// Head Configuration
/// 
/// This object is used by the client to update a single head's configuration.
/// It is a protocol error to set the same property twice.
public final class ZwlrOutputConfigurationHeadV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "zwlr_output_configuration_head_v1",
            version: 4,
            requests: [
                Message(
                    name: "set_mode",
                    arguments: [
                        Argument(
                            name: "mode",
                            type: .object,
                            interface: "zwlr_output_mode_v1",
                        ),
                    ],
                ),
                Message(
                    name: "set_custom_mode",
                    arguments: [
                        Argument(
                            name: "width",
                            type: .int,
                        ),
                        Argument(
                            name: "height",
                            type: .int,
                        ),
                        Argument(
                            name: "refresh",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "set_position",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .int,
                        ),
                        Argument(
                            name: "y",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "set_transform",
                    arguments: [
                        Argument(
                            name: "transform",
                            type: .int,
                        ),
                    ],
                ),
                Message(
                    name: "set_scale",
                    arguments: [
                        Argument(
                            name: "scale",
                            type: .fixed,
                        ),
                    ],
                ),
                Message(
                    name: "set_adaptive_sync",
                    arguments: [
                        Argument(
                            name: "state",
                            type: .uint,
                        ),
                    ],
                    since: 4
                ),
            ],
        )
    /// Set The Mode
    /// 
    /// This request sets the head's mode.
    /// 
    /// - Parameters:
    public func setMode(_ mode: ZwlrOutputModeV1) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .object(mode.id),
        ])
    }

    /// Set A Custom Mode
    /// 
    /// This request assigns a custom mode to the head. The size is given in
    /// physical hardware units of the output device. If set to zero, the
    /// refresh rate is unspecified.
    /// It is a protocol error to set both a mode and a custom mode.
    /// 
    /// - Parameters:
    ///   - width: width of the mode in hardware units
    ///   - height: height of the mode in hardware units
    ///   - refresh: vertical refresh rate in mHz or zero
    public func setCustomMode(width: Int32, height: Int32, refresh: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .int(width),
            .int(height),
            .int(refresh),
        ])
    }

    /// Set The Position
    /// 
    /// This request sets the head's position in the global compositor space.
    /// 
    /// - Parameters:
    ///   - x: x position in the global compositor space
    ///   - y: y position in the global compositor space
    public func setPosition(x: Int32, y: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .int(x),
            .int(y),
        ])
    }

    /// Set The Transform
    /// 
    /// This request sets the head's transform.
    /// 
    /// - Parameters:
    public func setTransform(_ transform: Int32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .int(transform),
        ])
    }

    /// Set The Scale
    /// 
    /// This request sets the head's scale.
    /// 
    /// - Parameters:
    public func setScale(_ scale: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 4, [
            .fixed(scale),
        ])
    }

    /// Enable/Disable Adaptive Sync
    /// 
    /// This request enables/disables adaptive sync. Adaptive sync is also
    /// known as Variable Refresh Rate or VRR.
    /// 
    /// - Parameters:
    public func setAdaptiveSync(state: ZwlrOutputHeadV1.AdaptiveSyncState) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 5, [
            .uint(state.rawValue),
        ])
    }

    
    public static let `protocol`: Protocol = WlrOutputManagementUnstableV1Protocol
    
    public enum Error: UInt32 {
        /// property has already been set
        case alreadySet = 1

        /// mode doesn't belong to head
        case invalidMode = 2

        /// mode is invalid
        case invalidCustomMode = 3

        /// transform value outside enum
        case invalidTransform = 4

        /// scale negative or zero
        case invalidScale = 5

        /// invalid enum value used in the set_adaptive_sync request
        case invalidAdaptiveSyncState = 6
    }

    public typealias Event = NoEvent
}


public let WlrOutputManagementUnstableV1Protocol = Protocol(
        name: "wlr_output_management_unstable_v1",
        interfaces: [
            ZwlrOutputManagerV1.interface,
ZwlrOutputHeadV1.interface,
ZwlrOutputModeV1.interface,
ZwlrOutputConfigurationV1.interface,
ZwlrOutputConfigurationHeadV1.interface
        ]
    )

#endif