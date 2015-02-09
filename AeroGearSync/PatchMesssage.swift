import Foundation

public struct PatchMessage: Printable {
    public let documentId: String
    public let clientId: String
    public let edits: [Edit]

    public init(id: String, clientId: String, edits: [Edit]) {
        self.documentId = id
        self.clientId = clientId
        self.edits = edits
    }

    public var description: String {
        return "PatchMessage[documentId=\(documentId), clientId=\(clientId), edits=\(edits)]"
    }

}
