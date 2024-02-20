import Foundation

struct SOREvent {
    let number: UInt16
    let unadjustedDistance: UInt32
    let slope: Int16
    let spliceLoss: Int16
    let reflectionLoss: Int32
    let eventType: String
    let auxilaryLeftMarker: UInt32
    let mainLeftMarker: UInt32
    let centralMarker: UInt32
    let mainRightMarker: UInt32
    let auxilaryRightMarker: UInt32
    let comment: String
}

struct SORKeyEvents: SORBlock {
    let totalLoss: UInt16
    let fiberStartPosition: Int32
    let fiberLength: UInt32
    let opticalReturnLoss: UInt16
    let events: [SOREvent]
    
    init?(from fileHandle: FileHandle, header: SORBlockHeader) {
        if header.version.major == 2 {
            guard let name = fileHandle.readString(), name == header.name else { return nil }
        }
        
        do {
            let numberOfEvents = try fileHandle.read { $0.readUInt16() }
            var events = [SOREvent]()
            for _ in 1...numberOfEvents {
                let event = SOREvent(
                    number: try fileHandle.read { $0.readUInt16() },
                    unadjustedDistance: try fileHandle.read { $0.readUInt32() },
                    slope: Int16(bitPattern: try fileHandle.read { $0.readUInt16() }),
                    spliceLoss: Int16(bitPattern: try fileHandle.read { $0.readUInt16() }),
                    reflectionLoss: Int32(bitPattern: try fileHandle.read { $0.readUInt32() }),
                    eventType: try fileHandle.read { $0.readString(8) },
                    auxilaryLeftMarker: try fileHandle.read { $0.readUInt32() },
                    mainLeftMarker: try fileHandle.read { $0.readUInt32() },
                    centralMarker: try fileHandle.read { $0.readUInt32() },
                    mainRightMarker: try fileHandle.read { $0.readUInt32() },
                    auxilaryRightMarker: try fileHandle.read { $0.readUInt32() },
                    comment: try fileHandle.read { $0.readString() }
                )
                events.append(event)
            }
            self.events = events
            
            totalLoss = try fileHandle.read { $0.readUInt16() }
            fiberStartPosition = Int32(bitPattern: try fileHandle.read { $0.readUInt32() })
            fiberLength = try fileHandle.read { $0.readUInt32() }
            opticalReturnLoss = try fileHandle.read { $0.readUInt16() }
            
            // Read just possible dublicates for fiberStartPosition and Length
            fileHandle.readData(ofLength: 8)
            
            // Read unknown 2 bytes
            fileHandle.readData(ofLength: 2)
        } catch { return nil }
    }
}
