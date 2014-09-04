import Foundation

public class ClientSyncEngine<String> {
    
    let synchronizer: ClientSynchronizer
    let datastore: DataStore
    
    public init(synchronizer: ClientSynchronizer, datastore: DataStore) {
        self.synchronizer = synchronizer
        self.datastore = datastore
    }
    
}
