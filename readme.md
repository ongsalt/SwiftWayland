# SwiftWayland
Wayland scanner and Wayland client library for swift. We don't do server yet.


## WARNING: fd ~~transport~~ receiving is not yet ~~implemented~~ test

# Usages

For client library see `SwiftWaylandExample` 

## Code generation

See Scripts/generate.py


# Design
some design decision
## Destructor method
- now every method will be able to throws
- will expose a destructor function as a `consuming func`
- will provide a `deinit` that will be automatically run first destructor method with no argument
- this should be configurable

## Versioning
- its currently inherited from what you bind
- what if some interface create an object from another registry
    - if its wl_callback, just make it 1 or just ignore

# Todos
- nullable onEvent
- make Event decode failable (and not fatalError)
- when should i check if fd is open? dispatch??? or when call
- error message when connection closed,
- async again
- there is 2 `ZwpLinuxBufferParamsV1`: stable and unstable, probably need to do some namespacing + aliasing
- codegen plugin
- @spi export
- bitfield
- generate documentation
    - throws
    - returns multiple object
- test
    - probably gonna steal from wayland-rs
