import Foundation

struct SORSupplierParams: SORBlock {
    let supplierName: String
    let OTDRName: String
    let OTDRSerialNumber: String
    let moduleName: String
    let moduleSerialNumber: String
    let softwareVersion: String
    let other: String
    
    init?(from fileHandle: FileHandle, header: SORBlockHeader) {
        if header.version.major == 2 {
            guard let name = fileHandle.readString(), name == header.name else { return nil }
        }

        guard let supplierName = fileHandle.readString() else { return nil }
        self.supplierName = supplierName

        guard let OTDRName = fileHandle.readString() else { return nil }
        self.OTDRName = OTDRName

        guard let OTDRSerialNumber = fileHandle.readString() else { return nil }
        self.OTDRSerialNumber = OTDRSerialNumber

        guard let moduleName = fileHandle.readString() else { return nil }
        self.moduleName = moduleName

        guard let moduleSerialNumber = fileHandle.readString() else { return nil }
        self.moduleSerialNumber = moduleSerialNumber

        guard let softwareVersion = fileHandle.readString() else { return nil }
        self.softwareVersion = softwareVersion

        guard let other = fileHandle.readString() else { return nil }
        self.other = other
    }
}
