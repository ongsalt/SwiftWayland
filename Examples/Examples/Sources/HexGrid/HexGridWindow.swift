import Foundation
import SwiftWayland
import WaylandProtocols

public final class HexGridWindow {
    public let connection: Connection

    private var compositor: WlCompositor?
    private var shm: WlShm?
    private var xdgWmBase: XdgWmBase?
    private var seat: WlSeat?
    private var pointer: WlPointer?
    private var gestureManager: ZwpPointerGesturesV1?
    private var pinchGesture: ZwpPointerGesturePinchV1?

    #if SSD
        private var decorationManager: KdeServerDecorationManager?
    #endif

    private var surface: WlSurface?
    private var xdgSurface: XdgSurface?
    private var toplevel: XdgToplevel?
    private var contentBuffer: ShmBuffer?

    private var width: Int { contentBuffer?.width ?? 640 }
    private var height: Int { contentBuffer?.height ?? 480 }
    private var pendingSize: (width: Int, height: Int) = (0, 0)

    // Pan offset: world coordinate that maps to screen centre
    private var panX: Double = 0
    private var panY: Double = 0

    private var pointerX: Double = 0
    private var pointerY: Double = 0
    private var isDragging = false
    private var lastPinchScale: Double = 1.0
    private var axisSource: WlPointer.AxisSource = .wheel
    private var zoomLevel: Double = 1.0

    private var needsRedraw = false
    private var frameCallbackPending = false

    // Title bar
    private let titleBarHeight = 36
    private var isMaximized = false

    // Resize
    private let resizeEdgeSize = 8
    private var currentEdge: XdgToplevel.ResizeEdge = .none

    // Grid
    private let hexSpacing: Double = 96
    private let iconRadius: Double = 36
    // Width of the edge fade zone in screen pixels (0→1 scale over this distance)
    private var edgeZone: Double {
        iconRadius * 1.8
    }

    private let palette: [UInt32] = [
        0xFFFF_5F57, 0xFFFF_BD2E, 0xFF28_C840, 0xFF7A_A2F7,
        0xFFBB_9AF7, 0xFF73_DACA, 0xFFE0_AF68, 0xFFF7_768E,
        0xFF9E_CE6A, 0xFF7D_CFFF, 0xFFFF_9E64, 0xFF89_DDFF,
    ]

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
        gestureManager = try? globals.bind(to: ZwpPointerGesturesV1.self, version: 3...3)
        #if SSD
            decorationManager = try? globals.bind(
                to: KdeServerDecorationManager.self, version: 1...1)
        #endif

        xdgWmBase!.onEvent = { [weak self] ev in
            if case .ping(let serial) = ev { try! self?.xdgWmBase?.pong(serial: serial) }
        }

        guard let compositor, let xdgWmBase, let shm, let seat else {
            fatalError("Missing required globals")
        }

        surface = try compositor.createSurface()
        try surface!.setOpaqueRegion(region: nil)  // tell compositor this surface has alpha
        xdgSurface = try xdgWmBase.getXdgSurface(surface: surface!)
        toplevel = try xdgSurface!.getToplevel()
        try toplevel!.setTitle("App Launcher")
        try toplevel!.setMinSize(width: 200, height: 200)

        #if SSD
            if let decorationManager {
                let deco = try decorationManager.create(surface: surface!)
                try deco.requestMode(mode: KdeServerDecorationManager.Mode.client.rawValue)
            }
        #endif

        toplevel!.onEvent = { [weak self] event in
            guard let self else { return }
            switch event {
            case .configure(let w, let h, let states):
                self.pendingSize = (w > 0 ? Int(w) : self.width, h > 0 ? Int(h) : self.height)
                self.isMaximized = states.withUnsafeBytes { buf in
                    stride(from: 0, to: states.count, by: 4).map {
                        buf.load(fromByteOffset: $0, as: UInt32.self)
                    }
                }.contains(XdgToplevel.State.maximized.rawValue)
            case .close: exit(0)
            default: break
            }
        }

