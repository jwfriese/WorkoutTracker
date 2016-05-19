import Swinject

public class WorkoutStoryboardMetadata: SwinjectStoryboardMetadata {
    public init() { }
    
    public var name: String {
        get {
            return "Workout"
        }
    }
    
    private var storyboard: UIStoryboard {
        return SwinjectStoryboard.create(name: name, bundle: nil, container: container)
    }
    
    public var initialViewController: UIViewController {
        get {
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
                return LiftSerializer()
            }
            
            container.register(LiftCreator.self) { resolver in
                let liftLoadAgent = resolver.resolve(LiftLoadAgent.self)
                return LiftCreator(liftLoadAgent: liftLoadAgent)
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
                let liftHistoryIndexLoader = resolver.resolve(LiftHistoryIndexLoader.self)
                
                return LiftLoadAgent(withLiftSetDeserializer: liftSetDeserializer, localStorageWorker: localStorageWorker, liftHistoryIndexLoader: liftHistoryIndexLoader)
            }
            
            container.register(LiftHistoryIndexLoader.self) { resolver in
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                
                return LiftHistoryIndexLoader(withLocalStorageWorker: localStorageWorker)
            }
            
            container.register(WorkoutDeserializer.self) { resolver in
                let liftLoadAgent = resolver.resolve(LiftLoadAgent.self)
                return WorkoutDeserializer(withLiftLoadAgent: liftLoadAgent)
            }
            
            container.register(LiftSetJSONValidator.self) { resolver in
                return LiftSetJSONValidator()
            }
            
            container.register(LiftSetDeserializer.self) { resolver in
                let liftSetJSONValidator = resolver.resolve(LiftSetJSONValidator.self)
                return LiftSetDeserializer(withLiftSetJSONValidator: liftSetJSONValidator!)
            }
            
            container.register(LiftDeleteAgent.self) { resolver in
                let localStorageWorker = resolver.resolve(LocalStorageWorker.self)
                return LiftDeleteAgent(withLocalStorageWorker: localStorageWorker)
            }
            
            container.register(LiftTableHeaderViewProvider.self) { resolver in
                return LiftTableHeaderViewProvider()
            }
            
            container.register(LiftTemplatePickerViewModel.self) { resolver in
                return LiftTemplatePickerViewModel()
            }
            
            WeightRepsEditFormViewController.registerForInjection(container)
            HeightRepsEditFormViewController.registerForInjection(container)
            TimeInSecondsEditFormViewController.registerForInjection(container)
            
            container.register(LiftSetEditFormControllerFactory.self) { resolver in
                return LiftSetEditFormControllerFactory(withControllerContainer: container)
            }
            
            container.registerForStoryboard(WorkoutViewController.self) { resolver, instance in
                instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
                instance.liftCreator = resolver.resolve(LiftCreator.self)
                instance.liftDeleteAgent = resolver.resolve(LiftDeleteAgent.self)
            }
            
            container.registerForStoryboard(LiftViewController.self) { resolver, instance in
                instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
                instance.liftTableHeaderViewProvider = resolver.resolve(LiftTableHeaderViewProvider.self)
            }
            
            container.registerForStoryboard(LiftEntryFormViewController.self) { resolver, instance in
                instance.liftTemplatePickerViewModel = resolver.resolve(LiftTemplatePickerViewModel.self)
            }
            
            container.registerForStoryboard(SetEditModalViewController.self) { resolver, instance in
                instance.liftSetEditFormControllerFactory = resolver.resolve(LiftSetEditFormControllerFactory.self)
            }
            
            return container
        }
    }
}
