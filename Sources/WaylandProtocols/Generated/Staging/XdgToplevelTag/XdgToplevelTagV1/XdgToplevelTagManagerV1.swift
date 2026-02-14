import Foundation
import SwiftWayland

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
public final class XdgToplevelTagManagerV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_toplevel_tag_manager_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy Toplevel Tag Object
    /// 
    /// Destroy this toplevel tag manager object. This request has no other
    /// effects.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
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
    ///   - Tag: untranslated tag
    public func setToplevelTag(toplevel: XdgToplevel, tag: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.object(toplevel),
            WaylandData.string(tag)
        ])
        connection.send(message: message)
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
    ///   - Description: translated description
    public func setToplevelDescription(toplevel: XdgToplevel, description: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.object(toplevel),
            WaylandData.string(description)
        ])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
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
