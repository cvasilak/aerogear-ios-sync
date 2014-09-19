import Foundation

public protocol DataStore {
    
    typealias T

    func saveClientDocument(clientDocument: ClientDocument<T>)
    func getClientDocument(documentId: String, clientId: String) -> ClientDocument<T>?
    
    func saveShadowDocument(shadowDocument: ShadowDocument<T>)
    func getShadowDocument(documentId: String, clientId: String) -> ShadowDocument<T>?
    
    func saveBackupShadowDocument(backupShadowDocument: BackupShadowDocument<T>)
    func getBackupShadowDocument(documentId: String, clientId: String) -> BackupShadowDocument<T>?
    
    func saveEdits(edit: Edit)
    func getEdits(documentId: String, clientId: String) -> [Edit]?
    func removeEdit(edit: Edit)
    func removeEdits(documentId: String, clientId: String)
    
}
