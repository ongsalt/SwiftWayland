import Foundation

/// Shared Memory Support
/// 
/// A singleton global object that provides support for shared
/// memory.
/// Clients can create wl_shm_pool objects using the create_pool
/// request.
/// On binding the wl_shm object one or more format events
/// are emitted to inform clients about the valid pixel formats
/// that can be used for buffers.
public final class WlShm: WlProxyBase, WlProxy, WlInterface {
    public static let name: String = "wl_shm"
    public var onEvent: (Event) -> Void = { _ in }

    /// Create A Shm Pool
    /// 
    /// Create a new wl_shm_pool object.
    /// The pool can be used to create shared memory based buffer
    /// objects.  The server will mmap size bytes of the passed file
    /// descriptor, to use as backing memory for the pool.
    /// 
    /// - Parameters:
    ///   - Fd: file descriptor for the pool
    ///   - Size: pool size, in bytes
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
    
    /// Release The Shm Object
    /// 
    /// Using this request a client can tell the server that it is not going to
    /// use the shm object anymore.
    /// Objects created via this interface remain unaffected.
    /// 
    /// Available since version 2
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
    
    /// Wl_Shm Error Values
    /// 
    /// These errors can be emitted in response to wl_shm requests.
    public enum Error: UInt32, WlEnum {
        /// Buffer Format Is Not Known
        case invalidFormat = 0
        
        /// Invalid Size Or Stride During Pool Or Buffer Creation
        case invalidStride = 1
        
        /// Mmapping The File Descriptor Failed
        case invalidFd = 2
    }
    
    /// Pixel Formats
    /// 
    /// This describes the memory layout of an individual pixel.
    /// All renderers should support argb8888 and xrgb8888 but any other
    /// formats are optional and may not be supported by the particular
    /// renderer in use.
    /// The drm format codes match the macros defined in drm_fourcc.h, except
    /// argb8888 and xrgb8888. The formats actually supported by the compositor
    /// will be reported by the format event.
    /// For all wl_shm formats and unless specified in another protocol
    /// extension, pre-multiplied alpha is used for pixel values.
    public enum Format: UInt32, WlEnum {
        /// 32-Bit Argb Format, [31:0] A:R:G:B 8:8:8:8 Little Endian
        case argb8888 = 0
        
        /// 32-Bit Rgb Format, [31:0] X:R:G:B 8:8:8:8 Little Endian
        case xrgb8888 = 1
        
        /// 8-Bit Color Index Format, [7:0] C
        case c8 = 0x20203843
        
        /// 8-Bit Rgb Format, [7:0] R:G:B 3:3:2
        case rgb332 = 0x38424752
        
        /// 8-Bit Bgr Format, [7:0] B:G:R 2:3:3
        case bgr233 = 0x38524742
        
        /// 16-Bit Xrgb Format, [15:0] X:R:G:B 4:4:4:4 Little Endian
        case xrgb4444 = 0x32315258
        
        /// 16-Bit Xbgr Format, [15:0] X:B:G:R 4:4:4:4 Little Endian
        case xbgr4444 = 0x32314258
        
        /// 16-Bit Rgbx Format, [15:0] R:G:B:X 4:4:4:4 Little Endian
        case rgbx4444 = 0x32315852
        
        /// 16-Bit Bgrx Format, [15:0] B:G:R:X 4:4:4:4 Little Endian
        case bgrx4444 = 0x32315842
        
        /// 16-Bit Argb Format, [15:0] A:R:G:B 4:4:4:4 Little Endian
        case argb4444 = 0x32315241
        
        /// 16-Bit Abgr Format, [15:0] A:B:G:R 4:4:4:4 Little Endian
        case abgr4444 = 0x32314241
        
        /// 16-Bit Rbga Format, [15:0] R:G:B:A 4:4:4:4 Little Endian
        case rgba4444 = 0x32314152
        
        /// 16-Bit Bgra Format, [15:0] B:G:R:A 4:4:4:4 Little Endian
        case bgra4444 = 0x32314142
        
        /// 16-Bit Xrgb Format, [15:0] X:R:G:B 1:5:5:5 Little Endian
        case xrgb1555 = 0x35315258
        
        /// 16-Bit Xbgr 1555 Format, [15:0] X:B:G:R 1:5:5:5 Little Endian
        case xbgr1555 = 0x35314258
        
        /// 16-Bit Rgbx 5551 Format, [15:0] R:G:B:X 5:5:5:1 Little Endian
        case rgbx5551 = 0x35315852
        
        /// 16-Bit Bgrx 5551 Format, [15:0] B:G:R:X 5:5:5:1 Little Endian
        case bgrx5551 = 0x35315842
        
