import Foundation

public class WorkoutLoadAgent {
    public private(set) var workoutDeserializer: WorkoutDeserializer!
    public private(set) var localStorageWorker: LocalStorageWorker!
    
    public init(withWorkoutDeserializer workoutDeserializer: WorkoutDeserializer?,
        localStorageWorker: LocalStorageWorker?) {
        self.workoutDeserializer = workoutDeserializer
        self.localStorageWorker = localStorageWorker
    }
    
    public func loadWorkout(withIdentifier workoutIdentifier: UInt) -> Workout? {
        return loadFromFile("Workouts/\(workoutIdentifier)_.json")
    }
    
    public func loadAllWorkouts() -> [Workout] {
        let allWorkoutFiles = localStorageWorker.allFilesWithExtension(".json", recursive: false,
            startingDirectory: "Workouts")
        var workouts = [Workout]()
        
        for workoutFile in allWorkoutFiles {
            let workoutDictionary = localStorageWorker.readJSONDictionaryFromFile(workoutFile)
            workouts.append(workoutDeserializer.deserialize(workoutDictionary!))
        }
        
        return workouts
    }
    
    private func loadFromFile(workoutFileName: String) -> Workout? {
        let workoutDictionary = localStorageWorker.readJSONDictionaryFromFile(workoutFileName)
        return workoutDeserializer.deserialize(workoutDictionary!)
    }
}
