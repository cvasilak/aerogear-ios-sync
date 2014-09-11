import Foundation

public protocol ClientSynchronizer {
    
    typealias ContentType
    
    func patchShadow(edit: Edit, shadowDocument: ShadowDocument<ContentType>)
    
    func patchDocument(edit: Edit, clientDocument: ClientDocument<ContentType>)
    
    func serverDiff(clientDocument: ClientDocument<ContentType>, shadowDocument: ShadowDocument<ContentType>)
    
    func clientDiff(clientDocument: ClientDocument<ContentType>, shadowDocument: ShadowDocument<ContentType>)
}