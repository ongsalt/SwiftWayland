import Foundation

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
/// To send parameters, the compositor sends one main_device event, tranches
/// (each consisting of one tranche_target_device event, one tranche_flags
/// event, tranche_formats events and then a tranche_done event), then one
/// done event.
public final class ZwpLinuxDmabufFeedbackV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_dmabuf_feedback_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Feedback Object
    /// 
    /// Using this request a client can tell the server that it is not going to
    /// use the wp_linux_dmabuf_feedback object anymore.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum TrancheFlags: UInt32, WlEnum {
        /// Direct Scan-Out Tranche
        case scanout = 1
    }
    
    public enum Event: WlEventEnum {
        /// All Feedback Has Been Sent
        /// 
        /// This event is sent after all parameters of a wp_linux_dmabuf_feedback
        /// object have been sent.
        /// This allows changes to the wp_linux_dmabuf_feedback parameters to be
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
        /// 
        /// - Parameters:
        ///   - Fd: table file descriptor
        ///   - Size: table size, in bytes
        case formatTable(fd: FileHandle, size: UInt32)
        
        /// Preferred Main Device
        /// 
        /// This event advertises the main device that the server prefers to use
        /// when direct scan-out to the target device isn't possible. The
        /// advertised main device may be different for each
        /// wp_linux_dmabuf_feedback object, and may change over time.
        /// There is exactly one main device. The compositor must send at least
        /// one preference tranche with tranche_target_device equal to main_device.
        /// Clients need to create buffers that the main device can import and
        /// read from, otherwise creating the dmabuf wl_buffer will fail (see the
        /// wp_linux_buffer_params.create and create_immed requests for details).
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
        /// 
        /// - Parameters:
        ///   - Device: device dev_t value
        case mainDevice(device: Data)
        
        /// A Preference Tranche Has Been Sent
        /// 
        /// This event splits tranche_target_device and tranche_formats events in
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
        /// still be accessible from the main device, either through direct import
        /// or through a potentially more expensive fallback path. If the buffer
        /// can't be directly imported from the main device then clients must be
        /// prepared for the compositor changing the tranche priority or making
        /// wl_buffer creation fail (see the wp_linux_buffer_params.create and
        /// create_immed requests for details).
        /// If the device is a DRM node, the DRM node type (primary vs. render) is
        /// unspecified. Clients must not rely on the compositor sending a
        /// particular node type. Clients cannot check two devices for equality by
        /// comparing the dev_t value.
        /// This event is tied to a preference tranche, see the tranche_done event.
        /// 
        /// - Parameters:
        ///   - Device: device dev_t value
        case trancheTargetDevice(device: Data)
        
        /// Supported Buffer Format Modifier
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
        /// wp_linux_buffer_params.create request.
        /// 
        /// - Parameters:
        ///   - Indices: array of 16-bit indexes
        case trancheFormats(indices: Data)
        
        /// Tranche Flags
        /// 
        /// This event sets tranche-specific flags.
        /// The scanout flag is a hint that direct scan-out may be attempted by the
        /// compositor on the target device if the client appropriately allocates a
        /// buffer. How to allocate a buffer that can be scanned out on the target
        /// device is implementation-defined.
        /// This event is tied to a preference tranche, see the tranche_done event.
        /// 
        /// - Parameters:
        ///   - Flags: tranche flags
        case trancheFlags(flags: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.done
            case 1:
                return Self.formatTable(fd: r.readFd(), size: r.readUInt())
            case 2:
                return Self.mainDevice(device: r.readArray())
            case 3:
                return Self.trancheDone
            case 4:
                return Self.trancheTargetDevice(device: r.readArray())
            case 5:
                return Self.trancheFormats(indices: r.readArray())
            case 6:
                return Self.trancheFlags(flags: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
