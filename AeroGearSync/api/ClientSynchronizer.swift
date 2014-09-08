import Foundation

public protocol ClientSynchronizer {
    func patchShadow<S: ShadowDocument>(edit: Edit, shadowDocument: S)
    func patchDocument<C: ClientDocument>(edit: Edit, clientDocument: C)
    func serverDiff<C: ClientDocument, S: ShadowDocument>(clientDocument: C, shadowDocument: S)
    func clientDiff<C: ClientDocument, S: ShadowDocument>(clientDocument: C, shadowDocument: S)
}