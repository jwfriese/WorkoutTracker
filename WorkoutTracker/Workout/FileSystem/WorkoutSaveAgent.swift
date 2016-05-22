import Foundation

class WorkoutSaveAgent {
    private(set) var workoutSerializer: WorkoutSerializer!
    private(set) var liftSaveAgent: LiftSaveAgent!
    private(set) var localStorageWorker: LocalStorageWorker!
    
    init(withWorkoutSerializer workoutSerializer: WorkoutSerializer?, liftSaveAgent: LiftSaveAgent?,
                    localStorageWorker: LocalStorageWorker?) {
        self.workoutSerializer = workoutSerializer
        self.liftSaveAgent = liftSaveAgent
        self.localStorageWorker = localStorageWorker
    }
    
    func save(workout: Workout) -> String {
        for lift in workout.lifts {
            liftSaveAgent.save(lift)
        }
        
        let workoutDictionary = workoutSerializer.serialize(workout)
        let workoutNameWithoutWhitespace = workout.name.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let fileName = "Workouts/\(String(workout.timestamp))_\(workoutNameWithoutWhitespace).json"
        do {
            try localStorageWorker.writeJSONDictionary(workoutDictionary, toFileWithName: fileName,
                createSubdirectories: true)
        } catch {
            print("Failed to write to \(fileName)")
        }
    
        return fileName
    }
}
