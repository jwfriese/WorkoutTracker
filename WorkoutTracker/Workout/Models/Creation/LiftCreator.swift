import Foundation

public class LiftCreator {
    public private(set) var liftHistoryIndexLoader: LiftHistoryIndexLoader!
    public private(set) var workoutLoadAgent: WorkoutLoadAgent!
    
    public init(withLiftHistoryIndexLoader liftHistoryIndexLoader: LiftHistoryIndexLoader?,
                    workoutLoadAgent: WorkoutLoadAgent?) {
        self.liftHistoryIndexLoader = liftHistoryIndexLoader
        self.workoutLoadAgent = workoutLoadAgent
    }
    
    public func createWithName(name: String) -> Lift {
        let lift = Lift(withName: name)
        
        let index = liftHistoryIndexLoader.load()
        if let workoutIndices = index[name] {
            if let workout = workoutLoadAgent.loadWorkout(withIdentifier: workoutIndices.last!) {
                lift.previousInstance = workout.liftByName(name)
            }
        }
        
        return lift
    }
}
