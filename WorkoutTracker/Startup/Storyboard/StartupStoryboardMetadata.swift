import UIKit
import Swinject

class StartupStoryboardMetadata: SwinjectStoryboardMetadata {
    var name: String {
        return "Startup"
    }
    
    var initialViewController: UIViewController {
        get {
            let storyboard = SwinjectStoryboard.create(name: name, bundle: nil,
                                                       container: WorkoutTrackerContainer.container)
            return storyboard.instantiateInitialViewController()!
        }
    }
}
