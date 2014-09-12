import Foundation

public class Diff {
    
    let operation: Operation
    let text: String
    
    public init(operation: Operation, text: String) {
        self.operation = operation
        self.text = text
    }
}
