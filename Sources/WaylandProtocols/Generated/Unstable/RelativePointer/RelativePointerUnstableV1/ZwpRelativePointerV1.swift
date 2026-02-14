import Foundation
import SwiftWayland

/// Relative Pointer Object
/// 
/// A wp_relative_pointer object is an extension to the wl_pointer interface
/// used for emitting relative pointer events. It shares the same focus as
/// wl_pointer objects of the same seat and will only emit events when it has
/// focus.
public final class ZwpRelativePointerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zwp_relative_pointer_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Release The Relative Pointer Object
    /// 
    /// 
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
        /// Relative Pointer Motion
        /// 
        /// Relative x/y pointer motion from the pointer of the seat associated with
        /// this object.
        /// A relative motion is in the same dimension as regular wl_pointer motion
        /// events, except they do not represent an absolute position. For example,
        /// moving a pointer from (x, y) to (x', y') would have the equivalent
        /// relative motion (x' - x, y' - y). If a pointer motion caused the
        /// absolute pointer position to be clipped by for example the edge of the
        /// monitor, the relative motion is unaffected by the clipping and will
        /// represent the unclipped motion.
        /// This event also contains non-accelerated motion deltas. The
        /// non-accelerated delta is, when applicable, the regular pointer motion
        /// delta as it was before having applied motion acceleration and other
        /// transformations such as normalization.
        /// Note that the non-accelerated delta does not represent 'raw' events as
        /// they were read from some device. Pointer motion acceleration is device-
        /// and configuration-specific and non-accelerated deltas and accelerated
        /// deltas may have the same value on some devices.
        /// Relative motions are not coupled to wl_pointer.motion events, and can be
        /// sent in combination with such events, but also independently. There may
        /// also be scenarios where wl_pointer.motion is sent, but there is no
        /// relative motion. The order of an absolute and relative motion event
        /// originating from the same physical motion is not guaranteed.
        /// If the client needs button events or focus state, it can receive them
        /// from a wl_pointer object of the same seat that the wp_relative_pointer
        /// object is associated with.
        /// 
        /// - Parameters:
        ///   - UtimeHi: high 32 bits of a 64 bit timestamp with microsecond granularity
        ///   - UtimeLo: low 32 bits of a 64 bit timestamp with microsecond granularity
        ///   - Dx: the x component of the motion vector
        ///   - Dy: the y component of the motion vector
        ///   - DxUnaccel: the x component of the unaccelerated motion vector
        ///   - DyUnaccel: the y component of the unaccelerated motion vector
        case relativeMotion(utimeHi: UInt32, utimeLo: UInt32, dx: Double, dy: Double, dxUnaccel: Double, dyUnaccel: Double)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.relativeMotion(utimeHi: r.readUInt(), utimeLo: r.readUInt(), dx: r.readFixed(), dy: r.readFixed(), dxUnaccel: r.readFixed(), dyUnaccel: r.readFixed())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
