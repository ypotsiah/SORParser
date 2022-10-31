import Foundation

struct SORBlockHeader {
    let name: String
    let version: Version
    let size: UInt32
    
    init?(from fileHandle: FileHandle) {
        do {
            name = try fileHandle.read { $0.readString() }
            version = try fileHandle.read { Version(from: $0) }
            size = try fileHandle.read { $0.readUInt32() }
        } catch { return nil }
    }
}
