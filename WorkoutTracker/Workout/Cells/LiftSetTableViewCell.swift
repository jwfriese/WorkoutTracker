import UIKit

public class LiftSetTableViewCell: UITableViewCell {
    public static var name: String = "LiftSetTableViewCell"
    
    @IBOutlet public weak var setNumberLabel: UILabel?
    @IBOutlet public weak var weightLabel: UILabel?
    @IBOutlet public weak var repsLabel: UILabel?
    
    public private(set) var set: LiftSet?
    
    public func configureWithSet(set: LiftSet, setNumber: Int) {
        self.set = set
        
        setNumberLabel?.text = String(setNumber)
        weightLabel?.text = String(set.performedWeight)
        repsLabel?.text = String(set.performedReps)
    }
}
