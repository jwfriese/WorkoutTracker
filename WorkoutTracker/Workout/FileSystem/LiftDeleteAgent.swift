import Foundation

public class LiftDeleteAgent {
    public private(set) var localStorageWorker: LocalStorageWorker!
    
    public init(withLocalStorageWorker localStorageWorker: LocalStorageWorker?) {
        self.localStorageWorker = localStorageWorker
    }
    
    public func delete(lift: Lift) {
        let liftNameSnakeCased = lift.name.stringByReplacingOccurrencesOfString(" ", withString: "_")
        let fileName = "Lifts/\(liftNameSnakeCased)/\(String(lift.workout.timestamp)).json"
        
        do {
            try localStorageWorker.deleteFile(fileName)
        } catch {
            print("Failed to delete file with name \(fileName) (for lift named \"\(lift.name)\"")
        }
    }
}
