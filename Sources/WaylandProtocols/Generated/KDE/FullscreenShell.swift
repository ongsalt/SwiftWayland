import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
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
public final class WlFullscreenShell: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "_wl_fullscreen_shell",
            version: 1,
            requests: [
                Message(
                    name: "release",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "present_surface",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                            nullable: true,
                        ),
                        Argument(
                            name: "method",
                            type: .uint,
                        ),
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                            nullable: true,
                        ),
                    ],
                ),
                Message(
                    name: "present_surface_for_mode",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "output",
                            type: .object,
                            interface: "wl_output",
                        ),
                        Argument(
                            name: "framerate",
                            type: .int,
                        ),
                        Argument(
                            name: "feedback",
                            type: .newId,
                            interface: "_wl_fullscreen_shell_mode_feedback",
                        ),
                    ],
                ),
            ],
            events: [
                Message(
                    name: "capability",
                    arguments: [
                        Argument(
                            name: "capability",
                            type: .uint,
                        ),
                    ],
                ),
            ]
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
    public func presentSurfaceForMode(surface: WlSurface, output: WlOutput, framerate: Int32, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> WlFullscreenShellModeFeedback {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let feedback = connection.createProxy(type: WlFullscreenShellModeFeedback.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 2, [
            .object(surface.id),
            .object(output.id),
            .int(framerate),
            .object(feedback.id),
        ])
        return feedback
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: FullscreenShellProtocol)
    }
    
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

    public enum Event: Decodable {
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

public final class WlFullscreenShellModeFeedback: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "_wl_fullscreen_shell_mode_feedback",
            version: 1,
            events: [
                Message(
                    name: "mode_successful",
                    arguments: [],
                ),
                Message(
                    name: "mode_failed",
                    arguments: [],
                ),
                Message(
                    name: "present_cancelled",
                    arguments: [],
                ),
            ]
        )
    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: FullscreenShellProtocol)
    }
    
    public enum Event: Decodable {
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
            WlFullscreenShell.interface,
WlFullscreenShellModeFeedback.interface
        ]
    )

#endif