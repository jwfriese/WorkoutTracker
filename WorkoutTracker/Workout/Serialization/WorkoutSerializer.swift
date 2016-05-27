import Foundation
import Swinject

class WorkoutSerializer {
    init() { }
    
    func serialize(workout: Workout) -> [String : AnyObject] {
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

extension WorkoutSerializer: Injectable {
    static func registerForInjection(container: Container) {
        container.register(WorkoutSerializer.self) { _ in return WorkoutSerializer() }
    }
}
