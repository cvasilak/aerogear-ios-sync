import Foundation

public struct PatchMessage<E:Edit> {
    public let documentId: String
    public let clientId: String
    public let edits: [E]

    public init(id: String, clientId: String, edits: [E]) {
        self.documentId = id
        self.clientId = clientId
        self.edits = edits
    }

}
