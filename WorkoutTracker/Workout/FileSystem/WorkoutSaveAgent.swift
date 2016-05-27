import Foundation
import Swinject

class WorkoutSaveAgent {
    private(set) var workoutSerializer: WorkoutSerializer!
    private(set) var liftSaveAgent: LiftSaveAgent!
    private(set) var localStorageWorker: LocalStorageWorker!
    
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

extension WorkoutSaveAgent: Injectable {
    static func registerForInjection(container: Container) {
        container.register(WorkoutSaveAgent.self) { resolver in
            let instance = WorkoutSaveAgent()
            
            instance.workoutSerializer = resolver.resolve(WorkoutSerializer.self)
            instance.liftSaveAgent = resolver.resolve(LiftSaveAgent.self)
            instance.localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            
            return instance
        }
    }
}
