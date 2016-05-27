import Foundation
import Swinject

class MigrationAgent {
    private(set) var liftHistoryIndexBuilder: LiftHistoryIndexBuilder!
    private(set) var workoutLoadAgent: WorkoutLoadAgent!
    private(set) var localStorageWorker: LocalStorageWorker!
    
    func performMigrationWork(completionHandler completionHandler: (() -> ())?) {
        let workouts = workoutLoadAgent.loadAllWorkouts()
        let index = liftHistoryIndexBuilder.buildIndexFromWorkouts(workouts)
        try! localStorageWorker.writeJSONDictionary(index, toFileWithName: "Indices/LiftHistory.json",
                createSubdirectories: true)
        if let callback = completionHandler {
            callback()
        }
    }
}

extension MigrationAgent: Injectable {
    static func registerForInjection(container: Container) {
        container.register(MigrationAgent.self) { resolver in
            let instance = MigrationAgent()
            
            instance.liftHistoryIndexBuilder = container.resolve(LiftHistoryIndexBuilder.self)
            instance.workoutLoadAgent = container.resolve(WorkoutLoadAgent.self)
            instance.localStorageWorker = container.resolve(LocalStorageWorker.self)
            
            return instance
        }
    }
}
