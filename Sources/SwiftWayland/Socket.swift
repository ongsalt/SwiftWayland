import Dispatch
import Foundation
import Glibc

enum SocketEvent {
    case read
    case write
    case error(Error)
    case close
}

enum SocketError: Error {
    case readFailed(errno: Int32)
    case writeFailed(errno: Int32)
    case closed
}

final class Socket: @unchecked Sendable {
    private let fileDescriptor: Int32
    private let queue = DispatchQueue(label: "SwiftWayland.Socket")
    private let readSource: DispatchSourceRead
    private let eventStream: AsyncStream<SocketEvent>
    private let continuation: AsyncStream<SocketEvent>.Continuation

    var event: AsyncStream<SocketEvent> { eventStream }

    init(fileDescriptor: Int32) {
        self.fileDescriptor = fileDescriptor

        var streamContinuation: AsyncStream<SocketEvent>.Continuation!
        self.eventStream = AsyncStream { continuation in
            streamContinuation = continuation
        }
        self.continuation = streamContinuation

        self.readSource = DispatchSource.makeReadSource(
            fileDescriptor: fileDescriptor, queue: queue)
        self.readSource.setEventHandler { [weak self] in
            self?.continuation.yield(.read)
        }
        self.readSource.setCancelHandler { [weak self] in
            self?.continuation.yield(.close)
            self?.continuation.finish()
        }
        self.readSource.resume()
    }

    deinit {
        readSource.cancel()
        _ = Glibc.close(fileDescriptor)
    }

    func read(_ count: Int) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async { [fileDescriptor] in
                do {
                    let data = try Socket.readBlocking(fd: fileDescriptor, count: count)
                    continuation.resume(returning: data)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func write(_ data: Data) async throws {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async { [fileDescriptor] in
                do {
                    try Socket.writeBlocking(fd: fileDescriptor, data: data)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func readControlMessage() async throws -> [cmsghdr] {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async { [fileDescriptor] in
                do {
                    let data: [cmsghdr] = try Socket.readControlMessageBlocking(fd: fileDescriptor)
                    print("cmsghdr: \(data)")
                    continuation.resume(returning: data)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func writeControlMessage(_ data: Data) async throws {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async { [fileDescriptor] in
                do {
                    try Socket.writeControlMessageBlocking(fd: fileDescriptor, data: data)
                    continuation.resume()
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func close() async {
        readSource.cancel()
        _ = Glibc.close(fileDescriptor)
    }

    private static func readBlocking(fd: Int32, count: Int) throws -> Data {
        var buffer = [UInt8](repeating: 0, count: count)
        var bytesRead = 0

        while bytesRead < count {
            let result: Int = buffer.withUnsafeMutableBytes { ptr in
                let base = ptr.baseAddress!.advanced(by: bytesRead)
                return Glibc.read(fd, base, count - bytesRead)
            }

            if result == 0 {
                throw SocketError.closed
            }
            if result < 0 {
                if errno == EINTR { continue }
                throw SocketError.readFailed(errno: errno)
            }
            bytesRead += result
        }

        return Data(buffer)
    }

    private static func writeBlocking(fd: Int32, data: Data) throws {
        var bytesWritten = 0
        let total = data.count

        try data.withUnsafeBytes { ptr in
            while bytesWritten < total {
                let base = ptr.baseAddress!.advanced(by: bytesWritten)
                let result = Glibc.write(fd, base, total - bytesWritten)

                if result < 0 {
                    if errno == EINTR { continue }
                    throw SocketError.writeFailed(errno: errno)
                }
                bytesWritten += result
            }
        }
    }

    private static func readControlMessageBlocking(fd: Int32) throws -> [cmsghdr] {
        var controlBuffer = [UInt8](repeating: 0, count: 1024)  // no c macro
        let messages = try controlBuffer.withUnsafeMutableBufferPointer { ptr in
            var msg = msghdr()
            msg.msg_control = UnsafeMutableRawPointer(ptr.baseAddress)
            msg.msg_controllen = ptr.count

            let result = Glibc.recvmsg(fd, &msg, 0)

            if result < 0 {
                throw SocketError.readFailed(errno: errno)
            }

            let messages: [cmsghdr] = Array(
                UnsafeBufferPointer(
                    start: UnsafeRawPointer(ptr.baseAddress)?.assumingMemoryBound(to: cmsghdr.self),
                    count: Int(msg.msg_controllen)
                )
            )

            return messages
        }

        return messages
    }

    private static func writeControlMessageBlocking(fd: Int32, data: Data) throws {
        fatalError("msg_control is not implemented")
    }

}
