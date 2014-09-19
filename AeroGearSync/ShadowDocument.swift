import Foundation

public class ShadowDocument<T> {
    public let clientVersion: Int
    public let serverVersion: Int
    public let clientDocument: ClientDocument<T>

    public init(clientVersion: Int, serverVersion: Int, clientDocument: ClientDocument<T>) {
        self.clientVersion = clientVersion
        self.serverVersion = serverVersion
        self.clientDocument = clientDocument
    }
}
