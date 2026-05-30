import Foundation

struct PixelContext {
    let pixels: UnsafeMutablePointer<UInt32>
    let width: Int
    let height: Int

    init(buffer: UnsafeMutableRawPointer, width: Int, height: Int) {
        self.pixels = buffer.bindMemory(to: UInt32.self, capacity: width * height)
        self.width = width
        self.height = height
    }

    func fill(color: UInt32) {
        for i in 0..<(width * height) {
            pixels[i] = color
        }
    }

    func fillRect(x: Int, y: Int, w: Int, h: Int, color: UInt32) {
        let x0 = max(x, 0), y0 = max(y, 0)
        let x1 = min(x + w, width), y1 = min(y + h, height)
        for py in y0..<y1 {
            for px in x0..<x1 {
                pixels[py * width + px] = color
            }
        }
    }

    func fillCircle(cx: Int, cy: Int, r: Int, color: UInt32) {
        let r2 = r * r
        for py in (cy - r)..<(cy + r) {
            for px in (cx - r)..<(cx + r) {
                let dx = px - cx, dy = py - cy
                if dx * dx + dy * dy <= r2 {
                    setPixel(px, py, color)
                }
            }
        }
    }

    func fillRoundRect(x: Int, y: Int, w: Int, h: Int, r: Int, color: UInt32) {
        fillRect(x: x + r, y: y, w: w - 2 * r, h: h, color: color)
        fillRect(x: x, y: y + r, w: r, h: h - 2 * r, color: color)
        fillRect(x: x + w - r, y: y + r, w: r, h: h - 2 * r, color: color)
        fillCircle(cx: x + r, cy: y + r, r: r, color: color)
        fillCircle(cx: x + w - r, cy: y + r, r: r, color: color)
        fillCircle(cx: x + r, cy: y + h - r, r: r, color: color)
        fillCircle(cx: x + w - r, cy: y + h - r, r: r, color: color)
    }

    @inline(__always)
    private func setPixel(_ x: Int, _ y: Int, _ color: UInt32) {
        guard x >= 0, y >= 0, x < width, y < height else { return }
        pixels[y * width + x] = color
    }
}
