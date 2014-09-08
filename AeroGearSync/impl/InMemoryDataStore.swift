import Foundation

public class InMemoryDataStore: DataStore {
    
    public init() {
    }
    
    public func saveShadowDocument<S: ShadowDocument>(shadowDocument: S) {
    }
    
    public func getShadowDocument(documentId: String, clientId: String) {
    }
    
    public func saveBackupShadowDocument(backupShadowDocument: BackupShadowDocument) {
    }
    
    public func getBackupShadowDocument(documentId: String, clientId: String) {
    }
    
    public func saveEdits(edit: Edit) {
    }
    
    public func getEdits(documentId: String, clientId: String) -> NSMutableArray {
        return []
    }
    
    public func removeEdit(edit: Edit) {
    }
    
    public func removeEdits(documentId: String, clientId: String) {
    }
    
}
