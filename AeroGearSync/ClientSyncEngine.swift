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
        let optionalShadow = dataStore.getShadowDocument(clientDocument.id, clientId: clientDocument.clientId)
        if let shadow = optionalShadow {
            let edit = diffAgainstShadow(clientDocument, shadow: shadow)
            dataStore.saveEdits(edit)
            let patched = synchronizer.patchShadow(edit, shadow: shadow)
            dataStore.saveShadowDocument(incrementServerVersion(patched))
            let edits = dataStore.getEdits(clientDocument.id, clientId: clientDocument.clientId)
            return PatchMessage(id: clientDocument.id, clientId: clientDocument.clientId, edits: edits!)
        } else {
            return Optional.None
        }
    }

    public func patch(patchMessage: PatchMessage) {
        let patched = patchShadow(patchMessage)
        patchDocument(patched!)
        dataStore.saveBackupShadowDocument(BackupShadowDocument(version: patched!.clientVersion, shadowDocument: patched!))
    }

    private func patchShadow(patchMessage: PatchMessage) -> ShadowDocument<T>? {
        var optionalShadow = dataStore.getShadowDocument(patchMessage.documentId, clientId: patchMessage.clientId)
        if var shadow = optionalShadow {
            for edit in patchMessage.edits {
                if (edit.clientVersion < shadow.clientVersion && !isSeedVersion(edit)) {
                    shadow = restoreBackup(shadow, edit: edit)!
                    continue
                }
                if edit.serverVersion < shadow.serverVersion {
                    dataStore.removeEdit(edit)
                    continue
                }
                if edit.serverVersion == shadow.serverVersion && edit.clientVersion == shadow.clientVersion || isSeedVersion(edit) {
                    let patchedShadow = synchronizer.patchShadow(edit, shadow: shadow)
                    dataStore.removeEdit(edit)
                    if isSeedVersion(edit) {
                        shadow = ShadowDocument(clientVersion: 0, serverVersion: patchedShadow.serverVersion, clientDocument: patchedShadow.clientDocument)
                    } else {
                        shadow = ShadowDocument(clientVersion: 0, serverVersion: patchedShadow.serverVersion + 1, clientDocument: patchedShadow.clientDocument)
                    }
                    dataStore.saveShadowDocument(shadow)
                }
            }
            return shadow
        } else {
            return Optional.None
        }
    }

    private func restoreBackup(shadow: ShadowDocument<T>, edit: Edit) -> ShadowDocument<T>? {
        let optionalBackup = dataStore.getBackupShadowDocument(edit.documentId, clientId: edit.clientId)
        if let backup = optionalBackup {
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
        return ShadowDocument(clientVersion: shadow.clientVersion,
            serverVersion: shadow.serverVersion + 1,
            clientDocument: shadow.clientDocument)
    }

    private func patchDocument(shadow: ShadowDocument<T>) -> Document<T>? {
        let optionalDocument = dataStore.getClientDocument(shadow.clientDocument.id, clientId: shadow.clientDocument.clientId)
        if let document = optionalDocument {
            let edit = synchronizer.clientDiff(document, shadow: shadow)
            let patched = synchronizer.patchDocument(edit, clientDocument: document)
            dataStore.saveClientDocument(patched)
            dataStore.saveBackupShadowDocument(BackupShadowDocument(version: shadow.clientVersion, shadowDocument: shadow))
            return patched
        }
        return Optional.None
    }

}

