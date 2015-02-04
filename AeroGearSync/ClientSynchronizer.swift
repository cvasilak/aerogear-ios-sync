import Foundation

public protocol ClientSynchronizer {
    
    typealias T
    typealias D: Edit

    func patchShadow(edit: D, shadow: ShadowDocument<T>) -> ShadowDocument<T>
    
    func patchDocument(edit: D, clientDocument: ClientDocument<T>) -> ClientDocument<T>
    
    func clientDiff(clientDocument: ClientDocument<T>, shadow: ShadowDocument<T>) -> D
    
    func serverDiff(serverDocument: ClientDocument<T>, shadow: ShadowDocument<T>) -> D
}