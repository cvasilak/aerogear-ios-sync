import Foundation

public class InMemoryDataStore: DataStore {
    
    //var shadows = Dictionary<String, ShadowDocument>()
    
    public init() {
    }
    
    public func saveShadowDocument<T>(shadowDocument: ShadowDocument<T>) {
        //shadows[shadowDocument.clientDocument.id] = shadowDocument
    }
    
    public func getShadowDocument(documentId: String, clientId: String) {
    }
    
    public func saveBackupShadowDocument<T>(backupShadowDocument: BackupShadowDocument<T>) {
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
