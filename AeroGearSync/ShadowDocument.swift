import Foundation

public class ShadowDocument<T> {
    public let clientVersion: Int64
    public let serverVersion: Int64
    public let clientDocument: ClientDocument<T>

    public init(clientVersion: Int64, serverVersion: Int64, clientDocument: ClientDocument<T>) {
        self.clientVersion = clientVersion
        self.serverVersion = serverVersion
        self.clientDocument = clientDocument
    }
}
