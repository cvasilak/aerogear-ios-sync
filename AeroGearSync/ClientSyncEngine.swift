import Foundation

public class ClientSyncEngine<CS:ClientSynchronizer, D:DataStore where CS.T == D.T> {
    
    typealias T = CS.T
    let synchronizer: CS
    let dataStore: D
    
    public init(synchronizer: CS, dataStore: D) {
        self.synchronizer = synchronizer
        self.dataStore = dataStore
    }

    public func addDocument(clientDocument: ClientDocument<T>) {
        dataStore.saveClientDocument(clientDocument)
        let shadow = ShadowDocument(clientVersion: 0, serverVersion: 0, clientDocument: clientDocument)
        dataStore.saveShadowDocument(shadow)
        dataStore.saveBackupShadowDocument(BackupShadowDocument(version: 0, shadowDocument: shadow))
    }

    public func diff(clientDocument: ClientDocument<T>) -> PatchMessage? {
        if let shadow = dataStore.getShadowDocument(clientDocument.id, clientId: clientDocument.clientId) {
            let edit = diffAgainstShadow(clientDocument, shadow: shadow)
            dataStore.saveEdits(edit)
            let patched = synchronizer.patchShadow(edit, shadow: shadow)
            dataStore.saveShadowDocument(incrementServerVersion(patched))
            let edits = dataStore.getEdits(clientDocument.id, clientId: clientDocument.clientId)
            return PatchMessage(id: clientDocument.id, clientId: clientDocument.clientId, edits: edits!)
        }
        return Optional.None
    }

    public func patch(patchMessage: PatchMessage) {
        if let patched = patchShadow(patchMessage) {
            patchDocument(patched)
            dataStore.saveBackupShadowDocument(BackupShadowDocument(version: patched.clientVersion, shadowDocument: patched))
        }
    }

    private func patchShadow(patchMessage: PatchMessage) -> ShadowDocument<T>? {
        if let shadow = dataStore.getShadowDocument(patchMessage.documentId, clientId: patchMessage.clientId) {
            return patchMessage.edits.reduce(shadow) { (shadow, edit) -> ShadowDocument<T> in
                if (edit.clientVersion < shadow.clientVersion && !self.isSeedVersion(edit)) {
                    return self.restoreBackup(shadow, edit: edit)!
                }
                if edit.serverVersion < shadow.serverVersion {
                    self.dataStore.removeEdit(edit)
                    return shadow
                }
                if edit.serverVersion == shadow.serverVersion && edit.clientVersion == shadow.clientVersion || self.isSeedVersion(edit) {
                    let patchedShadow = self.synchronizer.patchShadow(edit, shadow: shadow)
                    self.dataStore.removeEdit(edit)
                    let serverVersion = self.isSeedVersion(edit) ? patchedShadow.serverVersion:patchedShadow.serverVersion + 1
                    let newShadow = ShadowDocument(clientVersion: 0, serverVersion: serverVersion, clientDocument: patchedShadow.clientDocument)
                    self.dataStore.saveShadowDocument(newShadow)
                    return newShadow
                }
                return shadow
            }
        }
        return Optional.None
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

    private func incrementServerVersion(shadow: ShadowDocument<T>) -> ShadowDocument<T> {
        return ShadowDocument(clientVersion: shadow.clientVersion, serverVersion: shadow.serverVersion + 1, clientDocument: shadow.clientDocument)
    }

    private func patchDocument(shadow: ShadowDocument<T>) -> Document<T>? {
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

