import Foundation
@_exported import SwiftWaylandCommon

extension WlRegistry {
    public func bind<T>(name: UInt32, version: UInt32, interface: T.Type, queue: EventQueue? = nil)
        -> T
    where T: Proxy {
        let obj = connection.createProxy(type: interface, queue: queue ?? self.queue)
        connection.send(
            self, 0,
            [
                .uint(name),
                .string(interface.interface.name),
                .uint(version),
                // TODO: switch back to .newId and map it back to .object() only for c backend
                .object(obj.id),
            ],
        )
        return obj
    }
}

extension Connection {
    public func createCallback(
        fn: @escaping (UInt32) -> Void, queue: EventQueue
    ) -> WlCallback {
        let callback = self.createProxy(type: WlCallback.self, queue: queue)
        callback.onEvent = { event in
            switch event {
            case .done(let callbackData):
                fn(callbackData)
            }
        }

        return callback
    }
}
