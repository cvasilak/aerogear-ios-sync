import Foundation

public protocol ShadowDocument {
    var serverVersion: Int64 { get }
    var clientVersion: Int64 { get }
    var clientDocument: ClientDocument { get }
}
