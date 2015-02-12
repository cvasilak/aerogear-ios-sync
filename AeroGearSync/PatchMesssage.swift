import Foundation

public class PatchMessage<E:Edit>: Printable, Payload {
    
    public let documentId: String!
    public let clientId: String!
    public let edits: [E]!
    
    public init() {}
    
    public init(id: String, clientId: String, edits: [E]) {
        self.documentId = id
        self.clientId = clientId
        self.edits = edits
    }
    
    public func asJson() -> String {
        fatalError("This method must be overridden")
    }
    
    public func fromJson(var json:String) -> PatchMessage<E>? {
        fatalError("This method must be overridden")
    }
    
    public var description: String {
        return "PatchMessage[documentId=\(documentId), clientId=\(clientId), edits=\(edits)]"
    }
    
}
