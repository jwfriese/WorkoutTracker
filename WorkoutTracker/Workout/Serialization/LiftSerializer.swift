import Foundation

public class LiftSerializer {
    public private(set) var liftSetSerializer: LiftSetSerializer!
    
    public init(withLiftSetSerializer liftSetSerializer: LiftSetSerializer?) {
        self.liftSetSerializer = liftSetSerializer
    }
    
    public func serialize(lift: Lift) -> [String : AnyObject] {
        var result = [String : AnyObject]()
        result["name"] = lift.name
        result["workout"] = lift.workout.timestamp
        var liftSets = Array<[String :  AnyObject]>()
        for set in lift.sets {
            liftSets.append(liftSetSerializer.serialize(set))
        }
        
        if let previousInstance = lift.previousInstance {
            if let owningWorkout = previousInstance.workout {
                result["previousLiftWorkoutIdentifier"] = owningWorkout.timestamp
            }
        }
        
        result["sets"] = liftSets
        return result
    }
}
