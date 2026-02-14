import Foundation

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
public final class WpPresentation: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_presentation"
    public var onEvent: (Event) -> Void = { _ in }

    /// Unbind From The Presentation Interface
    /// 
    /// Informs the server that the client will no longer be using
    /// this protocol object. Existing objects created by this object
    /// are not affected.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
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
    ///   - Surface: target surface
    public func feedback(surface: WlSurface) throws(WaylandProxyError) -> WpPresentationFeedback {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let callback = connection.createProxy(type: WpPresentationFeedback.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(surface),
            WaylandData.newId(callback.id)
        ])
        connection.send(message: message)
        return callback
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Fatal Presentation Errors
    /// 
    /// These fatal protocol errors may be emitted in response to
    /// illegal presentation requests.
    public enum Error: UInt32, WlEnum {
        /// Invalid Value In Tv_Nsec
        case invalidTimestamp = 0
        
        /// Invalid Flag
        case invalidFlag = 1
    }
    
    public enum Event: WlEventEnum {
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
        /// 
        /// - Parameters:
        ///   - ClkId: platform clock identifier
        case clockId(clkId: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.clockId(clkId: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
