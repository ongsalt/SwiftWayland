import Foundation
import SwiftWayland

/// Factory For Creating Dmabuf-Based Wl_Buffers
/// 
/// Following the interfaces from:
/// https://www.khronos.org/registry/egl/extensions/EXT/EGL_EXT_image_dma_buf_import.txt
/// https://www.khronos.org/registry/EGL/extensions/EXT/EGL_EXT_image_dma_buf_import_modifiers.txt
/// and the Linux DRM sub-system's AddFb2 ioctl.
/// This interface offers ways to create generic dmabuf-based wl_buffers.
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
/// zwp_linux_dmabuf_params_v1 object with a zwp_linux_dmabuf_v1.create_params
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
/// Disclaimer: This protocol extension has been marked stable. This copy is
/// no longer used and only retained for backwards compatibility. The
/// canonical version can be found in the stable/ directory.
public final class ZwpLinuxDmabufV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_linux_dmabuf_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Unbind The Factory
    /// 
    /// Objects created through this interface, especially wl_buffers, will
    /// remain valid.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Create A Temporary Object For Buffer Parameters
    /// 
    /// This temporary object is used to collect multiple dmabuf handles into
    /// a single batch to create a wl_buffer. It can only be used once and
    /// should be destroyed after a 'created' or 'failed' event has been
    /// received.
    public func createParams() throws(WaylandProxyError) -> ZwpLinuxBufferParamsV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let paramsId = connection.createProxy(type: ZwpLinuxBufferParamsV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(paramsId.id)
        ])
        connection.send(message: message)
        return paramsId
    }
    
    /// Get Default Feedback
    /// 
    /// This request creates a new wp_linux_dmabuf_feedback object not bound
    /// to a particular surface. This object will deliver feedback about dmabuf
    /// parameters to use if the client doesn't support per-surface feedback
    /// (see get_surface_feedback).
    /// 
    /// Available since version 4
    public func getDefaultFeedback() throws(WaylandProxyError) -> ZwpLinuxDmabufFeedbackV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let id = connection.createProxy(type: ZwpLinuxDmabufFeedbackV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Get Feedback For A Surface
    /// 
    /// This request creates a new wp_linux_dmabuf_feedback object for the
    /// specified wl_surface. This object will deliver feedback about dmabuf
    /// parameters to use for buffers attached to this surface.
    /// If the surface is destroyed before the wp_linux_dmabuf_feedback object,
    /// the feedback object becomes inert.
    /// 
    /// Available since version 4
    public func getSurfaceFeedback(surface: WlSurface) throws(WaylandProxyError) -> ZwpLinuxDmabufFeedbackV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        let id = connection.createProxy(type: ZwpLinuxDmabufFeedbackV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.newId(id.id),
            WaylandData.object(surface)
        ])
        connection.send(message: message)
        return id
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Event: WlEventEnum {
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
        /// 
        /// - Parameters:
        ///   - Format: DRM_FORMAT code
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
        /// 
        /// - Parameters:
        ///   - Format: DRM_FORMAT code
        ///   - ModifierHi: high 32 bits of layout modifier
        ///   - ModifierLo: low 32 bits of layout modifier
        /// 
        /// Available since version 3
        case modifier(format: UInt32, modifierHi: UInt32, modifierLo: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.format(format: r.readUInt())
            case 1:
                return Self.modifier(format: r.readUInt(), modifierHi: r.readUInt(), modifierLo: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
