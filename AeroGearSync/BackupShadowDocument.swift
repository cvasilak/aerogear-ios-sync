import Foundation

public class BackupShadowDocument<T> {
    public let version: Int
    public let shadowDocument: ShadowDocument<T>
    
    public init(version: Int, shadowDocument: ShadowDocument<T>) {
        self.version = version
        self.shadowDocument = shadowDocument
    }
}
