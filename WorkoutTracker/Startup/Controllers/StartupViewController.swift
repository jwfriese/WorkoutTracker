import UIKit

public class StartupViewController : UIViewController {
    public var migrationAgent: MigrationAgent!
    public var workoutListStoryboardMetadata: WorkoutListStoryboardMetadata!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        migrationAgent.performMigrationWork() {
            let workoutListViewController = self.workoutListStoryboardMetadata.initialViewController
            self.navigationController?.pushViewController(workoutListViewController, animated: true)
        }
    }
}
