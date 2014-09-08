import Foundation

public protocol Document {
    var id: String { get }
    
    typealias T
    var content: T { get }
}
