import Foundation
import Swinject

class LiftSaveAgent {
    private(set) var liftSerializer: LiftSerializer!
    private(set) var localStorageWorker: LocalStorageWorker!
    
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

extension LiftSaveAgent: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftSaveAgent.self) { resolver in
            let instance = LiftSaveAgent()
            
            instance.liftSerializer = resolver.resolve(LiftSerializer.self)
            instance.localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            
            return instance
        }
    }
}