        xdgSurface!.onEvent = { [weak self] event in
            guard let self else { return }
            if case .configure(let serial) = event {
                try! self.xdgSurface!.ackConfigure(serial: serial)
                let (w, h) = self.pendingSize
                if w > 0, h > 0, w != self.width || h != self.height {
                    self.contentBuffer = ShmBuffer(shm: shm, width: w, height: h, format: .argb8888)
                }
                self.frameCallbackPending = false
                self.presentFrame()
            }
        }

        setupPointer(seat: seat)
        contentBuffer = ShmBuffer(shm: shm, width: 640, height: 480)

        try surface!.commit()
        connection.roundtrip()
        connection.roundtrip()
    }

    // MARK: - Frame pacing

    private func presentFrame() {
        redraw()
        try! surface!.frame { [weak self] _ in
            guard let self else { return }
            self.frameCallbackPending = false
            if self.needsRedraw {
                self.needsRedraw = false
                self.presentFrame()
            }
        }
        try! surface!.attach(buffer: contentBuffer!.buffer, x: 0, y: 0)
        try! surface!.damage(x: 0, y: 0, width: Int32(width), height: Int32(height))
        try! surface!.commit()
        frameCallbackPending = true
    }

    private func setNeedsRedraw() {
        needsRedraw = true
        if !frameCallbackPending {
            needsRedraw = false
            presentFrame()
        }
    }

    // MARK: - Input

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
            case .motion(_, let x, let y):
                if self.isDragging {
                    self.panX -= (x - self.pointerX) / self.zoomLevel
                    self.panY -= (y - self.pointerY) / self.zoomLevel
                    self.setNeedsRedraw()
                } else {
                    let edge = self.resizeEdge(at: x, y: y)
                    if edge != self.currentEdge {
                        self.currentEdge = edge
                        self.setNeedsRedraw()
                    }
                }
                self.pointerX = x
                self.pointerY = y

            case .button(let serial, _, let button, let state):
                guard button == 272 else { break }
                if state == .pressed {
                    self.handlePress(x: self.pointerX, y: self.pointerY, serial: serial)
                } else {
                    self.isDragging = false
                }

            case .axisSource(let source):
                self.axisSource = source

            case .axis(_, let axis, let value):
                switch self.axisSource {
                case .finger, .continuous:
                    // Touchpad: pan
                    let speed = 3.0 / self.zoomLevel
                    if axis == .verticalScroll {
                        self.panY += value * speed
                    } else {
                        self.panX += value * speed
                    }
                case .wheel, .wheelTilt:
                    // Mouse wheel: zoom toward cursor
                    guard axis == .verticalScroll else { break }
                    let factor = pow(1.1, -value)
                    self.zoom(by: factor, aroundScreenX: self.pointerX, y: self.pointerY)
                }
                self.setNeedsRedraw()

            default: break
            }
        }

        if let gestureManager, let pointer {
            pinchGesture = try? gestureManager.getPinchGesture(pointer: pointer)
            pinchGesture?.onEvent = { [weak self] event in
                guard let self else { return }
                switch event {
                case .begin: self.lastPinchScale = 1.0
                case .update(_, let dx, let dy, let scale, _):
                    // Pan via finger translation
                    self.panX -= dx / self.zoomLevel
                    self.panY -= dy / self.zoomLevel
                    // Zoom via pinch spread
                    let delta = scale / self.lastPinchScale
                    self.lastPinchScale = scale
                    self.zoom(by: delta, aroundScreenX: self.pointerX, y: self.pointerY)
                    self.setNeedsRedraw()
                default: break
                }
            }
        }
    }

    // Zoom by `factor` keeping the screen point (cx, cy) fixed in world space
    private func zoom(by factor: Double, aroundScreenX cx: Double, y cy: Double) {
        let contentCX = Double(width) / 2
        let contentCY = Double(titleBarHeight) + Double(height - titleBarHeight) / 2
        // World point under the anchor before zoom
        let wx = (cx - contentCX) / zoomLevel + panX
        let wy = (cy - contentCY) / zoomLevel + panY
        zoomLevel = max(0.08, min(8, zoomLevel * factor))
        // Adjust pan so that world point stays under anchor after zoom
        panX = wx - (cx - contentCX) / zoomLevel
        panY = wy - (cy - contentCY) / zoomLevel
    }

    private func resizeEdge(at x: Double, y: Double) -> XdgToplevel.ResizeEdge {
        guard !isMaximized else { return .none }
        let e = Double(resizeEdgeSize)
        let l = x < e
        let r = x > Double(width) - e
        let t = y < e
        let b = y > Double(height) - e
        switch (t, b, l, r) {
        case (true, false, true, false): return .topLeft
        case (true, false, false, true): return .topRight
        case (false, true, true, false): return .bottomLeft
        case (false, true, false, true): return .bottomRight
        case (true, false, false, false): return .top
        case (false, true, false, false): return .bottom
        case (false, false, true, false): return .left
        case (false, false, false, true): return .right
        default: return .none
        }
    }

    private func handlePress(x: Double, y: Double, serial: UInt32) {
        let edge = resizeEdge(at: x, y: y)
        if edge != .none {
            try! toplevel!.resize(seat: seat!, serial: serial, edges: edge)
            return
        }
        if y < Double(titleBarHeight) {
            let bx = Double(width)
            let by = Double(titleBarHeight) / 2
            if (x - (bx - 20)) * (x - (bx - 20)) + (y - by) * (y - by) <= 64 { exit(0) }
            if (x - (bx - 48)) * (x - (bx - 48)) + (y - by) * (y - by) <= 64 {
                isMaximized ? try! toplevel!.unsetMaximized() : try! toplevel!.setMaximized()
                return
            }
            try! toplevel!.move(seat: seat!, serial: serial)
        } else {
            isDragging = true
        }
    }

    // MARK: - Scale

    // Returns the draw scale for an icon whose centre is at (sx, sy) on screen.
    // Scale = 1 everywhere except within `edgeZone` pixels of any screen edge
    // (title bar counts as the top edge), where it tapers linearly 1 → 0.
    private func edgeScale(sx: Double, sy: Double) -> Double {
        let w = Double(width)
        let h = Double(height)
        let tb = Double(titleBarHeight)
        let fx = min(sx, w - sx) / (edgeZone * zoomLevel)
        let fy = min(sy - tb, h - sy) / (edgeZone * zoomLevel)
        return max(0, min(1, min(fx, fy)))
    }

    // MARK: - Rendering

    private func redraw() {
        guard let data = contentBuffer?.data else { return }
        var ctx = PixelContext(buffer: data, width: width, height: height)
        ctx.fill(color: 0xC01A_1B26)
        drawHexGrid(ctx: &ctx)
        drawTitleBar(ctx: &ctx)
        if currentEdge != .none { drawEdgeHighlight(ctx: &ctx, edge: currentEdge) }
    }

    private func drawEdgeHighlight(ctx: inout PixelContext, edge: XdgToplevel.ResizeEdge) {
        let c: UInt32 = 0xFF6C_7DC4
        let t = 2
        let w = width
        let h = height
        switch edge {
        case .top: ctx.fillRect(x: 0, y: 0, w: w, h: t, color: c)
        case .bottom: ctx.fillRect(x: 0, y: h - t, w: w, h: t, color: c)
        case .left: ctx.fillRect(x: 0, y: 0, w: t, h: h, color: c)
        case .right: ctx.fillRect(x: w - t, y: 0, w: t, h: h, color: c)
        case .topLeft:
            ctx.fillRect(x: 0, y: 0, w: w, h: t, color: c)
            ctx.fillRect(x: 0, y: 0, w: t, h: h, color: c)
        case .topRight:
            ctx.fillRect(x: 0, y: 0, w: w, h: t, color: c)
            ctx.fillRect(x: w - t, y: 0, w: t, h: h, color: c)
        case .bottomLeft:
            ctx.fillRect(x: 0, y: h - t, w: w, h: t, color: c)
            ctx.fillRect(x: 0, y: 0, w: t, h: h, color: c)
        case .bottomRight:
            ctx.fillRect(x: 0, y: h - t, w: w, h: t, color: c)
            ctx.fillRect(x: w - t, y: 0, w: t, h: h, color: c)
        default: break
        }
    }

    // Avalanche hash: deterministic per (row, col), looks random
    private func cellHash(row: Int, col: Int) -> UInt32 {
        var h = UInt32(bitPattern: Int32(truncatingIfNeeded: row)) &* 2_654_435_761
        h ^= UInt32(bitPattern: Int32(truncatingIfNeeded: col)) &* 2_246_822_519
        h ^= h >> 16
        h &*= 0x45d9f3b
        h ^= h >> 16
        return h
    }

    private func drawTitleBar(ctx: inout PixelContext) {
        ctx.fillRect(x: 0, y: 0, w: width, h: titleBarHeight, color: 0xFF24_283A)
        ctx.fillRect(x: 0, y: titleBarHeight - 1, w: width, h: 1, color: 0xFF41_4868)
        ctx.fillCircle(cx: width - 20, cy: titleBarHeight / 2, r: 7, color: 0xFFFF_5F57)
        ctx.fillCircle(
            cx: width - 48, cy: titleBarHeight / 2, r: 7,
            color: isMaximized ? 0xFFFF_BD2E : 0xFF28_C840)
    }

    private func drawHexGrid(ctx: inout PixelContext) {
        let hexH = hexSpacing * sqrt(3) / 2
        let cx = Double(width) / 2
        let cy = Double(titleBarHeight) + Double(height - titleBarHeight) / 2

        // World bounds visible on screen, accounting for zoom
        let margin = hexSpacing * 2
        let screenHalfW = cx / zoomLevel + margin
        let screenHalfH = (Double(height) - Double(titleBarHeight)) / 2 / zoomLevel + margin
        let wx0 = panX - screenHalfW
        let wx1 = panX + screenHalfW
        let wy0 = panY - screenHalfH
        let wy1 = panY + screenHalfH

        let rowMin = Int(floor(wy0 / hexH)) - 1
        let rowMax = Int(ceil(wy1 / hexH)) + 1

        struct Icon {
            let sx, sy, scale: Double
            let color: UInt32
        }
        var icons: [Icon] = []

        for row in rowMin...rowMax {
            let wy = Double(row) * hexH
            let offsetX = row.isMultiple(of: 2) ? 0.0 : hexSpacing / 2

            let colMin = Int(floor((wx0 - offsetX) / hexSpacing)) - 1
            let colMax = Int(ceil((wx1 - offsetX) / hexSpacing)) + 1

            for col in colMin...colMax {
                let wx = Double(col) * hexSpacing + offsetX

                // World → screen (linear pan + zoom)
                let sx = (wx - panX) * zoomLevel + cx
                let sy = (wy - panY) * zoomLevel + cy

                let scale = edgeScale(sx: sx, sy: sy)
                guard scale > 0 else { continue }

                let color = palette[Int(cellHash(row: row, col: col)) % palette.count]
                icons.append(Icon(sx: sx, sy: sy, scale: scale, color: color))
            }
        }

        // Draw edge icons (smaller) first so centre icons render on top
        icons.sort { $0.scale < $1.scale }

        for icon in icons {
            let r = max(1, Int(iconRadius * zoomLevel * icon.scale))
            ctx.fillCircle(cx: Int(icon.sx), cy: Int(icon.sy), r: r, color: icon.color)
        }
    }
}
