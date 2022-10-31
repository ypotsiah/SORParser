import Foundation

struct Version {
    let major: UInt16
    let minor: UInt16
    
    init?(from fileHandle: FileHandle) {
        guard let version = fileHandle.readUInt16() else { return nil }
        major = version / 100
        minor = version - (major * 100)
    }
}
