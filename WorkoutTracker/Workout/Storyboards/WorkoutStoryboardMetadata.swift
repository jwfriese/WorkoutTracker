import Swinject

class WorkoutStoryboardMetadata: SwinjectStoryboardMetadata {
    init() { }
    
    var name: String {
        get {
            return "Workout"
        }
    }
    
    private var storyboard: UIStoryboard {
        return SwinjectStoryboard.create(name: name, bundle: nil, container: container)
    }
    
    var initialViewController: UIViewController {
        get {
            return storyboard.instantiateInitialViewController()!
        }
    }
    
    var container: Container {
        get {
            let container = Container()

            LocalStorageWorker.registerForInjection(container)
            WorkoutSerializer.registerForInjection(container)
            LiftSerializer.registerForInjection(container)
            LiftCreator.registerForInjection(container)
            LiftHistoryIndexLoader.registerForInjection(container)
            LiftSaveAgent.registerForInjection(container)
            WorkoutSaveAgent.registerForInjection(container)
            WorkoutLoadAgent.registerForInjection(container)
            LiftLoadAgent.registerForInjection(container)
            LiftHistoryIndexLoader.registerForInjection(container)
            WorkoutDeserializer.registerForInjection(container)
            LiftSetJSONValidator.registerForInjection(container)
            LiftSetDeserializer.registerForInjection(container)
            LiftDeleteAgent.registerForInjection(container)
            LiftTableHeaderViewProvider.registerForInjection(container)
            LiftSetEditFormControllerFactory.registerForInjection(container)
            
            LiftEntryFormViewController.registerForInjection(container)
            WorkoutViewController.registerForInjection(container)
            LiftViewController.registerForInjection(container)
            SetEditModalViewController.registerForInjection(container)
            
            return container
        }
    }
}
