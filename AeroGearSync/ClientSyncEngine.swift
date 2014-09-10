import Foundation

public class ClientSyncEngine<T> {
    
    let synchronizer: ClientSynchronizer
    
    public init(synchronizer: ClientSynchronizer) {
        self.synchronizer = synchronizer
    }
    
}
