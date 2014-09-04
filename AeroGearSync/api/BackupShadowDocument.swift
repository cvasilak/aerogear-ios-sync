import Foundation

public protocol BackupShadowDocument {
    func version() -> Int64
    func shadowDocument() -> ShadowDocument
}
