
public struct DiffMatchPatchDiff: Diff {
    
    public let operation: Operation
    public let text: String
    
    public enum Operation : String {
        case Add = "ADD"
        case Delete = "DELETE"
        case Unchanged = "UNCHANGED"
    }
    
    public init(operation: Operation, text: String) {
        self.operation = operation
        self.text = text
    }
}