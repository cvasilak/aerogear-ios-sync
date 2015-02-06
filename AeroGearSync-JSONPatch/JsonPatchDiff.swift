
public struct JsonPatchDiff: Difference {
    
    public let operation: Operation
    public let path: String
    public let value: AnyObject?
    
    public enum Operation : String {
        case Add = "add"
        case Copy = "copy"
        case Remove = "remove"
        case Move = "move"
        case Replace = "replace"
        case Test = "test"
        // not in spec! it seems to be a hack in JSONTools to get back patched document
        case Get = "_get"
    }
    
    public init(operation: Operation, path: String, value: AnyObject?) {
        self.operation = operation
        self.path = path
        self.value = value
    }
}