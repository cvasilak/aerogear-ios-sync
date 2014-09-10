import Foundation

public protocol ClientSynchronizer {
    func patchShadow<T, S: ShadowDocument<T>>(edit: Edit, shadowDocument: S)
    func patchDocument<T, C: ClientDocument<T>>(edit: Edit, clientDocument: C)
    func serverDiff<T, C: ClientDocument<T>, S: ShadowDocument<T>>(clientDocument: C, shadowDocument: S)
    func clientDiff<T, C: ClientDocument<T>, S: ShadowDocument<T>>(clientDocument: C, shadowDocument: S)
}