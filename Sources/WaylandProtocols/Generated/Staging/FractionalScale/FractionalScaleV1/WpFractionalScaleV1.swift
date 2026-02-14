import Foundation
import SwiftWayland

/// Fractional Scale Interface To A Wl_Surface
/// 
/// An additional interface to a wl_surface object which allows the compositor
/// to inform the client of the preferred scale.
public final class WpFractionalScaleV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wp_fractional_scale_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Remove Surface Scale Information For Surface
    /// 
    /// Destroy the fractional scale object. When this object is destroyed,
    /// preferred_scale events will no longer be sent.
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
    
    public enum Event: WlEventEnum {
        /// Notify Of New Preferred Scale
        /// 
        /// Notification of a new preferred scale for this surface that the
        /// compositor suggests that the client should use.
        /// The sent scale is the numerator of a fraction with a denominator of 120.
        /// 
        /// - Parameters:
        ///   - Scale: the new preferred scale
        case preferredScale(scale: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.preferredScale(scale: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
