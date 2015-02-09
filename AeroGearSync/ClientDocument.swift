import Foundation

public class ClientDocument<T>: Document<T>, Printable {
    
    public let clientId: String
    
    public init(id: String, clientId: String, content: T) {
        self.clientId = clientId
        super.init(id: id, content: content)
    }

    public override var description: String {
        return "ClientDocument[clientId=\(clientId), documentId=\(super.id), content=\(super.content)]"
    }
    
}
