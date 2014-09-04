import Foundation

public protocol Diff {
    func text() -> String
    func operation() -> Operation
}
