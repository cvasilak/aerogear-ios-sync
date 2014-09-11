import Foundation

public class Edit: Equatable {
    public let clientId: String
    public let documentId: String
    public let clientVersion: UInt64
    public let serverVersion: UInt64
    public let checksum: String
    public let diffs: Array<Diff>

    public init(clientId: String, documentId: String, clientVersion: UInt64, serverVersion: UInt64, checksum: String, diffs: Array<Diff>) {
        self.clientId = clientId
        self.documentId = documentId
        self.clientVersion = clientVersion
        self.serverVersion = serverVersion
        self.checksum = checksum
        self.diffs = diffs
    }

}

public func ==(lhs: Edit, rhs: Edit) -> Bool {
    return lhs.clientId == rhs.clientId &&
        lhs.documentId == rhs.documentId &&
        lhs.serverVersion == rhs.serverVersion &&
        lhs.checksum == rhs.checksum &&
        lhs.diffs.count == rhs.diffs.count
}
