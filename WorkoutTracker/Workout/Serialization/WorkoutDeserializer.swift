import Foundation

public class WorkoutDeserializer {
    public private(set) var liftDeserializer: LiftDeserializer?
    
    public init(withLiftDeserializer liftDeserializer: LiftDeserializer?) {
        self.liftDeserializer = liftDeserializer
    }
    
    public func deserialize(workoutDictionary: [String : AnyObject]) -> Workout {
        let name = workoutDictionary["name"] as! String
        let timestamp = workoutDictionary["timestamp"] as! UInt
        
        let workout = Workout(withName: name, timestamp: timestamp)
        let liftsArray = workoutDictionary["lifts"] as! Array<[String : AnyObject]>
        for lift in liftsArray {
            workout.addLift((liftDeserializer?.deserialize(lift))!)
        }
        
        return workout
    }
}
