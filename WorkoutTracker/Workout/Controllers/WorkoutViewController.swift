import UIKit

public class WorkoutViewController: UIViewController {
    @IBOutlet public private(set) weak var tableView: UITableView?
    
    public var workout: Workout!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Workout"
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.registerNib(UINib(nibName: WorkoutLiftTableViewCell.name, bundle: nil), forCellReuseIdentifier: WorkoutLiftTableViewCell.name)
    }
    
    @IBAction public func addLift() {
        self.performSegueWithIdentifier("PresentModalLiftEntryForm", sender: self)
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentModalLiftEntryForm" {
            if let liftEntryFormViewController = segue.destinationViewController as? LiftEntryFormViewController {
                
                liftEntryFormViewController.delegate = self
            }
        } else if segue.identifier == "ShowLift" {
            if let liftViewController = segue.destinationViewController as? LiftViewController {
                liftViewController.lift = sender as! Lift
            }
        }
    }
}

extension WorkoutViewController: LiftEntryFormDelegate {
    public func liftEnteredWithName(name: String) {
        workout.addLift(Lift(withName: name))
        tableView?.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension WorkoutViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowLift", sender: workout.lifts[indexPath.row])
    }
}

extension WorkoutViewController: UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.lifts.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WorkoutLiftTableViewCell.name, forIndexPath: indexPath) as! WorkoutLiftTableViewCell
        cell.lift = workout.lifts[indexPath.row]
        
        return cell
    }
}
