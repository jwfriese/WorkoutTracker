import Foundation

public class Lift {
    public var name: String!
    public private(set) var sets: [LiftSet] = []
    
    public init(withName name: String) {
        self.name = name
    }
    
    public func addSet(set: LiftSet) {
        sets.append(set)
    }
}