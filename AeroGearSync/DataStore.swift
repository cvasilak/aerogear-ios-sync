import Foundation

public protocol DataStore {
    
    typealias T
    typealias D

    func saveClientDocument(clientDocument: ClientDocument<T>)
    func getClientDocument(documentId: String, clientId: String) -> ClientDocument<T>?
    
    func saveShadowDocument(shadowDocument: ShadowDocument<T>)
    func getShadowDocument(documentId: String, clientId: String) -> ShadowDocument<T>?
    
    func saveBackupShadowDocument(backupShadowDocument: BackupShadowDocument<T>)
    func getBackupShadowDocument(documentId: String, clientId: String) -> BackupShadowDocument<T>?
    
    func saveEdits(edit: D)
    func getEdits(documentId: String, clientId: String) -> [D]?
    func removeEdit(edit: D)
    func removeEdits(documentId: String, clientId: String)
    
}
