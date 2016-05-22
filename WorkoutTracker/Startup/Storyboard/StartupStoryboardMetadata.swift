import UIKit
import Swinject

class StartupStoryboardMetadata: SwinjectStoryboardMetadata {
    var name: String {
        return "Startup"
    }
    
    var initialViewController: UIViewController {
        get {
            let storyboard = SwinjectStoryboard.create(name: name, bundle: nil,
                                                       container: container)
            return storyboard.instantiateInitialViewController()!
        }
    }
    
    var container: Container {
        let container = Container()
        
        container.register(MigrationAgent.self) { resolver in
            let liftHistoryIndexBuilder = resolver.resolve(LiftHistoryIndexBuilder.self)
            let workoutLoadAgent = resolver.resolve(WorkoutLoadAgent.self)
            let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            return MigrationAgent(withLiftHistoryIndexBuilder: liftHistoryIndexBuilder!, workoutLoadAgent: workoutLoadAgent!, localStorageWorker: localStorageWorker!)
        }
        
        container.register(WorkoutDeserializer.self) { resolver in
            let liftLoadAgent = resolver.resolve(LiftLoadAgent.self)
            return WorkoutDeserializer(withLiftLoadAgent: liftLoadAgent!)
        }
        
        container.register(LiftSetJSONValidator.self) { resolver in
            return LiftSetJSONValidator()
        }
        
        container.register(LiftSetDeserializer.self) { resolver in
            let liftSetJSONValidator = resolver.resolve(LiftSetJSONValidator.self)
            return LiftSetDeserializer(withLiftSetJSONValidator: liftSetJSONValidator!)
        }
        
        container.register(WorkoutLoadAgent.self) { resolver in
            let workoutDeserializer = resolver.resolve(WorkoutDeserializer.self)
            let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            return WorkoutLoadAgent(withWorkoutDeserializer: workoutDeserializer, localStorageWorker: localStorageWorker)
        }
        
        container.register(LiftLoadAgent.self) { resolver in
            let liftSetDeserializer = resolver.resolve(LiftSetDeserializer.self)
            let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            let liftHistoryIndexLoader = resolver.resolve(LiftHistoryIndexLoader.self)
            
            return LiftLoadAgent(withLiftSetDeserializer: liftSetDeserializer, localStorageWorker: localStorageWorker, liftHistoryIndexLoader: liftHistoryIndexLoader)
        }
        
        container.register(LiftHistoryIndexLoader.self) { resolver in
            let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
            
            return LiftHistoryIndexLoader(withLocalStorageWorker: localStorageWorker)
        }
        
        container.register(LocalStorageWorker.self) { resolver in
            return LocalStorageWorker()
        }
        
        container.register(LiftHistoryIndexBuilder.self) { resolver in
            return LiftHistoryIndexBuilder()
        }
        
        container.register(WorkoutListStoryboardMetadata.self) { resolver in
            return WorkoutListStoryboardMetadata()
        }
        
        container.registerForStoryboard(StartupViewController.self) { resolver, instance in
            instance.migrationAgent = resolver.resolve(MigrationAgent.self)
            instance.workoutListStoryboardMetadata = resolver.resolve(WorkoutListStoryboardMetadata.self)
        }
        
        return container
    }
}
