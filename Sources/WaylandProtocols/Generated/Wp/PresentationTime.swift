import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if WP
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
                    arguments: [],
                ),
                Message(
                    name: "feedback",
                    arguments: [
                        Argument(
                            name: "surface",
                            type: .object,
                            interface: "wl_surface",
                        ),
                        Argument(
                            name: "callback",
                            type: .newId,
                            interface: "wp_presentation_feedback",
                        ),
                    ],
                ),
            ],
            events: [
                Message(
                    name: "clock_id",
                    arguments: [
                        Argument(
                            name: "clk_id",
                            type: .uint,
                        ),
                    ],
                ),
            ]
        )
    /// Unbind From The Presentation Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object. Existing objects created by this object
    /// are not affected.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
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
        let callback = connection.createProxy(type: WpPresentationFeedback.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(surface.id),
            .object(callback.id),
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
                        ),
                    ],
                ),
                Message(
                    name: "presented",
                    type: .destructor,
                    arguments: [
                        Argument(
                            name: "tv_sec_hi",
                            type: .uint,
                        ),
                        Argument(
                            name: "tv_sec_lo",
                            type: .uint,
                        ),
                        Argument(
                            name: "tv_nsec",
                            type: .uint,
                        ),
                        Argument(
                            name: "refresh",
                            type: .uint,
                        ),
                        Argument(
                            name: "seq_hi",
                            type: .uint,
                        ),
                        Argument(
                            name: "seq_lo",
                            type: .uint,
                        ),
                        Argument(
                            name: "flags",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "discarded",
                    type: .destructor,
                    arguments: [],
                ),
            ]
        )
    
    public static let `protocol`: Protocol = PresentationTimeProtocol
    
    public struct Kind: OptionSet, @unchecked Sendable {
        public let rawValue: UInt32
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public static let vsync = Kind(rawValue: 1)

        public static let hwClock = Kind(rawValue: 2)

        public static let hwCompletion = Kind(rawValue: 4)

        public static let zeroCopy = Kind(rawValue: 8)
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
                self = Self.presented(tvSecHi: r.uint(), tvSecLo: r.uint(), tvNsec: r.uint(), refresh: r.uint(), seqHi: r.uint(), seqLo: r.uint(), flags: try _parseEnum(into: Kind.self, r.uint()))
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

#endif