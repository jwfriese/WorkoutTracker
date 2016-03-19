import Foundation

public class LiftSetSerializer {
    public init() { }
    
    public func serialize(liftSet: LiftSet) -> [String : AnyObject] {
        var liftSetDictionary = [String : AnyObject]()
        liftSetDictionary["weight"] = liftSet.performedWeight
        liftSetDictionary["reps"] = liftSet.performedReps
        
        if let targetWeight = liftSet.targetWeight {
            liftSetDictionary["targetWeight"] = targetWeight
        }
        
        if let targetReps = liftSet.targetReps {
            liftSetDictionary["targetReps"] = targetReps
        }
        
        return liftSetDictionary
    }
}
