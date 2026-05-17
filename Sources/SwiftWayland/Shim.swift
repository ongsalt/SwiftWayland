import Foundation
@_exported import SwiftWaylandCommon

extension WlRegistry {
    public func bind<T>(name: UInt32, version: UInt32, interface: T.Type, queue: EventQueue? = nil)
        -> T
    where T: Proxy {
        let obj = connection.sendConstructor(
            self, 0,
            [
                .uint(name),
                .string(interface.interface.name),
                .uint(version),
                .newId(1002),  // wayland-client do this for us???
            ],
            version: version,
            interface: interface,
            queue: queue
        )

        return obj
    }
}

extension Connection {
    public func createCallback(
        fn: @escaping (UInt32) -> Void, queue: EventQueue
    ) -> WlCallback {
        let callback = self.createProxy(type: WlCallback.self, version: 1, queue: queue)
        callback.onEvent = { event in
            switch event {
            case .done(let callbackData):
                fn(callbackData)
            }
        }

        return callback
    }
}
