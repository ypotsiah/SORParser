import Foundation

struct SORFixedParams: SORBlock {
    enum TraceType: String {
        case standardTrace = "ST"
        case reverseTrace = "RT"
        case differenceTrace = "DT"
        case reference = "RF"
        case unknown
    }
    
    let dateTime: Date
    let unknownFirst: Data
    let waveLength: UInt16
    let unknownSecond: Data
    let pulseWidth: UInt16
    let distanceSpacing: UInt32
    let numberOfDataPointsInTrace: UInt32
    let refractionIndex: UInt32
    let backscatteringCoefficient: UInt16
    let numberOfAverages: UInt32
    let range: UInt32
    let unknownThird: Data
    let lossThreshold: UInt16
    let reflectionThreshold: UInt16
    let endOfTransmissionThreshold: UInt16
    let traceType: TraceType
    let unknownFourth: Data
    
    init?(from fileHandle: FileHandle, header: SORBlockHeader) {
        if header.version.major == 2 {
            guard let name = fileHandle.readString(), name == header.name else { return nil }
        }
        
        do {
            let timeInterval = TimeInterval(try fileHandle.read { $0.readUInt32() })
            dateTime = Date(timeIntervalSince1970: timeInterval)
            unknownFirst = fileHandle.readData(ofLength: 2)
            waveLength = try fileHandle.read { $0.readUInt16() }
            unknownSecond = fileHandle.readData(ofLength: 10)
            pulseWidth = try fileHandle.read { $0.readUInt16() }
            distanceSpacing = try fileHandle.read { $0.readUInt32() }
            numberOfDataPointsInTrace = try fileHandle.read { $0.readUInt32() }
            refractionIndex = try fileHandle.read { $0.readUInt32() }
            backscatteringCoefficient = try fileHandle.read { $0.readUInt16() }
            numberOfAverages = try fileHandle.read { $0.readUInt32() }
            range = try fileHandle.read { $0.readUInt32() }
            unknownThird = fileHandle.readData(ofLength: 16)
            lossThreshold = try fileHandle.read { $0.readUInt16() }
            reflectionThreshold = try fileHandle.read { $0.readUInt16() }
            endOfTransmissionThreshold = try fileHandle.read { $0.readUInt16() }
            traceType = TraceType(rawValue: try fileHandle.read { $0.readString(2) }) ?? .unknown
            unknownFourth = fileHandle.readData(ofLength: 16)
        } catch { return nil }
    }
}
