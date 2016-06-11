import Foundation
import Swinject

class WorkoutSerializer {
    private(set) var timeFormatter: TimeFormatter!
    
    func serialize(workout: Workout) -> [String : AnyObject] {
        var result = [String : AnyObject]()
        result["name"] = workout.name
        result["timestamp"] =  timeFormatter.sqlTimestamptzStringFromIntegerTimestamp(workout.timestamp)
        
        var lifts = [String]()
        for lift in workout.lifts {
            lifts.append(lift.name)
        }
        
        result["lifts"] = lifts
        
        return result
    }
}

extension WorkoutSerializer: Injectable {
    static func registerForInjection(container: Container) {
        container.register(WorkoutSerializer.self) { resolver in
            let timeFormatter = resolver.resolve(TimeFormatter.self)
            
            let workoutSerializer = WorkoutSerializer()
            workoutSerializer.timeFormatter = timeFormatter
            
            return workoutSerializer
        }
    }
}
