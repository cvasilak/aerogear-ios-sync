import Foundation

public class BackupShadowDocument<T>: Printable {
    public let version: Int
    public let shadowDocument: ShadowDocument<T>
    
    public init(version: Int, shadowDocument: ShadowDocument<T>) {
        self.version = version
        self.shadowDocument = shadowDocument
    }

    public var description: String {
        return "BackupShadowDocument[version=\(version), shadowDocument=\(shadowDocument)]"
    }
}
