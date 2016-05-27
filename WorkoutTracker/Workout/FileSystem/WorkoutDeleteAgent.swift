import Foundation
import Swinject

class WorkoutDeleteAgent {
    private(set) var localStorageWorker: LocalStorageWorker!
    
    func delete(workout: Workout) {
        let workoutNameWithoutWhitespace = workout.name.stringByReplacingOccurrencesOfString(" ", withString: "")
        let fileName = "Workouts/\(String(workout.timestamp))_\(workoutNameWithoutWhitespace).json"
        
        do {
            try localStorageWorker.deleteFile(fileName)
        } catch {
            print("Failed to delete file with name \(fileName) (for workout named \"\(workout.name)\"")
        }
    }
}

extension WorkoutDeleteAgent: Injectable {
    static func registerForInjection(container: Container) {
        container.register(WorkoutDeleteAgent.self) { resolver in
            let instance = WorkoutDeleteAgent()
            instance.localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            return instance
        }
    }
}
