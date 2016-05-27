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
        
        MigrationAgent.registerForInjection(container)
        WorkoutDeserializer.registerForInjection(container)
        LiftSetJSONValidator.registerForInjection(container)
        LiftSetDeserializer.registerForInjection(container)
        WorkoutLoadAgent.registerForInjection(container)
        LiftLoadAgent.registerForInjection(container)
        LiftHistoryIndexLoader.registerForInjection(container)
        LocalStorageWorker.registerForInjection(container)
        LiftHistoryIndexBuilder.registerForInjection(container)
        
        StartupViewController.registerForInjection(container)
        
        container.register(WorkoutListStoryboardMetadata.self) { resolver in
            return WorkoutListStoryboardMetadata()
        }
        
        return container
    }
}
