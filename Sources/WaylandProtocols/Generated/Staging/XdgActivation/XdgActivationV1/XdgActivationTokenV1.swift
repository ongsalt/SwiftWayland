import Foundation
import SwiftWayland

/// An Exported Activation Handle
/// 
/// An object for setting up a token and receiving a token handle that can
/// be passed as an activation token to another client.
/// The object is created using the xdg_activation_v1.get_activation_token
/// request. This object should then be populated with the app_id, surface
/// and serial information and committed. The compositor shall then issue a
/// done event with the token. In case the request's parameters are invalid,
/// the compositor will provide an invalid token.
public final class XdgActivationTokenV1: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "xdg_activation_token_v1"
    public var onEvent: (Event) -> Void = { _ in }

    /// Specifies The Seat And Serial Of The Activating Event
    /// 
    /// Provides information about the seat and serial event that requested the
    /// token.
    /// The serial can come from an input or focus event. For instance, if a
    /// click triggers the launch of a third-party client, the launcher client
    /// should send a set_serial request with the serial and seat from the
    /// wl_pointer.button event.
    /// Some compositors might refuse to activate toplevels when the token
    /// doesn't have a valid and recent enough event serial.
    /// Must be sent before commit. This information is optional.
    /// 
    /// - Parameters:
    ///   - Serial: the serial of the event that triggered the activation
    ///   - Seat: the wl_seat of the event
    public func setSerial(serial: UInt32, seat: WlSeat) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.uint(serial),
            WaylandData.object(seat)
        ])
        connection.send(message: message)
    }
    
    /// Specifies The Application Being Activated
    /// 
    /// The requesting client can specify an app_id to associate the token
    /// being created with it.
    /// Must be sent before commit. This information is optional.
    /// 
    /// - Parameters:
    ///   - AppId: the application id of the client being activated.
    public func setAppId(appId: String) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 1, contents: [
            WaylandData.string(appId)
        ])
        connection.send(message: message)
    }
    
    /// Specifies The Surface Requesting Activation
    /// 
    /// This request sets the surface requesting the activation. Note, this is
    /// different from the surface that will be activated.
    /// Some compositors might refuse to activate toplevels when the token
    /// doesn't have a requesting surface.
    /// Must be sent before commit. This information is optional.
    /// 
    /// - Parameters:
    ///   - Surface: the requesting surface
    public func setSurface(surface: WlSurface) throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 2, contents: [
            WaylandData.object(surface)
        ])
        connection.send(message: message)
    }
    
    /// Issues The Token Request
    /// 
    /// Requests an activation token based on the different parameters that
    /// have been offered through set_serial, set_surface and set_app_id.
    public func commit() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 3, contents: [])
        connection.send(message: message)
    }
    
    /// Destroy The Xdg_Activation_Token_V1 Object
    /// 
    /// Notify the compositor that the xdg_activation_token_v1 object will no
    /// longer be used. The received token stays valid.
    public consuming func destroy() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let message = Message(objectId: self.id, opcode: 4, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.destroy()
    }
    
    public enum Error: UInt32, WlEnum {
        /// The Token Has Already Been Used Previously
        case alreadyUsed = 0
    }
    
    public enum Event: WlEventEnum {
        /// The Exported Activation Token
        /// 
        /// The 'done' event contains the unique token of this activation request
        /// and notifies that the provider is done.
        /// 
        /// - Parameters:
        ///   - Token: the exported activation token
        case done(token: String)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.done(token: r.readString())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
