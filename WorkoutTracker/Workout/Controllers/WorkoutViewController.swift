import UIKit

class WorkoutViewController: UIViewController {
    @IBOutlet private(set) weak var tableView: UITableView?
    
    var workout: Workout!
    var workoutSaveAgent: WorkoutSaveAgent!
    var liftCreator: LiftCreator!
    var liftDeleteAgent: LiftDeleteAgent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Workout"
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.registerNib(UINib(nibName: WorkoutLiftTableViewCell.name, bundle: nil), forCellReuseIdentifier: WorkoutLiftTableViewCell.name)
    }
    
    @IBAction func addLift() {
        self.performSegueWithIdentifier("PresentModalLiftEntryForm", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
    func liftEnteredWithName(name: String, dataTemplate: LiftDataTemplate) {
        let lift = liftCreator.createWithName(name, dataTemplate: dataTemplate)
        workout.addLift(lift)
        workoutSaveAgent.save(workout)
        tableView?.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension WorkoutViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowLift", sender: workout.lifts[indexPath.row])
    }
}

extension WorkoutViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workout.lifts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(WorkoutLiftTableViewCell.name, forIndexPath: indexPath) as! WorkoutLiftTableViewCell
        cell.lift = workout.lifts[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let liftToDelete = workout.lifts[indexPath.row]
            workout.removeLiftWithName(liftToDelete.name)
            self.tableView?.reloadData()
            liftDeleteAgent.delete(liftToDelete)
            workoutSaveAgent.save(workout)
        }
    }
}
