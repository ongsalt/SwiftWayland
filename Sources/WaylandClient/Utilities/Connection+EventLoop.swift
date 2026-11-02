import CWayland

#if canImport(Dispatch)
    import Dispatch
    import Glibc
    import Synchronization

    extension Connection {
        public func makeReadSource(queue: DispatchQueue = .main) -> any DispatchSourceRead {
            DispatchSource.makeReadSource(fileDescriptor: fd, queue: queue)
        }

        /// Drives the default queue from the main dispatch queue, so it works under
        /// `dispatchMain()`, `RunLoop`, or anything else that drains it.
        ///
        /// Assumes the main thread is the only one reading the socket. A read is never held
        /// while handlers run, so blocking calls such as `roundtrip()` are safe from handlers.
        @MainActor
        public func attach() -> Watch {
            let pump = EventPump(connection: self)
            pump.start()
            return Watch { pump.stop() }
        }

        fileprivate var errorDescription: String {
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
        fileprivate var hasPendingInput: Bool {
            var pfd = pollfd(fd: fd, events: Int16(POLLIN), revents: 0)
            return poll(&pfd, 1, 0) > 0
        }
    }

    /// One coalesced main-queue job that drains, reads once if there is input, drains
    /// again and flushes. Scheduled when the socket is readable and whenever the
    /// connection reports activity (requests queued, blocking calls returned).
    @MainActor
    private final class EventPump {
        let connection: Connection
        let source: any DispatchSourceRead
        nonisolated let scheduled = Atomic<Bool>(false)
        var stopped = false

        init(connection: Connection) {
            self.connection = connection
            self.source = connection.makeReadSource(queue: .main)
        }

        func start() {
            source.setEventHandler { [weak self] in
                MainActor.assumeIsolated { self?.pump() }
            }
            source.resume()
            connection.setActivityHandler { [weak self] in self?.schedule() }
            schedule()
        }

        func stop() {
            if stopped { return }
            stopped = true
            connection.setActivityHandler(nil)
            source.cancel()
        }

        nonisolated func schedule() {
            if scheduled.exchange(true, ordering: .relaxed) { return }
            DispatchQueue.main.async {
                MainActor.assumeIsolated { self.pump() }
            }
        }

        private func pump() {
            // Cleared first, so requests sent by handlers below schedule another flush.
            scheduled.store(false, ordering: .relaxed)
            if stopped { return }

            while true {
                guard let read = connection.prepareRead() else {
                    if connection.dispatchPending() < 0 { return fail() }
                    continue
                }
                if connection.hasPendingInput {
                    read.read()
                    // Always dispatch after reading: wl_display events (error, delete_id) go to
                    // libwayland's internal display queue, which prepareRead doesn't check.
                    if connection.dispatchPending() < 0 { return fail() }
                }
                // Otherwise dropping `read` cancels it.
                break
            }

            connection.flush()
            if wl_display_get_error(connection.rawDisplay) != 0 { fail() }
        }

        private func fail() {
            print("Wayland connection failed, detaching: \(connection.errorDescription)")
            stop()
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

#endif
