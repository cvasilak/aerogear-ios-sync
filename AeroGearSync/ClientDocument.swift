import Foundation

public class ClientDocument<T>: Document<T> {
    
    public let clientId: String
    
    public init(id: String, clientId: String, content: T) {
        self.clientId = clientId
        super.init(id: id, content: content)
    }
    
}
