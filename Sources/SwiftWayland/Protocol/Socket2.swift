import Foundation
import Glibc

// Copied from wayland-rs
/// Maximum number of FD that can be sent in a single socket message
let MAX_FDS_OUT: UInt = 28
/// Maximum number of bytes that can be sent in a single socket message
let MAX_BYTES_OUT: UInt = 4096

class Socket2 {
    private let fd: Int32

    init(fileDescriptor: Int32) {
        self.fd = fileDescriptor
    }
    
    func send(data: Data, fds: [FileHandle]) throws(SocketError)  {
        try Socket2.send(data: data, fds: fds, to: FileHandle(fileDescriptor: fd))
    }

    func receive(data: inout Data, fds: inout [FileHandle]) throws(SocketError)  -> Int {
        return try Socket2.receive(data: &data, fds: &fds, from: FileHandle(fileDescriptor: fd))
    }

    static func send(data: Data, fds handles: [FileHandle], to target: FileHandle) throws(SocketError) {
        let flags: Int32 = numericCast(MSG_DONTWAIT)
        let fds: [Int32] = handles.map { $0.fileDescriptor }
        let fdSize = MemoryLayout<Int32>.size * fds.count

        data.withUnsafeBytes { data in
            let message = Box(msghdr())

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

            sendmsg(target.fileDescriptor, message.ptr, flags)
        }
    }

    // reuse pls
    static func receive(data: inout Data, fds: inout [FileHandle], from fd: FileHandle) throws(SocketError)
        -> Int
    {
        let flags: Int32 = numericCast(MSG_DONTWAIT)

        data.reserveCapacity(Int(MAX_BYTES_OUT))
        let message = Box(msghdr())

        let bytesRead = data.withUnsafeMutableBytes { data in
            // data buffer
            let iov = Box(
                iovec(
                    iov_base: UnsafeMutableRawPointer(mutating: data.baseAddress),
                    iov_len: Int(MAX_BYTES_OUT)
                ))
            message.pointee.msg_iov = iov.ptr
            message.pointee.msg_iovlen = 1

            // Set up control buffer
            // Ancillary Data
            let controlBuffer = UnsafeMutableRawBufferPointer.allocate(
                byteCount: ControlMessage.space(Int(MAX_BYTES_OUT)),  // idk
                alignment: MemoryLayout<cmsghdr>.alignment
            )
            // defer { controlBuffer.deallocate() }
            message.pointee.msg_control = UnsafeMutableRawPointer(controlBuffer.baseAddress)
            message.pointee.msg_controllen = controlBuffer.count

            let bytesRead = recvmsg(fd.fileDescriptor, message.ptr, flags)
            return bytesRead
        }

        if bytesRead < 0 {
            throw SocketError.readFailed(errno: errno)
        }

        defer {
            message.pointee.msg_control.deallocate()
        }

        // data is already mutate so its fine
        // the header tho

        let controlMessage = ControlMessage.firstHeader(message.ptr)!

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

        fds.append(contentsOf: innerFds.map { FileHandle(fileDescriptor: $0) })

        print("+ Data: \(data)")
        print("+ fds: \(innerFds)")

        return bytesRead
    }
}

// Async stuff
extension Socket2 {

}
