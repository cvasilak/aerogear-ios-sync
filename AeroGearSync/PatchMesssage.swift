import Foundation

public struct PatchMessage {
    public let documentId: String
    public let clientId: String
    public let edits: [Edit]

    public init(id: String, clientId: String, edits: [Edit]) {
        self.documentId = id
        self.clientId = clientId
        self.edits = edits
    }

}
