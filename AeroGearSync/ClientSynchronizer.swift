import Foundation

public protocol ClientSynchronizer {
    
    typealias ContentType
    
    func patchShadow(edit: Edit, shadow: ShadowDocument<ContentType>) -> ShadowDocument<ContentType>
    
    func patchDocument(edit: Edit, clientDocument: ClientDocument<ContentType>) -> ClientDocument<ContentType>
    
    func clientDiff(clientDocument: ClientDocument<ContentType>, shadow: ShadowDocument<ContentType>) -> Edit
    
    func serverDiff(serverDocument: ClientDocument<ContentType>, shadow: ShadowDocument<ContentType>) -> Edit
}