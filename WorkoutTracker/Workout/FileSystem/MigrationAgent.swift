import Foundation

class MigrationAgent {
    private(set) var liftHistoryIndexBuilder: LiftHistoryIndexBuilder!
    private(set) var workoutLoadAgent: WorkoutLoadAgent!
    private(set) var localStorageWorker: LocalStorageWorker!
    
    init(withLiftHistoryIndexBuilder liftHistoryIndexBuilder: LiftHistoryIndexBuilder,
                    workoutLoadAgent: WorkoutLoadAgent, localStorageWorker: LocalStorageWorker) {
        self.liftHistoryIndexBuilder = liftHistoryIndexBuilder
        self.workoutLoadAgent = workoutLoadAgent
        self.localStorageWorker = localStorageWorker
    }
    
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
