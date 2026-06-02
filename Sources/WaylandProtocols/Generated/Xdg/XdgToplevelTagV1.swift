import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if XDG
/// Protocol For Setting Toplevel Tags
/// 
/// In order to make some window properties like position, size,
/// "always on top" or user defined rules for window behavior persistent, the
/// compositor needs some way to identify windows even after the application
/// has been restarted.
/// This protocol allows clients to make this possible by setting a tag for
/// toplevels.
/// Warning! The protocol described in this file is currently in the testing
/// phase. Backward compatible changes may be added together with the
/// corresponding interface version bump. Backward incompatible changes can
/// only be done by creating a new major version of the extension.
public final class XdgToplevelTagManagerV1: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "xdg_toplevel_tag_manager_v1",
            version: 1,
            requests: [
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                ),
                Message(
                    name: "set_toplevel_tag",
                    arguments: [
                        Argument(
                            name: "toplevel",
                            type: .object,
                            interface: "xdg_toplevel",
                        ),
                        Argument(
                            name: "tag",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "set_toplevel_description",
                    arguments: [
                        Argument(
                            name: "toplevel",
                            type: .object,
                            interface: "xdg_toplevel",
                        ),
                        Argument(
                            name: "description",
                            type: .string,
                        ),
                    ],
                ),
            ],
        )
    /// Destroy Toplevel Tag Object
    /// 
    /// Destroy this toplevel tag manager object. This request has no other
    /// effects.
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        self.markDead()
        connection.send(self, 0, [
        ])
    }

    /// Set Tag
    /// 
    /// Set a tag for a toplevel. The tag may be shown to the user in UI, so
    /// it's preferable for it to be human readable, but it must be suitable
    /// for configuration files and should not be translated.
    /// Suitable tags would for example be "main window", "settings",
    /// "e-mail composer" or similar.
    /// The tag does not need to be unique across applications, and the client
    /// may set the same tag for multiple windows, for example if the user has
    /// opened the same UI twice. How the potentially resulting conflicts are
    /// handled is compositor policy.
    /// The client should set the tag as part of the initial commit on the
    /// associated toplevel, but it may set it at any time afterwards as well,
    /// for example if the purpose of the toplevel changes.
    /// 
    /// - Parameters:
    ///   - tag: untranslated tag
    public func setToplevelTag(toplevel: XdgToplevel, tag: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .object(toplevel.id),
            .string(tag),
        ])
    }

    /// Set Description
    /// 
    /// Set a description for a toplevel. This description may be shown to the
    /// user in UI or read by a screen reader for accessibility purposes, and
    /// should be translated.
    /// It is recommended to make the description the translation of the tag.
    /// The client should set the description as part of the initial commit on
    /// the associated toplevel, but it may set it at any time afterwards as
    /// well, for example if the purpose of the toplevel changes.
    /// 
    /// - Parameters:
    ///   - description: translated description
    public func setToplevelDescription(toplevel: XdgToplevel, description: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .object(toplevel.id),
            .string(description),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: XdgToplevelTagV1Protocol)
    }
    
    var destructor: Destructor? = .destroy

    enum Destructor {
        case destroy
    }

    deinit {
        if self.isAlive {
            switch self.destructor {
                case .destroy: try? self.destroy()
                case nil: break
            }
        }
    }

    public typealias Event = NoEvent
}


public let XdgToplevelTagV1Protocol = Protocol(
        name: "xdg_toplevel_tag_v1",
        interfaces: [
            XdgToplevelTagManagerV1.interface
        ]
    )

#endif