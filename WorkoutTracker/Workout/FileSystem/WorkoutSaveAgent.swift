import Foundation

public class WorkoutSaveAgent {
    public private(set) var workoutSerializer: WorkoutSerializer!
    public private(set) var localStorageWorker: LocalStorageWorker!
    
    public init(withWorkoutSerializer workoutSerializer: WorkoutSerializer?, localStorageWorker: LocalStorageWorker?) {
        self.workoutSerializer = workoutSerializer
        self.localStorageWorker = localStorageWorker
    }
    
    public func save(workout: Workout) -> String {
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
