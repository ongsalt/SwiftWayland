import Foundation
import SwiftWayland

/// Interface For Activating Surfaces
/// 
/// A global interface used for informing the compositor about applications
/// being activated or started, or for applications to request to be
/// activated.
public final class XdgActivationV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_activation_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Destroy The Xdg_Activation Object
    /// 
    /// Notify the compositor that the xdg_activation object will no longer be
    /// used.
    /// The child objects created via this interface are unaffected and should
    /// be destroyed separately.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    /// Requests A Token
    /// 
    /// Creates an xdg_activation_token_v1 object that will provide
    /// the initiating client with a unique token for this activation. This
    /// token should be offered to the clients to be activated.
    public func getActivationToken() throws(WaylandProxyError) -> XdgActivationTokenV1 {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: XdgActivationTokenV1.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.newId(id.id)
        ])
        connection.send(message: message)
        return id
    }
    
    /// Notify New Interaction Being Available
    /// 
    /// Requests surface activation. It's up to the compositor to display
    /// this information as desired, for example by placing the surface above
    /// the rest.
    /// The compositor may know who requested this by checking the activation
    /// token and might decide not to follow through with the activation if it's
    /// considered unwanted.
    /// Compositors can ignore unknown activation tokens when an invalid
    /// token is passed.
    /// 
    /// - Parameters:
    ///   - Token: the activation token of the initiating client
    ///   - Surface: the wl_surface to activate
    public func activate(token: String, surface: WlSurface) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.string(token),
            WaylandData.object(surface)
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
