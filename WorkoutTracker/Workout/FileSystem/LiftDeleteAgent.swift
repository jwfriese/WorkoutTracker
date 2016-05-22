import Foundation

class LiftDeleteAgent {
    private(set) var localStorageWorker: LocalStorageWorker!
    
    init(withLocalStorageWorker localStorageWorker: LocalStorageWorker?) {
        self.localStorageWorker = localStorageWorker
    }
    
    func delete(lift: Lift) {
        if let liftWorkout = lift.workout {
            let liftNameSnakeCased = lift.name.stringByReplacingOccurrencesOfString(" ", withString: "_")
            let fileName = "Lifts/\(liftNameSnakeCased)/\(String(liftWorkout.timestamp)).json"
            
            do {
                try localStorageWorker.deleteFile(fileName)
            } catch {
                print("Failed to delete file with name \(fileName) (for lift named \"\(lift.name)\"")
            }
        }
    }
}
