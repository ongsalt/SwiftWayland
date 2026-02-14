import Foundation

enum BufferedSocketError: Error {
    case notEnoughBytes(requested: Int, left: Int)
}

public class BufferedSocket {
    let socket: Socket2
    var data: Data
    var fds: [FileHandle] = []

    var dataAvailable: Bool {
        data.count > 0
    }

    private var outData: [(Data, [FileHandle])] = []

    init(_ socket: Socket2) {
        self.socket = socket
        data = Data()
    }

    func read(_ bytes: UInt16, consume: Bool = true) throws(BufferedSocketError) -> Data {
        try self.read(Int(bytes), consume: consume)
    }

    func read(_ bytes: Int, consume: Bool = true) throws(BufferedSocketError) -> Data {
        guard data.count >= bytes else {
            throw .notEnoughBytes(requested: bytes, left: data.count)
        }

        let out = Data(self.data[0..<bytes])

        if consume {
            self.data = Data(self.data[bytes..<data.count])
        }

        return out
    }

    func readFd() -> FileHandle? {
        if self.fds.count == 0 {
            nil
        } else {
            self.fds.removeFirst()
        }
    }

    func write(data: Data, fds: [FileHandle]) {
        outData.append((data, fds))
    }

    func flush() throws(SocketError) {
        let flushed = outData
        outData = []

        // we should just merge all of this together first
        // well, is this the perfect use case for iovec
        for (data, fds) in flushed {
            #if DEBUG
                // print("[Wayland] sending: \(data as NSData)")
            #endif

            do {
                try data.withUnsafeBytes { data in
                    // print("Sending")
                    _ = try socket.send(data: data, fds: fds)
                }
            } catch {
                throw error as! SocketError
            }
        }
    }

    private let _data: UnsafeMutableRawBufferPointer = UnsafeMutableRawBufferPointer.allocate(
        byteCount: Int(MAX_BYTES_OUT), alignment: MemoryLayout<UInt8>.alignment)
    deinit {
        _data.deallocate()
    }

    func receiveUntilDone(force: Bool = false) throws(SocketError) {
        var shouldRun = force
        var fds: [FileHandle] = []

        while socket.canRead || shouldRun {
            shouldRun = false
            let read = try socket.receive(data: _data, fds: &fds)

            if read <= 0 {
                if read < 0 {
                    print("err \(read)")
                }
                break
            }

            self.data.append(_data.baseAddress!.assumingMemoryBound(to: UInt8.self), count: read)
            self.fds.append(contentsOf: fds)
        }
    }
}
