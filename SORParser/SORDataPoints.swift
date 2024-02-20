import Foundation

struct SORDataPoints: SORBlock {
    let points: [UInt16]
    init?(from fileHandle: FileHandle, header: SORBlockHeader) {
        if header.version.major == 2 {
            guard let name = fileHandle.readString(), name == header.name else { return nil }
        }
        
        do {
            let numberOfPoints = try fileHandle.read { $0.readUInt32() }
            // Skip some unknown data
            fileHandle.readData(ofLength: 8)
            var points = [UInt16]()
            for _ in 1...numberOfPoints {
                points.append(try fileHandle.read { $0.readUInt16() })
            }
            self.points = points
        } catch { return nil }
    }
}
