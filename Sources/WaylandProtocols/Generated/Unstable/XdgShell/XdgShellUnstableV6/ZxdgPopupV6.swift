import Foundation
import SwiftWayland

/// Short-Lived, Popup Surfaces For Menus
/// 
/// A popup surface is a short-lived, temporary surface. It can be used to
/// implement for example menus, popovers, tooltips and other similar user
/// interface concepts.
/// A popup can be made to take an explicit grab. See xdg_popup.grab for
/// details.
/// When the popup is dismissed, a popup_done event will be sent out, and at
/// the same time the surface will be unmapped. See the xdg_popup.popup_done
/// event for details.
/// Explicitly destroying the xdg_popup object will also dismiss the popup and
/// unmap the surface. Clients that want to dismiss the popup when another
/// surface of their own is clicked should dismiss the popup using the destroy
/// request.
/// The parent surface must have either the xdg_toplevel or xdg_popup surface
/// role.
/// A newly created xdg_popup will be stacked on top of all previously created
/// xdg_popup surfaces associated with the same xdg_toplevel.
/// The parent of an xdg_popup must be mapped (see the xdg_surface
/// description) before the xdg_popup itself.
/// The x and y arguments passed when creating the popup object specify
/// where the top left of the popup should be placed, relative to the
/// local surface coordinates of the parent surface. See
/// xdg_surface.get_popup. An xdg_popup must intersect with or be at least
/// partially adjacent to its parent surface.
/// The client must call wl_surface.commit on the corresponding wl_surface
/// for the xdg_popup state to take effect.
public final class ZxdgPopupV6: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "zxdg_popup_v6"
    public var onEvent: (Event) -> Void = { _ in }

    /// Remove Xdg_Popup Interface
    /// 
    /// This destroys the popup. Explicitly destroying the xdg_popup
    /// object will also dismiss the popup, and unmap the surface.
    /// If this xdg_popup is not the "topmost" popup, a protocol error
    /// will be sent.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Make The Popup Take An Explicit Grab
    /// 
    /// This request makes the created popup take an explicit grab. An explicit
    /// grab will be dismissed when the user dismisses the popup, or when the
    /// client destroys the xdg_popup. This can be done by the user clicking
    /// outside the surface, using the keyboard, or even locking the screen
    /// through closing the lid or a timeout.
    /// If the compositor denies the grab, the popup will be immediately
    /// dismissed.
    /// This request must be used in response to some sort of user action like a
    /// button press, key press, or touch down event. The serial number of the
    /// event should be passed as 'serial'.
    /// The parent of a grabbing popup must either be an xdg_toplevel surface or
    /// another xdg_popup with an explicit grab. If the parent is another
    /// xdg_popup it means that the popups are nested, with this popup now being
    /// the topmost popup.
    /// Nested popups must be destroyed in the reverse order they were created
    /// in, e.g. the only popup you are allowed to destroy at all times is the
    /// topmost one.
    /// When compositors choose to dismiss a popup, they may dismiss every
    /// nested grabbing popup as well. When a compositor dismisses popups, it
    /// will follow the same dismissing order as required from the client.
    /// The parent of a grabbing popup must either be another xdg_popup with an
    /// active explicit grab, or an xdg_popup or xdg_toplevel, if there are no
    /// explicit grabs already taken.
    /// If the topmost grabbing popup is destroyed, the grab will be returned to
    /// the parent of the popup, if that parent previously had an explicit grab.
    /// If the parent is a grabbing popup which has already been dismissed, this
    /// popup will be immediately dismissed. If the parent is a popup that did
    /// not take an explicit grab, an error will be raised.
    /// During a popup grab, the client owning the grab will receive pointer
    /// and touch events for all their surfaces as normal (similar to an
    /// "owner-events" grab in X11 parlance), while the top most grabbing popup
    /// will always have keyboard focus.
    /// 
    /// - Parameters:
    ///   - Seat: the wl_seat of the user event
    ///   - Serial: the serial of the user event
    public func grab(seat: WlSeat, serial: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(seat),
            WaylandData.uint(serial)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// Tried To Grab After Being Mapped
        case invalidGrab = 0
    }
    
    public enum Event: WlEventEnum {
        /// Configure The Popup Surface
        /// 
        /// This event asks the popup surface to configure itself given the
        /// configuration. The configured state should not be applied immediately.
        /// See xdg_surface.configure for details.
        /// The x and y arguments represent the position the popup was placed at
        /// given the xdg_positioner rule, relative to the upper left corner of the
        /// window geometry of the parent surface.
        /// 
        /// - Parameters:
        ///   - X: x position relative to parent surface window geometry
        ///   - Y: y position relative to parent surface window geometry
        ///   - Width: window geometry width
        ///   - Height: window geometry height
        case configure(x: Int32, y: Int32, width: Int32, height: Int32)
        
        /// Popup Interaction Is Done
        /// 
        /// The popup_done event is sent out when a popup is dismissed by the
        /// compositor. The client should destroy the xdg_popup object at this
        /// point.
        case popupDone
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(x: r.readInt(), y: r.readInt(), width: r.readInt(), height: r.readInt())
            case 1:
                return Self.popupDone
            default:
                fatalError("Unknown message")
            }
        }
    }
}
