import Foundation

public class WorkoutDeserializer {
        public private(set) var liftLoadAgent: LiftLoadAgent!

        public init(withLiftLoadAgent liftLoadAgent: LiftLoadAgent?) {
                self.liftLoadAgent = liftLoadAgent
        }

        public func deserialize(workoutDictionary: [String : AnyObject]) -> Workout {
                let name = workoutDictionary["name"] as! String
                let timestamp = workoutDictionary["timestamp"] as! UInt

                let workout = Workout(withName: name, timestamp: timestamp)
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
