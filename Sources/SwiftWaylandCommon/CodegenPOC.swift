import Foundation

typealias EventQueue = NSObject

protocol Proxy {
    associatedtype Event
    associatedtype Request
    associatedtype ObjectId  // static
    // associatedtype UserData

    static var interface: Interface { get }

    var version: UInt32 { get }
    var id: ObjectId {
        get
    }

    var queue: EventQueue {
        get
    }

    // var userData: UserData {
    //     get
    //     set
    // }
}

protocol Backend {

}

// fd read into an immediate buffer -> see which object