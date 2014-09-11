import Foundation

public class DiffMatchPatchSynchronizer<T>: ClientSynchronizer {

    typealias ContentType = T
    
    public init() {
        
    }

    public func clientDiff(clientDocument: ClientDocument<T>, shadowDocument: ShadowDocument<T>) {
    }

    public func patchDocument(edit: Edit, clientDocument: ClientDocument<T>) {
    }

    public func patchShadow(edit: Edit, shadowDocument: ShadowDocument<T>) {
    }

    public func serverDiff(clientDocument: ClientDocument<T>, shadowDocument: ShadowDocument<T>) {
    }

}
