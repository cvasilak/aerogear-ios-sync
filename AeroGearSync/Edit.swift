import Foundation

public protocol Edit {
    func clientId() -> String
    func documentId() -> String
    func clientVersion() -> UInt64
    func serverVersion() -> UInt64
    func checksum() -> String
    func diffs() -> Array<Diff>
}
