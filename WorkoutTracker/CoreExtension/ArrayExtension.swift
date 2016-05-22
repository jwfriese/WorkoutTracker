import Foundation

extension Array {
    func lastSatisfyingPredicate(predicate: Element -> Bool) -> Element? {
        return filter({ predicate($0) }).last
    }
}
