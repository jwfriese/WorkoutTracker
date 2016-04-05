import Foundation

public class Lift {
    public var name: String!
    public private(set) var sets: [LiftSet] = []
    
    public var workout: Workout?
    public var previousInstance: Lift?
    
    public init(withName name: String) {
        self.name = name
    }
    
    public func addSet(set: LiftSet) {
        sets.append(set)
        set.lift = self
    }
    
    public func isSame(otherLift: Lift) -> Bool {
        return self.name == otherLift.name
    }
}
