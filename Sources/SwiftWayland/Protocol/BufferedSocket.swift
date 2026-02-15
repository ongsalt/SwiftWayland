import Foundation

enum BufferedSocketError: Error {
    case notEnoughBytes(requested: Int, left: Int)
    case closed
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

    func read(_ bytes: UInt16, consume: Bool = true) -> Result<Data, BufferedSocketError> {
        self.read(Int(bytes), consume: consume)
    }

    func read(_ bytes: Int, consume: Bool = true) -> Result<Data, BufferedSocketError> {
        guard data.count >= bytes else {
            return .failure(.notEnoughBytes(requested: bytes, left: data.count))
        }

        let out = Data(self.data[0..<bytes])

        if consume {
            self.data = Data(self.data[bytes..<data.count])
        }

        return .success(out)
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

    func flush() -> Result<(), SocketError> {
        let flushed = outData
        outData = []

        // we should just merge all of this together first
        // well, is this the perfect use case for iovec
        for (data, fds) in flushed {
            #if DEBUG
                print("[Wayland] sending: \(data as NSData)")
            #endif

            let res = data.withUnsafeBytes { data in
                // print("Sending")
                socket.send(data: data, fds: fds)
            }

            if case .failure(let error) = res {
                return .failure(error)
            }
        }

        return .success(())
    }

    private let _data: UnsafeMutableRawBufferPointer = UnsafeMutableRawBufferPointer.allocate(
        byteCount: Int(MAX_BYTES_OUT), alignment: MemoryLayout<UInt8>.alignment)
    deinit {
        _data.deallocate()
    }

    func receiveUntilDone(force: Bool = false) -> Result<(), SocketError> {
        var shouldRun = force
        var fds: [FileHandle] = []

        while socket.canRead || shouldRun {
            shouldRun = false
            let res = socket.receive(data: _data, fds: &fds)
            guard case .success(let bytesRead) = res else {
                return .failure(res.error!)
            }

            if bytesRead <= 0 {
                // if bytesRead < 0 {
                //     print("wtf err \(bytesRead)")
                // }
                break
            }

            self.data.append(
                _data.baseAddress!.assumingMemoryBound(to: UInt8.self), count: bytesRead)
            self.fds.append(contentsOf: fds)
        }

        return .success(())
    }
}
