import Foundation

public protocol DataStore {
    func saveShadowDocument(shadowDocument: ShadowDocument)
    func getShadowDocument(documentId: String, clientId: String)
    
    func saveBackupShadowDocument(backupShadowDocument: BackupShadowDocument)
    func getBackupShadowDocument(documentId: String, clientId: String)
    
    func saveEdits(edit: Edit)
    func getEdits(documentId: String, clientId: String) -> NSMutableArray
    func removeEdit(edit: Edit)
    func removeEdits(documentId: String, clientId: String)
}
