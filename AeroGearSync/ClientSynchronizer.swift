import Foundation

public protocol ClientSynchronizer {
    
    typealias ContentType
    
    func patchShadow(edit: Edit, shadow: ShadowDocument<ContentType>)
    
    func patchDocument(edit: Edit, clientDocument: ClientDocument<ContentType>)
    
    func clientDiff(clientDocument: ClientDocument<ContentType>, shadow: ShadowDocument<ContentType>)
    
    func serverDiff(serverDocument: ClientDocument<ContentType>, shadow: ShadowDocument<ContentType>) -> Edit
}