// // TODO: probably need some maping like `xwayland-shell` -> `shell`
// // for now just put those in different target
// // upside of rust macro way is that its probably won be generated unless use
// // we can do build option instead?


// public struct Unstable {
//     public struct PresentationTime {
//         public class V1 {

//         }
//     }
// }

// // we need namespacing because there gonna be same interface in both stable and unstable
// typealias PresentationTime = Unstable.PresentationTime.V1 // latest
// typealias PresentationTimeV1 = Unstable.PresentationTime.V1

// func a() -> PresentationTimeV1 {
//     PresentationTimeV1()
// }

// private func usages() {
//     let b = a()//  ???
// }
