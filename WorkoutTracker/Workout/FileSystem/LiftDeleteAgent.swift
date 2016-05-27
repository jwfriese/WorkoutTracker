import Foundation
import Swinject

class LiftDeleteAgent {
    private(set) var localStorageWorker: LocalStorageWorker!
    
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

extension LiftDeleteAgent: Injectable {
    static func registerForInjection(container: Container) {
        container.register(LiftDeleteAgent.self) { resolver in
            let instance = LiftDeleteAgent()
            
            instance.localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            
            return instance
        }
    }
}
