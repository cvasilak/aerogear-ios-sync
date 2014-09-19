import Foundation

public protocol ClientSynchronizer {
    
    typealias T
    
    func patchShadow(edit: Edit, shadow: ShadowDocument<T>) -> ShadowDocument<T>
    
    func patchDocument(edit: Edit, clientDocument: ClientDocument<T>) -> ClientDocument<T>
    
    func clientDiff(clientDocument: ClientDocument<T>, shadow: ShadowDocument<T>) -> Edit
    
    func serverDiff(serverDocument: ClientDocument<T>, shadow: ShadowDocument<T>) -> Edit
}