import Foundation

public class LiftSaveAgent {
    public private(set) var liftSerializer: LiftSerializer!
    public private(set) var localStorageWorker: LocalStorageWorker!
    
    public init(withLiftSerializer liftSerializer: LiftSerializer?, localStorageWorker: LocalStorageWorker?) {
        self.liftSerializer = liftSerializer
        self.localStorageWorker = localStorageWorker
    }
    
    public func save(lift: Lift) {
        let liftDictionary = liftSerializer.serialize(lift)
        let liftNameSnakeCase = lift.name.stringByReplacingOccurrencesOfString(" ", withString: "_")
        
        let fileName = "Lifts/\(liftNameSnakeCase)/\(String(lift.workout.timestamp)).json"
        do {
            try localStorageWorker.writeJSONDictionary(liftDictionary, toFileWithName: fileName,
                                                       createSubdirectories: true)
        } catch {
            print("Failed to write to \(fileName)")
        }
    }
}
