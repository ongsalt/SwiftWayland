import Foundation
import SwiftWayland

/// A Workspace Handing A Group Of Surfaces
/// 
/// A ext_workspace_handle_v1 object represents a workspace that handles a
/// group of surfaces.
/// Each workspace has:
/// - a name, conveyed to the client with the name event
/// - potentially an id conveyed with the id event
/// - a list of states, conveyed to the client with the state event
/// - and optionally a set of coordinates, conveyed to the client with the
/// coordinates event
/// 
/// The client may request that the compositor activate or deactivate the workspace.
/// Each workspace can belong to only a single workspace group.
/// Depending on the compositor policy, there might be workspaces with
/// the same name in different workspace groups, but these workspaces are still
/// separate (e.g. one of them might be active while the other is not).
public final class ExtWorkspaceHandleV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "ext_workspace_handle_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Ext_Workspace_Handle_V1 Object
    /// 
    /// Destroys the ext_workspace_handle_v1 object.
    /// This request should be made either when the client does not want to
    /// use the workspace object any more or after the remove event to finalize
    /// the destruction of the object.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Activate The Workspace
    /// 
    /// Request that this workspace be activated.
    /// There is no guarantee the workspace will be actually activated, and
    /// behaviour may be compositor-dependent. For example, activating a
    /// workspace may or may not deactivate all other workspaces in the same
    /// group.
    public func activate() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
    }
    
    /// Deactivate The Workspace
    /// 
    /// Request that this workspace be deactivated.
    /// There is no guarantee the workspace will be actually deactivated.
    public func deactivate() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [])
        connection.send(message: message)
    }
    
    /// Assign Workspace To Group
    /// 
    /// Requests that this workspace is assigned to the given workspace group.
    /// There is no guarantee the workspace will be assigned.
    public func assign(workspaceGroup: ExtWorkspaceGroupHandleV1) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [
            WaylandData.object(workspaceGroup)
        ])
        connection.send(message: message)
    }
    
    /// Remove The Workspace
    /// 
    /// Request that this workspace be removed.
    /// There is no guarantee the workspace will be actually removed.
    public func remove() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.send(message: message)
    }
    
    deinit {
        try! self.destroy()
    }
    
    /// Types Of States On The Workspace
    /// 
    /// The different states that a workspace can have.
    public enum State: UInt32, WlEnum {
        /// The Workspace Is Active
        case active = 1
        
        /// The Workspace Requests Attention
        case urgent = 2
        
        case hidden = 4
    }
    
    public enum WorkspaceCapabilities: UInt32, WlEnum {
        /// Activate Request Is Available
        case activate = 1
        
        /// Deactivate Request Is Available
        case deactivate = 2
        
        /// Remove Request Is Available
        case remove = 4
        
        /// Assign Request Is Available
        case assign = 8
    }
    
    public enum Event: WlEventEnum {
        /// Workspace Id
        /// 
        /// If this event is emitted, it will be send immediately after the
        /// ext_workspace_handle_v1 is created or when an id is assigned to
        /// a workspace (at most once during it's lifetime).
        /// An id will never change during the lifetime of the `ext_workspace_handle_v1`
        /// and is guaranteed to be unique during it's lifetime.
        /// Ids are not human-readable and shouldn't be displayed, use `name` for that purpose.
        /// Compositors are expected to only send ids for workspaces likely stable across multiple
        /// sessions and can be used by clients to store preferences for workspaces. Workspaces without
        /// ids should be considered temporary and any data associated with them should be deleted once
        /// the respective object is lost.
        case id(id: String)
        
        /// Workspace Name Changed
        /// 
        /// This event is emitted immediately after the ext_workspace_handle_v1 is
        /// created and whenever the name of the workspace changes.
        /// A name is meant to be human-readable and can be displayed to a user.
        /// Unlike the id it is neither stable nor unique.
        case name(name: String)
        
        /// Workspace Coordinates Changed
        /// 
        /// This event is used to organize workspaces into an N-dimensional grid
        /// within a workspace group, and if supported, is emitted immediately after
        /// the ext_workspace_handle_v1 is created and whenever the coordinates of
        /// the workspace change. Compositors may not send this event if they do not
        /// conceptually arrange workspaces in this way. If compositors simply
        /// number workspaces, without any geometric interpretation, they may send
        /// 1D coordinates, which clients should not interpret as implying any
        /// geometry. Sending an empty array means that the compositor no longer
        /// orders the workspace geometrically.
        /// Coordinates have an arbitrary number of dimensions N with an uint32
        /// position along each dimension. By convention if N > 1, the first
        /// dimension is X, the second Y, the third Z, and so on. The compositor may
        /// chose to utilize these events for a more novel workspace layout
        /// convention, however. No guarantee is made about the grid being filled or
        /// bounded; there may be a workspace at coordinate 1 and another at
        /// coordinate 1000 and none in between. Within a workspace group, however,
        /// workspaces must have unique coordinates of equal dimensionality.
        case coordinates(coordinates: Data)
        
        /// The State Of The Workspace Changed
        /// 
        /// This event is emitted immediately after the ext_workspace_handle_v1 is
        /// created and each time the workspace state changes, either because of a
        /// compositor action or because of a request in this protocol.
        /// Missing states convey the opposite meaning, e.g. an unset active bit
        /// means the workspace is currently inactive.
        case state(state: UInt32)
        
        /// Compositor Capabilities
        /// 
        /// This event advertises the capabilities supported by the compositor. If
        /// a capability isn't supported, clients should hide or disable the UI
        /// elements that expose this functionality. For instance, if the
        /// compositor doesn't advertise support for removing workspaces, a button
        /// triggering the remove request should not be displayed.
        /// The compositor will ignore requests it doesn't support. For instance,
        /// a compositor which doesn't advertise support for remove will ignore
        /// remove requests.
        /// Compositors must send this event once after creation of an
        /// ext_workspace_handle_v1 . When the capabilities change, compositors
        /// must send this event again.
        /// 
        /// - Parameters:
        ///   - Capabilities: capabilities
        case capabilities(capabilities: UInt32)
        
        /// This Workspace Has Been Removed
        /// 
        /// This event is send when the workspace associated with the ext_workspace_handle_v1
        /// has been removed. After sending this request, the compositor will immediately consider
        /// the object inert. Any requests will be ignored except the destroy request.
        /// It is guaranteed there won't be any more events referencing this
        /// ext_workspace_handle_v1.
        /// The compositor must only remove a workspaces not currently belonging to any
        /// workspace_group.
        case removed
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.id(id: r.readString())
            case 1:
                return Self.name(name: r.readString())
            case 2:
                return Self.coordinates(coordinates: r.readArray())
            case 3:
                return Self.state(state: r.readUInt())
            case 4:
                return Self.capabilities(capabilities: r.readUInt())
            case 5:
                return Self.removed
            default:
                fatalError("Unknown message")
            }
        }
    }
}
