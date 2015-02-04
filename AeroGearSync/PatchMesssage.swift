import Foundation

public struct PatchMessage<E:Edit>: Printable {

    public let documentId: String
    public let clientId: String
    public let edits: [E]

    public init(id: String, clientId: String, edits: [E]) {
        self.documentId = id
        self.clientId = clientId
        self.edits = edits
    }

    public var description: String {
        return "PatchMessage[documentId=\(documentId), clientId=\(clientId), edits=\(edits)]"
    }

}
