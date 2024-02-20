// The SOR ("Standard OTDR Record")
// Data format is used to store OTDR (optical time-domain reflectometer ) fiber data.

import Foundation

func parseFile(at path: String) {
    guard let fileHandle = FileHandle(forReadingAtPath: path) else {
        return
    }
    
    defer {
        try? fileHandle.close()
        print("Parsing finished")
    }
    
    // Make sure to set a correct ecoding
    fileHandle.encoding = .windowsCP1251
    
    if let map = SORMap(from: fileHandle) {
        print(map)

        let blocks: [SORBlock.Type] = [
            SORGeneralParams.self,
            SORSupplierParams.self,
            SORFixedParams.self,
            SORKeyEvents.self,
            SORDataPoints.self,
            SORCheckSum.self
        ]

        for (idx, block) in blocks.enumerated() {
            guard map.dataHeaders.indices.contains(idx) else {
                fatalError("Invalid block index: \(idx)")
            }
            
            if let data = block.init(from: fileHandle, header: map.dataHeaders[idx]) {
                print(data)
            } else {
                print("Unable to get data for block: \(map.dataHeaders[idx].name)")
            }
        }
    }
}

if let path = Bundle.main.path(forResource: "Test", ofType: "sor") {
    print("Found path: \(path)\nParsing...\n")
    parseFile(at: path)
} else {
    print("File not found")
}
