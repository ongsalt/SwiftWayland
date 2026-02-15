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
