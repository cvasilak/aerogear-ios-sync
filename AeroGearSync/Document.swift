import Foundation

public class Document<T>: Printable {
    
    public let id: String
    public let content: T
    
    init(id: String, content: T) {
        self.id = id
        self.content = content
    }

    public var description: String {
        return "Document[id=\(id), content=\(content)]"
    }
    
}
