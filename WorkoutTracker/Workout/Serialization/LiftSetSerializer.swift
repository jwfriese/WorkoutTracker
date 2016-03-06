import Foundation

public class LiftSetSerializer {
    public init() { }
    
    public func serialize(liftSet: LiftSet) -> [String : AnyObject] {
        return ["weight" : liftSet.weight, "reps" : liftSet.reps]
    }
}
