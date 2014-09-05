import Foundation

public class DefaultShadowDocument: ShadowDocument {
    
    public let serverVersion, clientVersion: UInt64
    public let clientDocument: ClientDocument
    
    public init(serverVersion: UInt64, clientVersion: UInt64, clientDocument: ClientDocument) {
        self.serverVersion = serverVersion
        self.clientVersion = clientVersion
        self.clientDocument = clientDocument
    }
    
}
