import Foundation

enum BufferedSocketError: Error {
    case notEnoughBytes
}

public class BufferedSocket {
    let socket: Socket2
    var data = Data()
    var fds: [FileHandle] = []

    var dataAvailable: Bool {
        data.count > 0
    }

    private var outData: [(Data, [FileHandle])] = []

    init(_ socket: Socket2) {
        self.socket = socket
    }

    func read(_ bytes: UInt16) throws(BufferedSocketError) -> Data {
        try self.read(Int(bytes))
    }

    func read(_ bytes: Int) throws(BufferedSocketError) -> Data {
        guard data.count >= bytes else {
            throw .notEnoughBytes
        }

        let out = Data(self.data[0..<bytes])
        self.data = Data(self.data[bytes..<data.count])

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
        // todo: batching?
        let flushed = outData
        outData = []
        for (data, fds) in flushed {
            print("[Wayland] sending: \(data as NSData)")
            try socket.send(data: data, fds: fds)
        }
    }

    func receiveUntilDone(force: Bool = false) throws(SocketError) {
        var shouldRun = force
        var data = Data()  // pls tell me this is CoW
        data.reserveCapacity(Int(MAX_BYTES_OUT))
        var fds: [FileHandle] = []

        while socket.canRead || shouldRun {
            shouldRun = false
            let read = try socket.receive(size: Int(MAX_BYTES_OUT), data: &data, fds: &fds)

            self.data.append(data[0..<read])
            self.fds.append(contentsOf: fds)

            if read <= 0 {
                if read < 0 {
                    print("err \(read)")
                }
                break
            }
        }
    }
}
