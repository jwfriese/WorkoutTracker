import Swinject

class WorkoutListStoryboardMetadata: SwinjectStoryboardMetadata {
    init() { }
    
    var name: String {
        get {
            return "WorkoutList"
        }
    }
    
    var initialViewController: UIViewController {
        get {
            let storyboard = SwinjectStoryboard.create(name: name, bundle: nil,
                                                       container: container)
            return storyboard.instantiateInitialViewController()!
        }
    }
    
    var container: Container {
        get {
            let container = Container()
            
            Timestamper.registerForInjection(container)
            LocalStorageWorker.registerForInjection(container)
            WorkoutSerializer.registerForInjection(container)
            LiftSerializer.registerForInjection(container)
            LiftSaveAgent.registerForInjection(container)
            WorkoutSaveAgent.registerForInjection(container)
            WorkoutDeserializer.registerForInjection(container)
            LiftSetJSONValidator.registerForInjection(container)
            LiftSetDeserializer.registerForInjection(container)
            WorkoutLoadAgent.registerForInjection(container)
            LiftLoadAgent.registerForInjection(container)
            LiftHistoryIndexLoader.registerForInjection(container)
            WorkoutDeleteAgent.registerForInjection(container)
            
            WorkoutListViewController.registerForInjection(container)
            
            container.register(WorkoutStoryboardMetadata.self) { resolver in
                return WorkoutStoryboardMetadata()
            }
            
            return container
        }
    }
}
