import Foundation

public enum AsyncUtils {
    @discardableResult
    public static func background<T>(queue: DispatchQueue = .global(), block: @Sendable @escaping () -> T) async -> T {
        await withUnsafeContinuation { c in
            queue.async {
                c.resume(returning: block())
            }
        }
    }

    
}
