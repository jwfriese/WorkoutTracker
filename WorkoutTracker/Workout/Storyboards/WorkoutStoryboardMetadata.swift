import Swinject

class WorkoutStoryboardMetadata: SwinjectStoryboardMetadata {
    init() { }
    
    var name: String {
        get {
            return "Workout"
        }
    }
    
    private var storyboard: UIStoryboard {
        return SwinjectStoryboard.create(name: name, bundle: nil,
                                         container: WorkoutTrackerContainer.container)
    }
    
    var initialViewController: UIViewController {
        get {
            return storyboard.instantiateInitialViewController()!
        }
    }
}
