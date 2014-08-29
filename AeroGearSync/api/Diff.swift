import Foundation

protocol Diff {
    func text() -> String
    func operation() -> Operation
}
