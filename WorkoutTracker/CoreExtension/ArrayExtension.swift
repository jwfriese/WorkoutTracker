import Foundation

extension Array {
    public func lastSatisfyingPredicate(predicate: Element -> Bool) -> Element? {
        return filter({ predicate($0) }).last
    }
}
