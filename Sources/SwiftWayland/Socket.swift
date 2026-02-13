import Dispatch
import Foundation
import Glibc

enum SocketEvent {
    case read(UInt)
    case write
    case error(Error)
    case close
}

enum SocketError: Error {
    case readFailed(errno: Int32)
    case writeFailed(errno: Int32)
    case closed
}

final class Socket {
    private let fileDescriptor: Int32
    private let queue = DispatchQueue(label: "SwiftWayland.Socket")
    private let readSource: DispatchSourceRead
    private let writeSource: DispatchSourceWrite
    private let eventStream: AsyncStream<SocketEvent>
    private let continuation: AsyncStream<SocketEvent>.Continuation
    var event: AsyncStream<SocketEvent> { eventStream }

    var canRead: Bool {
        var pfd = pollfd(fd: fileDescriptor, events: Int16(POLLIN), revents: 0)
        poll(&pfd, 1, 0)
        let res = pfd.revents & Int16(POLLIN)
        return res != 0
    }

    init(fileDescriptor: Int32) {
        self.fileDescriptor = fileDescriptor

        var streamContinuation: AsyncStream<SocketEvent>.Continuation!
        self.eventStream = AsyncStream { continuation in
            streamContinuation = continuation
        }
        self.continuation = streamContinuation

        self.writeSource = DispatchSource.makeWriteSource(
            fileDescriptor: fileDescriptor, queue: queue)
        self.readSource = DispatchSource.makeReadSource(
            fileDescriptor: fileDescriptor, queue: queue)

        self.readSource.setEventHandler { [unowned self] in
            if self.readSource.data != 0 {
                self.continuation.yield(.read(self.readSource.data))
            }
        }
        self.readSource.setCancelHandler { [unowned self] in
            self.continuation.yield(.close)
            self.continuation.finish()
        }
        self.writeSource.setEventHandler { [unowned self] in
            self.continuation.yield(.write)
        }

        self.writeSource.resume()
        self.readSource.resume()
    }

    deinit {
        readSource.cancel()
        writeSource.cancel()
        _ = Glibc.close(fileDescriptor)
    }

