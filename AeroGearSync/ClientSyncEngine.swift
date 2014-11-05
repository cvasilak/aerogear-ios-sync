import Foundation

/**
The client side implementation of a Differential Synchronization Engine.
*/
public class ClientSyncEngine<CS:ClientSynchronizer, D:DataStore where CS.T == D.T> {
    
    typealias T = CS.T
    let synchronizer: CS
    let dataStore: D
    var callbacks = Dictionary<String, (ClientDocument<T>) -> ()>()

    public init(synchronizer: CS, dataStore: D) {
        self.synchronizer = synchronizer
        self.dataStore = dataStore
    }

    public func addDocument(clientDocument: ClientDocument<T>, callback: ClientDocument<T> -> ()) {
        dataStore.saveClientDocument(clientDocument)
        let shadow = ShadowDocument(clientVersion: 0, serverVersion: 0, clientDocument: clientDocument)
        dataStore.saveShadowDocument(shadow)
        dataStore.saveBackupShadowDocument(BackupShadowDocument(version: 0, shadowDocument: shadow))
        callbacks[clientDocument.id] = callback
    }

    public func diff(clientDocument: ClientDocument<T>) -> PatchMessage? {
        if let shadow = dataStore.getShadowDocument(clientDocument.id, clientId: clientDocument.clientId) {
            let edit = diffAgainstShadow(clientDocument, shadow: shadow)
            dataStore.saveEdits(edit)
            let patched = synchronizer.patchShadow(edit, shadow: shadow)
            dataStore.saveShadowDocument(incrementClientVersion(patched))
            let edits = dataStore.getEdits(clientDocument.id, clientId: clientDocument.clientId)
            return PatchMessage(id: clientDocument.id, clientId: clientDocument.clientId, edits: edits!)
        }
        return Optional.None
    }

    public func patch(patchMessage: PatchMessage) {
        if let patched = patchShadow(patchMessage) {
            let callback = callbacks[patchMessage.documentId]!
            callback(patchDocument(patched)!)
            dataStore.saveBackupShadowDocument(BackupShadowDocument(version: patched.clientVersion, shadowDocument: patched))
        }
    }

    private func patchShadow(patchMessage: PatchMessage) -> ShadowDocument<T>? {
        if var shadow = dataStore.getShadowDocument(patchMessage.documentId, clientId: patchMessage.clientId) {
            for edit in patchMessage.edits {
                if (edit.clientVersion < shadow.clientVersion && !self.isSeedVersion(edit)) {
                    shadow = restoreBackup(shadow, edit: edit)!
                    continue
                }
                if edit.serverVersion < shadow.serverVersion {
                    dataStore.removeEdit(edit)
                    continue
                }
                if edit.serverVersion == shadow.serverVersion && edit.clientVersion == shadow.clientVersion || isSeedVersion(edit) {
                    let patched = synchronizer.patchShadow(edit, shadow: shadow)
                    dataStore.removeEdit(edit)
                    if isSeedVersion(edit) {
                        shadow = saveShadow(seededShadowDocument(patched))
                    } else {
                        shadow = saveShadow(incrementServerVersion(patched))
                    }
                }
            }
            return shadow
        }
        return Optional.None
    }

    private func seededShadowDocument(from: ShadowDocument<T>) -> ShadowDocument<T> {
        return ShadowDocument(clientVersion: 0, serverVersion: from.serverVersion, clientDocument: from.clientDocument)
    }

    private func incrementClientVersion(shadow: ShadowDocument<T>) -> ShadowDocument<T> {
        return ShadowDocument(clientVersion: shadow.clientVersion + 1, serverVersion: shadow.serverVersion, clientDocument: shadow.clientDocument)
    }

    private func incrementServerVersion(shadow: ShadowDocument<T>) -> ShadowDocument<T> {
        return ShadowDocument(clientVersion: shadow.clientVersion, serverVersion: shadow.serverVersion + 1, clientDocument: shadow.clientDocument)
    }

    private func saveShadow(shadow: ShadowDocument<T>) -> ShadowDocument<T> {
        dataStore.saveShadowDocument(shadow)
        return shadow
    }

    private func restoreBackup(shadow: ShadowDocument<T>, edit: Edit) -> ShadowDocument<T>? {
        if let backup = dataStore.getBackupShadowDocument(edit.documentId, clientId: edit.clientId) {
            if edit.clientVersion == backup.version {
                let patchedShadow = synchronizer.patchShadow(edit, shadow: ShadowDocument(clientVersion: shadow.clientVersion, serverVersion: shadow.serverVersion, clientDocument: shadow.clientDocument))
                dataStore.removeEdits(edit.documentId, clientId: edit.clientId)
                dataStore.saveShadowDocument(patchedShadow)
                return patchedShadow
            }
        }
        return Optional.None
    }

    private func isSeedVersion(edit: Edit) -> Bool {
        return edit.clientVersion == -1
    }

    private func diffAgainstShadow(clientDocument: ClientDocument<T>, shadow: ShadowDocument<T>) -> Edit {
        return synchronizer.serverDiff(clientDocument, shadow: shadow)
    }

    private func patchDocument(shadow: ShadowDocument<T>) -> ClientDocument<T>? {
        if let document = dataStore.getClientDocument(shadow.clientDocument.id, clientId: shadow.clientDocument.clientId) {
            let edit = synchronizer.clientDiff(document, shadow: shadow)
            let patched = synchronizer.patchDocument(edit, clientDocument: document)
            dataStore.saveClientDocument(patched)
            dataStore.saveBackupShadowDocument(BackupShadowDocument(version: shadow.clientVersion, shadowDocument: shadow))
            return patched
        }
        return Optional.None
    }

}

