import Foundation
import SwiftWayland

/// Interface For Associating Xwayland Windows To Wl_Surfaces
/// 
/// An Xwayland surface is a surface managed by an Xwayland server.
/// It is used for associating surfaces to Xwayland windows.
/// The Xwayland server associated with actions in this interface is
/// determined by the Wayland client making the request.
/// The client must call wl_surface.commit on the corresponding wl_surface
/// for the xwayland_surface_v1 state to take effect.
public final class XwaylandSurfaceV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xwayland_surface_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Associates A Xwayland Window To A Wl_Surface
    /// 
    /// Associates an Xwayland window to a wl_surface.
    /// The association state is double-buffered, see wl_surface.commit.
    /// The `serial_lo` and `serial_hi` parameters specify a non-zero
    /// monotonic serial number which is entirely unique and provided by the
    /// Xwayland server equal to the serial value provided by a client message
    /// with a message type of the `WL_SURFACE_SERIAL` atom on the X11 window
    /// for this surface to be associated to.
    /// The serial value in the `WL_SURFACE_SERIAL` client message is specified
    /// as having the lo-bits specified in `l[0]` and the hi-bits specified
    /// in `l[1]`.
    /// If the serial value provided by `serial_lo` and `serial_hi` is not
    /// valid, the `invalid_serial` protocol error will be raised.
    /// An X11 window may be associated with multiple surfaces throughout its
    /// lifespan. (eg. unmapping and remapping a window).
    /// 
    /// For each wl_surface, this state must not be committed more than once,
    /// otherwise the `already_associated` protocol error will be raised.
    /// 
    /// - Parameters:
    ///   - SerialLo: The lower 32-bits of the serial number associated with the X11 window
    ///   - SerialHi: The upper 32-bits of the serial number associated with the X11 window
    public func setSerial(serialLo: UInt32, serialHi: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.uint(serialLo),
            WaylandData.uint(serialHi)
        ])
        connection.send(message: message)
    }
    
    /// Destroy The Xwayland Surface Object
    /// 
    /// Destroy the xwayland_surface_v1 object.
    /// Any already existing associations are unaffected by this action.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Given Wl_Surface Is Already Associated With An X11 Window
        case alreadyAssociated = 0
        
        /// Serial Was Not Valid
        case invalidSerial = 1
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
