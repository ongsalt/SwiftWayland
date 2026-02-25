import Foundation
@_exported import SwiftWaylandCommon

extension WlRegistry {
    public func bind<T>(name: UInt32, version: UInt32, interface: T.Type, queue: EventQueue? = nil)
        -> T
    where T: Proxy {
        let obj = connection.createProxy(type: T.self, version: version, queue: queue ?? self.queue) 
        connection.send(self, 0, [
            .string(interface.interface.name),
            .object(obj.id) // wayland-client do this for us???
        ])

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
