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
        if let genParams = SORGeneralParams(from: fileHandle, header: map.dataHeaders[0]) {
            print(genParams)
        }
        
        if let supParams = SORSupplierParams(from: fileHandle, header: map.dataHeaders[1]) {
            print(supParams)
        }
        
        if let fixedParams = SORFixedParams(from: fileHandle, header: map.dataHeaders[2]) {
            print(fixedParams)
        }
        
        if let keyEvents = SORKeyEvents(from: fileHandle, header: map.dataHeaders[3]) {
            print(keyEvents)
        }
        
        if let dataPoints = SORDataPoints(from: fileHandle, header: map.dataHeaders[4]) {
            print(dataPoints)
        }
        
        if let chkSum = SORCheckSum(from: fileHandle, header: map.dataHeaders[5]) {
            print(chkSum)
        }
    }
}

if let path = Bundle.main.path(forResource: "Test", ofType: "sor") {
    print("Found path: \(path)\nParsing...\n")
    parseFile(at: path)
} else {
    print("File not found")
}
