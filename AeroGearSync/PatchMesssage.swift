import Foundation

public class PatchMessage {
    let documentId: String
    let clientId: String
    let edits: [Edit]

    public init(id: String, clientId: String, edits: [Edit]) {
        self.documentId = id
        self.clientId = clientId
        self.edits = edits
    }

}
