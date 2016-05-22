import UIKit

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
