import Foundation

public class BackupShadowDocument<T> {
    public let version: UInt64
    public let shadowDocument: ShadowDocument<T>
    
    public init(version: UInt64, shadowDocument: ShadowDocument<T>) {
        self.version = version
        self.shadowDocument = shadowDocument
    }
}