    func read(_ count: Int) async throws -> Data {
        let res = try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async { [fileDescriptor] in
                do {
                    let data = try Socket.readBlocking(fd: fileDescriptor, count: count)
                    continuation.resume(returning: data)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }

        return res
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

    func writeBlocking(data: Data) throws {
        try Socket.writeBlocking(fd: fileDescriptor, data: data)
    }

    func readBlocking(count: Int) throws -> Data {
        try Socket.readBlocking(fd: fileDescriptor, count: count)
    }

    func readControlMessage() async throws -> Int32 {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global().async { [fileDescriptor] in
                do {
                    let receivedFd = try Socket.readControlMessageBlocking(fd: fileDescriptor)
                    continuation.resume(returning: receivedFd)
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

    // https://stackoverflow.com/questions/2358684/can-i-share-a-file-descriptor-to-another-process-on-linux-or-are-they-local-to-t

    private static func readControlMessageBlocking(fd: Int32) throws -> Int32 {
        let dataSize = MemoryLayout<Int32>.size
        let sharedBuffer = UnsafeMutableBufferPointer<CChar>
            .allocate(capacity: ControlMessage.space(dataSize))
        defer { sharedBuffer.deallocate() }

        let iovBuffer = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: 1)
        defer { iovBuffer.deallocate() }

        let iov = UnsafeMutablePointer<iovec>.allocate(capacity: 1)
        defer { iov.deallocate() }
        iov.initialize(to: iovec(iov_base: iovBuffer.baseAddress, iov_len: iovBuffer.count))
        defer { iov.deinitialize(count: 1) }

        let message: UnsafeMutablePointer<msghdr> = .allocate(capacity: 1)
        defer { message.deallocate() }

        while true {
            message.pointee = msghdr(
                msg_name: nil,
                msg_namelen: 0,
                msg_iov: iov,
                msg_iovlen: 1,
                msg_control: sharedBuffer.baseAddress,
                msg_controllen: sharedBuffer.count,
                msg_flags: 0
            )

            let res = Glibc.recvmsg(fd, message, 0)
            if res < 0 {
                if errno == EINTR { continue }
                throw SocketError.readFailed(errno: errno)
            }

            guard let controlMessage = ControlMessage.firstHeader(message) else {
                throw SocketError.readFailed(errno: 0)
            }

            guard controlMessage.pointee.cmsg_level == SOL_SOCKET,
                  controlMessage.pointee.cmsg_type == Int32(SCM_RIGHTS),
                  controlMessage.pointee.cmsg_len >= ControlMessage.lenght(dataSize) else {
                throw SocketError.readFailed(errno: 0)
            }

            let dataPtr = ControlMessage.data(controlMessage)
            return dataPtr.assumingMemoryBound(to: Int32.self).pointee
        }
    }

    private static func writeControlMessageBlocking(sending sendFd: FileHandle, to fd: FileHandle) throws {
        let toSend: [Int32] = [sendFd.fileDescriptor]
        let dataSize = MemoryLayout<Int32>.size
        let sharedBuffer = UnsafeMutableBufferPointer<CChar>
            .allocate(capacity: ControlMessage.space(dataSize))
        defer { sharedBuffer.deallocate() }
        // just leave it there????
        let iovBuffer = UnsafeMutableBufferPointer<Int32>.allocate(capacity: 1)
        defer { iovBuffer.deallocate() }

        let iov = UnsafeMutablePointer<iovec>.allocate(capacity: 1)
        defer { iov.deallocate() }
        iov.initialize(
            to: iovec(
                iov_base: iovBuffer.baseAddress,
                iov_len: iovBuffer.count
            ))

        let message: UnsafeMutablePointer<msghdr> = .allocate(capacity: 1)
        defer { message.deallocate() }
        message.pointee = msghdr(
            msg_name: nil,
            msg_namelen: 0,
            msg_iov: iov,
            msg_iovlen: 1,
            msg_control: sharedBuffer.baseAddress,
            msg_controllen: 1,
            msg_flags: 0
        )

        let controlMessage: UnsafeMutablePointer<cmsghdr> = ControlMessage.firstHeader(message)!
        defer { controlMessage.deallocate() }
        controlMessage.pointee.cmsg_level = SOL_SOCKET
        controlMessage.pointee.cmsg_type = Int32(SCM_RIGHTS)
        controlMessage.pointee.cmsg_len = ControlMessage.lenght(dataSize)

        let dataPtr = ControlMessage.data(controlMessage)
        dataPtr.copyMemory(from: toSend, byteCount: dataSize)

        let res = Glibc.sendmsg(fd.fileDescriptor, message, 0)
        if res < 0 {
            throw SocketError.writeFailed(errno: errno)
        }
    }

    private static func writeControlMessageBlocking(fd: Int32, data: Data) throws {
        fatalError("msg_control is not implemented")
    }

}

// see socket.h
// __glibc_c99_flexarr_available is not defined for some reason
// swift wont see so __cmsg_data
struct ControlMessage {
    // CMSG_DATA
    static func data(_ cmsg: UnsafeMutableRawPointer) -> UnsafeMutableRawPointer {
        let dataPtr: UnsafeMutableRawPointer = cmsg.advanced(
            by: MemoryLayout<Int>.size + MemoryLayout<Int32>.size * 2)
        return dataPtr
    }

    // CMSG_ALIGN
    @inlinable
    static func align(_ len: Int) -> Int {
        (len + MemoryLayout<Int>.size - 1) & ~(MemoryLayout<Int>.size - 1)
    }

    // CMSG_SPACE
    @inlinable
    static func space(_ len: Int) -> Int {
        align(len) + align(MemoryLayout<ControlMessageHeader>.size)
    }

    // CMSG_LEN
    @inlinable
    static func lenght(_ len: Int) -> Int {
        align(MemoryLayout<ControlMessageHeader>.size) + (len)
    }

    // CMSG_FIRSTHDR
    @inlinable
    static func firstHeader(_ msg: UnsafeMutablePointer<msghdr>) -> UnsafeMutablePointer<cmsghdr>? {
        guard msg.pointee.msg_controllen >= MemoryLayout<cmsghdr>.size else { return nil }
        return msg.pointee.msg_control?.assumingMemoryBound(to: cmsghdr.self)
    }
}

struct ControlMessageHeader {
    public var lenght: Int
    public var level: Int32
    public var type: Int32
    // public var data: UInt
    // init(ptr: UnsafeRawPointer) {
    //     let buffer = UnsafeRawBufferPointer(start: ptr, count: MemoryLayout<Self>.size)
    //     self = buffer.assumingMemoryBound(to: Self.self)[0]
    // }
}
