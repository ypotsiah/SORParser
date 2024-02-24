import Foundation

protocol SORBlock {
    init?(from fileHandle: FileHandle, header: SORBlockHeader)
}
