import Foundation

public protocol Edit: Equatable, Printable {

    typealias D
    
    var clientId: String {get}
    var documentId: String {get}
    var clientVersion: Int {get}
    var serverVersion: Int {get}
    var checksum: String {get}
    var diffs: Array<D> {get}
}


