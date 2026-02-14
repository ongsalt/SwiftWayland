import Foundation

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
/// A newly created xdg_popup will be stacked on top of all previously created
/// xdg_popup surfaces associated with the same xdg_toplevel.
/// The parent of an xdg_popup must be mapped (see the xdg_surface
/// description) before the xdg_popup itself.
/// The client must call wl_surface.commit on the corresponding wl_surface
/// for the xdg_popup state to take effect.
public final class XdgPopup: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_popup"
    public var onEvent: (Event) -> Void = { _ in }

    /// Remove Xdg_Popup Interface
    /// 
    /// This destroys the popup. Explicitly destroying the xdg_popup
    /// object will also dismiss the popup, and unmap the surface.
    /// If this xdg_popup is not the "topmost" popup, the
    /// xdg_wm_base.not_the_topmost_popup protocol error will be sent.
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
    
    /// Recalculate The Popup's Location
    /// 
    /// Reposition an already-mapped popup. The popup will be placed given the
    /// details in the passed xdg_positioner object, and a
    /// xdg_popup.repositioned followed by xdg_popup.configure and
    /// xdg_surface.configure will be emitted in response. Any parameters set
    /// by the previous positioner will be discarded.
    /// The passed token will be sent in the corresponding
    /// xdg_popup.repositioned event. The new popup position will not take
    /// effect until the corresponding configure event is acknowledged by the
    /// client. See xdg_popup.repositioned for details. The token itself is
    /// opaque, and has no other special meaning.
    /// If multiple reposition requests are sent, the compositor may skip all
    /// but the last one.
    /// If the popup is repositioned in response to a configure event for its
    /// parent, the client should send an xdg_positioner.set_parent_configure
    /// and possibly an xdg_positioner.set_parent_size request to allow the
    /// compositor to properly constrain the popup.
    /// If the popup is repositioned together with a parent that is being
    /// resized, but not in response to a configure event, the client should
    /// send an xdg_positioner.set_parent_size request.
    /// 
    /// - Parameters:
    ///   - Token: reposition request token
    /// 
    /// Available since version 3
    public func reposition(positioner: XdgPositioner, token: UInt32) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.object(positioner),
            WaylandData.uint(token)
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
        /// For version 2 or older, the configure event for an xdg_popup is only
        /// ever sent once for the initial configuration. Starting with version 3,
        /// it may be sent again if the popup is setup with an xdg_positioner with
        /// set_reactive requested, or in response to xdg_popup.reposition requests.
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
        
        /// Signal The Completion Of A Repositioned Request
        /// 
        /// The repositioned event is sent as part of a popup configuration
        /// sequence, together with xdg_popup.configure and lastly
        /// xdg_surface.configure to notify the completion of a reposition request.
        /// The repositioned event is to notify about the completion of a
        /// xdg_popup.reposition request. The token argument is the token passed
        /// in the xdg_popup.reposition request.
        /// Immediately after this event is emitted, xdg_popup.configure and
        /// xdg_surface.configure will be sent with the updated size and position,
        /// as well as a new configure serial.
        /// The client should optionally update the content of the popup, but must
        /// acknowledge the new popup configuration for the new position to take
        /// effect. See xdg_surface.ack_configure for details.
        /// 
        /// - Parameters:
        ///   - Token: reposition request token
        /// 
        /// Available since version 3
        case repositioned(token: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.configure(x: r.readInt(), y: r.readInt(), width: r.readInt(), height: r.readInt())
            case 1:
                return Self.popupDone
            case 2:
                return Self.repositioned(token: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
