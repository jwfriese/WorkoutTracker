import Foundation

class LiftSaveAgent {
    private(set) var liftSerializer: LiftSerializer!
    private(set) var localStorageWorker: LocalStorageWorker!
    
    init(withLiftSerializer liftSerializer: LiftSerializer?, localStorageWorker: LocalStorageWorker?) {
        self.liftSerializer = liftSerializer
        self.localStorageWorker = localStorageWorker
    }
    
    func save(lift: Lift) {
        if let liftWorkout = lift.workout {
            let liftDictionary = liftSerializer.serialize(lift)
            let liftNameSnakeCase = lift.name.stringByReplacingOccurrencesOfString(" ", withString: "_")
            
            let fileName = "Lifts/\(liftNameSnakeCase)/\(String(liftWorkout.timestamp)).json"
            do {
                try localStorageWorker.writeJSONDictionary(liftDictionary, toFileWithName: fileName,
                                                           createSubdirectories: true)
            } catch {
                print("Failed to write to \(fileName)")
            }
        }
    }
}
