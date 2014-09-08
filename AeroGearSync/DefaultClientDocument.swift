import Foundation

public class DefaultClientDocument<T>: ClientDocument {
    
    public let id: String
    public let clientId: String
    public let content: T
    
    public init(id: String, clientId: String, content: T) {
        self.id = id
        self.clientId = clientId
        self.content = content
    }
    
    deinit {
        println("Destroying DefaultClientDocument")
    }
    
}
