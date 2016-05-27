import Foundation
import Swinject

class WorkoutLoadAgent {
    private(set) var workoutDeserializer: WorkoutDeserializer!
    private(set) var localStorageWorker: LocalStorageWorker!
    
    func loadWorkout(withIdentifier workoutIdentifier: UInt) -> Workout? {
        return loadFromFile("Workouts/\(workoutIdentifier)_.json")
    }
    
    func loadAllWorkouts() -> [Workout] {
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

extension WorkoutLoadAgent: Injectable {
    static func registerForInjection(container: Container) {
        container.register(WorkoutLoadAgent.self) { resolver in
            let instance = WorkoutLoadAgent()
            instance.workoutDeserializer = resolver.resolve(WorkoutDeserializer.self)
            instance.localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            
            return instance
        }
    }
}
