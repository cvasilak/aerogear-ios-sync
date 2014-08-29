import Foundation

protocol ClientSynchronizer {
    func patchShadow(edit: Edit, shadowDocument: ShadowDocument)
    func patchDocument(edit: Edit, clientDocument: ClientDocument)
    func serverDiff(document: Document, shadowDocument: ShadowDocument)
    func clientDiff(document: Document, shadowDocument: ShadowDocument)
}