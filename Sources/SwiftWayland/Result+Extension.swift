import Foundation

extension Result {
    var error: Failure? {
        do {
            _ = try self.get()
            return nil
        } catch {
            return error
        }
    }

    var value: Success? {
        do {
            return try self.get()
        } catch {
            return nil
        }
    }

    var isError: Bool {
        self.error != nil
    }

    var isOk: Bool {
        self.value != nil
    }
}

private extension FileHandle {
    var isOpen: Bool {
        return fcntl(self.fileDescriptor, F_GETFD) != -1 || errno != EBADF
    }
}
