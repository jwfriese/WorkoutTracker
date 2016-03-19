import Foundation

public class LiftSetDeserializer {
    public init() { }
    
    public func deserialize(liftSetDictionary: [String : AnyObject]) -> LiftSet? {
        let weightOptional = liftSetDictionary["weight"] as? Double
        let repsOptional = liftSetDictionary["reps"] as? Int
        let targetWeight = liftSetDictionary["targetWeight"] as? Double
        let targetReps = liftSetDictionary["targetReps"] as? Int
        
        if let weight = weightOptional {
            if let reps = repsOptional {
                return LiftSet(withTargetWeight: targetWeight, performedWeight: weight,
                    targetReps: targetReps, performedReps: reps)
            }
        }
        
        return nil
    }
}
