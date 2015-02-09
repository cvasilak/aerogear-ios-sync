import Foundation

public class ShadowDocument<T>: Printable {
    public let clientVersion: Int
    public let serverVersion: Int
    public let clientDocument: ClientDocument<T>

    public init(clientVersion: Int, serverVersion: Int, clientDocument: ClientDocument<T>) {
        self.clientVersion = clientVersion
        self.serverVersion = serverVersion
        self.clientDocument = clientDocument
    }

    public var description: String {
        return "ShadowDocument[clientVersion=\(clientVersion), serverVersion=\(serverVersion), clientDocument=\(clientDocument)]"
    }
}
