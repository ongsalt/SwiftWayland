import CWayland

#if canImport(Foundation) && canImport(CoreFoundation)
    import CoreFoundation
    import Foundation

    extension Connection {
        public func makeReadSource(queue: DispatchQueue = .main) -> any DispatchSourceRead {
            DispatchSource.makeReadSource(fileDescriptor: fd, queue: queue)
        }

        @MainActor
        public func attach() -> Watch {
            var prepared = false

            func preparePoll() {
                while !self.prepareRead() {
                    self.dispatchPending()
                }
                prepared = true
                self.flush()
            }

            let source = makeReadSource(queue: .main)
            source.setEventHandler {
                self.readEvents()
                prepared = false
                self.dispatchPending()

                if wl_display_get_error(self.rawDisplay) != 0 {
                    source.cancel()
                    return
                }

                preparePoll()
            }

            source.setCancelHandler {
                if prepared {
                    self.cancelRead()
                    prepared = false
                }
            }

            let observer = RunLoopObserver(on: [.beforeWaiting], runLoop: .main) { [weak self] _ in
                self?.flush()
            }

            preparePoll()
            source.resume()
            observer.start()

            return Watch {
                observer.stop()
                source.cancel()
            }
        }

        @MainActor
        public func run() {
            let watch = self.attach()
            RunLoop.main.run()
            _ = watch
        }
    }

    // TODO: actully getting CFRunLoop from a RunLoop
    final class RunLoopObserver {
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

#endif
