import Foundation
@_spi(SwiftWaylandPrivate) import SwiftWayland

#if KDE
/// Fake Input Manager
/// 
/// This interface allows other processes to provide fake input events.
/// Purpose is on the one hand side to provide testing facilities like XTest on X11.
/// But also to support use case like kdeconnect's mouse pad interface.
/// A compositor should not trust the input received from this interface.
/// Clients should not expect that the compositor honors the requests from this
/// interface.
/// Warning! The protocol described in this file is a desktop environment
/// implementation detail. Regular clients must not use this protocol.
/// Backward incompatible changes may be added without bumping the major
/// version of the extension.
public final class KdeFakeInput: BaseProxy, Proxy {
    public var onEvent: ((Event) -> Void)?
    public static let interface: Interface =
        Interface(
            name: "org_kde_kwin_fake_input",
            version: 6,
            requests: [
                Message(
                    name: "authenticate",
                    arguments: [
                        Argument(
                            name: "application",
                            type: .string,
                        ),
                        Argument(
                            name: "reason",
                            type: .string,
                        ),
                    ],
                ),
                Message(
                    name: "pointer_motion",
                    arguments: [
                        Argument(
                            name: "delta_x",
                            type: .fixed,
                        ),
                        Argument(
                            name: "delta_y",
                            type: .fixed,
                        ),
                    ],
                ),
                Message(
                    name: "button",
                    arguments: [
                        Argument(
                            name: "button",
                            type: .uint,
                        ),
                        Argument(
                            name: "state",
                            type: .uint,
                        ),
                    ],
                ),
                Message(
                    name: "axis",
                    arguments: [
                        Argument(
                            name: "axis",
                            type: .uint,
                        ),
                        Argument(
                            name: "value",
                            type: .fixed,
                        ),
                    ],
                ),
                Message(
                    name: "touch_down",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
                        ),
                        Argument(
                            name: "x",
                            type: .fixed,
                        ),
                        Argument(
                            name: "y",
                            type: .fixed,
                        ),
                    ],
                    since: 2
                ),
                Message(
                    name: "touch_motion",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
                        ),
                        Argument(
                            name: "x",
                            type: .fixed,
                        ),
                        Argument(
                            name: "y",
                            type: .fixed,
                        ),
                    ],
                    since: 2
                ),
                Message(
                    name: "touch_up",
                    arguments: [
                        Argument(
                            name: "id",
                            type: .uint,
                        ),
                    ],
                    since: 2
                ),
                Message(
                    name: "touch_cancel",
                    arguments: [],
                    since: 2
                ),
                Message(
                    name: "touch_frame",
                    arguments: [],
                    since: 2
                ),
                Message(
                    name: "pointer_motion_absolute",
                    arguments: [
                        Argument(
                            name: "x",
                            type: .fixed,
                        ),
                        Argument(
                            name: "y",
                            type: .fixed,
                        ),
                    ],
                    since: 3
                ),
                Message(
                    name: "keyboard_key",
                    arguments: [
                        Argument(
                            name: "button",
                            type: .uint,
                        ),
                        Argument(
                            name: "state",
                            type: .uint,
                        ),
                    ],
                    since: 4
                ),
                Message(
                    name: "destroy",
                    type: .destructor,
                    arguments: [],
                    since: 5
                ),
                Message(
                    name: "keyboard_keysym",
                    arguments: [
                        Argument(
                            name: "keysym",
                            type: .uint,
                        ),
                        Argument(
                            name: "state",
                            type: .uint,
                        ),
                    ],
                    since: 6
                ),
            ],
        )
    /// Information Why The Client Wants To Use The Interface
    /// 
    /// A client should use this request to tell the compositor why it wants to
    /// use this interface. The compositor might use the information to decide
    /// whether it wants to grant the request. The data might also be passed to
    /// the user to decide whether the application should get granted access to
    /// this very privileged interface.
    /// 
    /// - Parameters:
    ///   - application: user visible name of the application
    ///   - reason: reason why the application wants to use this interface
    public func authenticate(application: String, reason: String) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 0, [
            .string(application),
            .string(reason),
        ])
    }

    /// 
    /// - Parameters:
    public func pointerMotion(deltaX: Double, deltaY: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 1, [
            .fixed(deltaX),
            .fixed(deltaY),
        ])
    }

    /// 
    /// - Parameters:
    public func button(button: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 2, [
            .uint(button),
            .uint(state),
        ])
    }

    /// 
    /// - Parameters:
    public func axis(axis: UInt32, value: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        connection.send(self, 3, [
            .uint(axis),
            .fixed(value),
        ])
    }

    /// Touch Down Event
    /// 
    /// A client should use this request to send touch down event at specific
    /// coordinates.
    /// 
    /// - Parameters:
    ///   - id: unique id for touch down event
    ///   - x: x coordinate for touch down event
    ///   - y: y coordinate for touch down event
    public func touchDown(id: UInt32, x: Double, y: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 4, [
            .uint(id),
            .fixed(x),
            .fixed(y),
        ])
    }

    /// Touch Motion Event
    /// 
    /// A client should use this request to send touch motion to specific position.
    /// 
    /// - Parameters:
    ///   - id: unique id for touch motion event
    ///   - x: x coordinate for touch motion event
    ///   - y: y coordinate for touch motion event
    public func touchMotion(id: UInt32, x: Double, y: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 5, [
            .uint(id),
            .fixed(x),
            .fixed(y),
        ])
    }

    /// Touch Up Event
    /// 
    /// A client should use this request to send touch up event.
    /// 
    /// - Parameters:
    ///   - id: unique id for touch up event
    public func touchUp(id: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 6, [
            .uint(id),
        ])
    }

    /// Touch Cancel Event
    /// 
    /// A client should use this request to cancel the current
    /// touch event.
    public func touchCancel() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 7, [
        ])
    }

    /// Touch Frame Event
    /// 
    /// A client should use this request to send touch frame event.
    public func touchFrame() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        connection.send(self, 8, [
        ])
    }

    /// 
    /// - Parameters:
    public func pointerMotionAbsolute(x: Double, y: Double) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 3 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 3) }
        connection.send(self, 9, [
            .fixed(x),
            .fixed(y),
        ])
    }

    /// 
    /// - Parameters:
    public func keyboardKey(button: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 4 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 4) }
        connection.send(self, 10, [
            .uint(button),
            .uint(state),
        ])
    }

    /// Destroy The Fake Input Device
    /// 
    /// 
    public func destroy() throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 5 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 5) }
        self.markDead()
        connection.send(self, 11, [
        ])
    }

    /// 
    /// - Parameters:
    public func keyboardKeysym(keysym: UInt32, state: UInt32) throws(WaylandProxyError) {
        guard self.isAlive else { throw WaylandProxyError.destroyed }
        guard self.version >= 6 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 6) }
        connection.send(self, 12, [
            .uint(keysym),
            .uint(state),
        ])
    }

    
    @_spi(SwiftWaylandPrivate)
    override public class func ensureLoaded() {
        CRuntimeInfo.shared.addIfNotExists(protocol: FakeInputProtocol)
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


public let FakeInputProtocol = Protocol(
        name: "fake_input",
        interfaces: [
            KdeFakeInput.interface
        ]
    )

#endif