import Foundation
import SwiftWayland
import WaylandProtocols

// copilot wrote most of this
public final class Window {
    public let connection: Connection

    private var compositor: WlCompositor?
    private var shm: WlShm?
    private var xdgWmBase: XdgWmBase?

    private var surface: WlSurface?
    private var xdgSurface: XdgSurface?
    private var toplevel: XdgToplevel?

    private var shmPool: WlShmPool?
    private var buffer: WlBuffer?
    private var bufferData: UnsafeMutableRawPointer?
    private var bufferSize: Int = 0
    private var bufferWidth: Int = 0
    private var bufferHeight: Int = 0

    private var file: FileHandle?

    deinit {
        if let bufferData = bufferData, bufferSize > 0 {
            munmap(bufferData, bufferSize)
        }
        try? file?.close()

        try? buffer?.destroy()
        try? shmPool?.destroy()
        try? toplevel?.destroy()
        try? xdgSurface?.destroy()
        try? surface?.destroy()
        try? xdgWmBase?.destroy()
        try? shm?.release()

    }

    public init(connection: Connection) {
        self.connection = connection
    }

    func start() async throws {

        let display = connection.display
        let registry = try display.getRegistry()

        registry.onEvent = { [weak self] event in
            guard let self else { return }
            // print(event)
            switch event {
            case .global(let name, let interface, let version):
                switch interface {
                case WlCompositor.name:
                    self.compositor = registry.bind(
                        name: name, version: version, interface: WlCompositor.self)
                case WlShm.name:
                    self.shm = registry.bind(
                        name: name, version: version, interface: WlShm.self)
                case XdgWmBase.name:
                    self.xdgWmBase = registry.bind(
                        name: name, version: version, interface: XdgWmBase.self)
                    self.xdgWmBase?.onEvent = { [weak self] ev in
                        guard let self else { return }
                        if case .ping(let serial) = ev {
                            try! self.xdgWmBase?.pong(serial: serial)
                        }
                    }
                default:
                    break
                }
            default: break
            }
        }

        try await connection.roundtrip()

        guard
            let compositor = compositor,
            let xdgWmBase = xdgWmBase,
            let shm = shm
        else {
            fatalError("Missing required globals")
        }
        let surface = try! compositor.createSurface()
        let xdgSurface = try! xdgWmBase.getXdgSurface(surface: surface)
        let toplevel = try! xdgSurface.getToplevel()
        try! toplevel.setTitle(title: "SwiftWayland")

        self.surface = surface
        self.xdgSurface = xdgSurface
        self.toplevel = toplevel

        let initialWidth = 480
        let initialHeight = 320
        let bufferInfo = try! makeShmBuffer(shm: shm, width: initialWidth, height: initialHeight)
        shmPool = bufferInfo.pool
        buffer = bufferInfo.buffer
        bufferData = bufferInfo.data
        bufferSize = bufferInfo.size
        bufferWidth = initialWidth
        bufferHeight = initialHeight

        xdgSurface.onEvent = { [weak self] event in
            guard let self else { return }
            if case .configure(let serial) = event {
                try! xdgSurface.ackConfigure(serial: serial)
                try! surface.attach(buffer: self.buffer!, x: 0, y: 0)
                try! surface.damage(
                    x: 0, y: 0, width: Int32(self.bufferWidth), height: Int32(self.bufferHeight)
                )
                try! surface.commit()

            }
        }

        try surface.commit()

        print(connection.proxiesList)
        try await connection.roundtrip()
    }

    private func makeShmBuffer(shm: WlShm, width: Int, height: Int) throws -> (
        buffer: WlBuffer, pool: WlShmPool, data: UnsafeMutableRawPointer, size: Int
    ) {
        let stride = width * 4
        let size = stride * height

        let file: FileHandle = try! createShmFile(size: size)
        // self.file = file
        let pool = try! shm.createPool(fd: file, size: Int32(size))
        let buffer = try! pool.createBuffer(
            offset: 0,
            width: Int32(width),
            height: Int32(height),
            stride: Int32(stride),
            format: WlShm.Format.xrgb8888.rawValue
        )

        let data = mmap(nil, size, PROT_READ | PROT_WRITE, MAP_SHARED, file.fileDescriptor, 0)
        if data == MAP_FAILED {
            throw NSError(
                domain: "SwiftWayland", code: Int(errno),
                userInfo: [
                    NSLocalizedDescriptionKey: "mmap failed"
                ])
        }

        fillGradient(buffer: data!, width: width, height: height)
        return (buffer, pool, data!, size)
    }

    private func createShmFile(size: Int) throws -> FileHandle {
        let name = "/swiftwayland-\(UUID().uuidString)"
        let fd = shm_open(name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR)
        if fd == -1 {
            throw NSError(
                domain: "SwiftWayland", code: Int(errno),
                userInfo: [
                    NSLocalizedDescriptionKey: "shm_open failed"
                ])
        }
        _ = shm_unlink(name)
        if ftruncate(fd, off_t(size)) == -1 {
            close(fd)
            throw NSError(
                domain: "SwiftWayland", code: Int(errno),
                userInfo: [
                    NSLocalizedDescriptionKey: "ftruncate failed"
                ])
        }

        return FileHandle(fileDescriptor: fd, closeOnDealloc: true)
    }

    private func fillGradient(buffer: UnsafeMutableRawPointer, width: Int, height: Int) {
        let pixels = buffer.bindMemory(to: UInt32.self, capacity: width * height)
        let w = max(width - 1, 1)
        let h = max(height - 1, 1)
        for y in 0..<height {
            for x in 0..<width {
                let r = UInt32((x * 255) / w)
                let g = UInt32((y * 255) / h)
                let b = UInt32(64)
                pixels[y * width + x] = 0xFF00_0000 | (r << 16) | (g << 8) | b
            }
        }
    }
}
