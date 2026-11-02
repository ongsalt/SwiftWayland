import CWayland

#if canImport(Foundation) && canImport(CoreFoundation)
    import CoreFoundation
    import Foundation

    extension Connection {
        public func makeReadSource(queue: DispatchQueue = .main) -> any DispatchSourceRead {
            DispatchSource.makeReadSource(fileDescriptor: fd, queue: queue)
        }

        /// Drives the default queue from the main run loop.
        ///
        /// A read is only prepared while the loop is asleep: libwayland's `read_events`
        /// waits for every prepared reader, so holding one while handlers run would stall
        /// threads reading their own queues, and would deadlock blocking calls such as
        /// `roundtrip()` made from a handler.
        ///
        /// While the read is prepared, nobody can consume the socket, so events for this
        /// queue that another thread reads always arrive through the main thread's own read.
        @MainActor
        public func attach() -> Watch {
            var pendingRead: ReadGuard?
            var stopped = false
            var observer: RunLoopObserver?
            // Only wakes the run loop; the observer does the reading.
            let source = makeReadSource(queue: .main)
            source.setEventHandler {}

            func stop() {
                if stopped { return }
                stopped = true
                pendingRead = nil
                observer?.stop()
                source.cancel()
            }

            func fail() {
                print("Wayland connection failed, detaching: \(self.errorDescription)")
                stop()
            }

            func beforeWaiting() {
                if pendingRead != nil { return }
                while true {
                    if let read = self.prepareRead() {
                        pendingRead = consume read
                        break
                    }
                    if self.dispatchPending() < 0 {
                        fail()
                        return
                    }
                }
                self.flush()
            }

            func afterWaiting() {
                guard let read = pendingRead.take() else { return }
                if self.hasPendingInput {
                    read.read()
                }
                // Otherwise dropping `read` cancels it.
                if self.dispatchPending() < 0 || wl_display_get_error(self.rawDisplay) != 0 {
                    fail()
                }
            }

            observer = RunLoopObserver(
                on: [.beforeWaiting, .afterWaiting, .exit], runLoop: .main
            ) { activity in
                if activity == .beforeWaiting {
                    beforeWaiting()
                } else {
                    // A loop exiting while asleep (e.g. a nested `run(until:)` timing out)
                    // must not leave the read prepared either.
                    afterWaiting()
                }
            }

            source.resume()
            observer?.start()

            return Watch { stop() }
        }

        private var errorDescription: String {
            let code = wl_display_get_error(rawDisplay)
            guard code == EPROTO else { return String(cString: strerror(code)) }

            var interface: UnsafePointer<wl_interface>?
            var id: UInt32 = 0
            let protocolCode = wl_display_get_protocol_error(rawDisplay, &interface, &id)
            let name = interface.map { String(cString: $0.pointee.name) } ?? "unknown"
            return "protocol error \(protocolCode) on \(name)@\(id)"
        }

        /// Non-blocking check for socket input; errors and hangups count, so
        /// `ReadGuard.read()` gets to report them.
        private var hasPendingInput: Bool {
            var pfd = pollfd(fd: fd, events: Int16(POLLIN), revents: 0)
            return poll(&pfd, 1, 0) > 0
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
            CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes)
        }

        func stop() {
            CFRunLoopRemoveObserver(runLoop, observer, kCFRunLoopCommonModes)
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
