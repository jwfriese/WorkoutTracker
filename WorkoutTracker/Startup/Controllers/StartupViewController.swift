import UIKit
import Swinject

class StartupViewController : UIViewController {
    var migrationAgent: MigrationAgent!
    var workoutListStoryboardMetadata: WorkoutListStoryboardMetadata!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        migrationAgent.performMigrationWork() {
            let workoutListNavigationController = self.workoutListStoryboardMetadata.initialViewController
            UIApplication.sharedApplication().keyWindow?.rootViewController = workoutListNavigationController
        }
    }
}

extension StartupViewController: Injectable {
    static func registerForInjection(container: Container) {
        container.registerForStoryboard(StartupViewController.self) { resolver, instance in
            instance.migrationAgent = resolver.resolve(MigrationAgent.self)
            instance.workoutListStoryboardMetadata = resolver.resolve(WorkoutListStoryboardMetadata.self)
        }
    }
}
