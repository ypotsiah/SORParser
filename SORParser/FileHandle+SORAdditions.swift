import Foundation

enum DataReadingError: Error {
    case nilValue
}

extension FileHandle {
    struct Holder {
        static var encoding: String.Encoding = .ascii
    }
    
    var encoding: String.Encoding {
        get {
            return Holder.encoding
        }
        set(newValue) {
            Holder.encoding = newValue
        }
    }
    
    func read<T>(reader: (FileHandle) -> T?) throws -> T {
        guard let value = reader(self) else {
            throw DataReadingError.nilValue
        }
        return value
    }
    
    func readString(_ numChars: UInt = 0) -> String? {
        var bytes = Data()
        if numChars == 0 {
            let terminator = 0x00
            var lastByte = Data()

            repeat {
                lastByte = readData(ofLength: 1)
                if lastByte.count < 1 { break }
                if lastByte[0] != terminator {
                    bytes.append(lastByte)
                }
            } while lastByte[0] != terminator
        } else {
            bytes.append(readData(ofLength: Int(numChars)))
        }
        
        return String(bytes: bytes, encoding: encoding)
    }
    
    func readUInt16() -> UInt16? {
        let bytes = readData(ofLength: 2)
        guard bytes.count == 2 else { return nil }
        return CFSwapInt16LittleToHost(bytes.withUnsafeBytes { $0.load(as: UInt16.self) })
    }
    
    func readUInt32() -> UInt32? {
        let bytes = readData(ofLength: 4)
        guard bytes.count == 4 else { return nil }
        return CFSwapInt32LittleToHost(bytes.withUnsafeBytes { $0.load(as: UInt32.self) })
    }
}
