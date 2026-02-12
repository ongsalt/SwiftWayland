public final class WlShm: WlProxyBase, WlProxy {
    public var onEvent: (Event) -> Void = { _ in }

    public func createPool(fd: FileHandle, size: Int32) -> WlShmPool {
        let id = connection.createProxy(type: WlShmPool.self)
        let message = Message(objectId: self.id, opcode: 0, contents: [
            .newId(id.id),
            .fd(fd),
            .int(size)
        ])
        connection.queueSend(message: message)
        return id
    }
    
    public func release() {
        let message = Message(objectId: self.id, opcode: 1, contents: [])
        connection.queueSend(message: message)
    }
    
    public enum Error: UInt32, WlEnum {
        case invalidFormat = 0
        case invalidStride = 1
        case invalidFd = 2
    }
    
    public enum Format: UInt32, WlEnum {
        case argb8888 = 0
        case xrgb8888 = 1
        case c8 = 538982467
        case rgb332 = 943867730
        case bgr233 = 944916290
        case xrgb4444 = 842093144
        case xbgr4444 = 842089048
        case rgbx4444 = 842094674
        case bgrx4444 = 842094658
        case argb4444 = 842093121
        case abgr4444 = 842089025
        case rgba4444 = 842088786
        case bgra4444 = 842088770
        case xrgb1555 = 892424792
        case xbgr1555 = 892420696
        case rgbx5551 = 892426322
        case bgrx5551 = 892426306
        case argb1555 = 892424769
        case abgr1555 = 892420673
        case rgba5551 = 892420434
        case bgra5551 = 892420418
        case rgb565 = 909199186
        case bgr565 = 909199170
        case rgb888 = 875710290
        case bgr888 = 875710274
        case xbgr8888 = 875709016
        case rgbx8888 = 875714642
        case bgrx8888 = 875714626
        case abgr8888 = 875708993
        case rgba8888 = 875708754
        case bgra8888 = 875708738
        case xrgb2101010 = 808669784
        case xbgr2101010 = 808665688
        case rgbx1010102 = 808671314
        case bgrx1010102 = 808671298
        case argb2101010 = 808669761
        case abgr2101010 = 808665665
        case rgba1010102 = 808665426
        case bgra1010102 = 808665410
        case yuyv = 1448695129
        case yvyu = 1431918169
        case uyvy = 1498831189
        case vyuy = 1498765654
        case ayuv = 1448433985
        case nv12 = 842094158
        case nv21 = 825382478
        case nv16 = 909203022
        case nv61 = 825644622
        case yuv410 = 961959257
        case yvu410 = 961893977
        case yuv411 = 825316697
        case yvu411 = 825316953
        case yuv420 = 842093913
        case yvu420 = 842094169
        case yuv422 = 909202777
        case yvu422 = 909203033
        case yuv444 = 875713881
        case yvu444 = 875714137
        case r8 = 538982482
        case r16 = 540422482
        case rg88 = 943212370
        case gr88 = 943215175
        case rg1616 = 842221394
        case gr1616 = 842224199
        case xrgb16161616f = 1211388504
        case xbgr16161616f = 1211384408
        case argb16161616f = 1211388481
        case abgr16161616f = 1211384385
        case xyuv8888 = 1448434008
        case vuy888 = 875713878
        case vuy101010 = 808670550
        case y210 = 808530521
        case y212 = 842084953
        case y216 = 909193817
        case y410 = 808531033
        case y412 = 842085465
        case y416 = 909194329
        case xvyu2101010 = 808670808
        case xvyu1216161616 = 909334104
        case xvyu16161616 = 942954072
        case y0l0 = 810299481
        case x0l0 = 810299480
        case y0l2 = 843853913
        case x0l2 = 843853912
        case yuv4208Bit = 942691673
        case yuv42010Bit = 808539481
        case xrgb8888A8 = 943805016
        case xbgr8888A8 = 943800920
        case rgbx8888A8 = 943806546
        case bgrx8888A8 = 943806530
        case rgb888A8 = 943798354
        case bgr888A8 = 943798338
        case rgb565A8 = 943797586
        case bgr565A8 = 943797570
        case nv24 = 875714126
        case nv42 = 842290766
        case p210 = 808530512
        case p010 = 808530000
        case p012 = 842084432
        case p016 = 909193296
        case axbxgxrx106106106106 = 808534593
        case nv15 = 892425806
        case q410 = 808531025
        case q401 = 825242705
        case xrgb16161616 = 942953048
        case xbgr16161616 = 942948952
        case argb16161616 = 942953025
        case abgr16161616 = 942948929
        case c1 = 538980675
        case c2 = 538980931
        case c4 = 538981443
        case d1 = 538980676
        case d2 = 538980932
        case d4 = 538981444
        case d8 = 538982468
        case r1 = 538980690
        case r2 = 538980946
        case r4 = 538981458
        case r10 = 540029266
        case r12 = 540160338
        case avuy8888 = 1498764865
        case xvuy8888 = 1498764888
        case p030 = 808661072
    }
    
    public enum Event: WlEventEnum {
        case format(format: UInt32)
    
        public static func decode(message: Message, connection: Connection) -> Self {
            let r = WLReader(data: message.arguments)
            switch message.opcode {
            case 0:
                return Self.format(format: r.readUInt())
            default:
                fatalError("Unknown message")
            }
        }
    }
}
