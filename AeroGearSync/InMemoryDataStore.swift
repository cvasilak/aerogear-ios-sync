/*
* JBoss, Home of Professional Open Source.
* Copyright Red Hat, Inc., and individual contributors
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation

public class InMemoryDataStore<T, E: Edit>: DataStore {
    
    private var documents = Dictionary<Key, ClientDocument<T>>()
    private var shadows = Dictionary<Key, ShadowDocument<T>>()
    private var backups = Dictionary<Key, BackupShadowDocument<T>>()
    private var edits = Dictionary<Key, [E]?>()
    
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
    
    public func saveEdits(edit: E) {
        let key = InMemoryDataStore.key(edit.documentId, edit.clientId)
        if var pendingEdits = self.edits[key] {
            pendingEdits!.append(edit)
            self.edits.updateValue(pendingEdits, forKey: key)
        } else {
            self.edits.updateValue([edit], forKey: key)
        }
    }
    
    public func getEdits(documentId: String, clientId: String) -> [E]? {
        return edits[InMemoryDataStore.key(documentId, clientId)]?
    }
    
    public func removeEdit(edit: E) {
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
