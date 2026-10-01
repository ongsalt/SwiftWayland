import Foundation

// TODO: naming is hard
// this is for outgoing message
public enum Arg {
    case int(Int32)
    case uint(UInt32)
    case fixed(Double)
    case string(String?) // string are nullable
    case array(UnsafeRawBufferPointer) // NO COPY ARE PERFORM, may be accept a span
    // for incoming message its own by wayland, so we just make its RawSpan
    case fd(FileHandle)  // this need to live until we send it
    case `enum`(UInt32) // from a typed enum
    case object((any Proxy)?) // id type (*wl_proxy, or our id)
    case newId // we return the newly created object instead
}
