import Foundation

public class InMemoryDataStore<T>: DataStore {
    
    private var documents = Dictionary<Key, ClientDocument<T>>()
    private var shadows = Dictionary<Key, ShadowDocument<T>>()
    private var backups = Dictionary<Key, BackupShadowDocument<T>>()
    private var edits = Dictionary<Key, [Edit]?>()
    
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
        if var pendingEdits = self.edits[key] {
            pendingEdits!.append(edit)
            self.edits.updateValue(pendingEdits, forKey: key)
        } else {
            self.edits.updateValue([edit], forKey: key)
        }
    }
    
    public func getEdits(documentId: String, clientId: String) -> [Edit]? {
        return edits[InMemoryDataStore.key(documentId, clientId)]?
    }
    
    public func removeEdit(edit: Edit) {
        let key = InMemoryDataStore.key(edit.documentId, edit.clientId)
        if var pendingEdits = edits[key]? {
            edits.updateValue(pendingEdits.filter { edit.serverVersion != $0.serverVersion }, forKey: key)
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
