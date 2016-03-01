import UIKit

public class WorkoutLiftTableViewCell: UITableViewCell {
    public static var name: String = "WorkoutLiftTableViewCell"
    
    @IBOutlet weak public var contentLabel: UILabel?
    
    public var lift: Lift! {
        didSet {
            contentLabel?.text = lift.name
        }
    }
}
