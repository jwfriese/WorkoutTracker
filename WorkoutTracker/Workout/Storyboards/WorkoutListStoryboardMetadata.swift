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
                                                       container: WorkoutTrackerContainer.container)
            return storyboard.instantiateInitialViewController()!
        }
    }
}
