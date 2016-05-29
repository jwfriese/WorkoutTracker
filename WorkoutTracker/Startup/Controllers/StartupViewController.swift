import UIKit
import Swinject

extension Segues {
    static var showWorkoutList: String { get { return "ShowWorkoutList" } }
}

class StartupViewController : UIViewController {
    var migrationAgent: MigrationAgent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        migrationAgent.performMigrationWork() {
            self.performSegueWithIdentifier(Segues.showWorkoutList, sender: nil)
        }
    }
}

extension StartupViewController: Injectable {
    static func registerForInjection(container: Container) {
        container.registerForStoryboard(StartupViewController.self) { resolver, instance in
            instance.migrationAgent = resolver.resolve(MigrationAgent.self)
        }
    }
}
