import UIKit
import Swinject

class WorkoutListViewController: UIViewController {
    @IBOutlet private(set) weak var tableView: UITableView?
    
    private(set) var workouts: [Workout] = []
    
    var timestamper: Timestamper!
    var workoutSaveAgent: WorkoutSaveAgent!
    var workoutLoadAgent: WorkoutLoadAgent!
    var workoutDeleteAgent: WorkoutDeleteAgent!
    var workoutStoryboardMetadata: WorkoutStoryboardMetadata!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Workouts"
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.registerNib(UINib(nibName: WorkoutListTableViewCell.name, bundle: nil),
            forCellReuseIdentifier:WorkoutListTableViewCell.name)
        
        workouts = workoutLoadAgent.loadAllWorkouts()
    }
    
    @IBAction func addWorkoutItem() {
        let workout = Workout(withName: "", timestamp: timestamper.getTimestamp())
        workouts.append(workout)
        tableView?.reloadData()
        workoutSaveAgent.save(workout)
    }
}

extension WorkoutListViewController: Injectable {
    static func registerForInjection(container: Container) {
        container.registerForStoryboard(WorkoutListViewController.self) { resolver, instance in
            instance.timestamper = resolver.resolve(Timestamper.self)
            instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
            instance.workoutLoadAgent = resolver.resolve(WorkoutLoadAgent.self)
            instance.workoutDeleteAgent = resolver.resolve(WorkoutDeleteAgent.self)
            instance.workoutStoryboardMetadata = resolver.resolve(WorkoutStoryboardMetadata.self)
        }
    }
}

extension WorkoutListViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(WorkoutListTableViewCell.name) as! WorkoutListTableViewCell
            cell.workout = workouts[indexPath.row]
            return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let workoutToDelete = workouts[indexPath.row]
            workouts.removeAtIndex(indexPath.row)
            self.tableView?.reloadData()
            workoutDeleteAgent.delete(workoutToDelete)
        }
    }
}

extension WorkoutListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workoutViewController = workoutStoryboardMetadata.initialViewController as!
                WorkoutViewController
        workoutViewController.workout = workouts[indexPath.row]
        
        self.navigationController?.pushViewController(workoutViewController, animated: true)
    }
}
