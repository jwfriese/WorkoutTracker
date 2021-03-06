import UIKit
import Swinject

extension Segues {
    static var presentModalSetEditForm: String { get { return "PresentModalSetEditForm" } }
    static var showViewLastLift: String { get { return "ShowViewLastLift" } }
}

class LiftViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var addLiftButton: UIButton?
    
    private(set) var workoutSaveAgent: WorkoutSaveAgent!
    private(set) var liftTableHeaderViewProvider: LiftTableHeaderViewProvider!
    
    var lift: Lift!
    var isReadonly: Bool = false
    
    private var setInEditing: LiftSet?
    
    override func viewDidLoad() {
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
    
    @IBAction func addSet() {
        setInEditing = nil
        self.performSegueWithIdentifier(Segues.presentModalSetEditForm, sender: nil)
    }
    
    @IBAction func viewLastLift() {
        if let lastLift = lift.previousInstance {
            self.performSegueWithIdentifier(Segues.showViewLastLift, sender: lastLift)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Segues.presentModalSetEditForm {
            if let setEditModalViewController = segue.destinationViewController as? SetEditModalViewController {
                
                setEditModalViewController.delegate = self
                if let sentSet = sender as? LiftSet {
                    setInEditing = sentSet
                    setEditModalViewController.set = sentSet
                }
            }
        } else if segue.identifier == Segues.showViewLastLift {
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
    var liftDataTemplate: LiftDataTemplate {
        get {
            return lift.dataTemplate
        }
    }
    
    var lastSetEntered: LiftSet? {
        get {
            return lift.sets.last
        }
    }
    
    func setEnteredWithData(data: [String : AnyObject]) {
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
    
    func editCanceled() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LiftViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lift.sets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LiftSetTableViewCell.name, forIndexPath: indexPath) as! LiftSetTableViewCell
        cell.configureWithSet(lift.sets[indexPath.row])
        if isReadonly {
            cell.selectionStyle = .None
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !isReadonly {
            let set = lift.sets[indexPath.row]
            self.performSegueWithIdentifier(Segues.presentModalSetEditForm, sender: set)
        }
    }
}

extension LiftViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return liftTableHeaderViewProvider.provideForLift(self.lift)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension LiftViewController: Injectable {
    static func registerForInjection(container: Container) {
        container.registerForStoryboard(LiftViewController.self) { resolver, instance in
            instance.workoutSaveAgent = resolver.resolve(WorkoutSaveAgent.self)
            instance.liftTableHeaderViewProvider = resolver.resolve(LiftTableHeaderViewProvider.self)
        }
    }
}
