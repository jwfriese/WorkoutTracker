import Foundation
import Swinject

class LiftHistoryIndexBuilder {
    func buildIndexFromWorkouts(workouts: [Workout]) -> [String : [UInt]] {
        var index = Dictionary<String, [UInt]>()
        
        let allLifts = workouts.reduce([Lift]()) { lifts, nextWorkout in
            var liftsCopy = lifts
            liftsCopy.appendContentsOf(nextWorkout.lifts)
            return liftsCopy
        }
        
        for lift in allLifts {
            if var workoutTimestamps = index[lift.name] {
                workoutTimestamps.append(lift.workout!.timestamp)
                index[lift.name] = workoutTimestamps
            } else {
                index[lift.name] = [lift.workout!.timestamp]
            }
        }
        
        for (liftName, workoutTimestamps) in index {
            index[liftName] = workoutTimestamps.sort()
        }
        
        return index
    }
}

extension LiftHistoryIndexBuilder: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftHistoryIndexBuilder.self) { _ in return LiftHistoryIndexBuilder() }
    }
}
