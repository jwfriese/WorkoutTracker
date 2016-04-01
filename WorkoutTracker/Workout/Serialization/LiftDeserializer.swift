import Foundation

public class LiftDeserializer {
    public private(set) var liftSetDeserializer: LiftSetDeserializer!
    public weak var workoutLoadAgent: WorkoutLoadAgent!
    
    public init(withLiftSetDeserializer liftSetDeserializer: LiftSetDeserializer?) {
        self.liftSetDeserializer = liftSetDeserializer
    }
    
    public func deserialize(liftDictionary: [String : AnyObject]) -> Lift {
        let name = liftDictionary["name"] as! String
        
        let lift = Lift(withName: name)
        
        let setsArray = liftDictionary["sets"] as! Array<[String : AnyObject]>
        for set in setsArray {
            lift.addSet((liftSetDeserializer.deserialize(set))!)
        }
        
        if let workoutIdentifier = liftDictionary["previousLiftWorkoutIdentifier"] as? UInt {
            if let loadedWorkout = workoutLoadAgent.loadWorkout(withIdentifier: workoutIdentifier) {
                if let matchingLift = loadedWorkout.liftByName(name) {
                    lift.previousInstance = matchingLift
                }
            }
        }
        
        return lift
    }
}
