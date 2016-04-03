import Swinject

public class WorkoutListStoryboardMetadata: SwinjectStoryboardMetadata {
    public init() { }
    
    public var name: String {
        get {
            return "WorkoutList"
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
            
            container.register(Timestamper.self) { _ in
                return Timestamper()
            }
            
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
            
            container.register(WorkoutDeserializer.self) { resolver in
                let liftDeserializer = resolver.resolve(LiftDeserializer.self)
                
                return WorkoutDeserializer(withLiftDeserializer: liftDeserializer)
            }
            
            container.register(LiftDeserializer.self) { resolver in
                let liftSetDeserializer = resolver.resolve(LiftSetDeserializer.self)
                return LiftDeserializer(withLiftSetDeserializer: liftSetDeserializer)
            }.initCompleted { resolver, instance in
                instance.workoutLoadAgent = resolver.resolve(WorkoutLoadAgent.self)
            }
            
            container.register(LiftSetDeserializer.self) { resolver in
                return LiftSetDeserializer()
            }
            
            container.register(WorkoutLoadAgent.self) { resolver in
                let workoutDeserializer = resolver.resolve(WorkoutDeserializer.self)
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                
                return WorkoutLoadAgent(withWorkoutDeserializer: workoutDeserializer!,
                    localStorageWorker: localStorageWorker!)
            }
            
            container.register(WorkoutDeleteAgent.self) { resolver in
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                
                return WorkoutDeleteAgent(withLocalStorageWorker: localStorageWorker)
            }
            
            container.register(WorkoutStoryboardMetadata.self) { resolver in
                return WorkoutStoryboardMetadata()
            }
    
            container.registerForStoryboard(WorkoutListViewController.self) { resolver, instance in
                instance.timestamper = resolver.resolve(Timestamper.self)
                instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
                instance.workoutLoadAgent = resolver.resolve(WorkoutLoadAgent.self)
                instance.workoutDeleteAgent = resolver.resolve(WorkoutDeleteAgent.self)
                instance.workoutStoryboardMetadata = resolver.resolve(WorkoutStoryboardMetadata.self)
            }
            
            return container
        }
    }
}
