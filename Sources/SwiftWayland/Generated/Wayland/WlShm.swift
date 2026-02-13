import Foundation

public final class WlShm: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_shm"
    public var onEvent: (Event) -> Void = { _ in }

    public func createPool(fd: FileHandle, size: Int32) throws(WaylandProxyError) -> WlShmPool {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        let id = connection.createProxy(type: WlShmPool.self, version: self.version)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            WaylandData.newId(id.id),
            WaylandData.fd(fd),
            WaylandData.int(size)
        ])
        connection.send(message: message)
        return id
    }
    
    public consuming func release() throws(WaylandProxyError) {
        guard self._state == WaylandProxyState.alive else { throw WaylandProxyError.destroyed }
        guard self.version >= 2 else { throw WaylandProxyError.unsupportedVersion(current: self.version, required: 2) }
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.send(message: message)
        self._state = .dropped
        connection.removeObject(id: self.id)
    }
    
    deinit {
        try! self.release()
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidFormat = 0
        case invalidStride = 1
        case invalidFd = 2
    }
    
    public enum Format: UInt32, WlEnum {
        case argb8888 = 0
        case xrgb8888 = 1
        case c8 = 0x20203843
        case rgb332 = 0x38424752
        case bgr233 = 0x38524742
        case xrgb4444 = 0x32315258
        case xbgr4444 = 0x32314258
        case rgbx4444 = 0x32315852
        case bgrx4444 = 0x32315842
        case argb4444 = 0x32315241
        case abgr4444 = 0x32314241
        case rgba4444 = 0x32314152
        case bgra4444 = 0x32314142
        case xrgb1555 = 0x35315258
        case xbgr1555 = 0x35314258
        case rgbx5551 = 0x35315852
        case bgrx5551 = 0x35315842
        case argb1555 = 0x35315241
        case abgr1555 = 0x35314241
        case rgba5551 = 0x35314152
        case bgra5551 = 0x35314142
        case rgb565 = 0x36314752
        case bgr565 = 0x36314742
        case rgb888 = 0x34324752
        case bgr888 = 0x34324742
        case xbgr8888 = 0x34324258
        case rgbx8888 = 0x34325852
        case bgrx8888 = 0x34325842
        case abgr8888 = 0x34324241
        case rgba8888 = 0x34324152
        case bgra8888 = 0x34324142
        case xrgb2101010 = 0x30335258
        case xbgr2101010 = 0x30334258
        case rgbx1010102 = 0x30335852
        case bgrx1010102 = 0x30335842
        case argb2101010 = 0x30335241
        case abgr2101010 = 0x30334241
        case rgba1010102 = 0x30334152
        case bgra1010102 = 0x30334142
        case yuyv = 0x56595559
        case yvyu = 0x55595659
        case uyvy = 0x59565955
        case vyuy = 0x59555956
        case ayuv = 0x56555941
        case nv12 = 0x3231564e
        case nv21 = 0x3132564e
        case nv16 = 0x3631564e
        case nv61 = 0x3136564e
        case yuv410 = 0x39565559
        case yvu410 = 0x39555659
        case yuv411 = 0x31315559
        case yvu411 = 0x31315659
        case yuv420 = 0x32315559
        case yvu420 = 0x32315659
        case yuv422 = 0x36315559
        case yvu422 = 0x36315659
        case yuv444 = 0x34325559
        case yvu444 = 0x34325659
        case r8 = 0x20203852
        case r16 = 0x20363152
        case rg88 = 0x38384752
        case gr88 = 0x38385247
        case rg1616 = 0x32334752
        case gr1616 = 0x32335247
        case xrgb16161616f = 0x48345258
        case xbgr16161616f = 0x48344258
        case argb16161616f = 0x48345241
        case abgr16161616f = 0x48344241
        case xyuv8888 = 0x56555958
        case vuy888 = 0x34325556
        case vuy101010 = 0x30335556
        case y210 = 0x30313259
        case y212 = 0x32313259
        case y216 = 0x36313259
        case y410 = 0x30313459
        case y412 = 0x32313459
        case y416 = 0x36313459
        case xvyu2101010 = 0x30335658
        case xvyu1216161616 = 0x36335658
        case xvyu16161616 = 0x38345658
        case y0l0 = 0x304c3059
        case x0l0 = 0x304c3058
        case y0l2 = 0x324c3059
        case x0l2 = 0x324c3058
        case yuv4208Bit = 0x38305559
        case yuv42010Bit = 0x30315559
        case xrgb8888A8 = 0x38415258
        case xbgr8888A8 = 0x38414258
        case rgbx8888A8 = 0x38415852
        case bgrx8888A8 = 0x38415842
        case rgb888A8 = 0x38413852
        case bgr888A8 = 0x38413842
        case rgb565A8 = 0x38413552
        case bgr565A8 = 0x38413542
        case nv24 = 0x3432564e
        case nv42 = 0x3234564e
        case p210 = 0x30313250
        case p010 = 0x30313050
        case p012 = 0x32313050
        case p016 = 0x36313050
        case axbxgxrx106106106106 = 0x30314241
        case nv15 = 0x3531564e
        case q410 = 0x30313451
        case q401 = 0x31303451
        case xrgb16161616 = 0x38345258
        case xbgr16161616 = 0x38344258
        case argb16161616 = 0x38345241
        case abgr16161616 = 0x38344241
        case c1 = 0x20203143
        case c2 = 0x20203243
        case c4 = 0x20203443
        case d1 = 0x20203144
        case d2 = 0x20203244
        case d4 = 0x20203444
        case d8 = 0x20203844
        case r1 = 0x20203152
        case r2 = 0x20203252
        case r4 = 0x20203452
        case r10 = 0x20303152
        case r12 = 0x20323152
        case avuy8888 = 0x59555641
        case xvuy8888 = 0x59555658
        case p030 = 0x30333050
    }
    
    public enum Event: WlEventEnum {
        case format(format: UInt32)
    
        public static func decode(message: Message, connection: Connection, fdSource: BufferedSocket, version: UInt32) -> Self {
            var r = ArgumentParser(data: message.arguments, fdSource: fdSource)
            switch message.opcode {
            case 0:
                return Self.format(format: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
