import Foundation
import WaylandClient
import WaylandClientProtocols

public final class Window {
    public let connection: Connection

    private var compositor: WlCompositor?
    private var shm: WlShm?
    private var xdgWmBase: XdgWmBase?
    // private var decorationManager: KdeServerDecorationManager?

    private var surface: WlSurface?
    private var xdgSurface: XdgSurface?
    private var toplevel: XdgToplevel?
    // private var decoration: KdeServerDecoration?

    private var shmPool: WlShmPool?
    private var buffer: WlBuffer?
    private var bufferData: UnsafeMutableRawPointer?
    private var bufferSize: Int = 0
    private var bufferWidth: Int = 0
    private var bufferHeight: Int = 0

    public init(connection: Connection) {
        self.connection = connection
    }

    func start() throws {
        let globals = try Globals(connection: connection)
        connection.roundtrip()

        compositor = try globals.bind(to: WlCompositor.self, version: 6...6)
        shm = try globals.bind(to: WlShm.self, version: 1...2)
        xdgWmBase = try globals.bind(to: XdgWmBase.self, version: 6...7)
        xdgWmBase!.onEvent = { [weak self] ev in
            guard let self else { return }
            if case .ping(let serial) = ev {
                try! self.xdgWmBase?.pong(serial: serial)
            }
        }

        // decorationManager = try? globals.bind(to: KdeServerDecorationManager.self, version: 1...1)

        guard let compositor, let xdgWmBase, let shm else {
            fatalError("Missing required globals")
        }

        surface = try compositor.createSurface()
        xdgSurface = try xdgWmBase.getXdgSurface(surface: surface!)
        toplevel = try xdgSurface!.getToplevel()
        try toplevel!.setTitle("SwiftWayland")

        // if let decorationManager {
        //     decoration = try decorationManager.create(surface: surface!)
        //     try decoration!.requestMode(mode: KdeServerDecorationManager.Mode.server.rawValue)
        // }
 
        let initialWidth = 480
        let initialHeight = 320
        let bufferInfo = makeShmBuffer(shm: shm, width: initialWidth, height: initialHeight)
        shmPool = bufferInfo.pool
        buffer = bufferInfo.buffer
        bufferData = bufferInfo.data
        bufferSize = bufferInfo.size
        bufferWidth = initialWidth
        bufferHeight = initialHeight

        xdgSurface!.onEvent = { [weak self] event in
            guard let self else { return }
            if case .configure(let serial) = event {
                try! self.xdgSurface!.ackConfigure(serial: serial)
                try! self.surface!.attach(buffer: self.buffer!, x: 0, y: 0)
                try! self.surface!.damage(
                    x: 0, y: 0, width: Int32(self.bufferWidth), height: Int32(self.bufferHeight)
                )
                try! self.surface!.commit()
            }
        }

        try surface!.commit()
        connection.roundtrip()
        connection.roundtrip()
    }

    private func makeShmBuffer(shm: WlShm, width: Int, height: Int) -> (
        buffer: WlBuffer, pool: WlShmPool, data: UnsafeMutableRawPointer, size: Int
    ) {
        let stride = width * 4
        let size = stride * height

        let file = createShmFile(size: size)
        let pool = try! shm.createPool(fd: file, size: Int32(size))
        let buffer = try! pool.createBuffer(
            offset: 0,
            width: Int32(width),
            height: Int32(height),
            stride: Int32(stride),
            format: .xrgb8888
        )

        let data = mmap(nil, size, PROT_READ | PROT_WRITE, MAP_SHARED, file.fileDescriptor, 0)!
        fillGradient(buffer: data, width: width, height: height)
        return (buffer, pool, data, size)
    }

    private func createShmFile(size: Int) -> FileHandle {
        let name = "/swiftwayland-\(UUID().uuidString)"
        let fd = shm_open(name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR)
        if fd == -1 { fatalError("shm_open failed") }
        _ = shm_unlink(name)
        if ftruncate(fd, off_t(size)) == -1 {
            close(fd)
            fatalError("ftruncate failed")
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
