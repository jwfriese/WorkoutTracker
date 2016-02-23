import UIKit

public class WorkoutListViewController: UIViewController {
    public var viewModel: WorkoutListViewModel!
    @IBOutlet public private(set) weak var tableView: UITableView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "Workouts"
        tableView?.delegate = viewModel
        tableView?.dataSource = viewModel
        viewModel.setUpTableView(tableView!)
    }
    
    @IBAction func addWorkoutItem() {
        viewModel.createNewWorkout()
        tableView?.reloadData()
    }
}
