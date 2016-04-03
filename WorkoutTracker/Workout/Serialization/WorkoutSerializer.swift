import Foundation

public class WorkoutSerializer {
    public init() { }
    
    public func serialize(workout: Workout) -> [String : AnyObject] {
        var result = [String : AnyObject]()
        result["name"] = workout.name
        result["timestamp"] = workout.timestamp
        
        var lifts = [String]()
        for lift in workout.lifts {
            lifts.append(lift.name)
        }
        
        result["lifts"] = lifts
        
        return result
    }
}
