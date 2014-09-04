import Foundation

public class DefaultShadowDocument: ShadowDocument {
    
    public let serverVersion, clientVersion: Int64
    public let clientDocument: ClientDocument
    
    public init(serverVersion: Int64, clientVersion: Int64, clientDocument: ClientDocument) {
        self.serverVersion = serverVersion
        self.clientVersion = clientVersion
        self.clientDocument = clientDocument
    }
    
}
