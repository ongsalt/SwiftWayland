import Foundation
import SwiftWayland

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
/// be given in any order. Each plane index can be set only once.
public final class ZwpLinuxBufferParamsV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_buffer_params_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Delete This Object, Used Or Not
    /// 
    /// Cleans up the temporary data sent to the server for dmabuf-based
    /// wl_buffer creation.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
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
    ///   - Fd: dmabuf fd
    ///   - PlaneIdx: plane index
    ///   - Offset: offset in bytes
    ///   - Stride: stride in bytes
    ///   - ModifierHi: high 32 bits of layout modifier
    ///   - ModifierLo: low 32 bits of layout modifier
    public func add(fd: FileHandle, planeIdx: UInt32, offset: UInt32, stride: UInt32, modifierHi: UInt32, modifierLo: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.fd(fd),
            WaylandData.uint(planeIdx),
            WaylandData.uint(offset),
            WaylandData.uint(stride),
            WaylandData.uint(modifierHi),
            WaylandData.uint(modifierLo)
        ])
        connection.send(message: message)
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
    /// 'y_invert' means the that the image needs to be y-flipped.
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
    /// object after issuing 'create' raises ALREADY_USED protocol error.
    /// It is not mandatory to issue 'create'. If a client wants to
    /// cancel the buffer creation, it can just destroy this object.
    /// 
    /// - Parameters:
    ///   - Width: base plane width in pixels
    ///   - Height: base plane height in pixels
    ///   - Format: DRM_FORMAT code
    ///   - Flags: see enum flags
    public func create(width: Int32, height: Int32, format: UInt32, flags: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.int(width),
            WaylandData.int(height),
            WaylandData.uint(format),
            WaylandData.uint(flags)
        ])
        connection.send(message: message)
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
    ///   - Width: base plane width in pixels
    ///   - Height: base plane height in pixels
    ///   - Format: DRM_FORMAT code
    ///   - Flags: see enum flags
    /// 
    /// Available since version 2
    public func createImmed(width: Int32, height: Int32, format: UInt32, flags: UInt32) throws(WaylandProxyError) -> WlBuffer {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let bufferId = connection.createProxy(type: WlBuffer.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.newId(bufferId.id),
            WaylandData.int(width),
            WaylandData.int(height),
            WaylandData.uint(format),
            WaylandData.uint(flags)
        ])
        connection.send(message: message)
        return bufferId
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Dmabuf_Batch Object Has Already Been Used To Create A Wl_Buffer
        case alreadyUsed = 0
        
        /// Plane Index Out Of Bounds
        case planeIdx = 1
        
        /// The Plane Index Was Already Set
        case planeSet = 2
        
        /// Missing Or Too Many Planes To Create A Buffer
        case incomplete = 3
        
        /// Format Not Supported
        case invalidFormat = 4
        
        /// Invalid Width Or Height
        case invalidDimensions = 5
        
        /// Offset + Stride * Height Goes Out Of Dmabuf Bounds
        case outOfBounds = 6
        
        /// Invalid Wl_Buffer Resulted From Importing Dmabufs Via                The Create_Immed Request On Given Buffer_Params
        case invalidWlBuffer = 7
    }
    
    public enum Flags: UInt32, WlEnum {
        /// Contents Are Y-Inverted
        case yInvert = 1
        
        /// Content Is Interlaced
        case interlaced = 2
        
        /// Bottom Field First
        case bottomFirst = 4
    }
    
    public enum Event: WlEventEnum {
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
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.created(buffer: connection.createProxy(type: WlBuffer.self, version: version, id: r.readNewId()))
            case 1:
                return Self.failed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
