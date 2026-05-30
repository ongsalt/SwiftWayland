import Foundation
import SwiftWayland

final class ShmBuffer {
    let buffer: WlBuffer
    let data: UnsafeMutableRawPointer
    let width: Int
    let height: Int
    private let byteSize: Int

    init(shm: WlShm, width: Int, height: Int, format: WlShm.Format = .xrgb8888) {
        let stride = width * 4
        let size = stride * height
        let file = ShmBuffer.makeFile(size: size)
        let pool = try! shm.createPool(fd: file, size: Int32(size))
        self.buffer = try! pool.createBuffer(
            offset: 0, width: Int32(width), height: Int32(height),
            stride: Int32(stride), format: format
        )
        self.data = mmap(nil, size, PROT_READ | PROT_WRITE, MAP_SHARED, file.fileDescriptor, 0)!
        self.byteSize = size
        self.width = width
        self.height = height
    }

    deinit { munmap(data, byteSize) }

    private static func makeFile(size: Int) -> FileHandle {
        let name = "/swiftwayland-\(UUID().uuidString)"
        let fd = shm_open(name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR)
        if fd == -1 { fatalError("shm_open failed") }
        _ = shm_unlink(name)
        if ftruncate(fd, off_t(size)) == -1 { close(fd); fatalError("ftruncate failed") }
        return FileHandle(fileDescriptor: fd, closeOnDealloc: true)
    }
}
