import Foundation

public class ClientSyncEngine<T, CS:ClientSynchronizer, D:DataStore> {
    
    typealias ContentType = T
    
    let synchronizer: CS
    let dataStore: D
    
    public init(synchronizer: CS, dataStore: D) {
        self.synchronizer = synchronizer
        self.dataStore = dataStore
    }

    public func addDocument(clientDocument: ClientDocument<D.ContentType>) {
        dataStore.saveClientDocument(clientDocument)
    }

    public func diff(clientDocument: ClientDocument<CS.ContentType>) {
    }

    public func patch() {
    }
}

