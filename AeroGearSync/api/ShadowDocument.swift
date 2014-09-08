import Foundation

public protocol ShadowDocument {
    var serverVersion: UInt64 { get }
    var clientVersion: UInt64 { get }
    
    typealias Doc: ClientDocument
    var clientDocument: Doc { get }
}
