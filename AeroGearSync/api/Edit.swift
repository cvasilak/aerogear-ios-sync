import Foundation

public protocol Edit {
    func clientId() -> String
    func documentId() -> String
    func clientVersion() -> Int64
    func serverVersion() -> Int64
    func checksum() -> String
    func diffs() -> Array<Diff>
}
