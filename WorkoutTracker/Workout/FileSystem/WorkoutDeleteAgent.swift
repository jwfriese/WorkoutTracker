import Foundation

class WorkoutDeleteAgent {
    private(set) var localStorageWorker: LocalStorageWorker!
    
    init(withLocalStorageWorker localStorageWorker: LocalStorageWorker?) {
        self.localStorageWorker = localStorageWorker
    }
    
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
