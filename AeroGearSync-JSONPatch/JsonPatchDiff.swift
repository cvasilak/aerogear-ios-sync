import AeroGearSync

public struct JsonPatchDiff: Difference {
    
    public let operation: Operation
    public let path: String
    public let value: AnyObject?
    
    public enum Operation : String, Printable {
        case Add = "add"
        case Copy = "copy"
        case Remove = "remove"
        case Move = "move"
        case Replace = "replace"
        case Test = "test"
        // not in spec! it seems to be a hack in JSONTools to get back patched document
        case Get = "_get"
        public var description : String {
            return self.rawValue
        }
    }
    
    public init(operation: Operation, path: String, value: AnyObject?) {
        self.operation = operation
        self.path = path
        self.value = value
    }
    
    public init(operation: Operation) {
        self.operation = operation
        self.path = ""
        self.value = nil
    }
    
    public var description: String {
        return "JsonPatchDiff[operation=\(operation), path=\(path) value=\(value)]"
    }
}