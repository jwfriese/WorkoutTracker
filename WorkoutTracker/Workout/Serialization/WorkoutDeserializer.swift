import Foundation
import Swinject

class WorkoutDeserializer {
    private(set) var liftLoadAgent: LiftLoadAgent!
    private(set) var timeFormatter: TimeFormatter!
    
    func deserialize(workoutDictionary: [String : AnyObject]) -> Workout {
        let name = workoutDictionary["name"] as! String
        var timestamp: UInt?
        
        if let timestampString = workoutDictionary["timestamp"] as? String {
            timestamp = timeFormatter.integerTimestampFromSqlTimestamptzString(timestampString)
        } else {
            // Temporary support for old timestamp data format
            timestamp = workoutDictionary["timestamp"] as? UInt
        }
        
        let workout = Workout(withName: name, timestamp: timestamp!)
        if let liftsArray = workoutDictionary["lifts"] as? Array<String> {
            for lift in liftsArray {
                if let lift = liftLoadAgent.loadLift(withName: lift, fromWorkoutWithIdentifier: workout.timestamp, shouldLoadPreviousLift: true) {
                    
                    workout.addLift(lift)
                }
            }
        }
        
        return workout
    }
}

extension WorkoutDeserializer: Injectable {
    static func registerForInjection(container: Container) {
        container.register(WorkoutDeserializer.self) { resolver in
            let instance = WorkoutDeserializer()
            
            instance.liftLoadAgent = resolver.resolve(LiftLoadAgent.self)
            instance.timeFormatter = resolver.resolve(TimeFormatter.self)
            
            return instance
        }
    }
}
