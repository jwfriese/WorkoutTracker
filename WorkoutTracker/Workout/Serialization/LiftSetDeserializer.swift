import Foundation

public class LiftSetDeserializer {
    public init() { }
    
    public func deserialize(liftSetDictionary: [String : AnyObject]) -> LiftSet {
        let weight = liftSetDictionary["weight"] as! Double
        let reps = liftSetDictionary["reps"] as! Int
        
        return LiftSet(withWeight: weight, reps: reps)
    }
}
