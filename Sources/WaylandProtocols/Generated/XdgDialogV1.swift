import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if STAGING
/// Create Dialogs Related To Other Toplevels
/// 
/// The xdg_wm_dialog_v1 interface is exposed as a global object allowing
/// to register surfaces with a xdg_toplevel role as "dialogs" relative to
/// another toplevel.
/// The compositor may let this relation influence how the surface is
/// placed, displayed or interacted with.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgWmDialogV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_wm_dialog_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "get_xdg_dialog",
                    arguments: [
                    Argument(
                        name: "id",
                        type: .newId,
                        interface: "xdg_dialog_v1"
                    ),
                    Argument(
                        name: "toplevel",
                        type: .object,
                        interface: "xdg_toplevel"
                    ),
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Dialog Manager Object
    /// 
    /// Destroys the xdg_wm_dialog_v1 object. This does not affect
    /// the xdg_dialog_v1 objects generated through it.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Create A Dialog Object
    /// 
    /// Creates a xdg_dialog_v1 object for the given toplevel. See the interface
    /// description for more details.
    /// Compositors must raise an already_used error if clients attempt to
    /// create multiple xdg_dialog_v1 objects for the same xdg_toplevel.
    /// 
    /// - Parameters:
    public func getXdgDialog(toplevel: XdgToplevel, queue _queue: EventQueue? = nil) throws(WaylandProxyError) -> XdgDialogV1 {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgDialogV1.self, version: self.version, queue: _queue ?? self.queue)
        connection.send(self, 1, [
            .object(id.id),
            .object(toplevel.id),
        ])
        return id
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgDialogV1)
    }
    
    public enum Error: UInt32 {
        /// the xdg_toplevel object has already been used to create a xdg_dialog_v1
        case alreadyUsed = 0
    }

    public typealias Event = NoEvent
}
/// Dialog Object
/// 
/// A xdg_dialog_v1 object is an ancillary object tied to a xdg_toplevel. Its
/// purpose is hinting the compositor that the toplevel is a "dialog" (e.g. a
/// temporary window) relative to another toplevel (see
/// xdg_toplevel.set_parent). If the xdg_toplevel is destroyed, the xdg_dialog_v1
/// becomes inert.
/// Through this object, the client may provide additional hints about
/// the purpose of the secondary toplevel. This interface has no effect
/// on toplevels that are not attached to a parent toplevel.
public final class XdgDialogV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_dialog_v1",
            version: 1,
            enums: [],
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [
                    ],
                ),
                Message(
                    name: "set_modal",
                    arguments: [
                    ],
                ),
                Message(
                    name: "unset_modal",
                    arguments: [
                    ],
                ),
                ],
            events: [
                ],
        )
    /// Destroy The Dialog Object
    /// 
    /// Destroys the xdg_dialog_v1 object. If this object is destroyed
    /// before the related xdg_toplevel, the compositor should unapply its
    /// effects.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Mark Dialog As Modal
    /// 
    /// Hints that the dialog has "modal" behavior. Modal dialogs typically
    /// require to be fully addressed by the user (i.e. closed) before resuming
    /// interaction with the parent toplevel, and may require a distinct
    /// presentation.
    /// Clients must implement the logic to filter events in the parent
    /// toplevel on their own.
    /// Compositors may choose any policy in event delivery to the parent
    /// toplevel, from delivering all events unfiltered to using them for
    /// internal consumption.
    public func setModal() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
        ])
    }

    /// Mark Dialog As Not Modal
    /// 
    /// Drops the hint that this dialog has "modal" behavior. See
    /// xdg_dialog_v1.set_modal for more details.
    public func unsetModal() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgDialogV1)
    }
    
    public typealias Event = NoEvent
}

public let XdgDialogV1 = Protocol(
        name: "xdg_dialog_v1",
        interfaces: [
            XdgWmDialogV1.interface,
XdgDialogV1.interface
        ]
    )

#endif