        /// 16-Bit Argb 1555 Format, [15:0] A:R:G:B 1:5:5:5 Little Endian
        case argb1555 = 0x35315241
        
        /// 16-Bit Abgr 1555 Format, [15:0] A:B:G:R 1:5:5:5 Little Endian
        case abgr1555 = 0x35314241
        
        /// 16-Bit Rgba 5551 Format, [15:0] R:G:B:A 5:5:5:1 Little Endian
        case rgba5551 = 0x35314152
        
        /// 16-Bit Bgra 5551 Format, [15:0] B:G:R:A 5:5:5:1 Little Endian
        case bgra5551 = 0x35314142
        
        /// 16-Bit Rgb 565 Format, [15:0] R:G:B 5:6:5 Little Endian
        case rgb565 = 0x36314752
        
        /// 16-Bit Bgr 565 Format, [15:0] B:G:R 5:6:5 Little Endian
        case bgr565 = 0x36314742
        
        /// 24-Bit Rgb Format, [23:0] R:G:B Little Endian
        case rgb888 = 0x34324752
        
        /// 24-Bit Bgr Format, [23:0] B:G:R Little Endian
        case bgr888 = 0x34324742
        
        /// 32-Bit Xbgr Format, [31:0] X:B:G:R 8:8:8:8 Little Endian
        case xbgr8888 = 0x34324258
        
        /// 32-Bit Rgbx Format, [31:0] R:G:B:X 8:8:8:8 Little Endian
        case rgbx8888 = 0x34325852
        
        /// 32-Bit Bgrx Format, [31:0] B:G:R:X 8:8:8:8 Little Endian
        case bgrx8888 = 0x34325842
        
        /// 32-Bit Abgr Format, [31:0] A:B:G:R 8:8:8:8 Little Endian
        case abgr8888 = 0x34324241
        
        /// 32-Bit Rgba Format, [31:0] R:G:B:A 8:8:8:8 Little Endian
        case rgba8888 = 0x34324152
        
        /// 32-Bit Bgra Format, [31:0] B:G:R:A 8:8:8:8 Little Endian
        case bgra8888 = 0x34324142
        
        /// 32-Bit Xrgb Format, [31:0] X:R:G:B 2:10:10:10 Little Endian
        case xrgb2101010 = 0x30335258
        
        /// 32-Bit Xbgr Format, [31:0] X:B:G:R 2:10:10:10 Little Endian
        case xbgr2101010 = 0x30334258
        
        /// 32-Bit Rgbx Format, [31:0] R:G:B:X 10:10:10:2 Little Endian
        case rgbx1010102 = 0x30335852
        
        /// 32-Bit Bgrx Format, [31:0] B:G:R:X 10:10:10:2 Little Endian
        case bgrx1010102 = 0x30335842
        
        /// 32-Bit Argb Format, [31:0] A:R:G:B 2:10:10:10 Little Endian
        case argb2101010 = 0x30335241
        
        /// 32-Bit Abgr Format, [31:0] A:B:G:R 2:10:10:10 Little Endian
        case abgr2101010 = 0x30334241
        
        /// 32-Bit Rgba Format, [31:0] R:G:B:A 10:10:10:2 Little Endian
        case rgba1010102 = 0x30334152
        
        /// 32-Bit Bgra Format, [31:0] B:G:R:A 10:10:10:2 Little Endian
        case bgra1010102 = 0x30334142
        
        /// Packed Ycbcr Format, [31:0] Cr0:Y1:Cb0:Y0 8:8:8:8 Little Endian
        case yuyv = 0x56595559
        
        /// Packed Ycbcr Format, [31:0] Cb0:Y1:Cr0:Y0 8:8:8:8 Little Endian
        case yvyu = 0x55595659
        
        /// Packed Ycbcr Format, [31:0] Y1:Cr0:Y0:Cb0 8:8:8:8 Little Endian
        case uyvy = 0x59565955
        
        /// Packed Ycbcr Format, [31:0] Y1:Cb0:Y0:Cr0 8:8:8:8 Little Endian
        case vyuy = 0x59555956
        
        /// Packed Aycbcr Format, [31:0] A:Y:Cb:Cr 8:8:8:8 Little Endian
        case ayuv = 0x56555941
        
        /// 2 Plane Ycbcr Cr:Cb Format, 2X2 Subsampled Cr:Cb Plane
        case nv12 = 0x3231564e
        
        /// 2 Plane Ycbcr Cb:Cr Format, 2X2 Subsampled Cb:Cr Plane
        case nv21 = 0x3132564e
        
        /// 2 Plane Ycbcr Cr:Cb Format, 2X1 Subsampled Cr:Cb Plane
        case nv16 = 0x3631564e
        
