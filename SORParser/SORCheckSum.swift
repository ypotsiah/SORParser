import Foundation

struct SORCheckSum {
    let chkSum: UInt16
    init?(from fileHandle: FileHandle, header: SORBlockHeader) {
        if header.version.major == 2 {
            guard let name = fileHandle.readString(), name == header.name else { return nil }
        }
        
        do {
            chkSum = try fileHandle.read { $0.readUInt16() }
        } catch { return nil }
    }
}
