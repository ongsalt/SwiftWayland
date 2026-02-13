// import Foundation
// import SwiftWayland
// import Glibc

// @main
// @MainActor
// public struct SwiftWayland {
//     public static var connection: Connection! = nil
//     public static var flusher: AutoFlusher! = nil

//     private struct State {
//         var compositor: WlCompositor?
//         var shm: WlShm?
//         var xdgWmBase: XdgWmBase?

//         var surface: WlSurface?
//         var xdgSurface: XdgSurface?
//         var toplevel: XdgToplevel?

//         var shmPool: WlShmPool?
//         var buffer: WlBuffer?
//         var bufferData: UnsafeMutableRawPointer?
//         var bufferSize: Int = 0
//         var bufferWidth: Int = 0
//         var bufferHeight: Int = 0
//     }

//     public static func main() {
//         Task {
//             try await start()

//             // while !Task.isCancelled {
//             //     // print("--")
//             //     try await connection.roundtrip()
//             // }

//             // flusher = AutoFlusher(connection: connection)
//             // flusher.start()
//         }

//         RunLoop.main.run()
//     }

//     static func start() async throws {
//         connection = try Connection.fromEnv()

//         let display = connection.display!
//         display.onEvent = { event in
//             switch event {
//             case .deleteId(let id):
//                 print("___---- Delete id \(id)")
//             default:
//                 break
//             }
//         }

//         let registry = display.getRegistry()

//         var state = State()

//         registry.onEvent = { event in
//             switch event {
//             case .global(let name, let interface, let version):
//                 // print(interface)
//                 switch interface {
//                 case WlCompositor.name:
//                     state.compositor = registry.bind(name: name, version: version, interface: WlCompositor.self)
//                 case WlShm.name:
//                     state.shm = registry.bind(name: name, version: version, interface: WlShm.self)
//                 case XdgWmBase.name:
//                     state.xdgWmBase = registry.bind(name: name, version: version, interface: XdgWmBase.self)
//                     state.xdgWmBase?.onEvent = { ev in
//                         if case .ping(let serial) = ev {
//                             state.xdgWmBase?.pong(serial: serial)
//                         }
//                     }
//                 default:
//                     break
//                 }
//             default:
//                 break
//             }
//         }

//         try connection.roundtrip()

//         // guard
//         //     let compositor = state.compositor,
//         //     let xdgWmBase = state.xdgWmBase,
//         //     let shm = state.shm
//         // else {
//         //     fatalError("Missing required globals")
//         // }

//         // let surface = compositor.createSurface()
//         // let xdgSurface = xdgWmBase.getXdgSurface(surface: surface)
//         // let toplevel = xdgSurface.getToplevel()
//         // toplevel.setTitle(title: "SwiftWayland")

//         // let initialWidth = 480
//         // let initialHeight = 320
//         // let bufferInfo = try makeShmBuffer(shm: shm, width: initialWidth, height: initialHeight)
//         // state.shmPool = bufferInfo.pool
//         // state.buffer = bufferInfo.buffer
//         // state.bufferData = bufferInfo.data
//         // state.bufferSize = bufferInfo.size
//         // state.bufferWidth = initialWidth
//         // state.bufferHeight = initialHeight

//         // xdgSurface.onEvent = { ev in
//         //     if case .configure(let serial) = ev {
//         //         xdgSurface.ackConfigure(serial: serial)
//         //         if let buffer = state.buffer {
//         //             surface.attach(buffer: buffer, x: 0, y: 0)
//         //             surface.damage(x: 0, y: 0, width: Int32(state.bufferWidth), height: Int32(state.bufferHeight))
//         //             surface.commit()
//         //         }
//         //     }
//         // }

//         // state.surface = surface
//         // state.xdgSurface = xdgSurface
//         // state.toplevel = toplevel

//         // surface.commit()

//         try await connection.roundtrip()
//     }

//     static func makeShmBuffer(shm: WlShm, width: Int, height: Int) throws -> (buffer: WlBuffer, pool: WlShmPool, data: UnsafeMutableRawPointer, size: Int) {
//         let stride = width * 4
//         let size = stride * height

//         let file = try createShmFile(size: size)
//         let pool = shm.createPool(fd: file, size: Int32(size))
//         let buffer = pool.createBuffer(
//             offset: 0,
//             width: Int32(width),
//             height: Int32(height),
//             stride: Int32(stride),
//             format: WlShm.Format.xrgb8888.rawValue
//         )

//         let data = mmap(nil, size, PROT_READ | PROT_WRITE, MAP_SHARED, file.fileDescriptor, 0)
//         if data == MAP_FAILED {
//             throw NSError(domain: "SwiftWayland", code: Int(errno), userInfo: [
//                 NSLocalizedDescriptionKey: "mmap failed"
//             ])
//         }

//         fillGradient(buffer: data!, width: width, height: height)
//         return (buffer, pool, data!, size)
//     }

//     static func createShmFile(size: Int) throws -> FileHandle {
//         let name = "/swiftwayland-\(UUID().uuidString)"
//         let fd = shm_open(name, O_RDWR | O_CREAT | O_EXCL, S_IRUSR | S_IWUSR)
//         if fd == -1 {
//             throw NSError(domain: "SwiftWayland", code: Int(errno), userInfo: [
//                 NSLocalizedDescriptionKey: "shm_open failed"
//             ])
//         }
//         _ = shm_unlink(name)
//         if ftruncate(fd, off_t(size)) == -1 {
//             close(fd)
//             throw NSError(domain: "SwiftWayland", code: Int(errno), userInfo: [
//                 NSLocalizedDescriptionKey: "ftruncate failed"
//             ])
//         }

//         return FileHandle(fileDescriptor: fd, closeOnDealloc: true)
//     }

//     static func fillGradient(buffer: UnsafeMutableRawPointer, width: Int, height: Int) {
//         let pixels = buffer.bindMemory(to: UInt32.self, capacity: width * height)
//         let w = max(width - 1, 1)
//         let h = max(height - 1, 1)
//         for y in 0..<height {
//             for x in 0..<width {
//                 let r = UInt32((x * 255) / w)
//                 let g = UInt32((y * 255) / h)
//                 let b = UInt32(64)
//                 pixels[y * width + x] = 0xFF000000 | (r << 16) | (g << 8) | b
//             }
//         }
//     }
// }
