import Foundation

public class InMemoryDataStore<T>: DataStore {
    
    typealias ContentType = T
    var documents = Dictionary<Key, ClientDocument<T>>()
    var shadows = Dictionary<Key, ShadowDocument<T>>()
    var backups = Dictionary<Key, BackupShadowDocument<T>>()
    var edits = Dictionary<Key, [Edit]>()
    
    public init() {
    }

    public func saveClientDocument(document: ClientDocument<T>) {
        let key = InMemoryDataStore.key(document.id, document.clientId)
        documents[key] = document
    }

    public func getClientDocument(documentId: String, clientId: String) -> ClientDocument<T>? {
        return documents[InMemoryDataStore.key(documentId, clientId)]
    }
    
    public func saveShadowDocument(shadow: ShadowDocument<T>) {
        let key = InMemoryDataStore.key(shadow.clientDocument.id, shadow.clientDocument.clientId)
        shadows[key] = shadow
    }
    
    public func getShadowDocument(documentId: String, clientId: String) -> ShadowDocument<T>? {
        return shadows[InMemoryDataStore.key(documentId, clientId)]
    }
    
    public func saveBackupShadowDocument(backup: BackupShadowDocument<T>) {
        let key = InMemoryDataStore.key(backup.shadowDocument.clientDocument.id, backup.shadowDocument.clientDocument.clientId)
        backups[key] = backup
    }
    
    public func getBackupShadowDocument(documentId: String, clientId: String) -> BackupShadowDocument<T>? {
        return backups[InMemoryDataStore.key(documentId, clientId)]
    }
    
    public func saveEdits(edit: Edit) {
        let key = InMemoryDataStore.key(edit.documentId, edit.clientId)
        var pendingEdits = edits[key] ?? []
        pendingEdits.append(edit)
        edits[key] = pendingEdits
    }
    
    public func getEdits(documentId: String, clientId: String) -> [Edit]? {
        return edits[InMemoryDataStore.key(documentId, clientId)]
    }
    
    public func removeEdit(edit: Edit) {
        let key = InMemoryDataStore.key(edit.documentId, edit.clientId)
        if var pendingEdits = edits[key] {
            let count = pendingEdits.count
            for i in 0..<count {
                if edit == pendingEdits[i] {
                    pendingEdits.removeAtIndex(i)
                }
            }
            edits[key] = pendingEdits
        }
    }
    
    public func removeEdits(documentId: String, clientId: String) {
        edits.removeValueForKey(Key(id: documentId, clientId: clientId))
    }

    private class func key(id: String, _ clientId: String) -> Key {
        return Key(id: id, clientId: clientId)
    }
    
}

func ==(lhs: Key, rhs: Key) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

struct Key: Hashable {
    let id: String
    let clientId: String
    
    init(id: String, clientId: String) {
        self.id = id
        self.clientId = clientId
    }
        
    var hashValue: Int {
        get {
            return "\(id),\(clientId)".hashValue
        }
    }
        
}
