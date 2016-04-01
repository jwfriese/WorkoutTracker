import Foundation

public class MigrationAgent {
    public private(set) var liftHistoryIndexBuilder: LiftHistoryIndexBuilder!
    public private(set) var workoutLoadAgent: WorkoutLoadAgent!
    public private(set) var localStorageWorker: LocalStorageWorker!
    
    public init(withLiftHistoryIndexBuilder liftHistoryIndexBuilder: LiftHistoryIndexBuilder,
                    workoutLoadAgent: WorkoutLoadAgent, localStorageWorker: LocalStorageWorker) {
        self.liftHistoryIndexBuilder = liftHistoryIndexBuilder
        self.workoutLoadAgent = workoutLoadAgent
        self.localStorageWorker = localStorageWorker
    }
    
    public func performMigrationWork(completionHandler completionHandler: (() -> ())?) {
        let workouts = workoutLoadAgent.loadAllWorkouts()
        let index = liftHistoryIndexBuilder.buildIndexFromWorkouts(workouts)
        try! localStorageWorker.writeJSONDictionary(index, toFileWithName: "Indices/LiftHistory.json",
                createSubdirectories: true)
        if let callback = completionHandler {
            callback()
        }
    }
}
