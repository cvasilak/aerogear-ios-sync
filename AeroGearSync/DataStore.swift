import Foundation

public protocol DataStore {
    
    typealias ContentType
    
    func saveShadowDocument(shadowDocument: ShadowDocument<ContentType>)
    func getShadowDocument(documentId: String, clientId: String) -> ShadowDocument<ContentType>?
    
    func saveBackupShadowDocument(backupShadowDocument: BackupShadowDocument<ContentType>)
    func getBackupShadowDocument(documentId: String, clientId: String) -> BackupShadowDocument<ContentType>?
    
    func saveEdits(edit: Edit)
    func getEdits(documentId: String, clientId: String) -> [Edit]?
    func removeEdit(edit: Edit)
    func removeEdits(documentId: String, clientId: String)
    
}
