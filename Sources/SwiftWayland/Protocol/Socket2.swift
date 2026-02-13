import Foundation
import Glibc

// Copied from wayland-rs
/// Maximum number of FD that can be sent in a single socket message
let MAX_FDS_OUT: UInt = 28
/// Maximum number of bytes that can be sent in a single socket message
let MAX_BYTES_OUT: UInt = 4096

class Socket2 {
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

    func send(data: Data, fds: [FileHandle]) throws(SocketError) {
        try Socket2.send(data: data, fds: fds, to: FileHandle(fileDescriptor: fd))
    }

    func receive(size: Int, data: inout Data, fds: inout [FileHandle]) throws(SocketError) -> Int {
        return try Socket2.receive(
            size: size, data: &data, fds: &fds, from: FileHandle(fileDescriptor: fd))
    }

    static func send(data: Data, fds handles: [FileHandle], to target: FileHandle)
        throws(SocketError)
    {
        let flags: Int32 = 0
        // let flags: Int32 = numericCast(MSG_DONTWAIT)
        let fds: [Int32] = handles.map { $0.fileDescriptor }
        let fdSize = MemoryLayout<Int32>.size * fds.count

        let res = data.withUnsafeBytes { data in
            let message = Box(msghdr())
            if data.count == 0 {
                print("duck: \(data)")
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
                    alignment: MemoryLayout<cmsghdr>.alignment
                )
                defer { ancillaryData.deallocate() }

                message.pointee.msg_control = UnsafeMutableRawPointer(ancillaryData.baseAddress)
                message.pointee.msg_controllen = ancillaryData.count

                let controlMessage = ControlMessage.firstHeader(message.ptr)!
                controlMessage.pointee.cmsg_level = SOL_SOCKET
                controlMessage.pointee.cmsg_type = Int32(SCM_RIGHTS)
                controlMessage.pointee.cmsg_len = ControlMessage.lenght(fdSize)

                // fds.cop
                let dataPtr: UnsafeMutableRawPointer = ControlMessage.data(controlMessage)
                dataPtr.copyMemory(from: fds, byteCount: fdSize)
            }

            // print("start")
            return sendmsg(target.fileDescriptor, message.ptr, flags)
        }

        if res < 0 {
            print("res: \(res)")
            throw SocketError.readFailed(errno: errno)
        }
    }

    // reuse pls
    static func receive(
        size: Int, data outData: inout Data, fds: inout [FileHandle], from fd: FileHandle
    )
        throws(SocketError)
        -> Int
    {
        let flags: Int32 = 0
        // let flags: Int32 = numericCast(MSG_DONTWAIT)

        let size = max(Int(MAX_BYTES_OUT), size)
        let data = UnsafeMutableBufferPointer<Int8>.allocate(capacity: size)

        // fill with garbage

        let message = Box(msghdr())

        // data buffer
        let iov = Box(
            iovec(
                iov_base: UnsafeMutableRawPointer(mutating: data.baseAddress),
                iov_len: size
            ))
        message.pointee.msg_iov = iov.ptr
        message.pointee.msg_iovlen = 1

        // Set up control buffer
        // Ancillary Data
        let controlBuffer = UnsafeMutableRawBufferPointer.allocate(
            byteCount: ControlMessage.space(size),  // idk
            alignment: MemoryLayout<cmsghdr>.alignment
        )
        // defer { controlBuffer.deallocate() }
        message.pointee.msg_control = UnsafeMutableRawPointer(controlBuffer.baseAddress)
        message.pointee.msg_controllen = controlBuffer.count

        let bytesRead = recvmsg(fd.fileDescriptor, message.ptr, flags)

        if bytesRead < 0 {
            throw SocketError.readFailed(errno: errno)
        }

        // print("Read: \(bytesRead)")

        defer {
            message.pointee.msg_control.deallocate()
        }

        // TODO: stop copying multiple time
        outData.append(UnsafeBufferPointer(start: data.baseAddress, count: bytesRead))
        // the header tho

        if let controlMessage = ControlMessage.firstHeader(message.ptr) {
            guard
                controlMessage.pointee.cmsg_type == SCM_RIGHTS
                    && controlMessage.pointee.cmsg_level == SOL_SOCKET
            else {
                throw .invalidData
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

        return bytesRead
    }
}

// Async stuff
extension Socket2 {

}
