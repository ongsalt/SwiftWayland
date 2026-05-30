import Foundation
import SwiftWayland
import WaylandProtocols

public final class DrawingWindow {
    public let connection: Connection

    private var compositor: WlCompositor?
    private var shm: WlShm?
    private var xdgWmBase: XdgWmBase?
    private var seat: WlSeat?
    private var pointer: WlPointer?
    #if WP
    private var gestureManager: ZwpPointerGesturesV1?
    private var pinchGesture: ZwpPointerGesturePinchV1?
    #endif
    #if KDE
    private var decorationManager: KdeServerDecorationManager?
    #endif

    private var surface: WlSurface?
    private var xdgSurface: XdgSurface?
    private var toplevel: XdgToplevel?

    private var shmPool: WlShmPool?
    private var buffer: WlBuffer?
    private var bufferData: UnsafeMutableRawPointer?
    private var bufferSize: Int = 0
    private let bufferWidth = 640
    private let bufferHeight = 480

    // Viewport state (scene units)
    private var viewOffsetX: Double = 0
    private var viewOffsetY: Double = 0
    private var viewScale: Double = 1.0

    private var needsRedraw = false

    public init(connection: Connection) {
        self.connection = connection
    }

    func start() throws {
        let globals = try Globals(connection: connection)
        connection.roundtrip()

        compositor = try globals.bind(to: WlCompositor.self, version: 6...6)
        shm = try globals.bind(to: WlShm.self, version: 1...2)
        xdgWmBase = try globals.bind(to: XdgWmBase.self, version: 6...7)
        seat = try globals.bind(to: WlSeat.self, version: 7...9)

        #if WP
        gestureManager = try? globals.bind(to: ZwpPointerGesturesV1.self, version: 3...3)
        #endif
        #if KDE
        decorationManager = try? globals.bind(to: KdeServerDecorationManager.self, version: 1...1)
        #endif

        xdgWmBase!.onEvent = { [weak self] ev in
            if case .ping(let serial) = ev {
                try! self?.xdgWmBase?.pong(serial: serial)
            }
        }

        guard let compositor, let xdgWmBase, let shm, let seat else {
            fatalError("Missing required globals")
        }

        surface = try compositor.createSurface()
        xdgSurface = try xdgWmBase.getXdgSurface(surface: surface!)
        toplevel = try xdgSurface!.getToplevel()
        try toplevel!.setTitle("SwiftWayland Drawing")

        #if KDE
        if let decorationManager {
            let decoration = try decorationManager.create(surface: surface!)
            try decoration.requestMode(mode: KdeServerDecorationManager.Mode.server.rawValue)
        }
        #endif

        setupPointer(seat: seat)

        let stride = bufferWidth * 4
        let size = stride * bufferHeight
        let file = createShmFile(size: size)
        shmPool = try! shm.createPool(fd: file, size: Int32(size))
        buffer = try! shmPool!.createBuffer(
            offset: 0, width: Int32(bufferWidth), height: Int32(bufferHeight),
            stride: Int32(stride), format: .xrgb8888
        )
        bufferData = mmap(nil, size, PROT_READ | PROT_WRITE, MAP_SHARED, file.fileDescriptor, 0)!
        bufferSize = size

        xdgSurface!.onEvent = { [weak self] event in
            guard let self else { return }
            if case .configure(let serial) = event {
                try! self.xdgSurface!.ackConfigure(serial: serial)
                self.redraw()
                try! self.surface!.attach(buffer: self.buffer!, x: 0, y: 0)
                try! self.surface!.damage(x: 0, y: 0, width: Int32(self.bufferWidth), height: Int32(self.bufferHeight))
                try! self.surface!.commit()
            }
        }

        try surface!.commit()
        connection.roundtrip()
        connection.roundtrip()
    }

