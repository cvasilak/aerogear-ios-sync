import Foundation

public protocol ClientSynchronizer {
    
    typealias ContentType
    
    func patchShadow(edit: Edit, shadowDocument: ShadowDocument<ContentType>)
    
    func patchDocument(edit: Edit, clientDocument: ClientDocument<ContentType>)
    
    func clientDiff(clientDocument: ClientDocument<ContentType>, shadowDocument: ShadowDocument<ContentType>)
    
    func serverDiff(serverDocument: ClientDocument<ContentType>, shadowDocument: ShadowDocument<ContentType>) -> PatchMessage
}