import Foundation

public protocol BackupShadowDocument {
    func version() -> UInt64
    func shadowDocument() -> ShadowDocument
}