    func commitIfNeeded() throws {
        guard needsRedraw else { return }
        needsRedraw = false
        redraw()
        try surface!.attach(buffer: buffer!, x: 0, y: 0)
        try surface!.damage(x: 0, y: 0, width: Int32(bufferWidth), height: Int32(bufferHeight))
        try surface!.commit()
    }

    private func setupPointer(seat: WlSeat) {
        seat.onEvent = { [weak self] event in
            guard let self else { return }
            if case .capabilities(let caps) = event, caps.contains(.pointer) {
                self.pointer = try! seat.getPointer()
                self.setupPointerEvents()
            }
        }
    }

    private func setupPointerEvents() {
        pointer!.onEvent = { [weak self] event in
            guard let self else { return }
            switch event {
            case .axis(_, let axis, let value):
                if axis == .verticalScroll {
                    self.viewOffsetY += value
                } else {
                    self.viewOffsetX += value
                }
                self.needsRedraw = true
            default:
                break
            }
        }

        #if WP
        if let gestureManager, let pointer {
            pinchGesture = try? gestureManager.getPinchGesture(pointer: pointer)
            pinchGesture?.onEvent = { [weak self] event in
                guard let self else { return }
                if case .update(_, _, _, let scale, _) = event {
                    let cx = Double(self.bufferWidth) / 2
                    let cy = Double(self.bufferHeight) / 2
                    // zoom toward center
                    self.viewOffsetX = cx - (cx - self.viewOffsetX) * scale
                    self.viewOffsetY = cy - (cy - self.viewOffsetY) * scale
                    self.viewScale *= scale
                    self.needsRedraw = true
                }
            }
        }
        #endif
    }

    private func redraw() {
        guard let bufferData else { return }
        var ctx = PixelContext(buffer: bufferData, width: bufferWidth, height: bufferHeight)

        // Background
        ctx.fill(color: 0xFF1A1B26)

        // Grid lines to make panning visible
        drawGrid(ctx: &ctx)

        // A large rect in scene space, transformed by the viewport
        let rectSceneX: Double = 100, rectSceneY: Double = 100
        let rectSceneW: Double = 300, rectSceneH: Double = 200

        let sx = Int(rectSceneX * viewScale - viewOffsetX)
        let sy = Int(rectSceneY * viewScale - viewOffsetY)
        let sw = Int(rectSceneW * viewScale)
        let sh = Int(rectSceneH * viewScale)

        ctx.fillRoundRect(x: sx, y: sy, w: sw, h: sh, r: max(1, Int(12 * viewScale)), color: 0xFF7AA2F7)

        // Inner highlight
        ctx.fillRoundRect(
            x: sx + Int(16 * viewScale), y: sy + Int(16 * viewScale),
            w: sw - Int(32 * viewScale), h: Int(8 * viewScale),
            r: max(1, Int(4 * viewScale)), color: 0xFFBBD0FF
        )
    }

    private func drawGrid(ctx: inout PixelContext) {
        let spacing = Int(64 * viewScale)
        guard spacing > 4 else { return }

        let ox = Int(viewOffsetX) % spacing
        let oy = Int(viewOffsetY) % spacing

        var x = -ox
        while x < bufferWidth {
            ctx.fillRect(x: x, y: 0, w: 1, h: bufferHeight, color: 0xFF2A2B3D)
            x += spacing
        }
        var y = -oy
        while y < bufferHeight {
            ctx.fillRect(x: 0, y: y, w: bufferWidth, h: 1, color: 0xFF2A2B3D)
            y += spacing
        }
    }

    private func createShmFile(size: Int) -> FileHandle {
        let name = "/swiftwayland-drawing-\(UUID().uuidString)"
        let fd = shm_open(name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR)
        if fd == -1 { fatalError("shm_open failed") }
        _ = shm_unlink(name)
        if ftruncate(fd, off_t(size)) == -1 {
            close(fd)
            fatalError("ftruncate failed")
        }
        return FileHandle(fileDescriptor: fd, closeOnDealloc: true)
    }
}
