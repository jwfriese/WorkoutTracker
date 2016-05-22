import UIKit

public class LiftViewController: UIViewController {
    @IBOutlet public weak var tableView: UITableView?
    @IBOutlet public weak var addLiftButton: UIButton?
    
    public var lift: Lift!
    public var workoutSaveAgent: WorkoutSaveAgent!
    public var liftTableHeaderViewProvider: LiftTableHeaderViewProvider!
    
    public var isReadonly: Bool = false
    
    private var setInEditing: LiftSet?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = lift.name
        tableView?.delegate = self
        tableView?.dataSource = self
        
        if isReadonly {
            navigationItem.rightBarButtonItem = nil
            addLiftButton?.hidden = true
            addLiftButton?.alpha = 0.0
        }
        
        tableView?.registerNib(UINib(nibName: LiftSetTableViewCell.name, bundle: nil), forCellReuseIdentifier: LiftSetTableViewCell.name)
    }
    
    @IBAction public func addSet() {
        setInEditing = nil
        self.performSegueWithIdentifier("PresentModalSetEditForm", sender: nil)
    }
    
    @IBAction public func viewLastLift() {
        if let lastLift = lift.previousInstance {
            self.performSegueWithIdentifier("ShowViewLastLift", sender: lastLift)
        }
    }
    
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentModalSetEditForm" {
            if let setEditModalViewController = segue.destinationViewController as? SetEditModalViewController {
                
                setEditModalViewController.delegate = self
                if let sentSet = sender as? LiftSet {
                    setInEditing = sentSet
                    setEditModalViewController.set = sentSet
                }
            }
        } else if segue.identifier == "ShowViewLastLift" {
            if let viewLastLiftViewController = segue.destinationViewController as? LiftViewController {
                viewLastLiftViewController.isReadonly = true
                
                if let sentPreviousLiftInstance = sender as? Lift {
                    viewLastLiftViewController.lift = sentPreviousLiftInstance
                }
            }
        }
    }
}

extension LiftViewController: SetEditDelegate {
    public var liftDataTemplate: LiftDataTemplate {
        get {
            return lift.dataTemplate
        }
    }
    
    public var lastSetEntered: LiftSet? {
        get {
            return lift.sets.last
        }
    }
    
    public func setEnteredWithData(data: [String : AnyObject]) {
        if let editedSet = setInEditing {
            editedSet.data = data
            setInEditing = nil
        } else {
            lift.addSet(LiftSet(withDataTemplate: lift.dataTemplate, data: data))
        }
        
        workoutSaveAgent.save(lift.workout!)
        self.dismissViewControllerAnimated(true, completion: nil)
        tableView?.reloadData()
    }
    
    public func editCanceled() {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        cell.configureWithSet(lift.sets[indexPath.row])
        if isReadonly {
            cell.selectionStyle = .None
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !isReadonly {
            let set = lift.sets[indexPath.row]
            self.performSegueWithIdentifier("PresentModalSetEditForm", sender: set)
        }
    }
}

extension LiftViewController: UITableViewDelegate {
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return liftTableHeaderViewProvider.provideForLift(self.lift)
    }
    
    public func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
