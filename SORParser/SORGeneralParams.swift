import Foundation

struct SORGeneralParams {
    enum FiberType: UInt16 {
        case multiMode = 651 // ITU-T G.651 (multi-mode fiber)
        case standardSingleMode = 652 // ITU-T G.652 (standard single-mode fiber)
        case dispersionShifted = 653 // ITU-T G.653 (dispersion-shifted fiber)
        case lossMinimzed = 654 // ITU-T G.654 (1550nm loss-minimzed fiber)
        case nonzeroDispersionShifted = 655 // ITU-T G.655 (nonzero dispersion-shifted fiber)
        case unknown
    }
    
    enum BuildCondition: String {
        case asBuilt = "BC"
        case asCurrent = "CC"
        case asRepaired = "RC"
        case other = "OT"
        case unknown
    }
    
    let language: String
    let cableId: String
    let fiberId: String
    let fiberType: FiberType?
    let waveLength: UInt16
    let locationA: String // starting location
    let locationB: String // ending location
    let cableCode: String // or fiber type
    let buildCondition: BuildCondition
    let unknownParam: Data
    let `operator`: String
    let comments: String
    
    init?(from fileHandle: FileHandle, header: SORBlockHeader) {
        if header.version.major == 2 {
            guard let name = fileHandle.readString(), name == header.name else { return nil }
        }
        
        guard let language = fileHandle.readString(2) else { return nil }
        self.language = language

        guard let cableId = fileHandle.readString() else { return nil }
        self.cableId = cableId
        
        guard let fiberId = fileHandle.readString() else { return nil }
        self.fiberId = fiberId
        
        if header.version.major == 2 {
            guard let fiberType = fileHandle.readUInt16() else { return nil }
            self.fiberType = FiberType(rawValue: fiberType) ?? .unknown
        } else {
            fiberType = nil
        }

        guard let waveLength = fileHandle.readUInt16() else { return nil }
        self.waveLength = waveLength

        guard let locationA = fileHandle.readString() else { return nil }
        self.locationA = locationA

        guard let locationB = fileHandle.readString() else { return nil }
        self.locationB = locationB

        guard let cableCode = fileHandle.readString() else { return nil }
        self.cableCode = cableCode

        guard let buildCondition = fileHandle.readString(2) else { return nil }
        self.buildCondition = BuildCondition(rawValue: buildCondition) ?? .unknown

        unknownParam = fileHandle.readData(ofLength: 8)
        guard unknownParam.count == 8 else { return nil }
        
        guard let `operator` = fileHandle.readString() else { return nil }
        self.operator = `operator`

        guard let comments = fileHandle.readString() else { return nil }
        self.comments = comments
    }
}
