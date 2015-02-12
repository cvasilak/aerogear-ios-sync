import AeroGearSync

public struct DiffMatchPatchDiff: Difference {
    
    public let operation: Operation
    public let text: String
    
    public enum Operation : String, Printable {
        case Add = "ADD"
        case Delete = "DELETE"
        case Unchanged = "UNCHANGED"
        public var description : String {
            return self.rawValue
        }
    }
    
    public init(operation: Operation, text: String) {
        self.operation = operation
        self.text = text
    }
    
    public var description: String {
        return "DiffMatchPatchDiff[operation=\(operation), text=\(text)]"
    }
}