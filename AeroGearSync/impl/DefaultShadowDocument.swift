import Foundation

public class DefaultShadowDocument<T:ClientDocument>: ShadowDocument {
    
    public let serverVersion, clientVersion: UInt64
    public let clientDocument: T
    
    public init(serverVersion: UInt64, clientVersion: UInt64, clientDocument: T) {
        self.serverVersion = serverVersion
        self.clientVersion = clientVersion
        self.clientDocument = clientDocument
    }
    
}
