import UIKit

public class StartupViewController : UIViewController {
    public var migrationAgent: MigrationAgent!
    public var workoutListStoryboardMetadata: WorkoutListStoryboardMetadata!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        migrationAgent.performMigrationWork() {
            let workoutListNavigationController = self.workoutListStoryboardMetadata.initialViewController
            UIApplication.sharedApplication().keyWindow?.rootViewController = workoutListNavigationController
        }
    }
}
