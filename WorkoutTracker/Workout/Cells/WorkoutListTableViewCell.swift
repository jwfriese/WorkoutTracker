import UIKit

class WorkoutListTableViewCell: UITableViewCell {
    static var name: String = "WorkoutListTableViewCell"
    
    @IBOutlet weak var contentLabel: UILabel?
    
    var workout: Workout! {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd/YYYY, hh:mma"
            let date = NSDate(timeIntervalSince1970: Double(workout.timestamp))
            
            contentLabel?.text = dateFormatter.stringFromDate(date)
        }
    }
}
