import Swinject

public class WorkoutStoryboardMetadata: SwinjectStoryboardMetadata {
    public init() { }
    
    public var name: String {
        get {
            return "Workout"
        }
    }
    
    public var initialViewController: UIViewController {
        get {
            let storyboard = SwinjectStoryboard.create(name: name, bundle: nil,
                container: container)
            return storyboard.instantiateInitialViewController()!
        }
    }
    
    public var container: Container {
        get {
            let container = Container()
            
            container.register(LocalStorageWorker.self) { resolver in
                return LocalStorageWorker()
            }
            
            container.register(WorkoutSerializer.self) { resolver in
                return WorkoutSerializer()
            }
            
            container.register(LiftSerializer.self) { resolver in
                let liftSetSerializer = resolver.resolve(LiftSetSerializer.self)
                
                return LiftSerializer(withLiftSetSerializer: liftSetSerializer!)
            }
            
            container.register(LiftSetSerializer.self) { resolver in
                return LiftSetSerializer()
            }
            
            container.register(LiftCreator.self) { resolver in
                let liftHistoryIndexLoader = resolver.resolve(LiftHistoryIndexLoader.self)
                let workoutLoadAgent = resolver.resolve(WorkoutLoadAgent.self)
                return LiftCreator(withLiftHistoryIndexLoader: liftHistoryIndexLoader,
                            workoutLoadAgent: workoutLoadAgent)
            }
            
            container.register(LiftHistoryIndexLoader.self) { resolver in
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                return LiftHistoryIndexLoader(withLocalStorageWorker: localStorageWorker)
            }
            
            container.register(LiftSaveAgent.self) { resolver in
                let liftSerializer = resolver.resolve(LiftSerializer.self)
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                
                return LiftSaveAgent(withLiftSerializer: liftSerializer, localStorageWorker: localStorageWorker)
            }
            
            container.register(WorkoutSaveAgent.self) { resolver in
                let workoutSerializer = resolver.resolve(WorkoutSerializer.self)
                let liftSaveAgent = resolver.resolve(LiftSaveAgent.self)
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                
                return WorkoutSaveAgent(withWorkoutSerializer: workoutSerializer!, liftSaveAgent: liftSaveAgent, localStorageWorker: localStorageWorker!)
            }
            
            container.register(WorkoutLoadAgent.self) { resolver in
                let workoutDeserializer = resolver.resolve(WorkoutDeserializer.self)
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                return WorkoutLoadAgent(withWorkoutDeserializer: workoutDeserializer,
                            localStorageWorker: localStorageWorker)
            }
            
            container.register(LiftLoadAgent.self) { resolver in
                let liftSetDeserializer = resolver.resolve(LiftSetDeserializer.self)
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                
                return LiftLoadAgent(withLiftSetDeserializer: liftSetDeserializer, localStorageWorker: localStorageWorker)
            }
            
            container.register(WorkoutDeserializer.self) { resolver in
                let liftLoadAgent = resolver.resolve(LiftLoadAgent.self)
                return WorkoutDeserializer(withLiftLoadAgent: liftLoadAgent)
            }
            
            container.register(LiftSetDeserializer.self) { resolver in
                return LiftSetDeserializer()
            }
            
            container.register(LiftDeleteAgent.self) { resolver in
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                return LiftDeleteAgent(withLocalStorageWorker: localStorageWorker)
            }
            
            container.registerForStoryboard(WorkoutViewController.self) { resolver, instance in
                instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
                instance.liftCreator = resolver.resolve(LiftCreator.self)
                instance.liftDeleteAgent = resolver.resolve(LiftDeleteAgent.self)
            }
            
            container.registerForStoryboard(LiftViewController.self) { resolver, instance in
               instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
            }
            
            return container
        }
    }
}
