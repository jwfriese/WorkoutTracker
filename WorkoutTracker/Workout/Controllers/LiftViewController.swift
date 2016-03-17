import UIKit

public class LiftTableViewHeaderView: UIView { }

public class LiftViewController: UIViewController {
    @IBOutlet public weak var tableView: UITableView?
    @IBOutlet public weak var addLiftButton: UIButton?
    
    public var lift: Lift!
    public var workoutSaveAgent: WorkoutSaveAgent!
    
    private var setInEditing: LiftSet?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = lift.name
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.registerNib(UINib(nibName: LiftSetTableViewCell.name, bundle: nil), forCellReuseIdentifier: LiftSetTableViewCell.name)
    }
    
    @IBAction public func addSet() {
        self.performSegueWithIdentifier("PresentModalSetEditForm", sender: nil)
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentModalSetEditForm" {
            if let setEditFormViewController = segue.destinationViewController as? SetEditFormViewController {
                
                setEditFormViewController.delegate = self
                if let sentSet = sender as? LiftSet {
                    setInEditing = sentSet
                    setEditFormViewController.set = sentSet
                }
            }
        }
    }
}

extension LiftViewController: SetEditFormDelegate {
    public var lastSetEntered: LiftSet? {
        get {
            return lift.sets.last
        }
    }
    
    public func setEnteredWithWeight(weight: Double, reps: Int) {
        if let editedSet = setInEditing {
            editedSet.weight = weight
            editedSet.reps = reps
            setInEditing = nil
        } else {
            lift.addSet(LiftSet(withWeight: weight, reps: reps))
        }
        
        workoutSaveAgent.save(lift.workout!)
        self.dismissViewControllerAnimated(true, completion: nil)
        tableView?.reloadData()
    }
}

extension LiftViewController: UITableViewDataSource {
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lift.sets.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LiftSetTableViewCell.name, forIndexPath: indexPath) as! LiftSetTableViewCell
        cell.configureWithSet(lift.sets[indexPath.row], setNumber: (indexPath.row + 1))
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let set = lift.sets[indexPath.row]
        self.performSegueWithIdentifier("PresentModalSetEditForm", sender: set)
    }
}

extension LiftViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = NSBundle.mainBundle().loadNibNamed("LiftTableViewHeaderView", owner: self,
            options: nil)[0] as? UIView
        return headerView
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