        /// 2 Plane Ycbcr Cb:Cr Format, 2X1 Subsampled Cb:Cr Plane
        case nv61 = 0x3136564e
        
        /// 3 Plane Ycbcr Format, 4X4 Subsampled Cb (1) And Cr (2) Planes
        case yuv410 = 0x39565559
        
        /// 3 Plane Ycbcr Format, 4X4 Subsampled Cr (1) And Cb (2) Planes
        case yvu410 = 0x39555659
        
        /// 3 Plane Ycbcr Format, 4X1 Subsampled Cb (1) And Cr (2) Planes
        case yuv411 = 0x31315559
        
        /// 3 Plane Ycbcr Format, 4X1 Subsampled Cr (1) And Cb (2) Planes
        case yvu411 = 0x31315659
        
        /// 3 Plane Ycbcr Format, 2X2 Subsampled Cb (1) And Cr (2) Planes
        case yuv420 = 0x32315559
        
        /// 3 Plane Ycbcr Format, 2X2 Subsampled Cr (1) And Cb (2) Planes
        case yvu420 = 0x32315659
        
        /// 3 Plane Ycbcr Format, 2X1 Subsampled Cb (1) And Cr (2) Planes
        case yuv422 = 0x36315559
        
        /// 3 Plane Ycbcr Format, 2X1 Subsampled Cr (1) And Cb (2) Planes
        case yvu422 = 0x36315659
        
        /// 3 Plane Ycbcr Format, Non-Subsampled Cb (1) And Cr (2) Planes
        case yuv444 = 0x34325559
        
        /// 3 Plane Ycbcr Format, Non-Subsampled Cr (1) And Cb (2) Planes
        case yvu444 = 0x34325659
        
        /// [7:0] R
        case r8 = 0x20203852
        
        /// [15:0] R Little Endian
        case r16 = 0x20363152
        
        /// [15:0] R:G 8:8 Little Endian
        case rg88 = 0x38384752
        
        /// [15:0] G:R 8:8 Little Endian
        case gr88 = 0x38385247
        
        /// [31:0] R:G 16:16 Little Endian
        case rg1616 = 0x32334752
        
        /// [31:0] G:R 16:16 Little Endian
        case gr1616 = 0x32335247
        
        /// [63:0] X:R:G:B 16:16:16:16 Little Endian
        case xrgb16161616f = 0x48345258
        
        /// [63:0] X:B:G:R 16:16:16:16 Little Endian
        case xbgr16161616f = 0x48344258
        
        /// [63:0] A:R:G:B 16:16:16:16 Little Endian
        case argb16161616f = 0x48345241
        
        /// [63:0] A:B:G:R 16:16:16:16 Little Endian
        case abgr16161616f = 0x48344241
        
        /// [31:0] X:Y:Cb:Cr 8:8:8:8 Little Endian
        case xyuv8888 = 0x56555958
        
        /// [23:0] Cr:Cb:Y 8:8:8 Little Endian
        case vuy888 = 0x34325556
        
        /// Y Followed By U Then V, 10:10:10. Non-Linear Modifier Only
        case vuy101010 = 0x30335556
        
        /// [63:0] Cr0:0:Y1:0:Cb0:0:Y0:0 10:6:10:6:10:6:10:6 Little Endian Per 2 Y Pixels
        case y210 = 0x30313259
        
        /// [63:0] Cr0:0:Y1:0:Cb0:0:Y0:0 12:4:12:4:12:4:12:4 Little Endian Per 2 Y Pixels
        case y212 = 0x32313259
        
        /// [63:0] Cr0:Y1:Cb0:Y0 16:16:16:16 Little Endian Per 2 Y Pixels
        case y216 = 0x36313259
        
        /// [31:0] A:Cr:Y:Cb 2:10:10:10 Little Endian
        case y410 = 0x30313459
        
        /// [63:0] A:0:Cr:0:Y:0:Cb:0 12:4:12:4:12:4:12:4 Little Endian
        case y412 = 0x32313459
        
        /// [63:0] A:Cr:Y:Cb 16:16:16:16 Little Endian
        case y416 = 0x36313459
        
        /// [31:0] X:Cr:Y:Cb 2:10:10:10 Little Endian
        case xvyu2101010 = 0x30335658
        
        /// [63:0] X:0:Cr:0:Y:0:Cb:0 12:4:12:4:12:4:12:4 Little Endian
        case xvyu1216161616 = 0x36335658
        
        /// [63:0] X:Cr:Y:Cb 16:16:16:16 Little Endian
        case xvyu16161616 = 0x38345658
        
