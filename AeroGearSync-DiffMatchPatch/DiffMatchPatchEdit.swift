import AeroGearSync

public struct DiffMatchPatchEdit: Edit {
    public let clientId: String
    public let documentId: String
    public let clientVersion: Int
    public let serverVersion: Int
    public let checksum: String
    public let diffs: Array<DiffMatchPatchDiff>
    
    public init(clientId: String, documentId: String, clientVersion: Int, serverVersion: Int, checksum: String, diffs: Array<DiffMatchPatchDiff>) {
        self.clientId = clientId
        self.documentId = documentId
        self.clientVersion = clientVersion
        self.serverVersion = serverVersion
        self.checksum = checksum
        self.diffs = diffs
    }
    
    public var description: String {
        return "Edit[clientId=\(clientId), documentId=\(documentId), clientVersion=\(clientVersion), serverVersion=\(serverVersion), checksum=\(checksum), diffs=\(diffs)]"
    }
}

public func ==(lhs: DiffMatchPatchEdit, rhs: DiffMatchPatchEdit) -> Bool {
    return lhs.clientId == rhs.clientId &&
        lhs.documentId == rhs.documentId &&
        lhs.serverVersion == rhs.serverVersion &&
        lhs.checksum == rhs.checksum &&
        lhs.diffs.count == rhs.diffs.count
}

