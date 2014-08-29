import Foundation

protocol ShadowDocument {
    func serverVersion() -> Int64
    func clientVersion() -> Int64
    func clientDocument() -> ClientDocument
}
