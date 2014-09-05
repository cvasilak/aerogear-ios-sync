import Foundation

public protocol ShadowDocument {
    var serverVersion: UInt64 { get }
    var clientVersion: UInt64 { get }
    var clientDocument: ClientDocument { get }
}
