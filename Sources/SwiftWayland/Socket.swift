import Dispatch
import Foundation
import Glibc

enum SocketEvent {
    case read(UInt)
    case write
    case error(Error)
    case close
}

public enum SocketError: Error {
    case cannotOpenSocket(errno: Int32)
    case cannotConnect(errno: Int32)
    case invalidData
    case invalidFds([Int32])
    case closed
    case readFailed(errno: Int32)
    case writeFailed(errno: Int32)
}

// Copied from wayland-rs
/// Maximum number of FD that can be sent in a single socket message
let MAX_FDS_OUT: UInt = 28
/// Maximum number of bytes that can be sent in a single socket message
let MAX_BYTES_OUT: UInt = 4096

class Socket {
    private let fd: Int32

    var canRead: Bool {
        var pfd = pollfd(fd: fd, events: Int16(POLLIN), revents: 0)
        poll(&pfd, 1, 0)
        let res = pfd.revents & Int16(POLLIN)
        // print(pfd)
        return res != 0
    }

    init(fileDescriptor: Int32) {
        self.fd = fileDescriptor
    }

    init(connectTo path: String) throws(SocketError) {
        var addr = sockaddr_un()
        addr.sun_family = UInt16(AF_UNIX)
        withUnsafeMutableBytes(of: &addr.sun_path) { ptr in
            ptr.copyBytes(from: path.utf8)
            ptr[path.count] = 0  // null terminated
        }

        let fd = Glibc.socket(AF_UNIX, Int32(SOCK_STREAM.rawValue), 0)
        guard fd != -1 else {
            throw .cannotOpenSocket(errno: errno)
        }

        let c = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1, ) { ptr in
                connect(fd, ptr, UInt32(MemoryLayout<sockaddr_un>.size))
            }
        }
        guard c != -1 else {
            throw .cannotConnect(errno: errno)
        }

        self.fd = fd
    }

    deinit {
        Glibc.close(self.fd)
    }

    func send(data: UnsafeRawBufferPointer, fds: [FileHandle]) -> Result<Int, SocketError> {
        Socket.send(data: data, fds: fds, to: FileHandle(fileDescriptor: fd))
    }

    func receive(data: UnsafeMutableRawBufferPointer, fds: inout [FileHandle]) -> Result<
        Int, SocketError
    > {
        Socket.receive(data: data, fds: &fds, from: FileHandle(fileDescriptor: fd))
    }

    static func send(data: UnsafeRawBufferPointer, fds handles: [FileHandle], to target: FileHandle)
        -> Result<Int, SocketError>
    {
        let flags: Int32 = 0
        // let flags: Int32 = numericCast(MSG_DONTWAIT)
        let fds: [Int32] = handles.map { $0.fileDescriptor }
        let fdSize = MemoryLayout<Int32>.size * fds.count

        let message = Box(msghdr())
        if data.count == 0 {
            // print("duck: \(data)")
        }

        // Actual data: iov
        let iov = Box(
            iovec(
                iov_base: UnsafeMutableRawPointer(mutating: data.baseAddress),
                iov_len: data.count
            ))

        message.pointee.msg_iov = iov.ptr
        message.pointee.msg_iovlen = 1

        // Set up control message
        // Ancillary Data
        if !fds.isEmpty {
            let ancillaryData = UnsafeMutableRawBufferPointer.allocate(
                byteCount: ControlMessage.space(fdSize),
                alignment: MemoryLayout<cmsghdr>.alignment  // 8
            )

            message.pointee.msg_control = UnsafeMutableRawPointer(ancillaryData.baseAddress)
            message.pointee.msg_controllen = ancillaryData.count

            let controlMessage = ControlMessage.firstHeader(message.ptr)!
            controlMessage.pointee.cmsg_level = SOL_SOCKET
            controlMessage.pointee.cmsg_type = Int32(SCM_RIGHTS)
            controlMessage.pointee.cmsg_len = ControlMessage.lenght(fdSize)

            let dataPtr: UnsafeMutableRawPointer = ControlMessage.data(controlMessage)
            dataPtr.copyMemory(from: fds, byteCount: fdSize)
        }

        defer { message.pointee.msg_control?.deallocate() }

        // print("start")
        let res = sendmsg(target.fileDescriptor, message.ptr, flags)

        if res < 0 {
            // print("res: \(res)")
            if errno == 9 {
                return .failure(SocketError.invalidFds(fds))
            }
            return .failure(SocketError.writeFailed(errno: errno))
        }

        return .success(res)
    }

    // reuse pls
    static func receive(
        data: UnsafeMutableRawBufferPointer, fds: inout [FileHandle], from fd: FileHandle
    )
        -> Result<Int, SocketError>
    {
        let flags: Int32 = 0
        // let flags: Int32 = numericCast(MSG_DONTWAIT)

        assert(data.count >= MAX_BYTES_OUT)
        // let data = UnsafeMutableBufferPointer<Int8>.allocate(capacity: size)

        // fill with garbage

        let message = Box(msghdr())

        // data buffer
        let iov = Box(
            iovec(
                iov_base: UnsafeMutableRawPointer(mutating: data.baseAddress),
                iov_len: data.count
            ))
        message.pointee.msg_iov = iov.ptr
        message.pointee.msg_iovlen = 1

        // Set up control buffer
        // Ancillary Data
        let controlBuffer = UnsafeMutableRawBufferPointer.allocate(
            byteCount: ControlMessage.space(data.count),  // idk
            alignment: MemoryLayout<cmsghdr>.alignment
        )
        // defer { controlBuffer.deallocate() }
        message.pointee.msg_control = UnsafeMutableRawPointer(controlBuffer.baseAddress)
        message.pointee.msg_controllen = controlBuffer.count

        let bytesRead = recvmsg(fd.fileDescriptor, message.ptr, flags)

        if bytesRead < 0 {
            // if errno == 104 {
            //     throw SocketError.connectionClosed
            // }
            return .failure(SocketError.readFailed(errno: errno))
        }

        defer {
            message.pointee.msg_control.deallocate()
        }

        if let controlMessage = ControlMessage.firstHeader(message.ptr) {
            guard
                controlMessage.pointee.cmsg_type == SCM_RIGHTS
                    && controlMessage.pointee.cmsg_level == SOL_SOCKET
            else {
                return .failure(SocketError.invalidData)
            }

            let dataPtr = ControlMessage.data(controlMessage)
            let innerFds = [Int32](
                UnsafeRawBufferPointer(start: dataPtr, count: controlMessage.pointee.cmsg_len)
                    .assumingMemoryBound(to: Int32.self)
            )

            fds = innerFds.makeIterator().map { FileHandle(fileDescriptor: $0) }
        }

        // print("+ outData: (\(outData)) \(outData as NSData)")
        // print("+ fds: \(fds)")

        return .success(bytesRead)
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
