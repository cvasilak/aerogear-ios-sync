import Foundation

public struct Edit: Equatable, Printable {
    public let clientId: String
    public let documentId: String
    public let clientVersion: Int
    public let serverVersion: Int
    public let checksum: String
    public let diffs: Array<Edit.Diff>

    public init(clientId: String, documentId: String, clientVersion: Int, serverVersion: Int, checksum: String, diffs: Array<Edit.Diff>) {
        self.clientId = clientId
        self.documentId = documentId
        self.clientVersion = clientVersion
        self.serverVersion = serverVersion
        self.checksum = checksum
        self.diffs = diffs
    }

    public enum Operation : String, Printable {
        case Add = "ADD"
        case Delete = "DELETE"
        case Unchanged = "UNCHANGED"
        public var description : String {
            return self.rawValue
        }
    }
    
    public struct Diff: Printable {
    
        public let operation: Operation
        public let text: String
    
        public init(operation: Operation, text: String) {
            self.operation = operation
            self.text = text
        }

        public var description: String {
            return "Diff[operation=\(operation), text=\(text)]"
        }
    }

    public var description: String {
        return "Edit[clientId=\(clientId), documentId=\(documentId), clientVersion=\(clientVersion), serverVersion=\(serverVersion), checksum=\(checksum), diffs=\(diffs)]"
    }
}

public func ==(lhs: Edit, rhs: Edit) -> Bool {
    return lhs.clientId == rhs.clientId &&
        lhs.documentId == rhs.documentId &&
        lhs.serverVersion == rhs.serverVersion &&
        lhs.checksum == rhs.checksum &&
        lhs.diffs.count == rhs.diffs.count
}

