import Foundation

public class Document<T> {
    
    public let id: String
    public let content: T
    
    init(id: String, content: T) {
        self.id = id
        self.content = content
    }
    
}
