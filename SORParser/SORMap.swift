import Foundation

struct SORMap {
    let header: SORBlockHeader
    let dataHeaders: [SORBlockHeader]
    init?(from fileHandle: FileHandle) {
        do {
            header = try fileHandle.read { SORBlockHeader(from: $0) }
            let blocksCount = try fileHandle.read { $0.readUInt16() }
            dataHeaders = try (1..<blocksCount).map { _ in
                try fileHandle.read { SORBlockHeader(from: $0) }
            }
        } catch { return nil }
    }
}
