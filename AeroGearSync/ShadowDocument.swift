import Foundation

public class ShadowDocument<T> {
    public let clientVersion: UInt64
    public let serverVersion: UInt64
    public let clientDocument: ClientDocument<T>

    public init(clientVersion: UInt64, serverVersion: UInt64, clientDocument: ClientDocument<T>) {
        self.clientVersion = clientVersion
        self.serverVersion = serverVersion
        self.clientDocument = clientDocument
    }
}
