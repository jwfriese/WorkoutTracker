import UIKit
import Swinject

public class WorkoutListViewController: UIViewController {
    @IBOutlet public private(set) weak var tableView: UITableView?
    
    public private(set) var workouts: [Workout] = []
    public var timestamper: Timestamper!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "All Workouts"
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.registerNib(UINib(nibName: WorkoutListTableViewCell.name, bundle: nil),
            forCellReuseIdentifier:WorkoutListTableViewCell.name)
    }
    
    @IBAction public func addWorkoutItem() {
        workouts.append(Workout(withName: "", timestamp: timestamper.getTimestamp()))
        tableView?.reloadData()
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowWorkoutDetail" {
            if let workoutViewController = segue.destinationViewController as? WorkoutViewController {
                workoutViewController.workout = sender as? Workout
            }
        }
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
}

extension WorkoutListViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowWorkoutDetail", sender: workouts[indexPath.row])
    }
}
