import CoreFoundation
import Foundation

public func _parseEnum<T>(into: T.Type, _ rawValue: UInt32) throws(DecodingError) -> T
where T: RawRepresentable, T.RawValue == UInt32 {
    guard let instance = T(rawValue: rawValue) else {
        throw .unknownEnumCase(case: rawValue, enumName: String(describing: T.self))
    }
    return instance
}

// TODO: actully getting CFRunLoop from a RunLoop
class RunLoopObserver {
    let observer: CFRunLoopObserver
    let runLoop: CFRunLoop

    init(
        on activities: [CFRunLoopActivity],
        runLoop: RunLoop = .main,
        repeated: Bool = true,
        priority: Int = 0,
        _ callback: @escaping (CFRunLoopActivity) -> Void
    ) {
        self.runLoop = runLoop.cfRunLoop

        let activities = activities.reduce(CFOptionFlags()) { partialResult, activity in
            activity.rawValue | partialResult
        }

        observer = CFRunLoopObserverCreateWithHandler(
            nil, activities, repeated, priority
        ) { observer, activity in
            callback(activity)
        }!
    }

    func start() {
        CFRunLoopAddObserver(runLoop, observer, kCFRunLoopDefaultMode)
    }

    func stop() {
        CFRunLoopRemoveObserver(runLoop, observer, kCFRunLoopDefaultMode)
    }
}

public struct Watch: ~Copyable {
    private var stop: (() -> Void)?
    init(_ stop: @escaping () -> Void) { self.stop = stop }
    public mutating func cancel() {
        stop?()
        stop = nil
    }
    deinit { stop?() }
}

extension RunLoop {
    var cfRunLoop: CFRunLoop! {
        let m = Mirror(reflecting: RunLoop.main)
        for c in m.children {
            if c.label == "_cfRunLoopStorage" {
                return unsafeBitCast(c.value as AnyObject, to: CFRunLoop.self)
            }
        }

        return nil
    }
}
