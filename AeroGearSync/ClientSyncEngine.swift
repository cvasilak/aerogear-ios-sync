import Foundation

public class ClientSyncEngine<CS:ClientSynchronizer, D:DataStore where CS.ContentType == D.ContentType> {
    
    let synchronizer: CS
    let dataStore: D
    
    public init(synchronizer: CS, dataStore: D) {
        self.synchronizer = synchronizer
        self.dataStore = dataStore
    }

    public func addDocument(clientDocument: ClientDocument<D.ContentType>) {
        dataStore.saveClientDocument(clientDocument)
        let shadow = ShadowDocument(clientVersion: 0, serverVersion: 0, clientDocument: clientDocument)
        dataStore.saveShadowDocument(shadow)
        dataStore.saveBackupShadowDocument(BackupShadowDocument(version: 0, shadowDocument: shadow))
    }

    public func diff(clientDocument: ClientDocument<CS.ContentType>) -> PatchMessage? {
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

    private func diffAgainstShadow(clientDocument: ClientDocument<CS.ContentType>, shadow: ShadowDocument<CS.ContentType>) -> Edit {
        return synchronizer.serverDiff(clientDocument, shadow: shadow)
    }

    private func incrementServerVersion(shadow: ShadowDocument<CS.ContentType>) -> ShadowDocument<CS.ContentType> {
        return ShadowDocument(clientVersion: shadow.clientVersion,
            serverVersion: shadow.serverVersion + 1,
            clientDocument: shadow.clientDocument)
    }

}

