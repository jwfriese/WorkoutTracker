import Foundation

public class WorkoutSerializer {
    public private(set) var liftSerializer: LiftSerializer?
    
    public init(withLiftSerializer liftSerializer: LiftSerializer?) {
        self.liftSerializer = liftSerializer
    }
    
    public func serialize(workout: Workout) -> [String : AnyObject] {
        var result = [String : AnyObject]()
        result["name"] = workout.name
        result["timestamp"] = workout.timestamp
        
        var lifts = Array<[String : AnyObject]>()
        for lift in workout.lifts {
            lifts.append(liftSerializer!.serialize(lift))
        }
        
        result["lifts"] = lifts
        
        return result
    }
}
