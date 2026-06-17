import Foundation
@_exported import SwiftWaylandCommon

extension WlRegistry {
    public func bind<T>(name: UInt32, version: UInt32, interface: T.Type, queue: EventQueue? = nil)
        -> T
    where T: Proxy {
        connection.sendConstructor(
            self, 0,
            interface,
            version,
            queue,
            [
                .uint(name),
                .string(interface.interface.name),
                .uint(version),
                .newId,
            ]
        )
    }
}

extension WlCallback {
    public func register(_ callback: @escaping (UInt32) -> Void) {
        let ref = Unmanaged.passRetained(self)
        self.onEvent = { event in
            switch event {
            case .done(let callbackData):
                callback(callbackData)
                ref.release()
            }
        }
    }
}
