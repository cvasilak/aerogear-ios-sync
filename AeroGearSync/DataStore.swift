import Foundation

public protocol DataStore {
    
    func saveShadowDocument<T>(shadowDocument: ShadowDocument<T>)
    func getShadowDocument(documentId: String, clientId: String)
    
    func saveBackupShadowDocument<T>(backupShadowDocument: BackupShadowDocument<T>)
    func getBackupShadowDocument(documentId: String, clientId: String)
    
    func saveEdits(edit: Edit)
    func getEdits(documentId: String, clientId: String) -> NSMutableArray
    func removeEdit(edit: Edit)
    func removeEdits(documentId: String, clientId: String)
    
}
