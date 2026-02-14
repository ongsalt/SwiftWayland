import Foundation

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
public final class WpPresentationFeedback: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_presentation_feedback"
    public var onEvent: (Event) -> Void = { _ in }

    /// Bitmask Of Flags In Presented Event
    /// 
    /// These flags provide information about how the presentation of
    /// the related content update was done. The intent is to help
    /// clients assess the reliability of the feedback and the visual
    /// quality with respect to possible tearing and timings.
    public enum Kind: UInt32, WlEnum {
        case vsync = 0x1
        
        case hwClock = 0x2
        
        case hwCompletion = 0x4
        
        case zeroCopy = 0x8
    }
    
    public enum Event: WlEventEnum {
        /// Presentation Synchronized To This Output
        /// 
        /// As presentation can be synchronized to only one output at a
        /// time, this event tells which output it was. This event is only
        /// sent prior to the presented event.
        /// As clients may bind to the same global wl_output multiple
        /// times, this event is sent for each bound instance that matches
        /// the synchronized output. If a client has not bound to the
        /// right wl_output global at all, this event is not sent.
        /// 
        /// - Parameters:
        ///   - Output: presentation output
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
        /// 
        /// - Parameters:
        ///   - TvSecHi: high 32 bits of the seconds part of the presentation timestamp
        ///   - TvSecLo: low 32 bits of the seconds part of the presentation timestamp
        ///   - TvNsec: nanoseconds part of the presentation timestamp
        ///   - Refresh: nanoseconds till next refresh
        ///   - SeqHi: high 32 bits of refresh counter
        ///   - SeqLo: low 32 bits of refresh counter
        ///   - Flags: combination of 'kind' values
        case presented(tvSecHi: UInt32, tvSecLo: UInt32, tvNsec: UInt32, refresh: UInt32, seqHi: UInt32, seqLo: UInt32, flags: UInt32)
        
        /// The Content Update Was Not Displayed
        /// 
        /// The content update was never displayed to the user.
        case discarded
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.syncOutput(output: connection.get(as: WlOutput.self, id: r.readObjectId())!)
            case 1:
                return Self.presented(tvSecHi: r.readUInt(), tvSecLo: r.readUInt(), tvNsec: r.readUInt(), refresh: r.readUInt(), seqHi: r.readUInt(), seqLo: r.readUInt(), flags: r.readUInt())
            case 2:
                return Self.discarded
            default:
                fatalError("Unknown message")
            }
        }
    }
}
