import UIKit

class WorkoutLiftTableViewCell: UITableViewCell {
    static var name: String = "WorkoutLiftTableViewCell"
    
    @IBOutlet weak var contentLabel: UILabel?
    
    var lift: Lift! {
        didSet {
            contentLabel?.text = lift.name
        }
    }
}
