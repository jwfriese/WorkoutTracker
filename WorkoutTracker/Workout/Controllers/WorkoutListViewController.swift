import UIKit
import Swinject

public class WorkoutListViewController: UIViewController {
    @IBOutlet public private(set) weak var tableView: UITableView?
    
    public private(set) var workouts: [Workout] = []
    public var timestamper: Timestamper!
    public var workoutSaveAgent: WorkoutSaveAgent!
    public var workoutLoadAgent: WorkoutLoadAgent!
    public var workoutDeleteAgent: WorkoutDeleteAgent!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "All Workouts"
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.registerNib(UINib(nibName: WorkoutListTableViewCell.name, bundle: nil),
            forCellReuseIdentifier:WorkoutListTableViewCell.name)
        
        workouts = workoutLoadAgent.loadAllWorkouts()
    }
    
    @IBAction public func addWorkoutItem() {
        let workout = Workout(withName: "", timestamp: timestamper.getTimestamp())
        workouts.append(workout)
        tableView?.reloadData()
        workoutSaveAgent.save(workout)
    }
}

extension WorkoutListViewController: UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    public func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(WorkoutListTableViewCell.name) as! WorkoutListTableViewCell
            cell.workout = workouts[indexPath.row]
            return cell
    }
    
    public func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let workoutToDelete = workouts[indexPath.row]
            workouts.removeAtIndex(indexPath.row)
            self.tableView?.reloadData()
            workoutDeleteAgent.delete(workoutToDelete)
        }
    }
}

extension WorkoutListViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let workoutStoryboard = SwinjectStoryboard.create(name: WorkoutStoryboardMetadata.name,
            bundle: nil, container: WorkoutStoryboardMetadata.container)
        let workoutViewController = workoutStoryboard.instantiateInitialViewController() as!
            WorkoutViewController
        workoutViewController.workout = workouts[indexPath.row]
        
        self.navigationController?.pushViewController(workoutViewController, animated: true)
    }
}
