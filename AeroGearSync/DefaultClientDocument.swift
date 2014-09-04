import Foundation

public class DefaultClientDocument: ClientDocument {
    
    public let id: String
    public let clientId: String
    public let content: String
    
    public init(id: String, clientId: String, content: String) {
        self.id = id
        self.clientId = clientId
        self.content = content
    }
    
}
