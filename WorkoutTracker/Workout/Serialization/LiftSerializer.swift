import Foundation

public class LiftSerializer {
    public private(set) var liftSetSerializer: LiftSetSerializer!
    
    public init(withLiftSetSerializer liftSetSerializer: LiftSetSerializer?) {
        self.liftSetSerializer = liftSetSerializer
    }
    
    public func serialize(lift: Lift) -> [String : AnyObject] {
        var result = [String : AnyObject]()
        result["name"] = lift.name
        var liftSets = Array<[String :  AnyObject]>()
        for set in lift.sets {
            liftSets.append(liftSetSerializer.serialize(set))
        }
        
        result["sets"] = liftSets
        
        if let workoutIdentifier = lift.workout?.timestamp {
            result["workout"] = workoutIdentifier
        }
        
        return result
    }
}
