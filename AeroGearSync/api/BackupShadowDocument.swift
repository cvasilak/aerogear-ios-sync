import Foundation

protocol BackupShadowDocument {
    func version() -> Int64
    func shadowDocument() -> ShadowDocument
}