        /// [63:0]   A3:A2:Y3:0:Cr0:0:Y2:0:A1:A0:Y1:0:Cb0:0:Y0:0  1:1:8:2:8:2:8:2:1:1:8:2:8:2:8:2 Little Endian
        case y0l0 = 0x304c3059
        
        /// [63:0]   X3:X2:Y3:0:Cr0:0:Y2:0:X1:X0:Y1:0:Cb0:0:Y0:0  1:1:8:2:8:2:8:2:1:1:8:2:8:2:8:2 Little Endian
        case x0l0 = 0x304c3058
        
        /// [63:0]   A3:A2:Y3:Cr0:Y2:A1:A0:Y1:Cb0:Y0  1:1:10:10:10:1:1:10:10:10 Little Endian
        case y0l2 = 0x324c3059
        
        /// [63:0]   X3:X2:Y3:Cr0:Y2:X1:X0:Y1:Cb0:Y0  1:1:10:10:10:1:1:10:10:10 Little Endian
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
        
        /// Non-Subsampled Cr:Cb Plane
        case nv24 = 0x3432564e
        
        /// Non-Subsampled Cb:Cr Plane
        case nv42 = 0x3234564e
        
        /// 2X1 Subsampled Cr:Cb Plane, 10 Bit Per Channel
        case p210 = 0x30313250
        
        /// 2X2 Subsampled Cr:Cb Plane 10 Bits Per Channel
        case p010 = 0x30313050
        
        /// 2X2 Subsampled Cr:Cb Plane 12 Bits Per Channel
        case p012 = 0x32313050
        
        /// 2X2 Subsampled Cr:Cb Plane 16 Bits Per Channel
        case p016 = 0x36313050
        
        /// [63:0] A:X:B:X:G:X:R:X 10:6:10:6:10:6:10:6 Little Endian
        case axbxgxrx106106106106 = 0x30314241
        
        /// 2X2 Subsampled Cr:Cb Plane
        case nv15 = 0x3531564e
        
        case q410 = 0x30313451
        
        case q401 = 0x31303451
        
        /// [63:0] X:R:G:B 16:16:16:16 Little Endian
        case xrgb16161616 = 0x38345258
        
        /// [63:0] X:B:G:R 16:16:16:16 Little Endian
        case xbgr16161616 = 0x38344258
        
        /// [63:0] A:R:G:B 16:16:16:16 Little Endian
        case argb16161616 = 0x38345241
        
        /// [63:0] A:B:G:R 16:16:16:16 Little Endian
        case abgr16161616 = 0x38344241
        
        /// [7:0] C0:C1:C2:C3:C4:C5:C6:C7 1:1:1:1:1:1:1:1 Eight Pixels/Byte
        case c1 = 0x20203143
        
        /// [7:0] C0:C1:C2:C3 2:2:2:2 Four Pixels/Byte
        case c2 = 0x20203243
        
        /// [7:0] C0:C1 4:4 Two Pixels/Byte
        case c4 = 0x20203443
        
        /// [7:0] D0:D1:D2:D3:D4:D5:D6:D7 1:1:1:1:1:1:1:1 Eight Pixels/Byte
        case d1 = 0x20203144
        
        /// [7:0] D0:D1:D2:D3 2:2:2:2 Four Pixels/Byte
        case d2 = 0x20203244
        
        /// [7:0] D0:D1 4:4 Two Pixels/Byte
        case d4 = 0x20203444
        
        /// [7:0] D
        case d8 = 0x20203844
        
        /// [7:0] R0:R1:R2:R3:R4:R5:R6:R7 1:1:1:1:1:1:1:1 Eight Pixels/Byte
        case r1 = 0x20203152
        
        /// [7:0] R0:R1:R2:R3 2:2:2:2 Four Pixels/Byte
        case r2 = 0x20203252
        
        /// [7:0] R0:R1 4:4 Two Pixels/Byte
        case r4 = 0x20203452
        
        /// [15:0] X:R 6:10 Little Endian
        case r10 = 0x20303152
        
        /// [15:0] X:R 4:12 Little Endian
        case r12 = 0x20323152
        
        /// [31:0] A:Cr:Cb:Y 8:8:8:8 Little Endian
        case avuy8888 = 0x59555641
        
        /// [31:0] X:Cr:Cb:Y 8:8:8:8 Little Endian
        case xvuy8888 = 0x59555658
        
        /// 2X2 Subsampled Cr:Cb Plane 10 Bits Per Channel Packed
        case p030 = 0x30333050
    }
    
    public enum Event: WlEventEnum {
        /// Pixel Format Description
        /// 
        /// Informs the client about a valid pixel format that
        /// can be used for buffers. Known formats include
        /// argb8888 and xrgb8888.
        /// 
        /// - Parameters:
        ///   - Format: buffer pixel format
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
