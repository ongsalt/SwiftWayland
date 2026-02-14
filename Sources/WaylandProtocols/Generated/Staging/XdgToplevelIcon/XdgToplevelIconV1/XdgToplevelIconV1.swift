import Foundation
import SwiftWayland

/// A Toplevel Window Icon
/// 
/// This interface defines a toplevel icon.
/// An icon can have a name, and multiple buffers.
/// In order to be applied, the icon must have either a name, or at least
/// one buffer assigned. Applying an empty icon (with no buffer or name) to
/// a toplevel should reset its icon to the default icon.
/// It is up to compositor policy whether to prefer using a buffer or loading
/// an icon via its name. See 'set_name' and 'add_buffer' for details.
public final class XdgToplevelIconV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel_icon_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Icon Object
    /// 
    /// Destroys the 'xdg_toplevel_icon_v1' object.
    /// The icon must still remain set on every toplevel it was assigned to,
    /// until the toplevel icon is reset explicitly.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Set An Icon Name
    /// 
    /// This request assigns an icon name to this icon.
    /// Any previously set name is overridden.
    /// The compositor must resolve 'icon_name' according to the lookup rules
    /// described in the XDG icon theme specification[1] using the
    /// environment's current icon theme.
    /// If the compositor does not support icon names or cannot resolve
    /// 'icon_name' according to the XDG icon theme specification it must
    /// fall back to using pixel buffer data instead.
    /// If this request is made after the icon has been assigned to a toplevel
    /// via 'set_icon', a 'immutable' error must be raised.
    /// [1]: https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html
    public func setName(iconName: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.string(iconName)
        ])
        connection.send(message: message)
    }
    
    /// Add Icon Data From A Pixel Buffer
    /// 
    /// This request adds pixel data supplied as wl_buffer to the icon.
    /// The client should add pixel data for all icon sizes and scales that
    /// it can provide, or which are explicitly requested by the compositor
    /// via 'icon_size' events on xdg_toplevel_icon_manager_v1.
    /// The wl_buffer supplying pixel data as 'buffer' must be backed by wl_shm
    /// and must be a square (width and height being equal).
    /// If any of these buffer requirements are not fulfilled, a 'invalid_buffer'
    /// error must be raised.
    /// If this icon instance already has a buffer of the same size and scale
    /// from a previous 'add_buffer' request, data from the last request
    /// overrides the preexisting pixel data.
    /// The wl_buffer must be kept alive for as long as the xdg_toplevel_icon
    /// it is associated with is not destroyed, otherwise a 'no_buffer' error
    /// is raised. The buffer contents must not be modified after it was
    /// assigned to the icon. As a result, the region of the wl_shm_pool's
    /// backing storage used for the wl_buffer must not be modified after this
    /// request is sent. The wl_buffer.release event is unused.
    /// If this request is made after the icon has been assigned to a toplevel
    /// via 'set_icon', a 'immutable' error must be raised.
    /// 
    /// - Parameters:
    ///   - Scale: the scaling factor of the icon, e.g. 1
    public func addBuffer(buffer: WlBuffer, scale: Int32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.object(buffer),
            WaylandData.int(scale)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Provided Buffer Does Not Satisfy Requirements
        case invalidBuffer = 1
        
        /// The Icon Has Already Been Assigned To A Toplevel And Must Not Be Changed
        case immutable = 2
        
        /// The Provided Buffer Has Been Destroyed Before The Toplevel Icon
        case noBuffer = 3
    }
    
    public enum Event: WlEventEnum {
        
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            
            switch message.opcode {
            
            default:
                fatalError("Unknown message")
            }
        }
    }
}
